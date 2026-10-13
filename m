Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF9B4848AE;
	Tue, 13 Oct 2026 04:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866013; cv=none; b=r38X7r1Csk7Du4FWeP2wq/YxZwElea+WJ/Ji3/5yNfWH1Z2FFIQKjls5r6wFD0dqbsRnRxjVR4V6NX56I8IVrKWtu15tpv2h0vJBkcTStoOxIoJliNn1YC35arFZyeiTSAisYnjly/oo3trtHrpWAwUARBF+kwcwz3Xkcd50ka8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866013; c=relaxed/simple;
	bh=BfNSoFD8k7Ma7kzeBKUw5LIPlbQIYVE37mD9cBuEelE=;
	h=Date:To:From:Subject:Message-Id; b=UyEKUwVM/87IrS0R1F52+Eo9LadKaE6PyURYL6JCA+FrS+tp0v4X2WNLT9mTGHgr8H1pRlH6L2TTu+r9fTyVFDIoFp83gzH4rQC9ebigBz78dvHXf6jT2AmLA5m8Y+5PqdPYretA2n15hrsh87HTTd+wJDQw4+6mASimI27r7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EEl/Qoa8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EEl/Qoa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D614E1F00893;
	Tue, 13 Oct 2026 04:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866011;
	bh=j/H1y1PR3CpQsl4JbM8mbFUv74LBinvKUbuYvC/sceU=;
	h=Date:To:From:Subject;
	b=EEl/Qoa8TtUqEIrHZjLF1dcYKC1bM5ZxvsMOqkWPIYIIn69v8tkrec0vs4xEtlBsn
	 dUphPZnm8z79FL412leijgk5WE0UnDm/OK58s9P9eEWIOr5+4jxC9jQw2scdJu6Tvz
	 PXRS709CNa16g6Md29LeO3SJWFIhhpMKsJ2ePe1o=
Date: Mon, 12 Oct 2026 21:33:31 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch removed from -mm tree
Message-Id: <20261013043331.D614E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/alloc_tag: account for reserved tag ids in the kernel tag check
has been removed from the -mm tree.  Its filename was
     mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: mm/alloc_tag: account for reserved tag ids in the kernel tag check
Date: Wed, 16 Sep 2026 15:55:57 +0800

The tag ids stored in the page flags include two reserved markers.
Id 0 means the page has no tag and id 1 means the tag was cleared,
so real tags start at CODETAG_ID_FIRST. The kernel-side check in
alloc_tag_sec_init() compared kernel_tags.count alone against the
addressable limit, so with the count at or just under the limit
the last tag ids wrapped into those markers. Pages allocated
through them then look the same as untagged pages on free, nothing
is ever subtracted from the real tag and /proc/allocinfo shows
that memory as still allocated.

Add the missing CODETAG_ID_FIRST, same as tags_addressable().

Link: https://lore.kernel.org/20260916075557.121316-1-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/alloc_tag.c~mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check
+++ a/mm/alloc_tag.c
@@ -621,7 +621,7 @@ void __init alloc_tag_sec_init(void)
 	kernel_tags.count = last_codetag - kernel_tags.first_tag;
 
 	/* Check if kernel tags fit into page flags */
-	if (kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
+	if (CODETAG_ID_FIRST + kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
 		shutdown_mem_profiling(false); /* allocinfo file does not exist yet */
 		pr_err("%lu allocation tags cannot be references using %d available page flag bits. Memory allocation profiling is disabled!\n",
 			kernel_tags.count, NR_UNUSED_PAGEFLAG_BITS);
_

Patches currently in -mm which might be from hao.ge@linux.dev are


