Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FE0692EB
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708450587; cv=none; b=BZ3SSQp/H/4HCyZ0M/xxCdKeMc2Ye64gmd5bXrb3oVEGs3e9VIgQO4mRyrl17k8E17sDt/Ef22CvWuGSOBgUqvokSTSd/LdH9fsbIfeLZ/8yDQiYVm/mVtA0SQe6jVpNSc+CW681zO+wQKp5SWSAP7JKc4E4Rby39MCWxsQlzcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708450587; c=relaxed/simple;
	bh=We2n9ODSY6L65/0pc2yPChZ3dpyFP5S+Apn8iXqk/0s=;
	h=Date:To:From:Subject:Message-Id; b=B3HnvhOoLDEIAV6pVET15pV6E3kcei0tpsDvZvE0PRqvZArRAhwgm7YPy5WRdzD0rrXaahywbjnk9aw84IDzOJs4Z7H+gcJSWRIi7ksSi7M2UHX13aamzyJjUg+OnSCUOFo3bPuBBshNMWlyi1H9vGz2WL7knSiUZokrF8bdk0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u2z7RUwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u2z7RUwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E035C43390;
	Tue, 20 Feb 2024 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708450586;
	bh=We2n9ODSY6L65/0pc2yPChZ3dpyFP5S+Apn8iXqk/0s=;
	h=Date:To:From:Subject:From;
	b=u2z7RUwcPmYv48G6RthcCaUvdxJSRcV0LOVR96LlWrg6T6VsgiLHzSziHdV9G7H7a
	 +uw0e1SK9i5JTRLlvz0sYDaT/bSmUELLrdO7oDCf2j1pDLclFRfeyb/yiRpn29ZDaD
	 TBmy368xbaSAe/qSrQLA+SRnPVHAg/niwoTbBlEw=
Date: Tue, 20 Feb 2024 09:36:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch removed from -mm tree
Message-Id: <20240220173626.8E035C43390@smtp.kernel.org>
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
Date: Wed, 31 Jan 2024 21:16:26 +0800

Currently we will use 'cc->nr_freepages >= cc->nr_migratepages' comparison
to ensure that enough freepages are isolated in isolate_freepages(),
however it just decreases the cc->nr_freepages without updating
cc->nr_migratepages in compaction_alloc(), which will waste more CPU
cycles and cause too many freepages to be isolated.

So we should also update the cc->nr_migratepages when allocating or
freeing the freepages to avoid isolating excess freepages.  And I can see
fewer free pages are scanned and isolated when running thpcompact on my
Arm64 server: k6.7 k6.7_patched Ops Compaction pages isolated 120692036.00
118160797.00 Ops Compaction migrate scanned 131210329.00 154093268.00 Ops
Compaction free scanned 1090587971.00 1080632536.00 Ops Compact scan
efficiency 12.03 14.26

Moreover, I did not see an obvious latency improvements, this is likely because
isolating freepages is not the bottleneck in the thpcompact test case.
                              k6.7                  k6.7_patched
Amean     fault-both-1      1089.76 (   0.00%)     1080.16 *   0.88%*
Amean     fault-both-3      1616.48 (   0.00%)     1636.65 *  -1.25%*
Amean     fault-both-5      2266.66 (   0.00%)     2219.20 *   2.09%*
Amean     fault-both-7      2909.84 (   0.00%)     2801.90 *   3.71%*
Amean     fault-both-12     4861.26 (   0.00%)     4733.25 *   2.63%*
Amean     fault-both-18     7351.11 (   0.00%)     6950.51 *   5.45%*
Amean     fault-both-24     9059.30 (   0.00%)     9159.99 *  -1.11%*
Amean     fault-both-30    10685.68 (   0.00%)    11399.02 *  -6.68%*

[akpm@linux-foundation.org: fix it for the dropping of "mm/compaction: optimize >0 order folio compaction with free page split"
Link: https://lkml.kernel.org/r/994af744828efe3c060128445204a56ab41e3ebb.1706706820.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/compaction.c~mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages
+++ a/mm/compaction.c
@@ -1798,6 +1798,7 @@ static struct folio *compaction_alloc(st
 	dst = list_entry(cc->freepages.next, struct folio, lru);
 	list_del(&dst->lru);
 	cc->nr_freepages--;
+	cc->nr_migratepages--;
 
 	return dst;
 }
@@ -1813,6 +1814,7 @@ static void compaction_free(struct folio
 
 	list_add(&dst->lru, &cc->freepages);
 	cc->nr_freepages++;
+	cc->nr_migratepages++;
 }
 
 /* possible outcome of isolate_migratepages */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch
mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb.patch

