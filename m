Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51BDC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiANWF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiANWFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50120C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:05:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6CD9B8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F32CC36AE9;
        Fri, 14 Jan 2022 22:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197952;
        bh=i1n8wjA0M5/HzYEAu9i51yKPWNXKF5/Wd7OhO20lNQw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KNQNDmHIeotTk8sToQttD8TV3o57WAsRHu82Hlr1MhkdjSK2URJ+SNiErHro1wB+8
         tg4mk3fUYSlnhHGacMCSM2X6s0qJvyGOVgYBfmyFi/XgLA8ENVCYGf+/l5dkwKyb7i
         Oo2xV4wPtcgiBBTz8JO+5p2BuFFIgF/HmZETpsEY=
Date:   Fri, 14 Jan 2022 14:05:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, kirill@shutemov.name,
        linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, peterz@infradead.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, zhengqi.arch@bytedance.com,
        zhouchengming@bytedance.com
Subject:  [patch 055/146] mm: remove redundant check about
 FAULT_FLAG_ALLOW_RETRY bit
Message-ID: <20220114220551.g71d587A_%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: remove redundant check about FAULT_FLAG_ALLOW_RETRY bit

Since commit 4064b9827063 ("mm: allow VM_FAULT_RETRY for multiple times")
allowed VM_FAULT_RETRY for multiple times, the FAULT_FLAG_ALLOW_RETRY bit
of fault_flag will not be changed in the page fault path, so the following
check is no longer needed:

	flags & FAULT_FLAG_ALLOW_RETRY

So just remove it.

[akpm@linux-foundation.org: coding style fixes]
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
 arch/s390/mm/fault.c       |   28 ++++++++++++++--------------
 arch/sh/mm/fault.c         |   18 ++++++++----------
 arch/sparc/mm/fault_32.c   |   16 +++++++---------
 arch/sparc/mm/fault_64.c   |   16 +++++++---------
 arch/um/kernel/trap.c      |    8 +++-----
 arch/x86/mm/fault.c        |    3 +--
 arch/xtensa/mm/fault.c     |   17 ++++++++---------
 22 files changed, 128 insertions(+), 162 deletions(-)

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
@@ -452,21 +452,21 @@ retry:
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
+			/*
+			 * FAULT_FLAG_RETRY_NOWAIT has been set, mmap_lock has
+			 * not been released
+			 */
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
