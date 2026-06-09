Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0182DB794
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968153; cv=none; b=ePVQRx2NFHVqMEPR8zcv7N4kXWUcijeghhzqqIBsJz0AbM+vRiKDV3N2wLN5cAR7ADBAujJmL2l9lxu2vACfbQZS36KmGiURtoa2JmkMkrj4jDna2nmueCRkRRbf4owkvflgrBkE01Xm5Skttw6PT4pvZODvdSFDSVhLamKCxYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968153; c=relaxed/simple;
	bh=+2wbbbI9fSFEBtTOyBabnTtBfISxcHs5bxOeE+KfDd8=;
	h=Date:To:From:Subject:Message-Id; b=NzK82vp8GSRh9uuGwjPMF2f45bI6bsOvheHtd4Xu0lIP4aIN1aYB097zi38PzZfh+Qfr4+zGZkR5YpceFunKUnpJadDLRIGQE0n9c+5Y+3yGbEfD3m0jqQJx2hpAVdzGejO7YWv19Dqz5bf9IrVEztg6yoZMHDmYrgl5atR0se0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ubXfSeGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ubXfSeGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797C41F00893;
	Tue,  9 Jun 2026 01:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968152;
	bh=qj0Ee5X+rHIdhlCQ8ZlVPjzR4bshB22CfO1BC/WSyXU=;
	h=Date:To:From:Subject;
	b=ubXfSeGFHKDL8S+7Rcw90Hwx9xHbrgGkkKIWBj0xuEOoM1Y6e7n1PbZBmpKyjK7BY
	 lxuP3290ZQm6aovNIzrD0ff7JwM0Io8Yw5DAG+apFKPXC0wnwZKouguMPYAbOYtPpM
	 DsB09LZdUgoVqLEohIsOcAmWwZqA/FXpeY0yaIDw=
Date: Mon, 08 Jun 2026 18:22:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ljs@kernel.org,david@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-delete-stale-comment-about-cachelines.patch removed from -mm tree
Message-Id: <20260609012232.797C41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: delete stale comment about cachelines
has been removed from the -mm tree.  Its filename was
     mm-delete-stale-comment-about-cachelines.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: delete stale comment about cachelines
Date: Mon, 01 Jun 2026 11:40:09 +0000

These comments have been wrong since commit a211c6550efc ("mm: page_alloc:
defrag_mode kswapd/kcompactd watermarks") added NR_FREE_PAGES_BLOCKS. 
Since nobody has complained about it in the last year, it seems unlikely
these comments were particularly useful anyway, so delete them.

Link: https://lore.kernel.org/20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/mmzone.h~mm-delete-stale-comment-about-cachelines
+++ a/include/linux/mmzone.h
@@ -214,7 +214,6 @@ enum numa_stat_item {
 #endif
 
 enum zone_stat_item {
-	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
 	NR_FREE_PAGES_BLOCKS,
 	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
@@ -225,7 +224,6 @@ enum zone_stat_item {
 	NR_ZONE_UNEVICTABLE,
 	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
-	/* Second 128 byte cacheline */
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	NR_ZSPAGES,		/* allocated in zsmalloc */
 #endif
_

Patches currently in -mm which might be from jackmanb@google.com are


