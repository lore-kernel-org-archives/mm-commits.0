Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4859A69940
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 09:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706693243; cv=none; b=PZaMXCbo650bQ/DAONQgJrxHaIbepwRNpsoQX9y1n4WEhwpT1ZrfGOQ57ez46jmr3IOrT2vjNT8wIf8f32prT7l3RlHj2S10Q3VV5vJBVRDs7o8PEeAqPoqG31TsCV/qqPOvTAFTGFKshzcJ1rzabFocM3IN9ckvsHsjubWOPe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706693243; c=relaxed/simple;
	bh=KdTjDtrDhVlNvFlQ95mEnE7j6EWV2VmNYoXPGl5CdZg=;
	h=Date:To:From:Subject:Message-Id; b=uJPls8ptpP0yjJSic3BLWMcI47NULw9WL/dZem1SiylfSpXt1l2d8aslV12+tdbVAwApit9U/hEemQYvw5CDC8ZtRLMqoFo1vcaCtizS/5UphUy1sf2BkSfU/KlhQt89VytHGfynPjNYY3dPRyXlNYq8SXyR7oTff3Rz8vP+CTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VbKtbQa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VbKtbQa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B35DC43394;
	Wed, 31 Jan 2024 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706693243;
	bh=KdTjDtrDhVlNvFlQ95mEnE7j6EWV2VmNYoXPGl5CdZg=;
	h=Date:To:From:Subject:From;
	b=VbKtbQa/6t2DlHwXjcwtOLOS/wUfgjd6uY7JJSx+ySnit92UvDC4nT8RVhwOy04aH
	 eruyCf1SIfo040eCtTstAbQ65G49kf5BDAT6gPbRsmIf75VAA7cRq64c9MkfvSs++F
	 qcFir81MhjFZLBCSqJRPzKlmA6N/oK9rVy29OKaQ=
Date: Wed, 31 Jan 2024 01:27:08 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch removed from -mm tree
Message-Id: <20240131092721.7B35DC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
has been removed from the -mm tree.  Its filename was
     mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
Date: Mon, 22 Jan 2024 21:01:54 +0800

Currently we will use 'cc->nr_freepages >= cc->nr_migratepages' comparison
to ensure that enough freepages are isolated in isolate_freepages(), however
it just decreases the cc->nr_freepages without updating cc->nr_migratepages
in compaction_alloc(), which will waste more CPU cycles and cause too many
freepages to be isolated.

So we should also update the cc->nr_migratepages when allocating or
freeing the freepages to avoid isolating excess freepages.  And I can see
fewer free pages are scanned and isolated when running thpcompact on my
Arm64 server:

                                       k6.7         k6.7_patched
Ops Compaction pages isolated      120692036.00   118160797.00
Ops Compaction migrate scanned     131210329.00   154093268.00
Ops Compaction free scanned       1090587971.00  1080632536.00
Ops Compact scan efficiency               12.03          14.26

Moreover, I did not see an obvious latency improvements, this is likely
because isolating freepages is not the bottleneck in the thpcompact test
case.

                              k6.7                  k6.7_patched
Amean     fault-both-1      1089.76 (   0.00%)     1080.16 *   0.88%*
Amean     fault-both-3      1616.48 (   0.00%)     1636.65 *  -1.25%*
Amean     fault-both-5      2266.66 (   0.00%)     2219.20 *   2.09%*
Amean     fault-both-7      2909.84 (   0.00%)     2801.90 *   3.71%*
Amean     fault-both-12     4861.26 (   0.00%)     4733.25 *   2.63%*
Amean     fault-both-18     7351.11 (   0.00%)     6950.51 *   5.45%*
Amean     fault-both-24     9059.30 (   0.00%)     9159.99 *  -1.11%*
Amean     fault-both-30    10685.68 (   0.00%)    11399.02 *  -6.68%*

Link: https://lkml.kernel.org/r/0773058df022fa701b78f9a6dfe3c501a1a77351.1705928395.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/compaction.c~mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages
+++ a/mm/compaction.c
@@ -1876,6 +1876,7 @@ again:
 
 	dst = list_first_entry(&cc->freepages[order].pages, struct folio, lru);
 	cc->freepages[order].nr_pages--;
+	cc->nr_migratepages--;
 	list_del(&dst->lru);
 done:
 	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
@@ -1904,6 +1905,7 @@ static void compaction_free(struct folio
 	list_add(&dst->lru, &cc->freepages[order].pages);
 	cc->freepages[order].nr_pages++;
 	cc->nr_freepages += 1 << order;
+	cc->nr_migratepages++;
 }
 
 /* possible outcome of isolate_migratepages */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch

