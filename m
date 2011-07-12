From: akpm@linux-foundation.org
Subject: [merged] drivers-cpufreq-acpi-cpufreqc-fix-memory-leak.patch removed from -mm tree
Date: Tue, 12 Jul 2011 13:00:48 -0700
Message-ID: <201107122000.p6CK0ISA032573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153Ab1GLUAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 16:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luming.yu@gmail.com, lenb@kernel.org, luming.yu@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/cpufreq/acpi-cpufreq.c: fix memory leak
has been removed from the -mm tree.  Its filename was
     drivers-cpufreq-acpi-cpufreqc-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cpufreq/acpi-cpufreq.c: fix memory leak
From: Luming Yu <luming.yu@gmail.com>

I came across a memory leak during a cyclic cpu-online-offline test.

Signed-off-by: Yu Luming <luming.yu@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/acpi-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/acpi-cpufreq.c~drivers-cpufreq-acpi-cpufreqc-fix-memory-leak drivers/cpufreq/acpi-cpufreq.c
--- a/drivers/cpufreq/acpi-cpufreq.c~drivers-cpufreq-acpi-cpufreqc-fix-memory-leak
+++ a/drivers/cpufreq/acpi-cpufreq.c
@@ -759,7 +759,7 @@ static void __exit acpi_cpufreq_exit(voi
 
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
-	free_percpu(acpi_perf_data);
+	free_acpi_perf_data();
 }
 
 module_param(acpi_pstate_strict, uint, 0644);
_

Patches currently in -mm which might be from luming.yu@gmail.com are

origin.patch

