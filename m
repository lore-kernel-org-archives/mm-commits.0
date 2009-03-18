From: akpm@linux-foundation.org
Subject: [merged] acpi-pass-correct-parameter-to-acpi_processor_ffh_cstate_probe_cpu.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:48:22 -0700
Message-ID: <200903182248.n2IMmMtR020322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492AbZCRWxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, len.brown@intel.com, mingo@elte.hu, rusty@rustcorp.com.au, venkatesh.pallipadi@intel.com, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: pass correct parameter to acpi_processor_ffh_cstate_probe_cpu()
has been removed from the -mm tree.  Its filename was
     acpi-pass-correct-parameter-to-acpi_processor_ffh_cstate_probe_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: pass correct parameter to acpi_processor_ffh_cstate_probe_cpu()
From: Wu Fengguang <fengguang.wu@intel.com>

This fixes a NULL pointer dereference bug introduced by 6e911954cac ("use
smp_call_function_single() in arch/x86/kernel/acpi/cstate.c").

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/cstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/acpi/cstate.c~acpi-pass-correct-parameter-to-acpi_processor_ffh_cstate_probe_cpu arch/x86/kernel/acpi/cstate.c
--- a/arch/x86/kernel/acpi/cstate.c~acpi-pass-correct-parameter-to-acpi_processor_ffh_cstate_probe_cpu
+++ a/arch/x86/kernel/acpi/cstate.c
@@ -137,7 +137,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 	/* Run acpi_processor_ffh_cstate_probe_cpu() on the target CPU */
 
 	retval = smp_call_function_single(cpu,
-				acpi_processor_ffh_cstate_probe_cpu, cx, 1);
+				acpi_processor_ffh_cstate_probe_cpu, &cxcc, 1);
 	if (retval == 0) {
 		retval = cxcc.retval;
 		if (retval == 0) {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
ramfs-add-support-for-mode=-mount-option.patch

