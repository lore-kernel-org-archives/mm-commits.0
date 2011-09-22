From: akpm@google.com
Subject: [merged] x86-mrst-some-drivers-need-to-known-when-an-scu-is-available.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:00:24 -0700
Message-ID: <201109222100.p8ML0O6x032503@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10416 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IVVAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, feng.tang@intel.com, hpa@zytor.com, mathias.nyman@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mrst: some drivers need to known when an SCU is available
has been removed from the -mm tree.  Its filename was
     x86-mrst-some-drivers-need-to-known-when-an-scu-is-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: x86, mrst: some drivers need to known when an SCU is available

Add a notifier so that drivers can hook into SCU availability in order to
take actions post initialisation when/if the SCU becomes available.

In the ideal world we wouldn't need this and we could avoid any init
dependancies of this form, but in practice we can't do it for some cases.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/intel_scu_ipc.h |   24 +++++++++++++++++++++++-
 arch/x86/platform/mrst/mrst.c        |    7 +++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/intel_scu_ipc.h~x86-mrst-some-drivers-need-to-known-when-an-scu-is-available arch/x86/include/asm/intel_scu_ipc.h
--- a/arch/x86/include/asm/intel_scu_ipc.h~x86-mrst-some-drivers-need-to-known-when-an-scu-is-available
+++ a/arch/x86/include/asm/intel_scu_ipc.h
@@ -1,7 +1,9 @@
 #ifndef _ASM_X86_INTEL_SCU_IPC_H_
 #define  _ASM_X86_INTEL_SCU_IPC_H_
 
-#define IPCMSG_VRTC	0xFA	 /* Set vRTC device */
+#include <linux/notifier.h>
+
+#define IPCMSG_VRTC		0xFA	 /* Set vRTC device */
 
 /* Command id associated with message IPCMSG_VRTC */
 #define IPC_CMD_VRTC_SETTIME      1 /* Set time */
@@ -44,4 +46,24 @@ int intel_scu_ipc_i2c_cntrl(u32 addr, u3
 /* Update FW version */
 int intel_scu_ipc_fw_update(u8 *buffer, u32 length);
 
+extern struct blocking_notifier_head intel_scu_notifier;
+
+static inline void intel_scu_notifier_add(struct notifier_block *nb)
+{
+	blocking_notifier_chain_register(&intel_scu_notifier, nb);
+}
+
+static inline void intel_scu_notifier_remove(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&intel_scu_notifier, nb);
+}
+
+static inline int intel_scu_notifier_post(unsigned long v, void *p)
+{
+	return blocking_notifier_call_chain(&intel_scu_notifier, v, p);
+}
+
+#define		SCU_AVAILABLE		1
+#define		SCU_DOWN		2
+
 #endif
diff -puN arch/x86/platform/mrst/mrst.c~x86-mrst-some-drivers-need-to-known-when-an-scu-is-available arch/x86/platform/mrst/mrst.c
--- a/arch/x86/platform/mrst/mrst.c~x86-mrst-some-drivers-need-to-known-when-an-scu-is-available
+++ a/arch/x86/platform/mrst/mrst.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 
 #include <asm/setup.h>
 #include <asm/mpspec_def.h>
@@ -558,6 +559,9 @@ static void __init intel_scu_i2c_device_
 	i2c_devs[i2c_next_dev++] = new_dev;
 }
 
+BLOCKING_NOTIFIER_HEAD(intel_scu_notifier);
+EXPORT_SYMBOL_GPL(intel_scu_notifier);
+
 /* Called by IPC driver */
 void intel_scu_devices_create(void)
 {
@@ -582,6 +586,7 @@ void intel_scu_devices_create(void)
 		} else
 			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
 	}
+	intel_scu_notifier_post(SCU_AVAILABLE, 0L);
 }
 EXPORT_SYMBOL_GPL(intel_scu_devices_create);
 
@@ -590,6 +595,8 @@ void intel_scu_devices_destroy(void)
 {
 	int i;
 
+	intel_scu_notifier_post(SCU_DOWN, 0L);
+
 	for (i = 0; i < ipc_next_dev; i++)
 		platform_device_del(ipc_devs[i]);
 }
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
vrtc-change-its-year-offset-from-1960-to-1972.patch
x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms.patch
mrst-battery-fixes.patch
x86mrst-add-mapping-for-bma023.patch

