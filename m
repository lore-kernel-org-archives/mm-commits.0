From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch removed from -mm
 tree
Date: Thu, 30 Jan 2020 21:49:07 -0800
Message-ID: <20200131054907.uTrISO6bB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgAaFtI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 00:49:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, cl@linux.com, dwagner@suse.de, mm-commits@vger.kernel.org, tobin@kernel.org


The patch titled
     Subject: mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch

This patch was dropped because it was folded into mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix

renumber the bits for neatness

Cc: Alex Shi <alex.shi@linux.alibaba.com>
From: Daniel Wagner <dwagner@suse.de>
Subject: tools/vm/slabinfo: fix sanity checks enabling

The sysfs file name for enabling sanity checking is called 'sanity_checks'
and not 'sanity'.

The name of the file has never changed since the introduction of the slub
allocator.  Obviously, most people turn the checks on via the command line
option and not during runtime using slabinfo.

Link: http://lkml.kernel.org/r/20200116131642.642-1-dwagner@suse.de
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix
+++ a/mm/vmscan.c
@@ -4118,8 +4118,8 @@ module_init(kswapd_init)
  */
 int node_reclaim_mode __read_mostly;
 
-#define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
-#define RECLAIM_UNMAP (1<<2)	/* Unmap pages during reclaim */
+#define RECLAIM_WRITE (1<<0)	/* Writeout pages during reclaim */
+#define RECLAIM_UNMAP (1<<1)	/* Unmap pages during reclaim */
 
 /*
  * Priority for NODE_RECLAIM. This determines the fraction of pages
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch
