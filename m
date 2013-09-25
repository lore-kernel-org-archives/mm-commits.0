From: akpm@linux-foundation.org
Subject: [merged] watchdog-update-watchdog-attributes-atomically.patch
 removed from -mm tree
Date: Wed, 25 Sep 2013 12:05:50 -0700
Message-ID: <5243340e.R8bLrtGkMJJ5yt98%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3IYTFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:05:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com, dzickus@redhat.com, mhocko@suse.cz

Subject: [merged] watchdog-update-watchdog-attributes-atomically.patch removed from -mm tree
To: mhocko@suse.cz,dzickus@redhat.com,fweisbec@gmail.com,mingo@kernel.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:05:50 -0700


The patch titled
     Subject: watchdog: update watchdog attributes atomically
has been removed from the -mm tree.  Its filename was
     watchdog-update-watchdog-attributes-atomically.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: watchdog: update watchdog attributes atomically

proc_dowatchdog doesn't synchronize multiple callers which might lead to
confusion when two parallel callers might confuse watchdog_enable_all_cpus
resp.  watchdog_disable_all_cpus (e.g.  watchdog gets enabled even if
watchdog_thresh was set to 0 already).

This patch adds a local mutex which synchronizes callers to the sysctl
handler.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~watchdog-update-watchdog-attributes-atomically kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-update-watchdog-attributes-atomically
+++ a/kernel/watchdog.c
@@ -520,13 +520,15 @@ int proc_dowatchdog(struct ctl_table *ta
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err, old_thresh, old_enabled;
+	static DEFINE_MUTEX(watchdog_proc_mutex);
 
+	mutex_lock(&watchdog_proc_mutex);
 	old_thresh = ACCESS_ONCE(watchdog_thresh);
 	old_enabled = ACCESS_ONCE(watchdog_user_enabled);
 
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (err || !write)
-		return err;
+		goto out;
 
 	set_sample_period();
 	/*
@@ -544,7 +546,8 @@ int proc_dowatchdog(struct ctl_table *ta
 		watchdog_thresh = old_thresh;
 		watchdog_user_enabled = old_enabled;
 	}
