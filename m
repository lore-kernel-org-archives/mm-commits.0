From: akpm@linux-foundation.org
Subject: [merged] readahead-fault-retry-breaks-mmap-file-read-random-detection.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:57 -0700
Message-ID: <20121009181157.C00E81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53699 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab2JISL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:58 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so662627qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, fengguang.wu@intel.com, riel@redhat.com, shaohua.li@fusionio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: readahead: fault retry breaks mmap file read random detection
has been removed from the -mm tree.  Its filename was
     readahead-fault-retry-breaks-mmap-file-read-random-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: readahead: fault retry breaks mmap file read random detection

.fault now can retry.  The retry can break state machine of .fault.  In
filemap_fault, if page is miss, ra->mmap_miss is increased.  In the second
try, since the page is in page cache now, ra->mmap_miss is decreased.  And
these are done in one fault, so we can't detect random mmap file access.

Add a new flag to indicate .fault is tried once.  In the second try, skip
ra->mmap_miss decreasing.  The filemap_fault state machine is ok with it.

I only tested x86, didn't test other archs, but looks the change for other
archs is obvious, but who knows :)

Signed-off-by: Shaohua Li <shaohua.li@fusionio.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c        |    1 +
 arch/avr32/mm/fault.c      |    1 +
 arch/cris/mm/fault.c       |    1 +
 arch/hexagon/mm/vm_fault.c |    1 +
 arch/ia64/mm/fault.c       |    1 +
 arch/m68k/mm/fault.c       |    1 +
 arch/microblaze/mm/fault.c |    1 +
 arch/mips/mm/fault.c       |    1 +
 arch/openrisc/mm/fault.c   |    1 +
 arch/powerpc/mm/fault.c    |    1 +
 arch/s390/mm/fault.c       |    1 +
 arch/sh/mm/fault.c         |    1 +
 arch/sparc/mm/fault_32.c   |    1 +
 arch/sparc/mm/fault_64.c   |    1 +
 arch/tile/mm/fault.c       |    1 +
 arch/um/kernel/trap.c      |    1 +
 arch/x86/mm/fault.c        |    1 +
 arch/xtensa/mm/fault.c     |    1 +
 include/linux/mm.h         |    1 +
 mm/filemap.c               |    4 ++--
 20 files changed, 21 insertions(+), 2 deletions(-)

diff -puN arch/arm/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/arm/mm/fault.c
@@ -336,6 +336,7 @@ retry:
 			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
 			* of starvation. */
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
 	}
diff -puN arch/avr32/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/avr32/mm/fault.c
@@ -152,6 +152,7 @@ good_area:
 			tsk->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			/*
 			 * No need to up_read(&mm->mmap_sem) as we would have
diff -puN arch/cris/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/cris/mm/fault.c
--- a/arch/cris/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/cris/mm/fault.c
@@ -186,6 +186,7 @@ retry:
 			tsk->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			/*
 			 * No need to up_read(&mm->mmap_sem) as we would
diff -puN arch/hexagon/mm/vm_fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/hexagon/mm/vm_fault.c
--- a/arch/hexagon/mm/vm_fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/hexagon/mm/vm_fault.c
@@ -113,6 +113,7 @@ good_area:
 				current->min_flt++;
 			if (fault & VM_FAULT_RETRY) {
 				flags &= ~FAULT_FLAG_ALLOW_RETRY;
+				flags |= FAULT_FLAG_TRIED;
 				goto retry;
 			}
 		}
diff -puN arch/ia64/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/ia64/mm/fault.c
@@ -184,6 +184,7 @@ retry:
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			 /* No need to up_read(&mm->mmap_sem) as we would
 			 * have already released it in __lock_page_or_retry
diff -puN arch/m68k/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/m68k/mm/fault.c
--- a/arch/m68k/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/m68k/mm/fault.c
@@ -170,6 +170,7 @@ good_area:
 			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
 			 * of starvation. */
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			/*
 			 * No need to up_read(&mm->mmap_sem) as we would
diff -puN arch/microblaze/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/microblaze/mm/fault.c
--- a/arch/microblaze/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/microblaze/mm/fault.c
@@ -233,6 +233,7 @@ good_area:
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			/*
 			 * No need to up_read(&mm->mmap_sem) as we would
diff -puN arch/mips/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/mips/mm/fault.c
--- a/arch/mips/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/mips/mm/fault.c
@@ -171,6 +171,7 @@ good_area:
 		}
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			/*
 			 * No need to up_read(&mm->mmap_sem) as we would
diff -puN arch/openrisc/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/openrisc/mm/fault.c
--- a/arch/openrisc/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/openrisc/mm/fault.c
@@ -183,6 +183,7 @@ good_area:
 			tsk->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			 /* No need to up_read(&mm->mmap_sem) as we would
 			 * have already released it in __lock_page_or_retry
diff -puN arch/powerpc/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/powerpc/mm/fault.c
@@ -451,6 +451,7 @@ good_area:
 			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
 			 * of starvation. */
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
 	}
diff -puN arch/s390/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/s390/mm/fault.c
--- a/arch/s390/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/s390/mm/fault.c
@@ -367,6 +367,7 @@ retry:
 			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
 			 * of starvation. */
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 			down_read(&mm->mmap_sem);
 			goto retry;
 		}
diff -puN arch/sh/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/sh/mm/fault.c
--- a/arch/sh/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/sh/mm/fault.c
@@ -504,6 +504,7 @@ good_area:
 		}
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			/*
 			 * No need to up_read(&mm->mmap_sem) as we would
diff -puN arch/sparc/mm/fault_32.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/sparc/mm/fault_32.c
--- a/arch/sparc/mm/fault_32.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/sparc/mm/fault_32.c
@@ -265,6 +265,7 @@ good_area:
 		}
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			/* No need to up_read(&mm->mmap_sem) as we would
 			 * have already released it in __lock_page_or_retry
diff -puN arch/sparc/mm/fault_64.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/sparc/mm/fault_64.c
--- a/arch/sparc/mm/fault_64.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/sparc/mm/fault_64.c
@@ -452,6 +452,7 @@ good_area:
 		}
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			/* No need to up_read(&mm->mmap_sem) as we would
 			 * have already released it in __lock_page_or_retry
diff -puN arch/tile/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/tile/mm/fault.c
--- a/arch/tile/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/tile/mm/fault.c
@@ -454,6 +454,7 @@ good_area:
 			tsk->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			 /*
 			  * No need to up_read(&mm->mmap_sem) as we would
diff -puN arch/um/kernel/trap.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/um/kernel/trap.c
@@ -89,6 +89,7 @@ good_area:
 				current->min_flt++;
 			if (fault & VM_FAULT_RETRY) {
 				flags &= ~FAULT_FLAG_ALLOW_RETRY;
+				flags |= FAULT_FLAG_TRIED;
 
 				goto retry;
 			}
diff -puN arch/x86/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/x86/mm/fault.c
@@ -1220,6 +1220,7 @@ good_area:
 			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
 			 * of starvation. */
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
 	}
diff -puN arch/xtensa/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection arch/xtensa/mm/fault.c
--- a/arch/xtensa/mm/fault.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/arch/xtensa/mm/fault.c
@@ -126,6 +126,7 @@ good_area:
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			 /* No need to up_read(&mm->mmap_sem) as we would
 			 * have already released it in __lock_page_or_retry
diff -puN include/linux/mm.h~readahead-fault-retry-breaks-mmap-file-read-random-detection include/linux/mm.h
--- a/include/linux/mm.h~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/include/linux/mm.h
@@ -161,6 +161,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking */
 #define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
 #define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
+#define FAULT_FLAG_TRIED	0x40	/* second try */
 
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
diff -puN mm/filemap.c~readahead-fault-retry-breaks-mmap-file-read-random-detection mm/filemap.c
--- a/mm/filemap.c~readahead-fault-retry-breaks-mmap-file-read-random-detection
+++ a/mm/filemap.c
@@ -1607,13 +1607,13 @@ int filemap_fault(struct vm_area_struct 
 	 * Do we have something in the page cache already?
 	 */
 	page = find_get_page(mapping, offset);
-	if (likely(page)) {
+	if (likely(page) && !(vmf->flags & FAULT_FLAG_TRIED)) {
 		/*
 		 * We found the page, so try async readahead before
 		 * waiting for the lock.
 		 */
 		do_async_mmap_readahead(vma, ra, file, page, offset);
-	} else {
+	} else if (!page) {
 		/* No page in the page cache at all */
 		do_sync_mmap_readahead(vma, ra, file, offset);
 		count_vm_event(PGMAJFAULT);
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

