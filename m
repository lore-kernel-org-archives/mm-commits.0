From: akpm@linux-foundation.org
Subject: - gx-suspmodc-use-boot_cpu_data-instead-of-current_cpu_data.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:13 -0800
Message-ID: <200711272033.lARKXDqB028964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637AbXK0Udi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, davej@codemonkey.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     gx-suspmod.c: use boot_cpu_data instead of current_cpu_data
has been removed from the -mm tree.  Its filename was
     gx-suspmodc-use-boot_cpu_data-instead-of-current_cpu_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gx-suspmod.c: use boot_cpu_data instead of current_cpu_data
From: Dave Young <hidave.darkstar@gmail.com>

In preemptible kernel will report BUG: using smp_processor_id() in
preemptible, so use boot_cpu_data instead of current_cpu_data.

discussion in :
http://lkml.org/lkml/2007/7/25/32

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
CC: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/gx-suspmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/gx-suspmod.c~gx-suspmodc-use-boot_cpu_data-instead-of-current_cpu_data arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
--- a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c~gx-suspmodc-use-boot_cpu_data-instead-of-current_cpu_data
+++ a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
@@ -181,8 +181,8 @@ static __init struct pci_dev *gx_detect_
 	struct pci_dev *gx_pci = NULL;
 
 	/* check if CPU is a MediaGX or a Geode. */
-	if ((current_cpu_data.x86_vendor != X86_VENDOR_NSC) &&
-	    (current_cpu_data.x86_vendor != X86_VENDOR_CYRIX)) {
+	if ((boot_cpu_data.x86_vendor != X86_VENDOR_NSC) &&
+	    (boot_cpu_data.x86_vendor != X86_VENDOR_CYRIX)) {
 		dprintk("error: no MediaGX/Geode processor found!\n");
 		return NULL;
 	}
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

git-cpufreq.patch
bluetooth-hidp_process_hid_control-remove-unnecessary-parameter-dealing.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
