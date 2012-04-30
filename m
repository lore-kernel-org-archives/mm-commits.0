From: akpm@linux-foundation.org
Subject: + cpuidle-add-checks-to-avoid-null-pointer-dereference.patch added to -mm tree
Date: Mon, 30 Apr 2012 14:12:48 -0700
Message-ID: <20120430211248.E1C59A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43257 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2D3VMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 17:12:51 -0400
Received: by wgbdt11 with SMTP id dt11so84864wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 14:12:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srivatsa.bhat@linux.vnet.ibm.com, daniel.lezcano@linaro.org, len.brown@intel.com, lenb@kernel.org


The patch titled
     Subject: cpuidle: add checks to avoid NULL pointer dereference
has been added to the -mm tree.  Its filename is
     cpuidle-add-checks-to-avoid-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -285,6 +285,9 @@ int cpuidle_enable_device(struct cpuidle
 	int ret, i;
 	struct cpuidle_driver *drv = cpuidle_get_driver();
 
+	if (!dev)
+		return -EINVAL;
+
 	if (dev->enabled)
 		return 0;
 	if (!drv || !cpuidle_curr_governor)
@@ -369,8 +372,6 @@ static int __cpuidle_register_device(str
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
-	if (!dev)
-		return -EINVAL;
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
 
@@ -395,6 +396,9 @@ int cpuidle_register_device(struct cpuid
 {
 	int ret;
 
+	if (!dev)
+		return -EINVAL;
+
 	mutex_lock(&cpuidle_lock);
 
 	if ((ret = __cpuidle_register_device(dev))) {
_
Subject: Subject: cpuidle: add checks to avoid NULL pointer dereference

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

cpuidle-add-checks-to-avoid-null-pointer-dereference.patch

