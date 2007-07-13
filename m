From: akpm@linux-foundation.org
Subject: - bugfix-cpufreq-in-combination-with-performance-governor.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:32:18 -0700
Message-ID: <200707132232.l6DMWIEi024996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758311AbXGMWdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:33:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oruba@amd.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     bugfix cpufreq in combination with performance governor
has been removed from the -mm tree.  Its filename was
     bugfix-cpufreq-in-combination-with-performance-governor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bugfix cpufreq in combination with performance governor
From: "Peter Oruba" <peter.oruba@amd.com>

There is a frequency scaling issue that I encountered with the performance
governor in combination with CPU hotplug.

In cpufreq.c CPU frequency is reduced to its minimum before the CPU gets
unregistered and set offline.  Does that have a particular reason?

Since the (k8-)governor does not monitor CPU frequency that setting also
applies then to the remaining CPU as well and lets the system run on the
lowest frequency although performance is chose as the policy.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |    6 ------
 1 files changed, 6 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~bugfix-cpufreq-in-combination-with-performance-governor drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~bugfix-cpufreq-in-combination-with-performance-governor
+++ a/drivers/cpufreq/cpufreq.c
@@ -1687,7 +1687,6 @@ static int cpufreq_cpu_callback(struct n
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct sys_device *sys_dev;
-	struct cpufreq_policy *policy;
 
 	sys_dev = get_cpu_sysdev(cpu);
 	if (sys_dev) {
@@ -1701,11 +1700,6 @@ static int cpufreq_cpu_callback(struct n
 			if (unlikely(lock_policy_rwsem_write(cpu)))
 				BUG();
 
-			policy = cpufreq_cpu_data[cpu];
-			if (policy) {
-				__cpufreq_driver_target(policy, policy->min,
-						CPUFREQ_RELATION_H);
-			}
 			__cpufreq_remove_dev(sys_dev);
 			break;
 		case CPU_DOWN_FAILED:
_

Patches currently in -mm which might be from peter.oruba@amd.com are

origin.patch
git-cpufreq.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
