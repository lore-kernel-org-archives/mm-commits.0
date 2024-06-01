Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD10D6FB6
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717202105; cv=none; b=cWSA/X9+gf1HyfTgkh1ZGSmr2wSTpykbL1sUruQbRaNgZ5usq798bQPuaN8twhbvpucBmkec1/AzERiVe00TuB/SJKTdFAya7nM/lDpnnrDg14MC7WYvzS0fXLPQyNqWaiM76/BfwJWWHly8YBIc75bxXoh54jCC2HLxxilRg0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717202105; c=relaxed/simple;
	bh=ZH4zPToCVWhNhxiohnxnpNxtIoktP1QHKkcGrA7Ukwc=;
	h=Date:To:From:Subject:Message-Id; b=utUqa6CsLE99VpoUfrUF1BBUJe8PTuLm06L1wJUNlH1rjPHqZfoH5B0wsyz9JbPLsEe2PpMmg4btmDQUSansFavIVZ4IgtsE6rcv/VI+CaWdbME+scftp71CliWScyLPnVaxvn5I7O5I2RIIRN4+PtvFIsT1szf4pg2vN7dxOYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DcrW90Fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DcrW90Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33922C116B1;
	Sat,  1 Jun 2024 00:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717202105;
	bh=ZH4zPToCVWhNhxiohnxnpNxtIoktP1QHKkcGrA7Ukwc=;
	h=Date:To:From:Subject:From;
	b=DcrW90Fkkl1KNIZM8rUWaruZCmtprmJyBLRRzN5S3z8anm+SSe0RkE9atg23EVphq
	 1vKznTlHF7fceLr06q382/zZ1Rc9Z9PemQxxxfO49X3oDV4NeI5uwqW57Orxx74SXk
	 6s9OWDztIinpRqBMjIyMGHgFhq5bLtMw8SWHny5o=
Date: Fri, 31 May 2024 17:35:04 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-get-the-highest-zone-directly.patch added to mm-unstable branch
Message-Id: <20240601003505.33922C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: get the highest zone directly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-get-the-highest-zone-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-get-the-highest-zone-directly.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: get the highest zone directly
Date: Fri, 31 May 2024 00:26:11 +0000

We have recorded nr_zones in pgdat, just get it directly.

Link: https://lkml.kernel.org/r/20240531002613.5231-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-get-the-highest-zone-directly
+++ a/mm/mm_init.c
@@ -2138,7 +2138,7 @@ static int __init deferred_init_memmap(v
 	unsigned long first_init_pfn, flags;
 	unsigned long start = jiffies;
 	struct zone *zone;
-	int zid, max_threads;
+	int max_threads;
 	u64 i;
 
 	/* Bind memory initialisation thread to a local node if possible */
@@ -2165,12 +2165,8 @@ static int __init deferred_init_memmap(v
 	 */
 	pgdat_resize_unlock(pgdat, &flags);
 
-	/* Only the highest zone is deferred so find it */
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		zone = pgdat->node_zones + zid;
-		if (first_init_pfn < zone_end_pfn(zone))
-			break;
-	}
+	/* Only the highest zone is deferred */
+	zone = pgdat->node_zones + pgdat->nr_zones - 1;
 
 	/* If the zone is empty somebody else may have cleared out the zone */
 	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
@@ -2198,7 +2194,7 @@ static int __init deferred_init_memmap(v
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */
-	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
+	WARN_ON(pgdat->nr_zones < MAX_NR_ZONES && populated_zone(++zone));
 
 	pr_info("node %d deferred pages initialised in %ums\n",
 		pgdat->node_id, jiffies_to_msecs(jiffies - start));
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-get-the-highest-zone-directly.patch
mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch
mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch

