From: akpm@linux-foundation.org
Subject: + cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:31:09 -0800
Message-ID: <200903042131.n24LV9oY004872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbZCDVbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:31:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, lizf@cn.fujitsu.com


The patch titled
     cpusets: allow cpusets to be configured/built on non-SMP systems
has been added to the -mm tree.  Its filename is
     cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig    |    2 +-
 kernel/cpuset.c |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems init/Kconfig
--- a/init/Kconfig~cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems
+++ a/init/Kconfig
@@ -471,7 +471,7 @@ config CGROUP_DEVICE
 
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

linux-next.patch
vfs-add-missing-unlock-in-sget.patch
cgroups-fix-cgrouph-comments.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
kernel-cgroupc-kfreenull-is-legal.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch
add-a-refcount-check-in-dput.patch

