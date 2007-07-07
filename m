From: akpm@linux-foundation.org
Subject: - port-of-blktrace-to-the-linux-kernel-markers-fix.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:32:34 -0700
Message-ID: <200707070036.l670ajjZ030030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbXGGAg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Port of blktrace to the Linux Kernel Markers Fix
has been removed from the -mm tree.  Its filename was
     port-of-blktrace-to-the-linux-kernel-markers-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Port of blktrace to the Linux Kernel Markers Fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Adapt the blktrace port to the new markers API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blktrace.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN block/blktrace.c~port-of-blktrace-to-the-linux-kernel-markers-fix block/blktrace.c
--- a/block/blktrace.c~port-of-blktrace-to-the-linux-kernel-markers-fix
+++ a/block/blktrace.c
@@ -806,23 +806,31 @@ int blk_probe_arm(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
-		result = marker_arm_probe(probe_array[i].name,
+		result = marker_probe_register(probe_array[i].name,
 				probe_array[i].format,
-				probe_array[i].callback, &probe_array[i]);
+				probe_array[i].callback, &probe_array[i], 0);
 		if (result)
 			printk(KERN_INFO
 				"blktrace unable to register probe %s\n",
 				probe_array[i].name);
+		result = marker_arm(probe_array[i].name);
+		if (result)
+			printk(KERN_INFO
+				"blktrace unable to arm probe %s\n",
+				probe_array[i].name);
 	}
 	return 0;
 }
 
 void blk_probe_disarm(void)
 {
-	int i;
+	int i, err;
 
 	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
-		marker_disarm_probe(probe_array[i].name);
+		err = marker_disarm(probe_array[i].name);
+		BUG_ON(err);
+		err = IS_ERR(marker_probe_unregister(probe_array[i].name));
+		BUG_ON(err);
 	}
 }
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
