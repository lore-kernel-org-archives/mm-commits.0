From: akpm@linux-foundation.org
Subject: - sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:34 -0700
Message-ID: <200710051956.l95JuYZ0022362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761143AbXJET4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, waite@skycomputers.com, mm-commits@vger.kernel.org


The patch titled
     Sky Cpu and Nexus: check for platform_get_resource ret 	code
has been removed from the -mm tree.  Its filename was
     sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Sky Cpu and Nexus: check for platform_get_resource ret 	code
From: Cyrill Gorcunov <gorcunov@gmail.com>

tAdd adds checking for platform_get_resource() return code to prevent possible
NULL pointer usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Brian Waite <waite@skycomputers.com>
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

git-cifs.patch
git-powerpc.patch
udf-code-style-fixup-v3.patch
