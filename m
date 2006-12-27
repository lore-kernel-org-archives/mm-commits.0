From: akpm@osdl.org
Subject: + buglet-in-vmscanc.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:16:40 -0800
Message-ID: <200612270916.kBR9Ge3h006602@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43267 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707AbWL0JRX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:17:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgoel01@yahoo.com, clameter@engr.sgi.com, stable@kernel.org


The patch titled
     Buglet in vmscan.c
has been added to the -mm tree.  Its filename is
     buglet-in-vmscanc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

buglet-in-vmscanc.patch

