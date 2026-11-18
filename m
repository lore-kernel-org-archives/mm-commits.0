Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972670;
	b=fJjI3AIo8WXDAc831Hbo+I6cDwAu3hdkBp51WzUoxuy1l7QyNyOWt0RmH2lR1rEZa0qR
	 vkMbD6W9X6Fzxk7YuXrQhOv7535Cks3mRHOUzVgnrHaslpG99Envsex1sZFMozD9C7wsD
	 8OwiU9P1rSF3ygwbdmQ1wVdmRl1ApGzkH9sjfmEXt8RodbWfPIqU5qOZik2knjPkq6VsL
	 9B5N9/qlKWbnTCsVIKAjXJS9klasfzij2R7YGjGdQz63LjFgOQaAx8v8X8zebqVwvH91k
	 A8ybiGUrPc4nWY0yk228RgM4cpo7behKeMprhMOR3+DESfhRpExMaw020xyD1nNjUlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972670;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WtCJmE3omcfhXFnEoGiBmwOEi3wFX0+OZraH1FpgzP0=;
	b=ONKxf5VWI+GK8T1zaN41gn8zmwr3HrhgssYEihdxMawCU8puxQiSfT5Cb9ObAq//mjn4
	 cC0B1PH1/N58Mikj4iz6BBamQAqh9bBPJPuYCxjxJJBn9WZ7LbkEiGjLgEyu7rZ/F7hLm
	 zFMwpSSE6Q4Ohzr/sGzAQ24SXSrW8x2zplVBjvxeTg7lYZ8jBNxoQwkmOn+CRoaAGwaOF
	 2Tgh66oE2o7miUPjBAfuLNKGmH4dMZm0cO1pAAOn/JsHzLAb5Qt/ypHYLWqzts3uml6oB
	 xsSPCgUDVt+ZhPj/m8LCHIQQBrO6FSRsydWOT2TCpOvVD+42cw4FqxTIRcWz6xhKCBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uQ9dt3o+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328B9606A325;
	Wed, 18 Nov 2026 03:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uQ9dt3o+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F091D1F000C7;
	Wed, 18 Nov 2026 03:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794972670;
	bh=WtCJmE3omcfhXFnEoGiBmwOEi3wFX0+OZraH1FpgzP0=;
	h=Date:To:From:Subject;
	b=uQ9dt3o+KAYkkQYAkcJNMePMB68tAg3mU/7jum7iSU+cJXrc9Y/En2WvXXfOrYIk5
	 m72J0vuuf5y9sTyfUJAhVcDjaFXycjDK8/syAi8zh1kvkY9ObeGJtYXgpaDRiAKrEy
	 DyMdPJoNflntZmcLBgYfgauwPcDwP4TjfMTVI3F0=
Date: Tue, 17 Nov 2026 19:31:09 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,
	stable@vger.kernel.org,osalvador@suse.de,osalvador@kernel.org,
	muchun.song@linux.dev,lance.yang@linux.dev,fvdl@google.com,david@kernel.org,
	azpijr@gmail.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-gfp-mask-propagation-to-cma.patch added to mm-new branch
Message-Id: <20261118033109.F091D1F000C7@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb: fix GFP mask propagation to CMA
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-gfp-mask-propagation-to-cma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-gfp-mask-propagation-to-cma.patch

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
Subject: mm: hugetlb: fix GFP mask propagation to CMA
Date: Tue, 17 Nov 2026 17:33:59 +0800

cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
during the first MPOL_PREFERRED_MANY allocation attempt even though
the caller clears __GFP_DIRECT_RECLAIM.

Pass the caller's GFP mask through the helper so CMA respects its
reclaim constraints when trying the preferred nodes.

Link: https://lore.kernel.org/990efc61c4c3b2a4186cd578a56c6a74348fcdb1.1794907279.git.zhengqi.arch@bytedance.com
Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>

 include/linux/cma.h |    2 +-
 mm/cma.c            |   10 ++++++++--
 mm/hugetlb_cma.c    |    4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/include/linux/cma.h~mm-hugetlb-fix-gfp-mask-propagation-to-cma
+++ a/include/linux/cma.h
@@ -56,7 +56,7 @@ extern bool cma_release(struct cma *cma,
 
 struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 		unsigned int align, bool no_warn);
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp);
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count);
 
--- a/mm/cma.c~mm-hugetlb-fix-gfp-mask-propagation-to-cma
+++ a/mm/cma.c
@@ -837,9 +837,15 @@ struct page *cma_alloc_frozen(struct cma
 	return __cma_alloc_frozen(cma, count, align, gfp);
 }
 
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	/*
+	 * The only caller of cma_alloc_frozen_compound() is hugetlb, and
+	 * hugetlb constructs its gfp mask via htlb_alloc_mask(), which already
+	 * sets __GFP_COMP. Check here for usecases bypassing htlb_alloc_mask().
+	 */
+	if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
+		return NULL;
 
 	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
 }
--- a/mm/hugetlb_cma.c~mm-hugetlb-fix-gfp-mask-propagation-to-cma
+++ a/mm/hugetlb_cma.c
@@ -69,14 +69,14 @@ retry_cpuset:
 	}
 
 	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
-		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nmask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order, gfp_mask);
 			if (page)
 				break;
 		}
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

x86-hugetlb-disable-default-cma-reservations-on-32-bit-kernel.patch
mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios.patch
mm-hugetlb-fix-gfp-mask-propagation-to-cma.patch

