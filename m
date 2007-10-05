From: akpm@linux-foundation.org
Subject: - sky-cpu-use-c99-style-for-struct-init.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:38 -0700
Message-ID: <200710051956.l95JucAp022371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761495AbXJET4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, waite@skycomputers.com, mm-commits@vger.kernel.org


The patch titled
     Sky Cpu: use C99 style for struct init
has been removed from the -mm tree.  Its filename was
     sky-cpu-use-c99-style-for-struct-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Sky Cpu: use C99 style for struct init
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch change structure item init format to C99.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Brian Waite <waite@skycomputers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

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

git-cifs.patch
git-powerpc.patch
udf-code-style-fixup-v3.patch
