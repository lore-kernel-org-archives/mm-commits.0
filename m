Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34591C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347775AbiATVZQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:25:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57308 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347688AbiATVZQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:25:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27735B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CCCC340E0;
        Thu, 20 Jan 2022 21:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713913;
        bh=qEttXQzKLo1oYua5d4g/ReMDQhD2l38P7p7fQyMjI/U=;
        h=Date:From:To:Subject:From;
        b=0gblUP0/q/KrGKd/qNEdh5nfd7x7jI6dFH9p1/r9KgAvh/Wj/8THTeESEF3BE+rol
         QpL4CC1oh2810PMxKcQPx3jmx5K2ANrmGa4bAXsc6wfeDeO1SQVwVAJPVWHB/YdMDv
         UepaBXas615G9rnZj6G0aSFphJSvuyFRtERUTVnM=
Date:   Thu, 20 Jan 2022 13:25:13 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, kirill@shutemov.name, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        peterz@infradead.org, songmuchun@bytedance.com,
        zhengqi.arch@bytedance.com, zhouchengming@bytedance.com
Subject:  [merged]
 mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch removed
 from -mm tree
Message-ID: <20220120212513.Wr4je77gS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove redundant check about FAULT_FLAG_ALLOW_RETRY bit
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


