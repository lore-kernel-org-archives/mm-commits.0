From: akpm@linux-foundation.org
Subject: - sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:36 -0700
Message-ID: <200710051956.l95JuaNC022365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761328AbXJET4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, waite@skycomputers.com, mm-commits@vger.kernel.org


The patch titled
     Sky Cpu and Nexus: check for create_proc_entry ret code
has been removed from the -mm tree.  Its filename was
     sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Sky Cpu and Nexus: check for create_proc_entry ret code
From: Cyrill Gorcunov <gorcunov@gmail.com>

Adds checking of create_proc_entry call to prevent possible NULL pointer
usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Brian Waite <waite@skycomputers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_nexus.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

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

git-cifs.patch
git-powerpc.patch
udf-code-style-fixup-v3.patch
