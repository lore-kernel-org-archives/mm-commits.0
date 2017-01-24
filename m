From: akpm@linux-foundation.org
Subject: [patch 02/26] mm/huge_memory.c: respect FOLL_FORCE/FOLL_COW for
 thp
Date: Tue, 24 Jan 2017 15:17:48 -0800
Message-ID: <5887e09c.Pj4/LP+SgOpG5PCX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdAXXRt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, keno@juliacomputing.com, gthelen@google.com, hughd@google.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, luto@kernel.org, mhocko@suse.com, npiggin@gmail.com, oleg@redhat.com, stable@vger.kernel.org, w@1wt.eu

From: Keno Fischer <keno@juliacomputing.com>
Subject: mm/huge_memory.c: respect FOLL_FORCE/FOLL_COW for thp

In 19be0eaff ("mm: remove gup_flags FOLL_WRITE games from
__get_user_pages()"), the mm code was changed from unsetting FOLL_WRITE
after a COW was resolved to setting the (newly introduced) FOLL_COW
instead.  Simultaneously, the check in gup.c was updated to still allow
writes with FOLL_FORCE set if FOLL_COW had also been set.  However, a
similar check in huge_memory.c was forgotten.  As a result, remote memory
writes to ro regions of memory backed by transparent huge pages cause an
infinite loop in the kernel (handle_mm_fault sets FOLL_COW and returns 0
causing a retry, but follow_trans_huge_pmd bails out immidiately because
`(flags & FOLL_WRITE) && !pmd_write(*pmd)` is true.  While in this state
the process is stil SIGKILLable, but little else works (e.g.  no ptrace
attach, no other signals).  This is easily reproduced with the following
code (assuming thp are set to always):

    #include <assert.h>
    #include <fcntl.h>
    #include <stdint.h>
    #include <stdio.h>
    #include <string.h>
    #include <sys/mman.h>
    #include <sys/stat.h>
    #include <sys/types.h>
    #include <sys/wait.h>
    #include <unistd.h>

    #define TEST_SIZE 5 * 1024 * 1024

    int main(void) {
      int status;
      pid_t child;
      int fd = open("/proc/self/mem", O_RDWR);
      void *addr = mmap(NULL, TEST_SIZE, PROT_READ,
                        MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
      assert(addr != MAP_FAILED);
      pid_t parent_pid = getpid();
      if ((child = fork()) == 0) {
        void *addr2 = mmap(NULL, TEST_SIZE, PROT_READ | PROT_WRITE,
                           MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
        assert(addr2 != MAP_FAILED);
        memset(addr2, 'a', TEST_SIZE);
        pwrite(fd, addr2, TEST_SIZE, (uintptr_t)addr);
        return 0;
      }
      assert(child == waitpid(child, &status, 0));
      assert(WIFEXITED(status) && WEXITSTATUS(status) == 0);
      return 0;
    }

Fix this by updating follow_trans_huge_pmd in huge_memory.c analogously to
the update in gup.c in the original commit.  The same pattern exists in
follow_devmap_pmd.  However, we should not be able to reach that check
with FOLL_COW set, so add WARN_ONCE to make sure we notice if we ever do.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170106015025.GA38411@juliacomputing.com
Signed-off-by: Keno Fischer <keno@juliacomputing.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-respect-foll_force-foll_cow-for-thp mm/huge_memory.c
--- a/mm/huge_memory.c~mm-respect-foll_force-foll_cow-for-thp
+++ a/mm/huge_memory.c
@@ -783,6 +783,12 @@ struct page *follow_devmap_pmd(struct vm
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
+	/*
+	 * When we COW a devmap PMD entry, we split it into PTEs, so we should
+	 * not be in this function with `flags & FOLL_COW` set.
+	 */
+	WARN_ONCE(flags & FOLL_COW, "mm: In follow_devmap_pmd with FOLL_COW set");
+
 	if (flags & FOLL_WRITE && !pmd_write(*pmd))
 		return NULL;
 
@@ -1128,6 +1134,16 @@ out_unlock:
 	return ret;
 }
 
+/*
+ * FOLL_FORCE can write to even unwritable pmd's, but only
+ * after we've gone through a COW cycle and they are dirty.
+ */
+static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
+{
+	return pmd_write(pmd) ||
+	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+}
+
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 				   unsigned long addr,
 				   pmd_t *pmd,
@@ -1138,7 +1154,7 @@ struct page *follow_trans_huge_pmd(struc
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	if (flags & FOLL_WRITE && !pmd_write(*pmd))
+	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags))
 		goto out;
 
 	/* Avoid dumping huge zero page */
_
