From: akpm@linux-foundation.org
Subject: + bugfix-cpufreq-in-combination-with-performance-governor.patch added to -mm tree
Date: Tue, 05 Jun 2007 23:22:59 -0700
Message-ID: <200706060622.l566MxdD010875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758680AbXFFGXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 02:23:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oruba@amd.com, davej@codemonkey.org.uk


The patch titled
     bugfix cpufreq in combination with performance governor
has been added to the -mm tree.  Its filename is
     bugfix-cpufreq-in-combination-with-performance-governor.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/cpufreq/cpufreq.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~bugfix-cpufreq-in-combination-with-performance-governor drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~bugfix-cpufreq-in-combination-with-performance-governor
+++ a/drivers/cpufreq/cpufreq.c
@@ -1698,11 +1698,6 @@ static int cpufreq_cpu_callback(struct n
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

bugfix-cpufreq-in-combination-with-performance-governor.patch
pci-x-pci-express-read-control-interfaces-fix.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
