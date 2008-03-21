From: akpm@linux-foundation.org
Subject: - x86-visws-fix-printk-format-warnings.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:23 -0700
Message-ID: <200803212031.m2LKVN7D009067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757955AbYCUUcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86/visws: fix printk format warnings
has been removed from the -mm tree.  Its filename was
     x86-visws-fix-printk-format-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86/visws: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix visws printk format warnings:

/local/linsrc/linux-2.6.24-git15/arch/x86/mach-visws/traps.c:50: warning: format '%#lx' expects type 'long unsigned int', but argument 2 has type 'u32'
/local/linsrc/linux-2.6.24-git15/arch/x86/mach-visws/traps.c:50: warning: format '%#lx' expects type 'long unsigned int', but argument 3 has type 'u32'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mach-visws/traps.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/x86/mach-visws/traps.c~x86-visws-fix-printk-format-warnings arch/x86/mach-visws/traps.c
--- a/arch/x86/mach-visws/traps.c~x86-visws-fix-printk-format-warnings
+++ a/arch/x86/mach-visws/traps.c
@@ -46,8 +46,9 @@ static __init void cobalt_init(void)
 	 */
 	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
 	setup_local_APIC();
-	printk(KERN_INFO "Local APIC Version %#lx, ID %#lx\n",
-		apic_read(APIC_LVR), apic_read(APIC_ID));
+	printk(KERN_INFO "Local APIC Version %#x, ID %#x\n",
+		(unsigned int)apic_read(APIC_LVR),
+		(unsigned int)apic_read(APIC_ID));
 
 	set_fixmap(FIX_CO_CPU, CO_CPU_PHYS);
 	set_fixmap(FIX_CO_APIC, CO_APIC_PHYS);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch

