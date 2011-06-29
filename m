From: akpm@linux-foundation.org
Subject: + x86-olpc-ec-sci-wakeup-mask-functionality.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:29:22 -0700
Message-ID: <201106292129.p5TLTM6F013098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab1F2V3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86, olpc: EC SCI wakeup mask functionality
has been added to the -mm tree.  Its filename is
     x86-olpc-ec-sci-wakeup-mask-functionality.patch

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
Subject: x86, olpc: EC SCI wakeup mask functionality
From: Daniel Drake <dsd@laptop.org>

Update the EC SCI masks with recent additions.

Add functions to query SCI events and set the wakeup mask, to be used by
followup patches.

Add functions to tweak an event mask used to select certain EC events as a
system wakeup source.  Also add a function to determine if EC wakeup
functionality is available, as this depends on child drivers (different
for each laptop model) to configure the SCI interrupt.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/olpc.h   |   31 +++++++++--
 arch/x86/platform/olpc/olpc.c |   86 ++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/olpc.h~x86-olpc-ec-sci-wakeup-mask-functionality arch/x86/include/asm/olpc.h
--- a/arch/x86/include/asm/olpc.h~x86-olpc-ec-sci-wakeup-mask-functionality
+++ a/arch/x86/include/asm/olpc.h
@@ -13,6 +13,7 @@ struct olpc_platform_t {
 
 #define OLPC_F_PRESENT		0x01
 #define OLPC_F_DCON		0x02
+#define OLPC_F_EC_WIDE_SCI	0x04
 
 #ifdef CONFIG_OLPC
 
@@ -62,6 +63,13 @@ static inline int olpc_board_at_least(ui
 	return olpc_platform_info.boardrev >= rev;
 }
 
+extern void olpc_ec_wakeup_set(u16 value);
+extern void olpc_ec_wakeup_clear(u16 value);
+extern bool olpc_ec_wakeup_available(void);
+
+extern int olpc_ec_mask_write(u16 bits);
+extern int olpc_ec_sci_query(u16 *sci_value);
+
 #else
 
 static inline int machine_is_olpc(void)
@@ -74,6 +82,14 @@ static inline int olpc_has_dcon(void)
 	return 0;
 }
 
+static inline void olpc_ec_wakeup_set(u16 value) { }
+static inline void olpc_ec_wakeup_clear(u16 value) { }
+
+static inline bool olpc_ec_wakeup_available(void)
+{
+	return false;
+}
+
 #endif
 
 #ifdef CONFIG_OLPC_XO1_PM
@@ -89,17 +105,18 @@ extern int pci_olpc_init(void);
 extern int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
 		unsigned char *outbuf, size_t outlen);
 
-extern int olpc_ec_mask_set(uint8_t bits);
-extern int olpc_ec_mask_unset(uint8_t bits);
-
 /* EC commands */
 
 #define EC_FIRMWARE_REV			0x08
+#define EC_WRITE_SCI_MASK		0x1b
 #define EC_WAKE_UP_WLAN			0x24
 #define EC_WLAN_LEAVE_RESET		0x25
 #define EC_SET_SCI_INHIBIT		0x32
 #define EC_SET_SCI_INHIBIT_RELEASE	0x34
 #define EC_WLAN_ENTER_RESET		0x35
+#define EC_WRITE_EXT_SCI_MASK		0x38
+#define EC_SCI_QUERY			0x84
+#define EC_EXT_SCI_QUERY		0x85
 
 /* SCI source values */
 
@@ -108,10 +125,12 @@ extern int olpc_ec_mask_unset(uint8_t bi
 #define EC_SCI_SRC_BATTERY	0x02
 #define EC_SCI_SRC_BATSOC	0x04
 #define EC_SCI_SRC_BATERR	0x08
-#define EC_SCI_SRC_EBOOK	0x10
-#define EC_SCI_SRC_WLAN		0x20
+#define EC_SCI_SRC_EBOOK	0x10	/* XO-1 only */
+#define EC_SCI_SRC_WLAN		0x20	/* XO-1 only */
 #define EC_SCI_SRC_ACPWR	0x40
-#define EC_SCI_SRC_ALL		0x7F
+#define EC_SCI_SRC_BATCRIT	0x80
+#define EC_SCI_SRC_GPWAKE	0x100	/* XO-1.5 only */
+#define EC_SCI_SRC_ALL		0x1FF
 
 /* GPIO assignments */
 
diff -puN arch/x86/platform/olpc/olpc.c~x86-olpc-ec-sci-wakeup-mask-functionality arch/x86/platform/olpc/olpc.c
--- a/arch/x86/platform/olpc/olpc.c~x86-olpc-ec-sci-wakeup-mask-functionality
+++ a/arch/x86/platform/olpc/olpc.c
@@ -19,6 +19,7 @@
 #include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -30,6 +31,9 @@ EXPORT_SYMBOL_GPL(olpc_platform_info);
 
 static DEFINE_SPINLOCK(ec_lock);
 
+/* EC event mask to be applied during suspend (defining wakeup sources). */
+static u16 ec_wakeup_mask;
+
 /* what the timeout *should* be (in ms) */
 #define EC_BASE_TIMEOUT 20
 
@@ -188,6 +192,79 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
+void olpc_ec_wakeup_set(u16 value)
+{
+	ec_wakeup_mask |= value;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_wakeup_set);
+
+void olpc_ec_wakeup_clear(u16 value)
+{
+	ec_wakeup_mask &= ~value;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_wakeup_clear);
+
+/*
+ * Returns true if the compile and runtime configurations allow for EC events
+ * to wake the system.
+ */
+bool olpc_ec_wakeup_available(void)
+{
+	if (!machine_is_olpc())
+		return false;
+
+	/*
+	 * XO-1 EC wakeups are available when olpc-xo1-sci driver is
+	 * compiled in
+	 */
+#ifdef CONFIG_OLPC_XO1_SCI
+	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0)) /* XO-1 */
+		return true;
+#endif
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_wakeup_available);
+
+int olpc_ec_mask_write(u16 bits)
+{
+	if (olpc_platform_info.flags & OLPC_F_EC_WIDE_SCI) {
+		__be16 ec_word = cpu_to_be16(bits);
+		return olpc_ec_cmd(EC_WRITE_EXT_SCI_MASK, (void *) &ec_word, 2,
+				   NULL, 0);
+	} else {
+		unsigned char ec_byte = bits & 0xff;
+		return olpc_ec_cmd(EC_WRITE_SCI_MASK, &ec_byte, 1, NULL, 0);
+	}
+}
+EXPORT_SYMBOL_GPL(olpc_ec_mask_write);
+
+int olpc_ec_sci_query(u16 *sci_value)
+{
+	int ret;
+
+	if (olpc_platform_info.flags & OLPC_F_EC_WIDE_SCI) {
+		__be16 ec_word;
+		ret = olpc_ec_cmd(EC_EXT_SCI_QUERY,
+			NULL, 0, (void *) &ec_word, 2);
+		if (ret == 0)
+			*sci_value = be16_to_cpu(ec_word);
+	} else {
+		unsigned char ec_byte;
+		ret = olpc_ec_cmd(EC_SCI_QUERY, NULL, 0, &ec_byte, 1);
+		if (ret == 0)
+			*sci_value = ec_byte;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_sci_query);
+
+static int olpc_ec_suspend(void)
+{
+	return olpc_ec_mask_write(ec_wakeup_mask);
+}
+
 static bool __init check_ofw_architecture(struct device_node *root)
 {
 	const char *olpc_arch;
@@ -242,6 +319,10 @@ static int __init add_xo1_platform_devic
 	return 0;
 }
 
+static struct syscore_ops olpc_syscore_ops = {
+	.suspend = olpc_ec_suspend,
+};
+
 static int __init olpc_init(void)
 {
 	int r = 0;
@@ -266,6 +347,9 @@ static int __init olpc_init(void)
 			!cs5535_has_vsa2())
 		x86_init.pci.arch_init = pci_olpc_init;
 #endif
+	/* EC version 0x5f adds support for wide SCI mask */
+	if (olpc_platform_info.ecver >= 0x5f)
+		olpc_platform_info.flags |= OLPC_F_EC_WIDE_SCI;
 
 	printk(KERN_INFO "OLPC board revision %s%X (EC=%x)\n",
 			((olpc_platform_info.boardrev & 0xf) < 8) ? "pre" : "",
@@ -278,6 +362,8 @@ static int __init olpc_init(void)
 			return r;
 	}
 
+	register_syscore_ops(&olpc_syscore_ops);
+
 	return 0;
 }
 
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

