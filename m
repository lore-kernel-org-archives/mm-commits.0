From: akpm@linux-foundation.org
Subject: - sky-cpu-and-nexus-include-ioh.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:32 -0700
Message-ID: <200710051956.l95JuWCX022359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761237AbXJET4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, waite@skycomputers.com, mm-commits@vger.kernel.org


The patch titled
     Sky Cpu and Nexus: include io.h
has been removed from the -mm tree.  Its filename was
     sky-cpu-and-nexus-include-ioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Sky Cpu and Nexus: include io.h
From: Cyrill Gorcunov <gorcunov@gmail.com>

Add #include <asm/io.h> directive to properly declare ioremap() and writel().

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Brian Waite <waite@skycomputers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    1 +
 drivers/misc/hdpuftrs/hdpu_nexus.c    |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-include-ioh drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-include-ioh
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <asm/uaccess.h>
 #include <linux/hdpu_features.h>
+#include <asm/io.h>
 
 #define SKY_CPUSTATE_VERSION		"1.1"
 
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-include-ioh drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-include-ioh
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -20,6 +20,7 @@
 #include <linux/hdpu_features.h>
 
 #include <linux/platform_device.h>
+#include <asm/io.h>
 
 static int hdpu_nexus_probe(struct platform_device *pdev);
 static int hdpu_nexus_remove(struct platform_device *pdev);
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-cifs.patch
git-powerpc.patch
udf-code-style-fixup-v3.patch
