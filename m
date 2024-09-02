Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CB2273FC
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247656; cv=none; b=TQYMBeA9lPJriedw9CJy8whcfc05W0Ru9jL0sB13LVvUGDX2ZWbOyFmYrqMk9ADfjAYFARVWmuyrQQWGj8Z9AUclm4kJh6SzwzryWrLHtNbnwFMAb2YISd+tgJW0T8UQ3yMaODEg7jEjvaA4Mr0HBtONkywahrHL7hCY8E0/BOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247656; c=relaxed/simple;
	bh=iIUcdiA6T7BdMgIM/uZiZcF7vVHPcjcYujEgmxl3YEc=;
	h=Date:To:From:Subject:Message-Id; b=j8xbivheh4r5oy+DxTBPXLfnQvCYm2Crqkio+V2dYoP9+G/gOqTIW2JUkLPPk2wTJtdDxfmWA9D54JDjCMR/CBovYM1Kdc0kTTrloo8zaul/V7ndKCIN3oUk/3yjaUJheYJiUXhrufF293AXbAvghmBjgmM2ZxOB2umH5ukn/lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s5vO+4aE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s5vO+4aE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EB5C4CEC2;
	Mon,  2 Sep 2024 03:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247656;
	bh=iIUcdiA6T7BdMgIM/uZiZcF7vVHPcjcYujEgmxl3YEc=;
	h=Date:To:From:Subject:From;
	b=s5vO+4aENZPghxAuA7e6yLHvILuzYDV5xGY+gHx+ygyZ7c9O2hE/4WdTAIfu5H89f
	 vDIrI1E6aUKvd5n83Lt8CAePFd+lg67Qq3JgAWBTncmzi5YcLz77WK9wZwgSSiBQbv
	 ZkjvMcaYBgm8qNIBHE2geg9NkDLgSli3fInw4GDY=
Date: Sun, 01 Sep 2024 20:27:35 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,lizhijian@fujitsu.com,cerasuolodomenico@gmail.com,mcassell411@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-added-node_reclaim-successes-to-vm-event-counters.patch removed from -mm tree
Message-Id: <20240902032735.E1EB5C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add node_reclaim successes to VM event counters
has been removed from the -mm tree.  Its filename was
     mm-added-node_reclaim-successes-to-vm-event-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matthew Cassell <mcassell411@gmail.com>
Subject: mm: add node_reclaim successes to VM event counters
Date: Mon, 22 Jul 2024 17:13:16 +0000

/proc/vmstat currently shows the number of node_reclaim() failures when
vm.zone_reclaim_mode is set appropriately.  It would be convenient to have
the number of successes right next to zone_reclaim_failed (similar to
compaction and migration).

While just a trivially addition to the vmstat file.  It was helpful during
benchmarking to not have to probe node_reclaim() to observe the
success/failure ratio.

Link: https://lkml.kernel.org/r/20240722171316.7517-1-mcassell411@gmail.com
Signed-off-by: Matthew Cassell <mcassell411@gmail.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/vmscan.c                   |    4 +++-
 mm/vmstat.c                   |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/vm_event_item.h~mm-added-node_reclaim-successes-to-vm-event-counters
+++ a/include/linux/vm_event_item.h
@@ -50,6 +50,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGSTEAL_ANON,
 		PGSTEAL_FILE,
 #ifdef CONFIG_NUMA
+		PGSCAN_ZONE_RECLAIM_SUCCESS,
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_INODESTEAL,
--- a/mm/vmscan.c~mm-added-node_reclaim-successes-to-vm-event-counters
+++ a/mm/vmscan.c
@@ -7539,7 +7539,9 @@ int node_reclaim(struct pglist_data *pgd
 	ret = __node_reclaim(pgdat, gfp_mask, order);
 	clear_bit(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
-	if (!ret)
+	if (ret)
+		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
+	else
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
 
 	return ret;
--- a/mm/vmstat.c~mm-added-node_reclaim-successes-to-vm-event-counters
+++ a/mm/vmstat.c
@@ -1314,6 +1314,7 @@ const char * const vmstat_text[] = {
 	"pgsteal_file",
 
 #ifdef CONFIG_NUMA
+	"zone_reclaim_success",
 	"zone_reclaim_failed",
 #endif
 	"pginodesteal",
_

Patches currently in -mm which might be from mcassell411@gmail.com are


