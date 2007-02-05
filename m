From: akpm@linux-foundation.org
Subject: - efi-x86-pass-firmware-call-parameters-on-the-stack.patch removed from -mm tree
Date: Mon, 05 Feb 2007 01:25:33 -0800
Message-ID: <200702050925.l159PXdW016450@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbXBEJZz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 04:25:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: frederic.riss@gmail.com, Matt_Domsch@dell.com, ak@suse.de, artiom.myaskouvskey@intel.com, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     EFI x86: pass firmware call parameters on the stack
has been removed from the -mm tree.  Its filename was
     efi-x86-pass-firmware-call-parameters-on-the-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: EFI x86: pass firmware call parameters on the stack
From: Frederic Riss <frederic.riss@gmail.com>

When calling into the EFI firmware, the parameters need to be passed on
the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
This patch is needed to allow the new Intel-based Macs to suspend to ram
(efi.get_time is called during the suspend phase).

Signed-off-by: Frederic Riss <frederic.riss@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: <artiom.myaskouvskey@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/efi.c |   89 +++++++++++++++++++++++++++++++--------
 1 files changed, 73 insertions(+), 16 deletions(-)

diff -puN arch/i386/kernel/efi.c~efi-x86-pass-firmware-call-parameters-on-the-stack arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c~efi-x86-pass-firmware-call-parameters-on-the-stack
+++ a/arch/i386/kernel/efi.c
@@ -473,6 +473,70 @@ static inline void __init check_range_fo
 }
 
 /*
+ * Wrap all the virtual calls in a way that forces the parameters on the stack.
+ */
+
+#define efi_call_virt(f, args...) \
+     ((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
+
+static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	return efi_call_virt(get_time, tm, tc);
+}
+
+static efi_status_t virt_efi_set_time (efi_time_t *tm)
+{
+	return efi_call_virt(set_time, tm);
+}
+
+static efi_status_t virt_efi_get_wakeup_time (efi_bool_t *enabled,
+					      efi_bool_t *pending,
+					      efi_time_t *tm)
+{
+	return efi_call_virt(get_wakeup_time, enabled, pending, tm);
+}
+
+static efi_status_t virt_efi_set_wakeup_time (efi_bool_t enabled,
+					      efi_time_t *tm)
+{
+	return efi_call_virt(set_wakeup_time, enabled, tm);
+}
+
+static efi_status_t virt_efi_get_variable (efi_char16_t *name,
+					   efi_guid_t *vendor, u32 *attr,
+					   unsigned long *data_size, void *data)
+{
+	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
+}
+
+static efi_status_t virt_efi_get_next_variable (unsigned long *name_size,
+						efi_char16_t *name,
+						efi_guid_t *vendor)
+{
+	return efi_call_virt(get_next_variable, name_size, name, vendor);
+}
+
+static efi_status_t virt_efi_set_variable (efi_char16_t *name,
+					   efi_guid_t *vendor,
+					   unsigned long attr,
+					   unsigned long data_size, void *data)
+{
+	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
+}
+
+static efi_status_t virt_efi_get_next_high_mono_count (u32 *count)
+{
+	return efi_call_virt(get_next_high_mono_count, count);
+}
+
+static void virt_efi_reset_system (int reset_type, efi_status_t status,
+				   unsigned long data_size,
+				   efi_char16_t *data)
+{
+	efi_call_virt(reset_system, reset_type, status, data_size, data);
+}
+
+/*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
  * has the runtime attribute bit set in its memory descriptor and update
@@ -525,22 +589,15 @@ void __init efi_enter_virtual_mode(void)
 	 * pointers in the runtime service table to the new virtual addresses.
 	 */
 
-	efi.get_time = (efi_get_time_t *) efi.systab->runtime->get_time;
-	efi.set_time = (efi_set_time_t *) efi.systab->runtime->set_time;
-	efi.get_wakeup_time = (efi_get_wakeup_time_t *)
-					efi.systab->runtime->get_wakeup_time;
-	efi.set_wakeup_time = (efi_set_wakeup_time_t *)
-					efi.systab->runtime->set_wakeup_time;
-	efi.get_variable = (efi_get_variable_t *)
-					efi.systab->runtime->get_variable;
-	efi.get_next_variable = (efi_get_next_variable_t *)
-					efi.systab->runtime->get_next_variable;
-	efi.set_variable = (efi_set_variable_t *)
-					efi.systab->runtime->set_variable;
-	efi.get_next_high_mono_count = (efi_get_next_high_mono_count_t *)
-					efi.systab->runtime->get_next_high_mono_count;
-	efi.reset_system = (efi_reset_system_t *)
-					efi.systab->runtime->reset_system;
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
 }
 
 void __init
_

Patches currently in -mm which might be from frederic.riss@gmail.com are
