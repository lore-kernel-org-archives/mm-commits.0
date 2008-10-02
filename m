From: akpm@linux-foundation.org
Subject: + acpi-dont-load-acpi_cpufreq-if-acpi=off.patch added to -mm tree
Date: Thu, 02 Oct 2008 16:25:18 -0700
Message-ID: <200810022325.m92NPInv032133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbYJBXZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 19:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, lenb@kernel.org


The patch titled
     acpi: don't load acpi_cpufreq if acpi=off
has been added to the -mm tree.  Its filename is
     acpi-dont-load-acpi_cpufreq-if-acpi=off.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: don't load acpi_cpufreq if acpi=off
From: Yinghai Lu <yhlu.kernel@gmail.com>

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~acpi-dont-load-acpi_cpufreq-if-acpi=off arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~acpi-dont-load-acpi_cpufreq-if-acpi=off
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -780,6 +780,9 @@ static int __init acpi_cpufreq_init(void
 {
 	int ret;
 
+	if (acpi_disabled)
+		return 0;
+
 	dprintk("acpi_cpufreq_init\n");
 
 	ret = acpi_cpufreq_early_init();
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

git-x86.patch
git-timers-fix-printk-errors-clean-up.patch
git-pci.patch
git-acpi.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
mm-print-out-meminit-for-memmap.patch
acpi-dont-load-acpi_cpufreq-if-acpi=off.patch

