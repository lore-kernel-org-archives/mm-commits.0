From: akpm@linux-foundation.org
Subject: + port-of-blktrace-to-the-linux-kernel-markers-fix.patch added to -mm tree
Date: Fri, 06 Jul 2007 10:55:58 -0700
Message-ID: <200707061755.l66Htwu8011089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764422AbXGFR4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 13:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Port of blktrace to the Linux Kernel Markers Fix
has been added to the -mm tree.  Its filename is
     port-of-blktrace-to-the-linux-kernel-markers-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
