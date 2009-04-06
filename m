From: akpm@linux-foundation.org
Subject: [merged] cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:08 -0700
Message-ID: <200904061935.n36JZ8Pv011923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757707AbZDFTjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpusets: allow cpusets to be configured/built on non-SMP systems
has been removed from the -mm tree.  Its filename was
     cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: allow cpusets to be configured/built on non-SMP systems
From: Paul Menage <menage@google.com>

Allow cpusets to be configured/built on non-SMP systems

Currently it's impossible to build cpusets under UML on x86-64, since
cpusets depends on SMP and x86-64 UML doesn't support SMP.

There's code in cpusets that doesn't depend on SMP.  This patch surrounds
the minimum amount of cpusets code with #ifdef CONFIG_SMP in order to
allow cpusets to build/run on UP systems (for testing purposes under UML).

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig    |    2 +-
 kernel/cpuset.c |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems init/Kconfig
--- a/init/Kconfig~cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems
+++ a/init/Kconfig
@@ -531,7 +531,7 @@ config CGROUP_DEVICE
 
 config CPUSETS
 	bool "Cpuset support"
-	depends on SMP && CGROUPS
+	depends on CGROUPS
 	help
 	  This option will let you create and manage CPUSETs which
 	  allow dynamically partitioning a system into sets of CPUs and
diff -puN kernel/cpuset.c~cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems
+++ a/kernel/cpuset.c
@@ -517,6 +517,7 @@ static int validate_change(const struct 
 	return 0;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Helper routine for generate_sched_domains().
  * Do cpusets a, b have overlapping cpus_allowed masks?
@@ -811,6 +812,18 @@ static void do_rebuild_sched_domains(str
 
 	put_online_cpus();
 }
+#else /* !CONFIG_SMP */
+static void do_rebuild_sched_domains(struct work_struct *unused)
+{
+}
+
+static int generate_sched_domains(struct cpumask **domains,
+			struct sched_domain_attr **attributes)
+{
+	*domains = NULL;
+	return 1;
+}
+#endif /* CONFIG_SMP */
 
 static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
 
@@ -1164,8 +1177,10 @@ int current_cpuset_is_being_rebound(void
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
+#ifdef CONFIG_SMP
 	if (val < -1 || val >= SD_LV_MAX)
 		return -EINVAL;
+#endif
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
add-a-refcount-check-in-dput.patch

