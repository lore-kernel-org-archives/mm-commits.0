Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCF66CDB3
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824373; cv=none; b=R9dWlayrMQB0JUYZ7W2LrbxxFp79ScH9VQ7dyBEZI7PSFQFrzenfqVVz+iFs7X+UzXfpoRHs/mXAmqIekP5ji9WvCOstgTOQpuiXLp63V9V7SLhbLEfrlacF31UsQMTjunieH6Npoav7MVEvQtqrZsBPJ7NB1EnIPX8fu1uBVng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824373; c=relaxed/simple;
	bh=+UyYbxg3Him6v0fWyRkCfe2J6qVEZwSTO+3UfE1CdMI=;
	h=Date:To:From:Subject:Message-Id; b=WWgjuKVRhJBNWm+G663Qdhq4uzsSWJpC3xvRQMh/Lfzm9VIAbnJu2dyV61szbCJcWajBUntl1dx9MBoOHWlsFj7SBRS49jn6H4T8tDDfHOIn44mGfkfQH2oMocqFWEiIp1SBGMTYc6CohL7rmTHJxRL9MTzxUmx1fGX81F8OJG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aU849sHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aU849sHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3465C32782;
	Fri, 12 Jul 2024 22:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824372;
	bh=+UyYbxg3Him6v0fWyRkCfe2J6qVEZwSTO+3UfE1CdMI=;
	h=Date:To:From:Subject:From;
	b=aU849sHb7ogKNVmG+srtrDs51aPyUxlGwfP4zr8kdjmPIKC80ECyBeQaEETQ6+mwy
	 Abq1pFTx0oSTep7I0ssajU7SA6ggQplZQOa6kzlQqAYHG6/J27iz9zSuN5nlrCM9RP
	 Yv7JwdVN+dGPsNtnUud4BkHvdFKzkGJLfVoPttEI=
Date: Fri, 12 Jul 2024 15:46:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch removed from -mm tree
Message-Id: <20240712224612.B3465C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-docs-for-per-order-mthp-split-counters-v3-fix
has been removed from the -mm tree.  Its filename was
     mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch

This patch was dropped because it was folded into mm-add-docs-for-per-order-mthp-split-counters.patch

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-add-docs-for-per-order-mthp-split-counters-v3-fix
Date: Sun, 7 Jul 2024 09:36:59 +0800

tweak Documentation/admin-guide/mm/transhuge.rst

Link: https://lkml.kernel.org/r/20240707013659.1151-1-ioworker0@gmail.com
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-docs-for-per-order-mthp-split-counters-v3-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -514,17 +514,16 @@ split
 	is incremented every time a huge page is successfully split into
 	smaller orders. This can happen for a variety of reasons but a
 	common reason is that a huge page is old and is being reclaimed.
-	This action implies splitting any block mappings into PTEs.
 
 split_failed
 	is incremented if kernel fails to split huge
 	page. This can happen if the page was pinned by somebody.
 
 split_deferred
-	is incremented when a huge page is put onto split
-	queue. This happens when a huge page is partially unmapped and
-	splitting it would free up some memory. Pages on split queue are
-	going to be split under memory pressure.
+        is incremented when a huge page is put onto split queue.
+        This happens when a huge page is partially unmapped and splitting
+        it would free up some memory. Pages on split queue are going to
+        be split under memory pressure, if splitting is possible.
 
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters.patch

