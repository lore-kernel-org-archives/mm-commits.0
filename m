From: akpm@linux-foundation.org
Subject: + mlock-make-mlock-error-return-posixly-correct.patch added to -mm tree
Date: Fri, 22 Aug 2008 14:44:29 -0700
Message-ID: <200808222144.m7MLiUqO018099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880AbYHVVpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 17:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mlock: make mlock error return Posixly Correct
has been added to the -mm tree.  Its filename is
     mlock-make-mlock-error-return-posixly-correct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: make mlock error return Posixly Correct
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Rework Posix error return for mlock().

Posix requires error code for mlock*() system calls for some conditions
that differ from what kernel low level functions, such as
get_user_pages(), return for those conditions.  For more info, see:

http://marc.info/?l=linux-kernel&m=121750892930775&w=2

This patch provides the same translation of get_user_pages()
error codes to posix specified error codes in the context
of the mlock rework for unevictable lru.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 mm/mlock.c  |   27 +++++++++++++++++++++------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mlock-make-mlock-error-return-posixly-correct mm/memory.c
--- a/mm/memory.c~mlock-make-mlock-error-return-posixly-correct
+++ a/mm/memory.c
@@ -2821,7 +2821,7 @@ int make_pages_present(unsigned long add
 			len, write, 0, NULL, NULL);
 	if (ret < 0)
 		return ret;
-	return ret == len ? 0 : -1;
+	return ret == len ? 0 : -EFAULT;
 }
 
 #if !defined(__HAVE_ARCH_GATE_AREA)
diff -puN mm/mlock.c~mlock-make-mlock-error-return-posixly-correct mm/mlock.c
--- a/mm/mlock.c~mlock-make-mlock-error-return-posixly-correct
+++ a/mm/mlock.c
@@ -143,6 +143,18 @@ static void munlock_vma_page(struct page
 	}
 }
 
+/*
+ * convert get_user_pages() return value to posix mlock() error
+ */
+static int __mlock_posix_error_return(long retval)
+{
+	if (retval == -EFAULT)
+		retval = -ENOMEM;
+	else if (retval == -ENOMEM)
+		retval = -EAGAIN;
+	return retval;
+}
+
 /**
  * __mlock_vma_pages_range() -  mlock/munlock a range of pages in the vma.
  * @vma:   target vma
@@ -248,11 +260,12 @@ static long __mlock_vma_pages_range(stru
 			addr += PAGE_SIZE;	/* for next get_user_pages() */
 			nr_pages--;
 		}
+		ret = 0;
 	}
 
 	lru_add_drain_all();	/* to update stats */
 
-	return 0;	/* count entire vma as locked_vm */
+	return ret;	/* count entire vma as locked_vm */
 }
 
 #else /* CONFIG_UNEVICTABLE_LRU */
@@ -265,7 +278,7 @@ static long __mlock_vma_pages_range(stru
 				   int mlock)
 {
 	if (mlock && (vma->vm_flags & VM_LOCKED))
-		make_pages_present(start, end);
+		return make_pages_present(start, end);
 	return 0;
 }
 #endif /* CONFIG_UNEVICTABLE_LRU */
@@ -435,10 +448,7 @@ success:
 		downgrade_write(&mm->mmap_sem);
 
 		ret = __mlock_vma_pages_range(vma, start, end, 1);
-		if (ret > 0) {
-			mm->locked_vm -= ret;
-			ret = 0;
-		}
+
 		/*
 		 * Need to reacquire mmap sem in write mode, as our callers
 		 * expect this.  We have no support for atomically upgrading
@@ -452,6 +462,11 @@ success:
 		/* non-NULL *prev must contain @start, but need to check @end */
 		if (!(*prev) || end > (*prev)->vm_end)
 			ret = -ENOMEM;
+		else if (ret > 0) {
+			mm->locked_vm -= ret;
+			ret = 0;
+		} else
+			ret = __mlock_posix_error_return(ret); /* translate if needed */
 	} else {
 		/*
 		 * TODO:  for unlocking, pages will already be resident, so
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page-2.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch

