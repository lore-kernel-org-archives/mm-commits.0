From: akpm@linux-foundation.org
Subject: [patch 67/84] mm: make vm_mmap killable
Date: Mon, 23 May 2016 16:25:30 -0700
Message-ID: <5743916a.k6AzGZA9DlPUsAw7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbcEWXZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, aarcange@redhat.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mgorman@suse.de, oleg@redhat.com, vbabka@suse.cz, viro@zeniv.linux.org.uk

From: Michal Hocko <mhocko@suse.com>
Subject: mm: make vm_mmap killable

All the callers of vm_mmap seem to check for the failure already and bail
out in one way or another on the error which means that we can change it
to use killable version of vm_mmap_pgoff and return -EINTR if the current
task gets killed while waiting for mmap_sem.  This also means that
vm_mmap_pgoff can be killable by default and drop the additional
parameter.

This will help in the OOM conditions when the oom victim might be stuck
waiting for the mmap_sem for write which in turn can block oom_reaper
which relies on the mmap_sem for read to make a forward progress and
reclaim the address space of the victim.

Please note that load_elf_binary is ignoring vm_mmap error for
current->personality & MMAP_PAGE_ZERO case but that shouldn't be a problem
because the address is not used anywhere and we never return to the
userspace if we got killed.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/internal.h      |    3 +--
 mm/mmap.c          |    2 +-
 mm/nommu.c         |    2 +-
 mm/util.c          |   13 ++++---------
 5 files changed, 8 insertions(+), 14 deletions(-)

diff -puN include/linux/mm.h~mm-make-vm_mmap-killable include/linux/mm.h
--- a/include/linux/mm.h~mm-make-vm_mmap-killable
+++ a/include/linux/mm.h
@@ -2013,7 +2013,7 @@ static inline void mm_populate(unsigned
 /* These take the mm semaphore themselves */
 extern unsigned long vm_brk(unsigned long, unsigned long);
 extern int vm_munmap(unsigned long, size_t);
-extern unsigned long vm_mmap(struct file *, unsigned long,
+extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
diff -puN mm/internal.h~mm-make-vm_mmap-killable mm/internal.h
--- a/mm/internal.h~mm-make-vm_mmap-killable
+++ a/mm/internal.h
@@ -444,8 +444,7 @@ extern u32 hwpoison_filter_enable;
 
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
-        unsigned long, unsigned long,
-        bool);
+        unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
 unsigned long reclaim_clean_pages_from_list(struct zone *zone,
diff -puN mm/mmap.c~mm-make-vm_mmap-killable mm/mmap.c
--- a/mm/mmap.c~mm-make-vm_mmap-killable
+++ a/mm/mmap.c
@@ -1333,7 +1333,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff, true);
+	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
 out_fput:
 	if (file)
 		fput(file);
diff -puN mm/nommu.c~mm-make-vm_mmap-killable mm/nommu.c
--- a/mm/nommu.c~mm-make-vm_mmap-killable
+++ a/mm/nommu.c
@@ -1446,7 +1446,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff, true);
+	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
 
 	if (file)
 		fput(file);
diff -puN mm/util.c~mm-make-vm_mmap-killable mm/util.c
--- a/mm/util.c~mm-make-vm_mmap-killable
+++ a/mm/util.c
@@ -289,7 +289,7 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
 unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
-	unsigned long flag, unsigned long pgoff, bool killable)
+	unsigned long flag, unsigned long pgoff)
 {
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
@@ -297,12 +297,8 @@ unsigned long vm_mmap_pgoff(struct file
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
-		if (killable) {
-			if (down_write_killable(&mm->mmap_sem))
-				return -EINTR;
-		} else {
-			down_write(&mm->mmap_sem);
-		}
+		if (down_write_killable(&mm->mmap_sem))
+			return -EINTR;
 		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
 				    &populate);
 		up_write(&mm->mmap_sem);
@@ -312,7 +308,6 @@ unsigned long vm_mmap_pgoff(struct file
 	return ret;
 }
 
-/* XXX are all callers checking an error */
 unsigned long vm_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long offset)
@@ -322,7 +317,7 @@ unsigned long vm_mmap(struct file *file,
 	if (unlikely(offset_in_page(offset)))
 		return -EINVAL;
 
-	return vm_mmap_pgoff(file, addr, len, prot, flag, offset >> PAGE_SHIFT, false);
+	return vm_mmap_pgoff(file, addr, len, prot, flag, offset >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(vm_mmap);
 
_
