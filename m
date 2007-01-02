From: akpm@osdl.org
Subject: - buglet-in-vmscanc.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:49 -0800
Message-ID: <200701020724.l027On5G012983@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37440 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914AbXABHZX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgoel01@yahoo.com, clameter@engr.sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Buglet in vmscan.c
has been removed from the -mm tree.  Its filename was
     buglet-in-vmscanc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Buglet in vmscan.c
From: Shantanu Goel <sgoel01@yahoo.com>

Fix a rather obvious buglet.  Noticed while instrumenting the VM using
/proc/vmstat.

Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~buglet-in-vmscanc mm/vmscan.c
--- a/mm/vmscan.c~buglet-in-vmscanc
+++ a/mm/vmscan.c
@@ -692,7 +692,7 @@ static unsigned long shrink_inactive_lis
 			__count_vm_events(KSWAPD_STEAL, nr_freed);
 		} else
 			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scan);
-		__count_vm_events(PGACTIVATE, nr_freed);
+		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
 
 		if (nr_taken == 0)
 			goto done;
_

Patches currently in -mm which might be from sgoel01@yahoo.com are
