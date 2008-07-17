From: akpm@linux-foundation.org
Subject: + cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch added to -mm tree
Date: Thu, 17 Jul 2008 14:40:05 -0700
Message-ID: <200807172140.m6HLe5IQ007716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760847AbYGQVrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 17:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, arekm@maven.pl, benh@kernel.crashing.org, davej@redhat.com, gnorton@novell.com, len.brown@intel.com, miguel@novell.com, mingo@elte.hu, sekharan@us.ibm.com, stable@kernel.org, venkatesh.pallipadi@intel.com


The patch titled
     CPUFREQ ACPI: Only call _PPC after cpufreq ACPI init funcs got called already
has been added to the -mm tree.  Its filename is
     cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CPUFREQ ACPI: Only call _PPC after cpufreq ACPI init funcs got called already
From: Thomas Renninger <trenn@suse.de>

Ingo Molnar provided a fix to not call _PPC at processor driver
initialization time.  Git commit #e4233dec749a3519069d9390561b5636a75c7579

But it can still happen that _PPC is called at processor driver
initialization time.

This patch should make sure that this is not possible anymore.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: <gnorton@novell.com>
Cc: <miguel@novell.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 ++++++
 drivers/acpi/processor_perflib.c              |   13 ++++++++++++-
 drivers/cpufreq/cpufreq.c                     |    3 +++
 include/linux/cpufreq.h                       |    1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
@@ -96,6 +96,12 @@ static int pmi_notifier(struct notifier_
 	struct cpufreq_frequency_table *cbe_freqs;
 	u8 node;
 
+	/* Should this really be called for CPUFREQ_ADJUST, CPUFREQ_INCOMPATIBLE
+	 * and CPUFREQ_NOTIFY policy events?)
+	 */
+	if (event == CPUFREQ_START)
+		return 0;
+
 	cbe_freqs = cpufreq_frequency_get_table(policy->cpu);
 	node = cbe_cpu_to_node(policy->cpu);
 
diff -puN drivers/acpi/processor_perflib.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already drivers/acpi/processor_perflib.c
--- a/drivers/acpi/processor_perflib.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already
+++ a/drivers/acpi/processor_perflib.c
@@ -72,7 +72,13 @@ MODULE_PARM_DESC(ignore_ppc, "If the fre
 #define PPC_REGISTERED   1
 #define PPC_IN_USE       2
 
-static int acpi_processor_ppc_status = 0;
+/* ignore_ppc:
+ * -1 -> cpufreq low level drivers not initialized -> _PSS, etc. not called yet
+ *       ignore _PPC
+ *  0 -> cpufreq low level drivers initialized -> consider _PPC values
+ *  1 -> ignore _PPC totally -> forced by user through boot param
+ */
+static int acpi_processor_ppc_status = -1;
 
 static int acpi_processor_ppc_notifier(struct notifier_block *nb,
 				       unsigned long event, void *data)
@@ -81,6 +87,11 @@ static int acpi_processor_ppc_notifier(s
 	struct acpi_processor *pr;
 	unsigned int ppc = 0;
 
+	if (event == CPUFREQ_START && ignore_ppc <= 0) {
+		ignore_ppc = 0;
+		return 0;
+	}
+
 	if (ignore_ppc)
 		return 0;
 
diff -puN drivers/cpufreq/cpufreq.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already
+++ a/drivers/cpufreq/cpufreq.c
@@ -825,6 +825,9 @@ static int cpufreq_add_dev(struct sys_de
 	policy->user_policy.min = policy->cpuinfo.min_freq;
 	policy->user_policy.max = policy->cpuinfo.max_freq;
 
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+				     CPUFREQ_START, policy);
+
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -puN include/linux/cpufreq.h~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already
+++ a/include/linux/cpufreq.h
@@ -106,6 +106,7 @@ struct cpufreq_policy {
 #define CPUFREQ_ADJUST		(0)
 #define CPUFREQ_INCOMPATIBLE	(1)
 #define CPUFREQ_NOTIFY		(2)
+#define CPUFREQ_START		(3)
 
 #define CPUFREQ_SHARED_TYPE_NONE (0) /* None */
 #define CPUFREQ_SHARED_TYPE_HW	 (1) /* HW does needed coordination */
_

Patches currently in -mm which might be from trenn@suse.de are

linux-next.patch
cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch

