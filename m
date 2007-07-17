From: akpm@linux-foundation.org
Subject: - knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:23 -0700
Message-ID: <200707172304.l6HN4Nl0011799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936708AbXGQXQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eshel@almaden.ibm.com, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: lockd: nfsd4: use same grace period for lockd and nfsd4
has been removed from the -mm tree.  Its filename was
     knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: lockd: nfsd4: use same grace period for lockd and nfsd4
From: Marc Eshel <eshel@almaden.ibm.com>

Both lockd and (in the nfsv4 case) nfsd enforce a "grace period" after reboot,
during which clients may reclaim locks from the previous server instance, but
may not acquire new locks.

Currently the lockd and nfsd enforce grace periods of different lengths.  This
may cause problems when we reboot a server with both v2/v3 and v4 clients. 
For example, if the lockd grace period is shorter (as is likely the case),
then a v3 client might acquire a new lock that conflicts with a lock already
held (but not yet reclaimed) by a v4 client.

This patch calculates a lease time that lockd and nfsd can both use.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc.c             |   27 ++++++++++++++++++++-------
 fs/nfsd/lockd.c            |    1 +
 fs/nfsd/nfs4state.c        |   16 ++++++++++++----
 include/linux/lockd/bind.h |    9 +++++++++
 4 files changed, 42 insertions(+), 11 deletions(-)

diff -puN fs/lockd/svc.c~knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4 fs/lockd/svc.c
--- a/fs/lockd/svc.c~knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4
+++ a/fs/lockd/svc.c
@@ -76,18 +76,31 @@ static const int		nlm_port_min = 0, nlm_
 
 static struct ctl_table_header * nlm_sysctl_table;
 
-static unsigned long set_grace_period(void)
+static unsigned long get_lockd_grace_period(void)
 {
-	unsigned long grace_period;
-
 	/* Note: nlm_timeout should always be nonzero */
 	if (nlm_grace_period)
-		grace_period = ((nlm_grace_period + nlm_timeout - 1)
-				/ nlm_timeout) * nlm_timeout * HZ;
+		return roundup(nlm_grace_period, nlm_timeout) * HZ;
 	else
-		grace_period = nlm_timeout * 5 * HZ;
+		return nlm_timeout * 5 * HZ;
+}
+
+unsigned long get_nfs_grace_period(void)
+{
+	unsigned long lockdgrace = get_lockd_grace_period();
+	unsigned long nfsdgrace = 0;
+
+	if (nlmsvc_ops)
+		nfsdgrace = nlmsvc_ops->get_grace_period();
+
+	return max(lockdgrace, nfsdgrace);
+}
+EXPORT_SYMBOL(get_nfs_grace_period);
+
+static unsigned long set_grace_period(void)
+{
 	nlmsvc_grace_period = 1;
-	return grace_period + jiffies;
+	return get_nfs_grace_period() + jiffies;
 }
 
 static inline void clear_grace_period(void)
diff -puN fs/nfsd/lockd.c~knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4 fs/nfsd/lockd.c
--- a/fs/nfsd/lockd.c~knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4
+++ a/fs/nfsd/lockd.c
@@ -65,6 +65,7 @@ nlm_fclose(struct file *filp)
 static struct nlmsvc_binding	nfsd_nlm_ops = {
 	.fopen		= nlm_fopen,		/* open file for locking */
 	.fclose		= nlm_fclose,		/* close file */
+	.get_grace_period = get_nfs4_grace_period,
 };
 
 void
diff -puN fs/nfsd/nfs4state.c~knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4 fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4
+++ a/fs/nfsd/nfs4state.c
@@ -51,6 +51,7 @@
 #include <linux/namei.h>
 #include <linux/mutex.h>
 #include <linux/lockd/bind.h>
+#include <linux/module.h>
 
 #define NFSDDBG_FACILITY                NFSDDBG_PROC
 
@@ -3190,20 +3191,27 @@ nfsd4_load_reboot_recovery_data(void)
 		printk("NFSD: Failure reading reboot recovery data\n");
 }
 
+unsigned long
+get_nfs4_grace_period(void)
+{
+	return max(user_lease_time, lease_time) * HZ;
+}
+
 /* initialization to perform when the nfsd service is started: */
 
 static void
 __nfs4_state_start(void)
 {
-	time_t grace_time;
+	unsigned long grace_time;
 
 	boot_time = get_seconds();
-	grace_time = max(user_lease_time, lease_time);
+	grace_time = get_nfs_grace_period();
 	lease_time = user_lease_time;
 	in_grace = 1;
-	printk("NFSD: starting %ld-second grace period\n", grace_time);
+	printk(KERN_INFO "NFSD: starting %ld-second grace period\n",
+	       grace_time/HZ);
 	laundry_wq = create_singlethread_workqueue("nfsd4");
-	queue_delayed_work(laundry_wq, &laundromat_work, grace_time*HZ);
+	queue_delayed_work(laundry_wq, &laundromat_work, grace_time);
 }
 
 int
diff -puN include/linux/lockd/bind.h~knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4 include/linux/lockd/bind.h
--- a/include/linux/lockd/bind.h~knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4
+++ a/include/linux/lockd/bind.h
@@ -27,6 +27,7 @@ struct nlmsvc_binding {
 						struct nfs_fh *,
 						struct file **);
 	void			(*fclose)(struct file *);
+	unsigned long		(*get_grace_period)(void);
 };
 
 extern struct nlmsvc_binding *	nlmsvc_ops;
@@ -38,4 +39,12 @@ extern int	nlmclnt_proc(struct inode *, 
 extern int	lockd_up(int proto);
 extern void	lockd_down(void);
 
+unsigned long get_nfs_grace_period(void);
+
+#ifdef CONFIG_NFSD_V4
+unsigned long get_nfs4_grace_period(void);
+#else
+static inline unsigned long get_nfs4_grace_period(void) {return 0;}
+#endif
+
 #endif /* LINUX_LOCKD_BIND_H */
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

origin.patch
git-vfs-lease-api.patch
