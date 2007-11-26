From: akpm@linux-foundation.org
Subject: - extended-interrupt-lvt-support-for-amd-barcelona.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:50:00 -0800
Message-ID: <200711262150.lAQLo0Ql024811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbXKZV7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.richter@amd.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Extended interrupt LVT support for AMD Barcelona
has been removed from the -mm tree.  Its filename was
     extended-interrupt-lvt-support-for-amd-barcelona.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Extended interrupt LVT support for AMD Barcelona
From: "Robert Richter" <robert.richter@amd.com>

This patch adds extended interrupt support for AMD Barcelona CPUs.  The
patch provides functions to setup MCE and IBS interrupt vectors.  Compared
to the previous K8 implementation the vector offsets are centrally handled
now in apic_64.c.  Thus, the APIC setup code is responsible for vector
mappings.  The vector mapping is hardcoded for now.

Also macro definitions in apicdef.h has been updated.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic_64.c               |   26 ++++++++++++++++++----
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   10 ++++----
 include/asm-x86/apic.h                  |    4 +--
 include/asm-x86/apicdef.h               |   19 ++++++++++------
 4 files changed, 41 insertions(+), 18 deletions(-)

diff -puN arch/x86/kernel/apic_64.c~extended-interrupt-lvt-support-for-amd-barcelona arch/x86/kernel/apic_64.c
--- a/arch/x86/kernel/apic_64.c~extended-interrupt-lvt-support-for-amd-barcelona
+++ a/arch/x86/kernel/apic_64.c
@@ -187,17 +187,35 @@ static void __setup_APIC_LVTT(unsigned i
 }
 
 /*
- * Setup extended LVT (K8 specific)
+ * Setup extended LVT, AMD specific (K8, family 10h)
+ *
+ * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
+ * MCE interrupts are supported. Thus MCE offset must be set to 0.
  */
-void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
-			     unsigned char msg_type, unsigned char mask)
+
+#define APIC_EILVT_LVTOFF_MCE 0
+#define APIC_EILVT_LVTOFF_IBS 1
+
+static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
 {
-	unsigned long reg = (lvt_off << 4) + K8_APIC_EXT_LVT_BASE;
+	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
 	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
 
 	apic_write(reg, v);
 }
 
+u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_MCE;
+}
+
+u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_IBS;
+}
+
 /*
  * Program the next event, relative to now
  */
diff -puN arch/x86/kernel/cpu/mcheck/mce_amd_64.c~extended-interrupt-lvt-support-for-amd-barcelona arch/x86/kernel/cpu/mcheck/mce_amd_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c~extended-interrupt-lvt-support-for-amd-barcelona
+++ a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -118,6 +118,7 @@ void __cpuinit mce_amd_feature_init(stru
 {
 	unsigned int bank, block;
 	unsigned int cpu = smp_processor_id();
+	u8 lvt_off;
 	u32 low = 0, high = 0, address = 0;
 
 	for (bank = 0; bank < NR_BANKS; ++bank) {
@@ -153,14 +154,13 @@ void __cpuinit mce_amd_feature_init(stru
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
 #endif
+			lvt_off = setup_APIC_eilvt_mce(THRESHOLD_APIC_VECTOR,
+						       APIC_EILVT_MSG_FIX, 0);
+
 			high &= ~MASK_LVTOFF_HI;
-			high |= K8_APIC_EXT_LVT_ENTRY_THRESHOLD << 20;
+			high |= lvt_off << 20;
 			wrmsr(address, low, high);
 
-			setup_APIC_extended_lvt(K8_APIC_EXT_LVT_ENTRY_THRESHOLD,
-						THRESHOLD_APIC_VECTOR,
-						K8_APIC_EXT_INT_MSG_FIX, 0);
-
 			threshold_defaults.address = address;
 			threshold_restart_bank(&threshold_defaults, 0, 0);
 		}
diff -puN include/asm-x86/apicdef.h~extended-interrupt-lvt-support-for-amd-barcelona include/asm-x86/apicdef.h
--- a/include/asm-x86/apicdef.h~extended-interrupt-lvt-support-for-amd-barcelona
+++ a/include/asm-x86/apicdef.h
@@ -116,13 +116,18 @@
 #define		APIC_TDR_DIV_32		0x8
 #define		APIC_TDR_DIV_64		0x9
 #define		APIC_TDR_DIV_128	0xA
-
-#define K8_APIC_EXT_LVT_BASE		0x500
-#define K8_APIC_EXT_INT_MSG_FIX		0x0
-#define K8_APIC_EXT_INT_MSG_SMI		0x2
-#define K8_APIC_EXT_INT_MSG_NMI		0x4
-#define K8_APIC_EXT_INT_MSG_EXT		0x7
-#define K8_APIC_EXT_LVT_ENTRY_THRESHOLD	0
+#define	APIC_EILVT0     0x500
+#define		APIC_EILVT_NR_AMD_K8	1	/* Number of extended interrupts */
+#define		APIC_EILVT_NR_AMD_10H	4
+#define		APIC_EILVT_LVTOFF(x)	(((x)>>4)&0xF)
+#define		APIC_EILVT_MSG_FIX	0x0
+#define		APIC_EILVT_MSG_SMI	0x2
+#define		APIC_EILVT_MSG_NMI	0x4
+#define		APIC_EILVT_MSG_EXT	0x7
+#define		APIC_EILVT_MASKED	(1<<16)
+#define	APIC_EILVT1     0x510
+#define	APIC_EILVT2     0x520
+#define	APIC_EILVT3     0x530
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 
diff -puN include/asm-x86/apic.h~extended-interrupt-lvt-support-for-amd-barcelona include/asm-x86/apic.h
--- a/include/asm-x86/apic.h~extended-interrupt-lvt-support-for-amd-barcelona
+++ a/include/asm-x86/apic.h
@@ -126,8 +126,8 @@ extern void enable_NMI_through_LVT0(void
 extern void setup_apic_routing(void);
 #endif
 
-extern void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
-				    unsigned char msg_type, unsigned char mask);
+extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
+extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
 
 extern int apic_is_clustered_box(void);
 
_

Patches currently in -mm which might be from robert.richter@amd.com are

git-x86.patch
