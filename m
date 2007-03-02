From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:57:30 -0800
Message-ID: <200703020457.l224vUEk000535@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41993 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbXCBE5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:57:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, kraxel@suse.de, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: add early printk support via hvc console
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch

This patch was dropped because Zach's patches destroyed it all

------------------------------------------------------
Subject: xen-paravirt_ops: add early printk support via hvc console
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add early printk support via hvc console, enable using "earlyprintk=xen" on
the kernel command line.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/early_printk.c |    5 +++++
 drivers/xen/hvc-console.c         |   25 +++++++++++++++++++++++++
 include/xen/hvc-console.h         |    6 ++++++
 3 files changed, 36 insertions(+)

diff -puN arch/x86_64/kernel/early_printk.c~xen-paravirt_ops-add-early-printk-support-via-hvc-console arch/x86_64/kernel/early_printk.c
--- a/arch/x86_64/kernel/early_printk.c~xen-paravirt_ops-add-early-printk-support-via-hvc-console
+++ a/arch/x86_64/kernel/early_printk.c
@@ -6,6 +6,7 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
+#include <xen/hvc-console.h>
 
 /* Simple VGA output */
 
@@ -243,6 +244,10 @@ static int __init setup_early_printk(cha
  		simnow_init(buf + 6);
  		early_console = &simnow_console;
  		keep_early = 1;
+#ifdef CONFIG_XEN
+	} else if (!strncmp(buf, "xen", 3)) {
+ 		early_console = &xenboot_console;
+#endif
 	}
 	register_console(early_console);
 	return 0;
diff -puN drivers/xen/hvc-console.c~xen-paravirt_ops-add-early-printk-support-via-hvc-console drivers/xen/hvc-console.c
--- a/drivers/xen/hvc-console.c~xen-paravirt_ops-add-early-printk-support-via-hvc-console
+++ a/drivers/xen/hvc-console.c
@@ -28,6 +28,7 @@
 #include <xen/page.h>
 #include <xen/events.h>
 #include <xen/interface/io/console.h>
+#include <xen/hvc-console.h>
 
 #include "../char/hvc_console.h"
 
@@ -132,3 +133,27 @@ static int xen_cons_init(void)
 module_init(xen_init);
 module_exit(xen_fini);
 console_initcall(xen_cons_init);
+
+static void xenboot_write_console(struct console *console, const char *string,
+				  unsigned len)
+{
+	unsigned int linelen, off = 0;
+	const char *pos;
+
+	while (off < len && NULL != (pos = strchr(string+off, '\n'))) {
+		linelen = pos-string+off;
+		if (off + linelen > len)
+			break;
+		write_console(0, string+off, linelen);
+		write_console(0, "\r\n", 2);
+		off += linelen + 1;
+	}
+	if (off < len)
+		write_console(0, string+off, len-off);
+}
+
+struct console xenboot_console = {
+	.name		= "xenboot",
+	.write		= xenboot_write_console,
+	.flags		= CON_PRINTBUFFER | CON_BOOT,
+};
diff -puN /dev/null include/xen/hvc-console.h
--- /dev/null
+++ a/include/xen/hvc-console.h
@@ -0,0 +1,6 @@
+#ifndef XEN_HVC_CONSOLE_H
+#define XEN_HVC_CONSOLE_H
+
+extern struct console xenboot_console;
+
+#endif	/* XEN_HVC_CONSOLE_H */
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
