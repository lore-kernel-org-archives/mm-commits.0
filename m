From: akpm@linux-foundation.org
Subject: + gcc-46-fs-fix-unused-but-set-warnings.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:43 -0700
Message-ID: <201006182331.o5INVhHM029562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab0FRXb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, axboe@kernel.dk, eparis@redhat.com


The patch titled
     gcc-4.6: fs: fix unused but set warnings
has been added to the -mm tree.  Its filename is
     gcc-46-fs-fix-unused-but-set-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcc-4.6: fs: fix unused but set warnings
From: Andi Kleen <andi@firstfloor.org>

No real bugs I believe, just some dead code, and some
shut up code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c           |    2 --
 include/linux/audit.h |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/splice.c~gcc-46-fs-fix-unused-but-set-warnings fs/splice.c
--- a/fs/splice.c~gcc-46-fs-fix-unused-but-set-warnings
+++ a/fs/splice.c
@@ -596,7 +596,6 @@ ssize_t default_file_splice_read(struct 
 	struct page *pages[PIPE_DEF_BUFFERS];
 	struct partial_page partial[PIPE_DEF_BUFFERS];
 	struct iovec *vec, __vec[PIPE_DEF_BUFFERS];
-	pgoff_t index;
 	ssize_t res;
 	size_t this_len;
 	int error;
@@ -620,7 +619,6 @@ ssize_t default_file_splice_read(struct 
 			goto shrink_ret;
 	}
 
-	index = *ppos >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 	nr_pages = (len + offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
diff -puN include/linux/audit.h~gcc-46-fs-fix-unused-but-set-warnings include/linux/audit.h
--- a/include/linux/audit.h~gcc-46-fs-fix-unused-but-set-warnings
+++ a/include/linux/audit.h
@@ -544,7 +544,7 @@ extern int audit_signals;
 #define audit_putname(n) do { ; } while (0)
 #define __audit_inode(n,d) do { ; } while (0)
 #define __audit_inode_child(i,p) do { ; } while (0)
-#define audit_inode(n,d) do { ; } while (0)
+#define audit_inode(n,d) do { (void)(d); } while (0)
 #define audit_inode_child(i,p) do { ; } while (0)
 #define audit_core_dumps(i) do { ; } while (0)
 #define auditsc_get_stamp(c,t,s) (0)
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

