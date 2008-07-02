From: akpm@linux-foundation.org
Subject: - macintosh-therm_windtunnel-semaphore-to-mutex.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:07 -0700
Message-ID: <200807020747.m627l7ko005624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbYGBHwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     macintosh: therm_windtunnel: semaphore to mutex
has been removed from the -mm tree.  Its filename was
     macintosh-therm_windtunnel-semaphore-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: macintosh: therm_windtunnel: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/therm_windtunnel.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/macintosh/therm_windtunnel.c~macintosh-therm_windtunnel-semaphore-to-mutex drivers/macintosh/therm_windtunnel.c
--- a/drivers/macintosh/therm_windtunnel.c~macintosh-therm_windtunnel-semaphore-to-mutex
+++ a/drivers/macintosh/therm_windtunnel.c
@@ -62,7 +62,7 @@ static struct {
 	volatile int		running;
 	struct task_struct	*poll_task;
 	
-	struct semaphore 	lock;
+	struct mutex	 	lock;
 	struct of_device	*of_dev;
 	
 	struct i2c_client	*thermostat;
@@ -286,23 +286,23 @@ restore_regs( void )
 
 static int control_loop(void *dummy)
 {
-	down(&x.lock);
+	mutex_lock(&x.lock);
 	setup_hardware();
-	up(&x.lock);
+	mutex_unlock(&x.lock);
 
 	for (;;) {
 		msleep_interruptible(8000);
 		if (kthread_should_stop())
 			break;
 
-		down(&x.lock);
+		mutex_lock(&x.lock);
 		poll_temp();
-		up(&x.lock);
+		mutex_unlock(&x.lock);
 	}
 
-	down(&x.lock);
+	mutex_lock(&x.lock);
 	restore_regs();
-	up(&x.lock);
+	mutex_unlock(&x.lock);
 
 	return 0;
 }
@@ -489,7 +489,7 @@ g4fan_init( void )
 	const struct apple_thermal_info *info;
 	struct device_node *np;
 
-	init_MUTEX( &x.lock );
+	mutex_init(&x.lock);
 
 	if( !(np=of_find_node_by_name(NULL, "power-mgt")) )
 		return -ENODEV;
_

Patches currently in -mm which might be from dwalker@mvista.com are

linux-next.patch
profile-likely-unlikely-macros.patch
likely_prof-changed-to-use-proc_create.patch
likeliness-accounting-change-and-cleanup.patch
likely-profiling-disable-ftrace.patch

