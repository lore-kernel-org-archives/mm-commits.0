From: akpm@linux-foundation.org
Subject: + sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:04:00 -0700
Message-ID: <200707052204.l65M402W021699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760742AbXGEWEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     Sky Cpu and Nexus: check for platform_get_resource ret 	code
has been added to the -mm tree.  Its filename is
     sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sky Cpu and Nexus: check for platform_get_resource ret 	code
From: Cyrill Gorcunov <gorcunov@gmail.com>

tAdd adds checking for platform_get_resource() return code to prevent possible
NULL pointer usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    5 +++++
 drivers/misc/hdpuftrs/hdpu_nexus.c    |    7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-check-for-platform_get_resource-ret drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-check-for-platform_get_resource-ret
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -194,6 +194,11 @@ static int hdpu_cpustate_probe(struct pl
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		printk(KERN_ERR "sky_cpustate: "
+		       "Invalid memory resource.\n");
+		return -EINVAL;
+	}
 	cpustate.set_addr = (unsigned long *)res->start;
 	cpustate.clr_addr = (unsigned long *)res->end - 1;
 
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-check-for-platform_get_resource-ret drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-check-for-platform_get_resource-ret
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -62,6 +62,11 @@ static int hdpu_nexus_probe(struct platf
 	int *nexus_id_addr;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		printk(KERN_ERR "sky_nexus: "
+		       "Invalid memory resource.\n");
+		return -EINVAL;
+	}
 	nexus_id_addr = ioremap(res->start,
 				(unsigned long)(res->end - res->start));
 	if (nexus_id_addr) {
@@ -69,7 +74,7 @@ static int hdpu_nexus_probe(struct platf
 		chassis_id = *nexus_id_addr & 0xff;
 		iounmap(nexus_id_addr);
 	} else {
-		printk(KERN_ERR "Could not map slot id\n");
+		printk(KERN_ERR "sky_nexus: Could not map slot id\n");
 	}
 
 	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
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
