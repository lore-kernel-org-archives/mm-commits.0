From: akpm@linux-foundation.org
Subject: - macintosh-qindfarm_smu_sat-semaphore-to-mutex.patch removed from -mm tree
Date: Tue, 06 May 2008 22:23:42 -0700
Message-ID: <200805070523.m475NgEC013216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520AbYEGFY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 01:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     macintosh: windfarm_smu_sat: semaphore to mutex
has been removed from the -mm tree.  Its filename was
     macintosh-qindfarm_smu_sat-semaphore-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: macintosh: windfarm_smu_sat: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/windfarm_smu_sat.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/macintosh/windfarm_smu_sat.c~macintosh-qindfarm_smu_sat-semaphore-to-mutex drivers/macintosh/windfarm_smu_sat.c
--- a/drivers/macintosh/windfarm_smu_sat.c~macintosh-qindfarm_smu_sat-semaphore-to-mutex
+++ a/drivers/macintosh/windfarm_smu_sat.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
-#include <linux/semaphore.h>
+#include <linux/mutex.h>
 #include <asm/prom.h>
 #include <asm/smu.h>
 #include <asm/pmac_low_i2c.h>
@@ -36,7 +36,7 @@
 struct wf_sat {
 	int			nr;
 	atomic_t		refcnt;
-	struct semaphore	mutex;
+	struct mutex		mutex;
 	unsigned long		last_read; /* jiffies when cache last updated */
 	u8			cache[16];
 	struct i2c_client	i2c;
@@ -163,7 +163,7 @@ static int wf_sat_get(struct wf_sensor *
 	if (sat->i2c.adapter == NULL)
 		return -ENODEV;
 
-	down(&sat->mutex);
+	mutex_lock(&sat->mutex);
 	if (time_after(jiffies, (sat->last_read + MAX_AGE))) {
 		err = wf_sat_read_cache(sat);
 		if (err)
@@ -182,7 +182,7 @@ static int wf_sat_get(struct wf_sensor *
 	err = 0;
 
  fail:
-	up(&sat->mutex);
+	mutex_unlock(&sat->mutex);
 	return err;
 }
 
@@ -233,7 +233,7 @@ static void wf_sat_create(struct i2c_ada
 	sat->nr = -1;
 	sat->node = of_node_get(dev);
 	atomic_set(&sat->refcnt, 0);
-	init_MUTEX(&sat->mutex);
+	mutex_init(&sat->mutex);
 	sat->i2c.addr = (addr >> 1) & 0x7f;
 	sat->i2c.adapter = adapter;
 	sat->i2c.driver = &wf_sat_driver;
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
linux-next.patch
profile-likely-unlikely-macros.patch
likely_prof-changed-to-use-proc_create.patch
likeliness-accounting-change-and-cleanup.patch

