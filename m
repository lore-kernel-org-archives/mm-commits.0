From: akpm@linux-foundation.org
Subject: + x86-olpc-add-missing-elements-to-device-tree.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:29:10 -0700
Message-ID: <201106292129.p5TLTAo2013080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab1F2V3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:29:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86, olpc: add missing elements to device tree
has been added to the -mm tree.  Its filename is
     x86-olpc-add-missing-elements-to-device-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, olpc: add missing elements to device tree
From: Daniel Drake <dsd@laptop.org>

In response to new device tree code in the kernel, OLPC will start using
it for probing of certain devices.  However, some firmware fixes are
needed to put the devicetree into a usable state.

Retain compatibility with old firmware by fixing up the device tree at
boot-time if it does not contain the new nodes/properties that we need for
probing.  This is the same approach taken on PPC platforms.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/olpc/olpc_dt.c |  103 +++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff -puN arch/x86/platform/olpc/olpc_dt.c~x86-olpc-add-missing-elements-to-device-tree arch/x86/platform/olpc/olpc_dt.c
--- a/arch/x86/platform/olpc/olpc_dt.c~x86-olpc-add-missing-elements-to-device-tree
+++ a/arch/x86/platform/olpc/olpc_dt.c
@@ -165,6 +165,107 @@ static struct of_pdt_ops prom_olpc_ops _
 	.pkg2path = olpc_dt_pkg2path,
 };
 
+static phandle __init olpc_dt_finddevice(const char *path)
+{
+	phandle node;
+	const void *args[] = { path };
+	void *res[] = { &node };
+
+	if (olpc_ofw("finddevice", args, res)) {
+		pr_err("olpc_dt: finddevice failed!\n");
+		return 0;
+	}
+
+	if ((s32) node == -1)
+		return 0;
+
+	return node;
+}
+
+static int __init olpc_dt_interpret(const char *words)
+{
+	int result;
+	const void *args[] = { words };
+	void *res[] = { &result };
+
+	if (olpc_ofw("interpret", args, res)) {
+		pr_err("olpc_dt: interpret failed!\n");
+		return -1;
+	}
+
+	return result;
+}
+
+/*
+ * Extract board revision directly from OFW device tree.
+ * We can't use olpc_platform_info because that hasn't been set up yet.
+ */
+static u32 __init olpc_dt_get_board_revision(void)
+{
+	phandle node;
+	__be32 rev;
+	int r;
+
+	node = olpc_dt_finddevice("/");
+	if (!node)
+		return 0;
+
+	r = olpc_dt_getproperty(node, "board-revision-int",
+				(char *) &rev, sizeof(rev));
+	if (r < 0)
+		return 0;
+
+	return be32_to_cpu(rev);
+}
+
+void __init olpc_dt_fixup(void)
+{
+	int r;
+	char buf[64];
+	phandle node;
+	u32 board_rev;
+
+	node = olpc_dt_finddevice("/battery@0");
+	if (!node)
+		return;
+
+	/*
+	 * If the battery node has a compatible property, we are running a new
+	 * enough firmware and don't have fixups to make.
+	 */
+	r = olpc_dt_getproperty(node, "compatible", buf, sizeof(buf));
+	if (r > 0)
+		return;
+
+	pr_info("PROM DT: Old firmware detected, applying fixes\n");
+
+	/* Add olpc,xo1-battery compatible marker to battery node */
+	olpc_dt_interpret("\" /battery@0\" find-device"
+		" \" olpc,xo1-battery\" +compatible"
+		" device-end");
+
+	board_rev = olpc_dt_get_board_revision();
+	if (!board_rev)
+		return;
+
+	if (board_rev >= olpc_board_pre(0xd0)) {
+		/* XO-1.5: add dcon device */
+		olpc_dt_interpret("\" /pci/display@1\" find-device"
+			" new-device"
+			" \" dcon\" device-name \" olpc,xo1-dcon\" +compatible"
+			" finish-device device-end");
+	} else {
+		/* XO-1: add dcon device, mark RTC as olpc,xo1-rtc */
+		olpc_dt_interpret("\" /pci/display@1,1\" find-device"
+			" new-device"
+			" \" dcon\" device-name \" olpc,xo1-dcon\" +compatible"
+			" finish-device device-end"
+			" \" /rtc\" find-device"
+			" \" olpc,xo1-rtc\" +compatible"
+			" device-end");
+	}
+}
+
 void __init olpc_dt_build_devicetree(void)
 {
 	phandle root;
@@ -172,6 +273,8 @@ void __init olpc_dt_build_devicetree(voi
 	if (!olpc_ofw_is_installed())
 		return;
 
+	olpc_dt_fixup();
+
 	root = olpc_dt_getsibling(0);
 	if (!root) {
 		pr_err("PROM: unable to get root node from OFW!\n");
_

Patches currently in -mm which might be from dsd@laptop.org are

linux-next.patch
x86-olpc-add-missing-elements-to-device-tree.patch
x86-olpc-move-cs5536-related-constants-to-cs5535h.patch
x86-olpc-rename-olpc-xo1-to-olpc-xo1-pm.patch
x86-olpc-add-xo-1-suspend-resume-support.patch
x86-olpc-add-xo-1-sci-driver-and-power-button-control.patch
x86-olpc-ec-sci-wakeup-mask-functionality.patch
x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality.patch
x86-olpc-xo1-sci-add-lid-switch-functionality.patch
x86-olpc-xo1-sci-propagate-power-supply-battery-events.patch
x86-olpc-add-xo-1-rtc-driver.patch
x86-olpc-add-xo-15-sci-driver.patch

