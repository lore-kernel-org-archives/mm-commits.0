From: akpm@linux-foundation.org
Subject: [merged] drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:36:56 -0700
Message-ID: <201109151936.p8FJauUs011049@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:10985 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab1IOTh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nagananda.chumbalkar@hp.com, davej@codemonkey.org.uk, lenb@kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/cpufreq/pcc-cpufreq.c: avoid NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cpufreq/pcc-cpufreq.c: avoid NULL pointer dereference
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

per_cpu(processors, n) can be NULL.

Loading CPUFreq modules[  437.661360] BUG: unable to handle kernel NULL pointer
dereference at (null)
IP: [<ffffffffa0434314>] pcc_cpufreq_cpu_init+0x74/0x220 [pcc_cpufreq]

It's better to avoid the oops by failing the driver, and allowing the
system to boot.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/pcc-cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/cpufreq/pcc-cpufreq.c~drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference drivers/cpufreq/pcc-cpufreq.c
--- a/drivers/cpufreq/pcc-cpufreq.c~drivers-cpufreq-pcc-cpufreqc-avoid-null-pointer-dereference
+++ a/drivers/cpufreq/pcc-cpufreq.c
@@ -261,6 +261,9 @@ static int pcc_get_offset(int cpu)
 	pr = per_cpu(processors, cpu);
 	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
 
+	if (!pr)
+		return -ENODEV;
+
 	status = acpi_evaluate_object(pr->handle, "PCCP", NULL, &buffer);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
_

Patches currently in -mm which might be from nagananda.chumbalkar@hp.com are

origin.patch
linux-next.patch

