From: akpm@linux-foundation.org
Subject: [folded-merged]
 tools-vm-slabinfo-fix-sanity-checks-enabling.patch removed from -mm tree
Date: Thu, 16 Jan 2020 15:38:32 -0800
Message-ID: <20200116233832.PdkO6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391250AbgAPXid (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 18:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tobin@kernel.org, cl@linux.com, akpm@linux-foundation.org, dwagner@suse.de


The patch titled
     Subject: tools/vm/slabinfo: fix sanity checks enabling
has been removed from the -mm tree.  Its filename was
     tools-vm-slabinfo-fix-sanity-checks-enabling.patch

This patch was dropped because it was folded into mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch

------------------------------------------------------
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

 tools/vm/slabinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-fix-sanity-checks-enabling
+++ a/tools/vm/slabinfo.c
@@ -720,11 +720,11 @@ static void slab_debug(struct slabinfo *
 		return;
 
 	if (sanity && !s->sanity_checks) {
-		set_obj(s, "sanity", 1);
+		set_obj(s, "sanity_checks", 1);
 	}
 	if (!sanity && s->sanity_checks) {
 		if (slab_empty(s))
-			set_obj(s, "sanity", 0);
+			set_obj(s, "sanity_checks", 0);
 		else
 			fprintf(stderr, "%s not empty cannot disable sanity checks\n", s->name);
 	}
_

Patches currently in -mm which might be from dwagner@suse.de are

mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
