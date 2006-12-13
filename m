From: akpm@osdl.org
Subject: - cpufreq-fix-bug-in-duplicate-freq-elimination-code-in-acpi-cpufreq.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:29 -0800
Message-ID: <200612130656.kBD6uTLJ030731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57970 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965045AbWLMG4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexey.y.starikovskiy@intel.com, davej@codemonkey.org.uk, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: fix bug in duplicate freq elimination code in acpi-cpufreq
has been removed from the -mm tree.  Its filename was
     cpufreq-fix-bug-in-duplicate-freq-elimination-code-in-acpi-cpufreq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpufreq: fix bug in duplicate freq elimination code in acpi-cpufreq
From: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>

Due to duplicate state elimiation in the loop earlier, the number of
valid_states can be less than perf->state_count, in which case freq_table
was ending up with some garbage/uninitialized entries in the table.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-fix-bug-in-duplicate-freq-elimination-code-in-acpi-cpufreq arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-fix-bug-in-duplicate-freq-elimination-code-in-acpi-cpufreq
+++ a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -693,7 +693,7 @@ static int acpi_cpufreq_cpu_init(struct 
 		    perf->states[i].core_frequency * 1000;
 		valid_states++;
 	}
-	data->freq_table[perf->state_count].frequency = CPUFREQ_TABLE_END;
+	data->freq_table[valid_states].frequency = CPUFREQ_TABLE_END;
 
 	result = cpufreq_frequency_table_cpuinfo(policy, data->freq_table);
 	if (result)
_

Patches currently in -mm which might be from alexey.y.starikovskiy@intel.com are

origin.patch
git-acpi.patch

