From: akpm@linux-foundation.org
Subject: + cpufreq-fix-missing-unlocks-in-cpufreq_add_dev-error-paths.patch added to -mm tree
Date: Thu, 13 Dec 2007 13:52:31 -0800
Message-ID: <200712132152.lBDLqVMD019913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbXLMVx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 16:53:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, mingo@elte.hu


The patch titled
     cpufreq: fix missing unlocks in cpufreq_add_dev error paths.
has been added to the -mm tree.  Its filename is
     cpufreq-fix-missing-unlocks-in-cpufreq_add_dev-error-paths.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpufreq: fix missing unlocks in cpufreq_add_dev error paths.
From: Dave Jones <davej@redhat.com>

Ingo hit some BUG_ONs that were probably caused by these missing unlocks
causing an unbalance.  He couldn't reproduce the bug reliably, so it's
unknown that it's definitly fixing the problem he hit, but it's a fairly
good chance, and this fixes an obvious bug.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-fix-missing-unlocks-in-cpufreq_add_dev-error-paths drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-fix-missing-unlocks-in-cpufreq_add_dev-error-paths
+++ a/drivers/cpufreq/cpufreq.c
@@ -868,19 +868,25 @@ static int cpufreq_add_dev (struct sys_d
 	drv_attr = cpufreq_driver->attr;
 	while ((drv_attr) && (*drv_attr)) {
 		ret = sysfs_create_file(&policy->kobj, &((*drv_attr)->attr));
-		if (ret)
+		if (ret) {
+			unlock_policy_rwsem_write(cpu);
 			goto err_out_driver_exit;
+		}
 		drv_attr++;
 	}
 	if (cpufreq_driver->get){
 		ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
-		if (ret)
+		if (ret) {
+			unlock_policy_rwsem_write(cpu);
 			goto err_out_driver_exit;
+		}
 	}
 	if (cpufreq_driver->target){
 		ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
-		if (ret)
+		if (ret) {
+			unlock_policy_rwsem_write(cpu);
 			goto err_out_driver_exit;
+		}
 	}
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
_

Patches currently in -mm which might be from davej@redhat.com are

cpufreq-fix-missing-unlocks-in-cpufreq_add_dev-error-paths.patch
git-cpufreq.patch
git-x86.patch
via-rng-enable-secondary-noise-source-on-cpus-where-it-is-present.patch
