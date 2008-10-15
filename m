From: akpm@linux-foundation.org
Subject: - acpi-dont-load-acpi_cpufreq-if-acpi=off.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:14:00 -0700
Message-ID: <200810152114.m9FLE0WI005659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253AbYJOVOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: don't load acpi_cpufreq if acpi=off
has been removed from the -mm tree.  Its filename was
     acpi-dont-load-acpi_cpufreq-if-acpi=off.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
mm-print-out-meminit-for-memmap.patch

