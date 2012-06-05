From: akpm@linux-foundation.org
Subject: [merged] cpuidle-add-checks-to-avoid-null-pointer-dereference.patch removed from -mm tree
Date: Tue, 05 Jun 2012 12:56:13 -0700
Message-ID: <20120605195613.5CA72A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54432 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FET4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 15:56:14 -0400
Received: by vbnl22 with SMTP id l22so629067vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 12:56:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srivatsa.bhat@linux.vnet.ibm.com, daniel.lezcano@linaro.org, len.brown@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuidle: add checks to avoid NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     cpuidle-add-checks-to-avoid-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: cpuidle: add checks to avoid NULL pointer dereference

The existing check for dev == NULL in __cpuidle_register_device() is
rendered useless because dev is dereferenced before the check itself. 
Moreover, correctly speaking, it is the job of the callers of this
function, i.e., cpuidle_register_device() & cpuidle_enable_device() (which
also happen to be exported functions) to ensure that
__cpuidle_register_device() is called with a non-NULL dev.

So add the necessary dev == NULL checks in the two callers and remove the
(useless) check from __cpuidle_register_device().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-add-checks-to-avoid-null-pointer-dereference drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-add-checks-to-avoid-null-pointer-dereference
+++ a/drivers/cpuidle/cpuidle.c
@@ -294,6 +294,9 @@ int cpuidle_enable_device(struct cpuidle
 	int ret, i;
 	struct cpuidle_driver *drv = cpuidle_get_driver();
 
+	if (!dev)
+		return -EINVAL;
+
 	if (dev->enabled)
 		return 0;
 	if (!drv || !cpuidle_curr_governor)
@@ -378,8 +381,6 @@ static int __cpuidle_register_device(str
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
-	if (!dev)
-		return -EINVAL;
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
 
@@ -416,6 +417,9 @@ int cpuidle_register_device(struct cpuid
 {
 	int ret;
 
+	if (!dev)
+		return -EINVAL;
+
 	mutex_lock(&cpuidle_lock);
 
 	if ((ret = __cpuidle_register_device(dev))) {
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
linux-next.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch

