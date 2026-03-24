Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0D13612E7
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388509; cv=none; b=M2LIs75h129d1+oeiTC7ie1c7Jtr+LFeCZkCcl/BVWgxI8aK6fbpiWx4rxxs79AhsbiOxbiq97rZwZXuw38qat2xMBUZd4N6HiIO2SbS1Nbv8lsG5p0WNZbs1dpOVgNlpao6GS2Kxj4kEVWV4iJLajav9qKS0+lxU2e8AIed/jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388509; c=relaxed/simple;
	bh=XYFp1r/vQ/o5EcYe7PknrQCm7oL3AGQq9/oCe9rR4VQ=;
	h=Date:To:From:Subject:Message-Id; b=fjjss3fP+krRK8wZfhRGmXNGm8GCjI1xX+iRjavkAy15QM4JxilSHgC9RQPSf15USszvd1JRFjHnBs4DVYMv1FFQ3LccFUgAacm8l88wZNNxg9+EEa3JL6KGVNZ3w8DkcHMGFRYUBT2dCnOCtGbUgrrjw0Gs+qU1O3eI5zMCvDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wlFwMWTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wlFwMWTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A91FC19424;
	Tue, 24 Mar 2026 21:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388509;
	bh=XYFp1r/vQ/o5EcYe7PknrQCm7oL3AGQq9/oCe9rR4VQ=;
	h=Date:To:From:Subject:From;
	b=wlFwMWTHpjVKlhRMiIQ5PiKE1+gIAA3D4CHPyjcBvVqy40UnEsX9XeHKi2KCli9Xe
	 volLv8CE8bWxW0f7vq5FY2T3qcuzWqr98hQQ+3jpQJu7R/6QX6TEg7EwelGBEoM7ZX
	 llD5kEJoOtcrYok98AXSooF7P1B0lfREdxP0tcgA=
Date: Tue, 24 Mar 2026 14:41:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-gap-support-slot-and-pivot-sizes-for-maple-copy.patch removed from -mm tree
Message-Id: <20260324214149.2A91FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add gap support, slot and pivot sizes for maple copy
has been removed from the -mm tree.  Its filename was
     maple_tree-add-gap-support-slot-and-pivot-sizes-for-maple-copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add gap support, slot and pivot sizes for maple copy
Date: Fri, 30 Jan 2026 15:59:21 -0500

Add plumbing work for using maple copy as a normal node for a source of
copy operations.  This is needed later.

Link: https://lkml.kernel.org/r/20260130205935.2559335-17-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    1 +
 lib/maple_tree.c           |    5 +++++
 2 files changed, 6 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-add-gap-support-slot-and-pivot-sizes-for-maple-copy
+++ a/include/linux/maple_tree.h
@@ -165,6 +165,7 @@ struct maple_copy {
 	} src[4];
 	/* Simulated node */
 	void __rcu *slot[3];
+	unsigned long gap[3];
 	unsigned long min;
 	union {
 		unsigned long pivot[3];
--- a/lib/maple_tree.c~maple_tree-add-gap-support-slot-and-pivot-sizes-for-maple-copy
+++ a/lib/maple_tree.c
@@ -101,6 +101,7 @@ static const unsigned long mt_max[] = {
 	[maple_leaf_64]		= ULONG_MAX,
 	[maple_range_64]	= ULONG_MAX,
 	[maple_arange_64]	= ULONG_MAX,
+	[maple_copy]		= ULONG_MAX,
 };
 #define mt_node_max(x) mt_max[mte_node_type(x)]
 #endif
@@ -110,6 +111,7 @@ static const unsigned char mt_slots[] =
 	[maple_leaf_64]		= MAPLE_RANGE64_SLOTS,
 	[maple_range_64]	= MAPLE_RANGE64_SLOTS,
 	[maple_arange_64]	= MAPLE_ARANGE64_SLOTS,
+	[maple_copy]		= 3,
 };
 #define mt_slot_count(x) mt_slots[mte_node_type(x)]
 
@@ -118,6 +120,7 @@ static const unsigned char mt_pivots[] =
 	[maple_leaf_64]		= MAPLE_RANGE64_SLOTS - 1,
 	[maple_range_64]	= MAPLE_RANGE64_SLOTS - 1,
 	[maple_arange_64]	= MAPLE_ARANGE64_SLOTS - 1,
+	[maple_copy]		= 3,
 };
 #define mt_pivot_count(x) mt_pivots[mte_node_type(x)]
 
@@ -126,6 +129,7 @@ static const unsigned char mt_min_slots[
 	[maple_leaf_64]		= (MAPLE_RANGE64_SLOTS / 2) - 2,
 	[maple_range_64]	= (MAPLE_RANGE64_SLOTS / 2) - 2,
 	[maple_arange_64]	= (MAPLE_ARANGE64_SLOTS / 2) - 1,
+	[maple_copy]		= 1, /* Should never be used */
 };
 #define mt_min_slot_count(x) mt_min_slots[mte_node_type(x)]
 
@@ -627,6 +631,7 @@ static inline unsigned long *ma_gaps(str
 	case maple_arange_64:
 		return node->ma64.gap;
 	case maple_copy:
+		return node->cp.gap;
 	case maple_range_64:
 	case maple_leaf_64:
 	case maple_dense:
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


