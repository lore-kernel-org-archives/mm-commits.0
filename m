From: akpm@linux-foundation.org
Subject: + acpi-pass-correct-parameter-to-acpi_processor_ffh_cstate_probe_cpu.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:29:01 -0700
Message-ID: <200903122229.n2CMT1LD012012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207AbZCLWbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:31:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, len.brown@intel.com, mingo@elte.hu, rusty@rustcorp.com.au, venkatesh.pallipadi@intel.com, yakui.zhao@intel.com


The patch titled
     acpi: pass correct parameter to acpi_processor_ffh_cstate_probe_cpu()
has been added to the -mm tree.  Its filename is
     acpi-pass-correct-parameter-to-acpi_processor_ffh_cstate_probe_cpu.patch

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

origin.patch
linux-next.patch
acpi-pass-correct-parameter-to-acpi_processor_ffh_cstate_probe_cpu.patch
ramfs-add-support-for-mode=-mount-option.patch

