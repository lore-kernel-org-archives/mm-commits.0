From: akpm@linux-foundation.org
Subject: + sky-cpu-and-nexus-include-ioh.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:03:58 -0700
Message-ID: <200707052203.l65M3wnY021696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757823AbXGEWEI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:04:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     Sky Cpu and Nexus: include io.h
has been added to the -mm tree.  Its filename is
     sky-cpu-and-nexus-include-ioh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sky Cpu and Nexus: include io.h
From: Cyrill Gorcunov <gorcunov@gmail.com>

Add #include <asm/io.h> directive to properly declare ioremap() and writel().

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
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
