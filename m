From: akpm@linux-foundation.org
Subject: + sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:04:02 -0700
Message-ID: <200707052204.l65M42ba021702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760449AbXGEWET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     Sky Cpu and Nexus: check for create_proc_entry ret code
has been added to the -mm tree.  Its filename is
     sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sky Cpu and Nexus: check for create_proc_entry ret code
From: Cyrill Gorcunov <gorcunov@gmail.com>

tAdd adds checking of create_proc_entry call to prevent possible NULL pointer
usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_nexus.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-check-for-create_proc_entry-ret-code drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-check-for-create_proc_entry-ret-code
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -78,10 +78,20 @@ static int hdpu_nexus_probe(struct platf
 	}
 
 	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
-	hdpu_slot_id->read_proc = hdpu_slot_id_read;
+	if (!hdpu_slot_id) {
+		printk(KERN_WARNING "sky_nexus: "
+		       "Unable to create proc dir entry: sky_slot_id\n");
+	} else {
+		hdpu_slot_id->read_proc = hdpu_slot_id_read;
+	}
 
 	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
-	hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
+	if (!hdpu_chassis_id) {
+		printk(KERN_WARNING "sky_nexus: "
+		       "Unable to create proc dir entry: sky_chassis_id\n");
+	} else {
+		hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from gorcunov@gmail.com are

sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
udf-coding-style-conversion-lindent.patch
udf-coding-style-conversion-lindent-fixups.patch
udf-coding-style-conversion-lindent-fixups-2.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
