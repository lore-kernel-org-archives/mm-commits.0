Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90EE6CDB3
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824371; cv=none; b=OuS2ya3wvNnz86F8W8U2qFNqRu6mRSdpTcZCOWmuoIHFSCLJK3pTxE0XOwJgnRmhdBYNW5b9YQM/sVfgAecns7BGi3PvJOKPrXm9viiMVhqrc6oeLtqCfQiGqArnEvsUI2OmOtbPQesSMcuVcPhpuMQx0g0yOz7t+xOP+99YVqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824371; c=relaxed/simple;
	bh=dt2VByi4IyWrmzQao94G7dJSyeHB1FBpD78xXIS2eBc=;
	h=Date:To:From:Subject:Message-Id; b=FW+37r/ex/SklOF4ZIqnLAOo1uo4a7kpwR9Asc9wJW1sBIxY5oebHkwnc0cGYy0WKbkj/bUsRXKyVY95g4H6w0XmFse31BGxrgnRB1csOYL8McyojDQScOduemRzwgYKyd72sW/g8WI9OAYCCjBZN8v4GFg3C+0Lp63deLblOI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFTBVSJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFTBVSJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FF4C32782;
	Fri, 12 Jul 2024 22:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824371;
	bh=dt2VByi4IyWrmzQao94G7dJSyeHB1FBpD78xXIS2eBc=;
	h=Date:To:From:Subject:From;
	b=dFTBVSJo3MHFZvxV/E7rLpz35Gg0FdyZFvxg66kGJc8Ym346ojf6KTlJ8z3rAPTUR
	 uDba4xFpbOUH4ClA4QJN1QjjfP0Dhinwzh+SPsRJR6ip7Fit7AAzsbQbbzS51zTbq6
	 atUHU4MNh1satUyELwAv7b0tb98P5G1gkdV1Nqts=
Date: Fri, 12 Jul 2024 15:46:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-docs-for-per-order-mthp-split-counters-v3.patch removed from -mm tree
Message-Id: <20240712224611.85FF4C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-docs-for-per-order-mthp-split-counters-v3
has been removed from the -mm tree.  Its filename was
     mm-add-docs-for-per-order-mthp-split-counters-v3.patch

This patch was dropped because it was folded into mm-add-docs-for-per-order-mthp-split-counters.patch

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-add-docs-for-per-order-mthp-split-counters-v3
Date: Thu, 4 Jul 2024 09:29:05 +0800

improve the doc as suggested by Ryan

Link: https://lkml.kernel.org/r/20240704012905.42971-3-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-docs-for-per-order-mthp-split-counters-v3
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -369,10 +369,6 @@ also applies to the regions registered i
 Monitoring usage
 ================
 
-.. note::
-   Currently the below counters only record events relating to
-   PMD-sized THP. Events relating to other THP sizes are not included.
-
 The number of PMD-sized anonymous transparent huge pages currently used by the
 system is available by reading the AnonHugePages field in ``/proc/meminfo``.
 To identify what applications are using PMD-sized anonymous transparent huge
@@ -516,8 +512,8 @@ file_fallback_charge
 
 split
 	is incremented every time a huge page is successfully split into
-	base pages. This can happen for a variety of reasons but a common
-	reason is that a huge page is old and is being reclaimed.
+	smaller orders. This can happen for a variety of reasons but a
+	common reason is that a huge page is old and is being reclaimed.
 	This action implies splitting any block mappings into PTEs.
 
 split_failed
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch

