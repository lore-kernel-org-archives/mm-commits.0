From: akpm@linux-foundation.org
Subject: - mm-add-nr_writeback_temp-counter-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:21:48 -0700
Message-ID: <200804300621.m3U6LmXI031531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbYD3GW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:22:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     add vmstat_text for NR_WRITEBACK_TEMP
has been removed from the -mm tree.  Its filename was
     mm-add-nr_writeback_temp-counter-fix.patch

This patch was dropped because it was folded into mm-add-nr_writeback_temp-counter.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add vmstat_text for NR_WRITEBACK_TEMP
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Against:  2.6.25-rc8-mm2 [maybe also missing in '.25-mm1]

/proc/vmstat items after "nr_vmscan_write" are off-by-one
because of missing test for NR_WRITEBACK_TEMP that was added
to mmzone.h.

Apparently from:

	mm-add-nr_writeback_temp-counter.patch

in -mm tree.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmstat.c~mm-add-nr_writeback_temp-counter-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-add-nr_writeback_temp-counter-fix
+++ a/mm/vmstat.c
@@ -608,6 +608,7 @@ static const char * const vmstat_text[] 
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
+	"nr_writeback_temp",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch

