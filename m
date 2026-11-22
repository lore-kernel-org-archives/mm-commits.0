Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795385841;
	b=vN0kDvbBh2Rb03Ja9gqTkjyC4kj5juVrysF66cidrrw4nKgir16CghZp3isMniA6Enix
	 RiXZJj4CSGG4HbAEcy+aJb8UsDQZp6jKv7kA/KpI10py3v8Jq4VYSO/ZioaRVYq5inMQv
	 3znnNRzKpO7tVZbx13yxeFGatP5QTpwhxRnB+zpnOJjUv3NIT2YiQJsc7FY4D3jlBeZj/
	 DAr2DvIX6jHToPaCp2RItN4cmWZbHpdTTeQHSQJFcU+wAEkvk7bBxmoLtoqvPW9a8HlBp
	 WxVdhoxOM8NQat10DU7eBG4hHy/qGdHEvFniPMw6uSOTa69l4TA5C2oKQuvi/fYsr1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795385841;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ADHHHwnG8HpV1n1/y58deSh22Qi6DXrTGuhE8GnziaM=;
	b=ZKqEQWkO2V4BqL39LIa5RWGMptdhWvjFWZaA3Z+HPTxUhTIufXMFsKlBCNlVHCcD+B9L
	 coCYIjdHQX6F0b4sdCur6FiPNwU6xuzpIGTXvOF3q662dg8Htoyz/ZLblJ1IKKp4w1LJR
	 2Ulfj4lNi2PQoUByBOTHkZS7H2sb6rTKGCoi9Qo1+ITM1fXDwnd7cCQZdYi7lSJal8SKu
	 xE585NxaA2Jye6Rr3ytmJiGA+tLNqEYUzUKNv00QM2xBL1Rsld840O8NT8jh0oYcShNZq
	 rKCmk4hQZz424jp+f4dDjDgmyeEAy2YS2vAOD+jLEsbi+IaTfasytFWDh/kbE5HD0uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g0ywX5UF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B511606A31A;
	Sun, 22 Nov 2026 22:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g0ywX5UF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D871F000C6;
	Sun, 22 Nov 2026 22:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795385840;
	bh=ADHHHwnG8HpV1n1/y58deSh22Qi6DXrTGuhE8GnziaM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=g0ywX5UFBsmmEMbY9R9wlx2NwJyv5lNiWaPra7zX+i064ZCNxaGgQGwToHljUl1gR
	 p1cBgRMHic07n5eYMEgcd+1Ncm/pTJgvVAg5atsqrFVyE9pk8Kd02CPxEGjvmDzX4H
	 WYHQzfjKPfR+s5WpvcAoiJDbLrALdrqYWGxJj/rQ=
Date: Sun, 22 Nov 2026 14:17:19 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,
	muchun.song@linux.dev,fvdl@google.com,david@kernel.org,azpijr@gmail.com,
	zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261122065527.33123-1-qi.zheng@linux.dev>
References: <20261122065527.33123-1-qi.zheng@linux.dev>
Subject: + mm-hugetlb-allocate-larger-early-cma-pages-first.patch added to mm-new branch
Message-Id: <20261122221720.32D871F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb: allocate larger early CMA pages first
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-allocate-larger-early-cma-pages-first.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-allocate-larger-early-cma-pages-first.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: hugetlb: allocate larger early CMA pages first
Date: Sun, 22 Nov 2026 14:55:26 +0800

With hugetlb_cma_only=1, early HugeTLB CMA allocations follow hstate
registration order, which can depend on the order of hugepagesz= and
default_hugepagesz= parameters.  cma_reserve_early() advances early_pfn by
the requested size without aligning the start of each allocation.

On arm64 with 4 KiB base pages, 32 MiB and 1 GiB pages share a CMA pool
aligned to 1 GiB.  In a 2 GiB CMA range starting at 4 GiB, allocating a 32
MiB page followed by a 1 GiB page places the latter at 4 GiB + 32 MiB,
violating its required 1 GiB physical alignment.

Simply rounding early_pfn up before the 1 GiB allocation would leave a 992
MiB gap and advance the cursor to 6 GiB.  cma_activate_area() marks the
entire prefix below early_pfn as allocated and only frees pageblocks after
it.  The gap would remain reserved with its bitmap bits set, and releasing
the two HugeTLB folios would not reclaim it, permanently losing 992 MiB of
usable CMA capacity.  An alignment-only fix would therefore also need to
track and reclaim such gaps.

The same alignment issue can affect non-LPAR PowerPC64 hash MMU systems
supporting 16 MiB and 16 GiB pages, with 64 KiB base pages and
CONFIG_ARCH_FORCE_MAX_ORDER=7.  The 16 MiB size then has order 8 and is
also gigantic, sharing the 16 GiB-aligned CMA pool.

Allocate early CMA hstates in descending order.  Each range starts aligned
to the largest supported size, so this preserves alignment for subsequent
smaller allocations without creating gaps.

Link: https://patch.msgid.link/20261122065527.33123-1-qi.zheng@linux.dev
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Frank van der Linden <fvdl@google.com>
Cc: <stable@vger.kernel.org>

 mm/hugetlb.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-allocate-larger-early-cma-pages-first
+++ a/mm/hugetlb.c
@@ -4651,8 +4651,25 @@ void __init hugetlb_bootmem_set_nodes(vo
 		node_set(nid, hugetlb_bootmem_nodes);
 }
 
+/* Return the largest early-CMA hstate below the given order. */
+static struct hstate *__init hugetlb_next_early_cma_hstate(unsigned int order)
+{
+	struct hstate *h, *next = NULL;
+
+	for_each_hstate(h) {
+		if (!hugetlb_early_cma(h) || huge_page_order(h) >= order)
+			continue;
+
+		if (!next || huge_page_order(h) > huge_page_order(next))
+			next = h;
+	}
+
+	return next;
+}
+
 void __init hugetlb_bootmem_alloc(void)
 {
+	unsigned int order;
 	struct hstate *h;
 	int i;
 
@@ -4666,9 +4683,19 @@ void __init hugetlb_bootmem_alloc(void)
 	for_each_hstate(h) {
 		h->next_nid_to_alloc = first_online_node;
 
-		if (hstate_is_gigantic(h))
+		if (hstate_is_gigantic(h) && !hugetlb_early_cma(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
+
+	/*
+	 * CMA ranges are aligned to the largest supported size. Allocate larger
+	 * sizes first to keep the early reservation cursor aligned without gaps.
+	 */
+	order = MAX_FOLIO_ORDER + 1;
+	while ((h = hugetlb_next_early_cma_hstate(order))) {
+		hugetlb_hstate_alloc_pages(h);
+		order = huge_page_order(h);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

x86-hugetlb-disable-default-cma-reservations-on-32-bit-kernel.patch
mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios.patch
mm-hugetlb-fix-gfp-mask-propagation-to-cma.patch
mm-hugetlb-allocate-larger-early-cma-pages-first.patch

