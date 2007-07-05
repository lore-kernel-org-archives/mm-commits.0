From: akpm@linux-foundation.org
Subject: + sky-cpu-use-c99-style-for-struct-init.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:04:46 -0700
Message-ID: <200707052204.l65M4kLm021733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761681AbXGEWE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     Sky Cpu: use C99 style for struct init
has been added to the -mm tree.  Its filename is
     sky-cpu-use-c99-style-for-struct-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sky Cpu: use C99 style for struct init
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch change structure item init format to C99.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-use-c99-style-for-struct-init drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-use-c99-style-for-struct-init
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -170,21 +170,21 @@ static struct platform_driver hdpu_cpust
  *	The various file operations we support.
  */
 static const struct file_operations cpustate_fops = {
-      owner:	THIS_MODULE,
-      open:	cpustate_open,
-      release:	cpustate_release,
-      read:	cpustate_read,
-      write:	cpustate_write,
-      fasync:	NULL,
-      poll:	NULL,
-      ioctl:	NULL,
-      llseek:	no_llseek,
+      .owner	= THIS_MODULE,
+      .open	= cpustate_open,
+      .release	= cpustate_release,
+      .read	= cpustate_read,
+      .write	= cpustate_write,
+      .fasync	= NULL,
+      .poll	= NULL,
+      .ioctl	= NULL,
+      .llseek	= no_llseek,
 };
 
 static struct miscdevice cpustate_dev = {
-	MISC_DYNAMIC_MINOR,
-	"sky_cpustate",
-	&cpustate_fops,
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "sky_cpustate",
+	.fops	= &cpustate_fops,
 };
 
 static int hdpu_cpustate_probe(struct platform_device *pdev)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
udf-coding-style-conversion-lindent.patch
udf-coding-style-conversion-lindent-fixups.patch
udf-coding-style-conversion-lindent-fixups-2.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
