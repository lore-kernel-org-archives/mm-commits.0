Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695B62F5E
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 01:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721698665; cv=none; b=eYq+XXf5Z6mwjIRe3ufeZJaMHoZ3wMesO1i/Cd30DUC4mfStBu0hdLIJ0TXIKO9ZB2lPuhYzlxw8YL5JIh0Y/HWnRxFDiMh5I1GntQMrquPUeR5Ah20wxizcUwcue073j3HFogmY7M6xpkSSXrxcC8EacCg+UtB7MRtuVdfUOOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721698665; c=relaxed/simple;
	bh=AYzdw3cVDRGb0naadROx2Yrmzdmj1rPigNvbxA6Ar2U=;
	h=Date:To:From:Subject:Message-Id; b=ZnL33l8bH+uKi4Reyu8/hC9Mb8dVI8pxomp90NGqLRTi1Zjk/WVlYpP7OJXJh2mOIYD2OLIiY5u94AhB53qy2DILvKsMFjUviQQx7Lk3ioEbpTVkXhPCdyr/FTo5ONiUcmPy3NLGDgJd2AgZJuTEF4fccOpTAHAPdU9zF2McIso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n0m7fCn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n0m7fCn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F3EC116B1;
	Tue, 23 Jul 2024 01:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721698664;
	bh=AYzdw3cVDRGb0naadROx2Yrmzdmj1rPigNvbxA6Ar2U=;
	h=Date:To:From:Subject:From;
	b=n0m7fCn3kEr+CWZEpG3CWMak7dfWtTIMimksIO363yP1sA2nC0tgVXXmTFK3McQ4/
	 ghMbl8fGa9HL8u7u1gIG6srjVfv+bTv+lyiRBjlOud2rsWwiLIeyFZSOar08Jeh259
	 Hu3PYkIMQC8Z5G2i/T4K6SJn4NGFebUFwqFlYZ4M=
Date: Mon, 22 Jul 2024 18:37:44 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,lizhijian@fujitsu.com,cerasuolodomenico@gmail.com,mcassell411@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-added-node_reclaim-successes-to-vm-event-counters.patch added to mm-unstable branch
Message-Id: <20240723013744.D3F3EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add node_reclaim successes to VM event counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-added-node_reclaim-successes-to-vm-event-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-added-node_reclaim-successes-to-vm-event-counters.patch

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
@@ -7548,7 +7548,9 @@ int node_reclaim(struct pglist_data *pgd
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
@@ -1296,6 +1296,7 @@ const char * const vmstat_text[] = {
 	"pgsteal_file",
 
 #ifdef CONFIG_NUMA
+	"zone_reclaim_success",
 	"zone_reclaim_failed",
 #endif
 	"pginodesteal",
_

Patches currently in -mm which might be from mcassell411@gmail.com are

mm-added-node_reclaim-successes-to-vm-event-counters.patch

