Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659897;
	b=H+hESp7bpLl223yKXY3J/WGBHyOSn1g/pCJa4ZBl0q7rolyO3WaAeFciwt/EUc3HlrcI
	 ezMHm7Xi9lt3hba4ioet4b3rjkkIfjwuKm0pXVfZFEZn9cApx9ZrbhGdshgKbrR9JKII9
	 77Gx7oViHx+eZA9vMuOfu5fwcbKP5aykp0dUstN+qmfoQM44zx3EdzsbOslqTec9stS07
	 X1+DxQmvK1wPBQaPEDAEBz/C3rLaeqNn+QDOsROsYxHO361KwjpMQxhHHk3f/yr8i3IYQ
	 VRuNa06aAC4YR1DjVxFZEQllOdfCf/USVF5MnjBcbD796dUaKvFUShJ5nOhpsga2x8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659897;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ImzfkGyq53vOTBkupmHz4H3vVBW3O/n6ThFf9ZRVXO4=;
	b=j5WiazAwIDyGU5dMwLl7KYclIT/9E08BfZ/Htk9vbOXQfYrI9kmMP/n9c58VkLYVclln
	 TVwl1fLucxGf61vrGKbQSP1Md0+9ZKQxUyWrAK/YRFT+5DGqBFv7NKE/HVMVmsC3sHP18
	 69Z0JaWdiuVq19/qBtVfb8dddHycmADXCdovMVUStNFBAVMqjMOZoM3Eq7OdqRIq+IJNU
	 pZhaJuoB0LSJcb+H3JNFy/jb3daTAJAfJvAhgi4xKoY12qOVjEmdu6Mw+Hk9fXOQThz+O
	 E0xC+5Y2uc2wnodZ7KeEPyDOMqRYa1gvGs/H8B+rt19h+yKHgi9MzqItaEV0RxqMnJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FtOmHt2x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E172606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 22:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FtOmHt2x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241AD1F00A16;
	Mon,  2 Nov 2026 22:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793659897;
	bh=ImzfkGyq53vOTBkupmHz4H3vVBW3O/n6ThFf9ZRVXO4=;
	h=Date:To:From:Subject;
	b=FtOmHt2xs6FVzClsSw8wYwm09RojZDUqWG8e9VJy+qDWSUbBv4H+RvxjTFYH/odK/
	 TH3HCqlp8QjD/U0W3LzEQiwY9p366jbzJtreglJ5tpf9FqlRUwM7txjRUMWrlbqwGu
	 HuXo5MKrkytGPMuHXn8WLMe4+tEpEDkJKuj1pU6k=
Date: Mon, 02 Nov 2026 14:51:36 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,osalvador@suse.de,
	muchun.song@linux.dev,mhocko@suse.com,joshua.hahnjy@gmail.com,
	fvdl@google.com,david@kernel.org,chris@chrisdown.name,
	baolin.wang@linux.alibaba.com,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch removed from -mm tree
Message-Id: <20261102225137.241AD1F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Wed, 28 Oct 2026 19:33:17 +0800

When hugetlb_cma contains a global size after node-specific entries,
cmdline_parse_hugetlb_cma() enters the global branch and reparses the
original parameter string.  For hugetlb_cma=1:2G,4G, this interprets the
initial node ID as a one-byte global size and clears the 2 GiB reservation
recorded for node 1.

Global and node-specific formats cannot be mixed.  Return -EINVAL when a
global entry follows a node-specific entry, before updating any settings. 
This preserves the valid prefix, so the example retains node 1's 2 GiB
reservation and reports the malformed option.

Link: https://lore.kernel.org/20261028113319.38544-2-kaitao.cheng@linux.dev
Fixes: 38e719ab2673 ("hugetlb: support node specified when using cma for gigantic hugepages")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-10f40d3e-3feb-4622-9da8-1fedecb2d0e2
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 mm/hugetlb_cma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input
+++ a/mm/hugetlb_cma.c
@@ -167,6 +167,9 @@ static int __init cmdline_parse_hugetlb_
 		} else {
 			char *next;
 
+			if (s != p)
+				return -EINVAL;
+
 			tmp = memparse(p, &next);
 			if (*next == '%') {
 				if (tmp > 100) {
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are


