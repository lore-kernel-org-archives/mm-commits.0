Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064ED144D00
	for <mm-commits@vger.kernel.org>; Thu,  1 Aug 2024 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722538752; cv=none; b=ghZra1Sqp8Ligo8czabv5tPMrkBgcBeZwlSgG1BYrbKhUL2GHi9Z8vvRb+Oi6LOIvoDMJ/XBHBiaDmrLsJyFZ3Im7z4A0JXai3M22Q0t5D87ZudBm+yiiqFLkRZUQr7OK7hJcxFH9GfssYB91/Et5GN4dCYK5SEWidh5A7wIwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722538752; c=relaxed/simple;
	bh=2KnsVxkDV+H5/7g0/PsYmIFOzvHTK891JICDNaYf9cw=;
	h=Date:To:From:Subject:Message-Id; b=SSqKkflr05VY3JLNkp+RVP+ZbB1LdP3xFlJn78UdAqZi6QdAk7qojxMro6Noc9qjTugoJ3ipo2VJLAR9UCX1AcFhEoKgR5tPsylimzZDY9yJaVP0qiU9KpaUdBltCfArv4oBgJIcEPbjQY+V1WMyLPwaz8Wv0NkGPxgvoInQaUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d7fBDaJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d7fBDaJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B44C32786;
	Thu,  1 Aug 2024 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722538751;
	bh=2KnsVxkDV+H5/7g0/PsYmIFOzvHTK891JICDNaYf9cw=;
	h=Date:To:From:Subject:From;
	b=d7fBDaJq/V6azZzR+jCR8Zp2zOhCsodxbNG/saPufW7CkfSnP937x+Sa9FOHIOa5A
	 cCFZJvbM8iQQJLPw8klxt51DdVEkdV/DUQJIQS/ipnm1NWgPcUnb+KHkG/Vinzs1r+
	 nl08f3khZ7Pzj5fglGsos7dN8oL9u+o45J8oSKhs=
Date: Thu, 01 Aug 2024 11:59:11 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch added to mm-unstable branch
Message-Id: <20240801185911.A3B44C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: consider CMA pages in watermark check for NUMA balancing target node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch

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
From: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Subject: mm: consider CMA pages in watermark check for NUMA balancing target node
Date: Thu, 1 Aug 2024 18:04:56 +0000

Currently in migrate_balanced_pgdat(), ALLOC_CMA flag is not passed when
checking watermark on the migration target node.  This does not match the
gfp in alloc_misplaced_dst_folio() which allows allocation from CMA.

This causes promotion failures when there are a lot of available CMA
memory in the system.

Therefore, we change the alloc_flags passed to zone_watermark_ok() in
migrate_balanced_pgdat().

Link: https://lkml.kernel.org/r/20240801180456.25927-1-kaiyang2@cs.cmu.edu
Signed-off-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node
+++ a/mm/migrate.c
@@ -2526,7 +2526,7 @@ static bool migrate_balanced_pgdat(struc
 		if (!zone_watermark_ok(zone, 0,
 				       high_wmark_pages(zone) +
 				       nr_migrate_pages,
-				       ZONE_MOVABLE, 0))
+				       ZONE_MOVABLE, ALLOC_CMA))
 			continue;
 		return true;
 	}
_

Patches currently in -mm which might be from kaiyang2@cs.cmu.edu are

mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch

