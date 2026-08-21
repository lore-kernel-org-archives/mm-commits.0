Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47323D47C2
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350906; cv=none; b=aea9j/LJ+sHBmnciZ72agONgqV1DtQgBzhQn4y6nmNX6hcIQ7NjKMB+9KoaSuc+mjZzTKAvpLwo9ViPnwyHaaVM6vR5QfV3C7oYLkCEAB48A1l7tnNuhDoEG25rUNNyMSuQUMWKoe59zmVlNLia8www8PhUKwrmz6b9E6L4uHO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350906; c=relaxed/simple;
	bh=O1URyvP1P0oIoNaclBA+Xat5PAboCfYYxxRcXW2fIZU=;
	h=Date:To:From:Subject:Message-Id; b=C2klzwcGE6j45NWDiE5luF1uv8TaBy6FuD7hqaL6kUvBXZlfRCZ6kOgEGNd83Rb9MPQsgYZTT2cT7OlBggZqJnr5+bVJ3zCAUNiFvWf5Sh5b1HX94m1uV/bG9Ghp+gN+VBJjXXe+GPJTX6j3nQKelkgEUYX4x7ziYubljg1Y+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/uPM/np; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/uPM/np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7C61F00A3A;
	Fri, 21 Aug 2026 22:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350905;
	bh=TNZkMjK6zqFsSkijcpntI7CNaIeI6IFTU5jsBFt9hDY=;
	h=Date:To:From:Subject;
	b=Q/uPM/npXqd9KOiq1Rn+LsMnvo/Dpd3UTU0L1+4At5Vd0WfJImPVIgf61NLuTmcbK
	 /cWaIWoq8hPVdmGp+UDS6kS9Swf9/UZZ6UCMklWsxkFy8XVE7LB+76PGarFddbs2da
	 h/JFSyjLqw0V0mX3UotQK5yrQjmJmUnvjxVWi9j8=
Date: Fri, 21 Aug 2026 15:21:45 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-drop-maple_alloc_slots.patch removed from -mm tree
Message-Id: <20260821222145.9D7C61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: drop MAPLE_ALLOC_SLOTS
has been removed from the -mm tree.  Its filename was
     maple_tree-drop-maple_alloc_slots.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: drop MAPLE_ALLOC_SLOTS
Date: Tue, 30 Jun 2026 15:08:30 -0400

MAPLE_ALLOC_SLOTS is no longer used, so remove it.

Link: https://lore.kernel.org/20260630190843.3563858-7-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
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

maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

