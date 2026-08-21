Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2133B9DAC
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352225; cv=none; b=Gf6Pwn86+praueZlp2qSx3xIZShLFwGBK76uVOZynlwPJkohRek5VyOhskpDS5n9B+WR1VBccSuGfLsOoxaDeDtFtV4p7hNbs7NkvDcyeYQWqQNwdLE9SipMSI76Ba6KR9/YHykyNempfaiHRsqqsNz1ggHNcgPizviSUHI/RFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352225; c=relaxed/simple;
	bh=zpkcQhB/xHYyBbKrml6Y0Tf7P1TYjxe4Vzi7+40zjks=;
	h=Date:To:From:Subject:Message-Id; b=MKWkTphCZhf4dunEq0k6OoSMgI5nuxGr+WRSvHqWO8rbRsZhnsmCdmTQ3jmIDYJ5H0mBY7mtyVH+sLrdBogMarlHDmkPq0qSo1MzFm5vrbY5vg6GjZZMqsJs6lwjU1ApFxXSHEv/6W0nBPAPaRUlMsHfC8+wSL7lERv1RgmQBGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RgUjKqPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RgUjKqPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8CF1F000E9;
	Fri, 21 Aug 2026 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352223;
	bh=TadwCYb2nMA2zO8qP8LqGzP4Z7s4+hQ2DF8Wbd05YZo=;
	h=Date:To:From:Subject;
	b=RgUjKqPD3jF7m7BzYr4MsqKFhiUstD+ZICNV6u2yFIeIqq9GCk/3ZXhjBcmXjfQ/I
	 YaBOwm56ygMSc42mx+spyON+kDEmsMAEOL49Lf/w11CdPDxIMyequTqY+dCT+VnlbR
	 yggn2ChElNl0W1EoeL2IWe+QAn/Xi2USvgzPEg4o=
Date: Fri, 21 Aug 2026 15:43:42 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-drop-maple_alloc_slots.patch added to mm-unstable branch
Message-Id: <20260821224343.4D8CF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: drop MAPLE_ALLOC_SLOTS
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-drop-maple_alloc_slots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-drop-maple_alloc_slots.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: drop MAPLE_ALLOC_SLOTS
Date: Fri, 21 Aug 2026 15:26:14 -0400

MAPLE_ALLOC_SLOTS is no longer used, so remove it.

Link: https://lore.kernel.org/20260821192627.4085470-7-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-drop-maple_alloc_slots
+++ a/include/linux/maple_tree.h
@@ -28,13 +28,11 @@
 #define MAPLE_NODE_SLOTS	31	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	16	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	10	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 1)
 #else
 /* 32bit sizes */
 #define MAPLE_NODE_SLOTS	63	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	32	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	21	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 2)
 #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
 
 #define MAPLE_NODE_MASK		255UL
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

