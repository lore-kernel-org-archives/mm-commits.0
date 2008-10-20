From: akpm@linux-foundation.org
Subject: - mlock-make-mlock-error-return-posixly-correct.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:29 -0700
Message-ID: <200810202033.m9KKXTke010634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbYJTUeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mlock: make mlock error return Posixly Correct
has been removed from the -mm tree.  Its filename was
     mlock-make-mlock-error-return-posixly-correct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix build]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 mm/mlock.c  |   33 +++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 7 deletions(-)

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
@@ -248,11 +248,24 @@ static long __mlock_vma_pages_range(stru
 			addr += PAGE_SIZE;	/* for next get_user_pages() */
 			nr_pages--;
 		}
+		ret = 0;
 	}
 
 	lru_add_drain_all();	/* to update stats */
 
-	return 0;	/* count entire vma as locked_vm */
+	return ret;	/* count entire vma as locked_vm */
+}
+
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
 }
 
 #else /* CONFIG_UNEVICTABLE_LRU */
@@ -265,9 +278,15 @@ static long __mlock_vma_pages_range(stru
 				   int mlock)
 {
 	if (mlock && (vma->vm_flags & VM_LOCKED))
-		make_pages_present(start, end);
+		return make_pages_present(start, end);
+	return 0;
+}
+
+static inline int __mlock_posix_error_return(long retval)
+{
 	return 0;
 }
+
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
 /**
@@ -434,10 +453,7 @@ success:
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
@@ -451,6 +467,11 @@ success:
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

origin.patch

