From: akpm@linux-foundation.org
Subject: + watchdog-update-watchdog-attributes-atomically.patch added to
 -mm tree
Date: Mon, 29 Jul 2013 14:04:28 -0700
Message-ID: <51f6d8dc.KRPqmicdJdI+vN+6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3G2VE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 17:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com, dzickus@redhat.com, mhocko@suse.cz

Subject: + watchdog-update-watchdog-attributes-atomically.patch added to -mm tree
To: mhocko@suse.cz,dzickus@redhat.com,fweisbec@gmail.com,mingo@kernel.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 14:04:28 -0700


The patch titled
     Subject: watchdog: update watchdog attributes atomically
has been added to the -mm tree.  Its filename is
     watchdog-update-watchdog-attributes-atomically.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-update-watchdog-attributes-atomically.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-update-watchdog-attributes-atomically.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
