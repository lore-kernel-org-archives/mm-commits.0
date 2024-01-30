Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2BE1172C
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596260; cv=none; b=dVgZKRiiOTyq13g+qxXuTqeJ2Vk4LgY3H8IlcHcC680vH7A8MBosqFptCa3pxizrn49MtkOLfouvlRmPAHsAVexuxd5geYykzlSh+jD7JfUl4ZbX35q1yXjoRaYyPWR32e54biCgTE3KH1N2I2ZvNsjY53EJBo+aIMlv6t8CbO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596260; c=relaxed/simple;
	bh=4NsRjAwwgh8tNWaTwGZ3RRWdPqmi8ZTWQrNA5AN2zkw=;
	h=Date:To:From:Subject:Message-Id; b=k8beR/d5Kj45moz9IpLpCgm/SnbMNNhbVQ7Ml1LqsKyM++KUIOIL9JUJBVaShNbrnJgUOANzvu8RyLfrAv1ntmGHlsrqP4IowR4ceP3f44Mb3flaa+IUcHpmMIvG8BXue9F6xZkaPKs4dmnQopunEVCFNYH34DHCAHVHb7nbeIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TGmzOXOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TGmzOXOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1891C433C7;
	Tue, 30 Jan 2024 06:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596260;
	bh=4NsRjAwwgh8tNWaTwGZ3RRWdPqmi8ZTWQrNA5AN2zkw=;
	h=Date:To:From:Subject:From;
	b=TGmzOXOyb/SPivfFwuJhT0fH7dqlMcg631UnJmYBCxFmbHC6TGVpKTwqOsbU73ORs
	 sidkpExGuZY9cuYDq1Ia89/Cim5mv5Jcm4WhyNu2ko0gIk7wiGDVy9i8FrFksdho4V
	 Mg3cWmFJSKSbn5NILcA4fEFC015ca3paesnEVrlk=
Date: Mon, 29 Jan 2024 22:30:45 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch added to mm-unstable branch
Message-Id: <20240130063057.A1891C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

