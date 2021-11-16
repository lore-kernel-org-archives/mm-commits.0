Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE09C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 03:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B339F61BA2
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 03:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhKPDsg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 22:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232629AbhKPDsa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 22:48:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A12F560174;
        Tue, 16 Nov 2021 03:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637034333;
        bh=HCoTM9c8o2EKM8Zav1YHwnKF13/hA/JDj5/X2aOANY8=;
        h=Date:From:To:Subject:From;
        b=whzsjwC/1JzFKGKpb7ADR9JuuoO++oZnuP5+Ojofb9DxVkoVwJ6EAN+GePEgq3bFm
         yaB6V2phfwnZtUHz/Q5FAnC6s52SIoXGaDofina91HIsmnxFfp2mLlsrVD0oVEfEUQ
         UStfJ3vt1jEHb93TjxDKg2MQNhkmSanw3+OlCu3Q=
Date:   Mon, 15 Nov 2021 19:45:33 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, kirill@shutemov.name, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        peterz@infradead.org, songmuchun@bytedance.com,
        zhengqi.arch@bytedance.com, zhouchengming@bytedance.com
Subject:  +
 mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch added to
 -mm tree
Message-ID: <20211116034533.vyDeqFop4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove redundant check about FAULT_FLAG_ALLOW_RETRY bit
has been added to the -mm tree.  Its filename is
     mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: remove redundant check about FAULT_FLAG_ALLOW_RETRY bit

Since commit 4064b9827063 ("mm: allow VM_FAULT_RETRY for multiple times")
allowed VM_FAULT_RETRY for multiple times, the FAULT_FLAG_ALLOW_RETRY bit
of fault_flag will not be changed in the page fault path, so the following
check is no longer needed:

	flags & FAULT_FLAG_ALLOW_RETRY

So just remove it.

Link: https://lkml.kernel.org/r/20211110123358.36511-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c      |   16 +++++++---------
 arch/arc/mm/fault.c        |    3 +--
 arch/arm/mm/fault.c        |    2 +-
 arch/arm64/mm/fault.c      |    6 ++----
 arch/hexagon/mm/vm_fault.c |    8 +++-----
 arch/ia64/mm/fault.c       |   16 +++++++---------
 arch/m68k/mm/fault.c       |   18 ++++++++----------
 arch/microblaze/mm/fault.c |   18 ++++++++----------
 arch/mips/mm/fault.c       |   19 +++++++++----------
 arch/nds32/mm/fault.c      |   16 +++++++---------
 arch/nios2/mm/fault.c      |   18 ++++++++----------
 arch/openrisc/mm/fault.c   |   18 ++++++++----------
 arch/parisc/mm/fault.c     |   18 ++++++++----------
 arch/powerpc/mm/fault.c    |    6 ++----
 arch/riscv/mm/fault.c      |    2 +-
 arch/s390/mm/fault.c       |   26 ++++++++++++--------------
 arch/sh/mm/fault.c         |   18 ++++++++----------
 arch/sparc/mm/fault_32.c   |   16 +++++++---------
 arch/sparc/mm/fault_64.c   |   16 +++++++---------
 arch/um/kernel/trap.c      |    8 +++-----
 arch/x86/mm/fault.c        |    3 +--
 arch/xtensa/mm/fault.c     |   17 ++++++++---------
 22 files changed, 126 insertions(+), 162 deletions(-)

--- a/arch/alpha/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/alpha/mm/fault.c
@@ -165,17 +165,15 @@ retry:
 		BUG();
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			 /* No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+		/* No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
 
-			goto retry;
-		}
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/arc/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/arc/mm/fault.c
@@ -149,8 +149,7 @@ retry:
 	/*
 	 * Fault retry nuances, mmap_lock already relinquished by core mm
 	 */
-	if (unlikely((fault & VM_FAULT_RETRY) &&
-		     (flags & FAULT_FLAG_ALLOW_RETRY))) {
+	if (unlikely(fault & VM_FAULT_RETRY)) {
 		flags |= FAULT_FLAG_TRIED;
 		goto retry;
 	}
--- a/arch/arm64/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/arm64/mm/fault.c
@@ -606,10 +606,8 @@ retry:
 	}
 
 	if (fault & VM_FAULT_RETRY) {
-		if (mm_flags & FAULT_FLAG_ALLOW_RETRY) {
-			mm_flags |= FAULT_FLAG_TRIED;
-			goto retry;
-		}
+		mm_flags |= FAULT_FLAG_TRIED;
+		goto retry;
 	}
 	mmap_read_unlock(mm);
 
--- a/arch/arm/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/arm/mm/fault.c
@@ -312,7 +312,7 @@ retry:
 		return 0;
 	}
 
-	if (!(fault & VM_FAULT_ERROR) && flags & FAULT_FLAG_ALLOW_RETRY) {
+	if (!(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 			goto retry;
--- a/arch/hexagon/mm/vm_fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/hexagon/mm/vm_fault.c
@@ -98,11 +98,9 @@ good_area:
 
 	/* The most common case -- we are done. */
 	if (likely(!(fault & VM_FAULT_ERROR))) {
-		if (flags & FAULT_FLAG_ALLOW_RETRY) {
-			if (fault & VM_FAULT_RETRY) {
-				flags |= FAULT_FLAG_TRIED;
-				goto retry;
-			}
+		if (fault & VM_FAULT_RETRY) {
+			flags |= FAULT_FLAG_TRIED;
+			goto retry;
 		}
 
 		mmap_read_unlock(mm);
--- a/arch/ia64/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/ia64/mm/fault.c
@@ -156,17 +156,15 @@ retry:
 		BUG();
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			 /* No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+		/* No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
 
-			goto retry;
-		}
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/m68k/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/m68k/mm/fault.c
@@ -153,18 +153,16 @@ good_area:
 		BUG();
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			/*
-			 * No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+		/*
+		 * No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
 
-			goto retry;
-		}
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/microblaze/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/microblaze/mm/fault.c
@@ -232,18 +232,16 @@ good_area:
 		BUG();
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			/*
-			 * No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+		/*
+		 * No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
 
-			goto retry;
-		}
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/mips/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/mips/mm/fault.c
@@ -171,18 +171,17 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
 
-			/*
-			 * No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			goto retry;
-		}
+		/*
+		 * No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
+
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/nds32/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/nds32/mm/fault.c
@@ -230,16 +230,14 @@ good_area:
 			goto bad_area;
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			/* No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
-			goto retry;
-		}
+		/* No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/nios2/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/nios2/mm/fault.c
@@ -149,18 +149,16 @@ good_area:
 		BUG();
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			/*
-			 * No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+		/*
+		 * No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
 
-			goto retry;
-		}
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/openrisc/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/openrisc/mm/fault.c
@@ -177,18 +177,16 @@ good_area:
 		BUG();
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		/*RGD modeled on Cris */
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	/*RGD modeled on Cris */
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			 /* No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+		/* No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
 
-			goto retry;
-		}
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/parisc/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/parisc/mm/fault.c
@@ -324,16 +324,14 @@ good_area:
 			goto bad_area;
 		BUG();
 	}
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			/*
-			 * No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
-			flags |= FAULT_FLAG_TRIED;
-			goto retry;
-		}
+	if (fault & VM_FAULT_RETRY) {
+		/*
+		 * No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
+		flags |= FAULT_FLAG_TRIED;
+		goto retry;
 	}
 	mmap_read_unlock(mm);
 	return;
--- a/arch/powerpc/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/powerpc/mm/fault.c
@@ -516,10 +516,8 @@ retry:
 	 * case.
 	 */
 	if (unlikely(fault & VM_FAULT_RETRY)) {
-		if (flags & FAULT_FLAG_ALLOW_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
-			goto retry;
-		}
+		flags |= FAULT_FLAG_TRIED;
+		goto retry;
 	}
 
 	mmap_read_unlock(current->mm);
--- a/arch/riscv/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/riscv/mm/fault.c
@@ -330,7 +330,7 @@ good_area:
 	if (fault_signal_pending(fault, regs))
 		return;
 
-	if (unlikely((fault & VM_FAULT_RETRY) && (flags & FAULT_FLAG_ALLOW_RETRY))) {
+	if (unlikely(fault & VM_FAULT_RETRY)) {
 		flags |= FAULT_FLAG_TRIED;
 
 		/*
--- a/arch/s390/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/s390/mm/fault.c
@@ -452,21 +452,19 @@ retry:
 	if (unlikely(fault & VM_FAULT_ERROR))
 		goto out_up;
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			if (IS_ENABLED(CONFIG_PGSTE) && gmap &&
-			    (flags & FAULT_FLAG_RETRY_NOWAIT)) {
-				/* FAULT_FLAG_RETRY_NOWAIT has been set,
-				 * mmap_lock has not been released */
-				current->thread.gmap_pfault = 1;
-				fault = VM_FAULT_PFAULT;
-				goto out_up;
-			}
-			flags &= ~FAULT_FLAG_RETRY_NOWAIT;
-			flags |= FAULT_FLAG_TRIED;
-			mmap_read_lock(mm);
-			goto retry;
+	if (fault & VM_FAULT_RETRY) {
+		if (IS_ENABLED(CONFIG_PGSTE) && gmap &&
+			(flags & FAULT_FLAG_RETRY_NOWAIT)) {
+			/* FAULT_FLAG_RETRY_NOWAIT has been set,
+			 * mmap_lock has not been released */
+			current->thread.gmap_pfault = 1;
+			fault = VM_FAULT_PFAULT;
+			goto out_up;
 		}
+		flags &= ~FAULT_FLAG_RETRY_NOWAIT;
+		flags |= FAULT_FLAG_TRIED;
+		mmap_read_lock(mm);
+		goto retry;
 	}
 	if (IS_ENABLED(CONFIG_PGSTE) && gmap) {
 		address =  __gmap_link(gmap, current->thread.gmap_addr,
--- a/arch/sh/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/sh/mm/fault.c
@@ -485,17 +485,15 @@ good_area:
 		if (mm_fault_error(regs, error_code, address, fault))
 			return;
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			/*
-			 * No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
-			goto retry;
-		}
+		/*
+		 * No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/sparc/mm/fault_32.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/sparc/mm/fault_32.c
@@ -200,17 +200,15 @@ good_area:
 		BUG();
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			/* No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+		/* No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
 
-			goto retry;
-		}
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
--- a/arch/sparc/mm/fault_64.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/sparc/mm/fault_64.c
@@ -437,17 +437,15 @@ good_area:
 		BUG();
 	}
 
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			/* No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+		/* No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
 
-			goto retry;
-		}
+		goto retry;
 	}
 	mmap_read_unlock(mm);
 
--- a/arch/um/kernel/trap.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/um/kernel/trap.c
@@ -87,12 +87,10 @@ good_area:
 			}
 			BUG();
 		}
-		if (flags & FAULT_FLAG_ALLOW_RETRY) {
-			if (fault & VM_FAULT_RETRY) {
-				flags |= FAULT_FLAG_TRIED;
+		if (fault & VM_FAULT_RETRY) {
+			flags |= FAULT_FLAG_TRIED;
 
-				goto retry;
-			}
+			goto retry;
 		}
 
 		pmd = pmd_off(mm, address);
--- a/arch/x86/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/x86/mm/fault.c
@@ -1413,8 +1413,7 @@ good_area:
 	 * and if there is a fatal signal pending there is no guarantee
 	 * that we made any progress. Handle this case first.
 	 */
-	if (unlikely((fault & VM_FAULT_RETRY) &&
-		     (flags & FAULT_FLAG_ALLOW_RETRY))) {
+	if (unlikely(fault & VM_FAULT_RETRY)) {
 		flags |= FAULT_FLAG_TRIED;
 		goto retry;
 	}
--- a/arch/xtensa/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit
+++ a/arch/xtensa/mm/fault.c
@@ -127,17 +127,16 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_RETRY) {
-			flags |= FAULT_FLAG_TRIED;
 
-			 /* No need to mmap_read_unlock(mm) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
-			 */
+	if (fault & VM_FAULT_RETRY) {
+		flags |= FAULT_FLAG_TRIED;
 
-			goto retry;
-		}
+		/* No need to mmap_read_unlock(mm) as we would
+		 * have already released it in __lock_page_or_retry
+		 * in mm/filemap.c.
+		 */
+
+		goto retry;
 	}
 
 	mmap_read_unlock(mm);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch

