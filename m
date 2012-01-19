From: akpm@linux-foundation.org
Subject: [merged] drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch removed from -mm tree
Date: Thu, 19 Jan 2012 12:32:11 -0800
Message-ID: <20120119203212.2B13B5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:44120 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab2ASUcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2012 15:32:13 -0500
Received: by mail-ee0-f74.google.com with SMTP id b15so11507eek.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2012 12:32:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, len.brown@intel.com, mingmingx.zhang@intel.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/idle/intel_idle.c: remove redundant local_irq_disable() call
has been removed from the -mm tree.  Its filename was
     drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: drivers/idle/intel_idle.c: remove redundant local_irq_disable() call

irq disabling happens earlier in process_32.c:cpu_idle.  Basically,
cpuidle_state->enter is called, cpu irq is disabled.  cpuidle_state->enter
would turn on irq when exiting.

intel_idle doesn't follow this assumption.  Although it doesn't cause real
issue, it misleads developers.  Remove the call to local_irq_disable() at
entry.

[akpm@linux-foundation.org: add comment]
Signed-off-by: mzha38X <mingmingx.zhang@intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/intel_idle.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/idle/intel_idle.c~drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call
+++ a/drivers/idle/intel_idle.c
@@ -232,6 +232,7 @@ static int get_driver_data(int cstate)
  * @drv: cpuidle driver
  * @index: index of cpuidle state
  *
+ * Must be called under local_irq_disable().
  */
 static int intel_idle(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
@@ -247,8 +248,6 @@ static int intel_idle(struct cpuidle_dev
 
 	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
 
-	local_irq_disable();
