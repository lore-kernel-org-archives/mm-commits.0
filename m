From: akpm@osdl.org
Subject: - smbfs-make-conn_pid-a-struct-pid.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:13:20 -0800
Message-ID: <200612140613.kBE6DKPT002105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbWLNGNc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:13:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     smbfs: Make conn_pid a struct pid
has been removed from the -mm tree.  Its filename was
     smbfs-make-conn_pid-a-struct-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smbfs: Make conn_pid a struct pid
From: Eric W. Biederman <ebiederm@xmission.com>

smbfs keeps track of the user space server process in conn_pid.  This converts
that track to use a struct pid instead of pid_t.  This keeps us safe from pid
wrap around issues and prepares the way for the pid namespace.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/smbfs/inode.c          |    5 +++--
 fs/smbfs/proc.c           |    6 +++---
 fs/smbfs/smbiod.c         |    5 +++--
 include/linux/smb_fs_sb.h |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/smbfs/inode.c~smbfs-make-conn_pid-a-struct-pid fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~smbfs-make-conn_pid-a-struct-pid
+++ a/fs/smbfs/inode.c
@@ -482,12 +482,13 @@ smb_put_super(struct super_block *sb)
 	smb_close_socket(server);
 
 	if (server->conn_pid)
-		kill_proc(server->conn_pid, SIGTERM, 1);
+		kill_pid(server->conn_pid, SIGTERM, 1);
 
 	kfree(server->ops);
 	smb_unload_nls(server);
 	sb->s_fs_info = NULL;
 	smb_unlock_server(server);
+	put_pid(server->conn_pid);
 	kfree(server);
 }
 
@@ -530,7 +531,7 @@ static int smb_fill_super(struct super_b
 	INIT_LIST_HEAD(&server->xmitq);
 	INIT_LIST_HEAD(&server->recvq);
 	server->conn_error = 0;
-	server->conn_pid = 0;
+	server->conn_pid = NULL;
 	server->state = CONN_INVALID; /* no connection yet */
 	server->generation = 0;
 
diff -puN fs/smbfs/proc.c~smbfs-make-conn_pid-a-struct-pid fs/smbfs/proc.c
--- a/fs/smbfs/proc.c~smbfs-make-conn_pid-a-struct-pid
+++ a/fs/smbfs/proc.c
@@ -877,7 +877,7 @@ smb_newconn(struct smb_sb_info *server, 
 		goto out_putf;
 
 	server->sock_file = filp;
-	server->conn_pid = current->pid;
+	server->conn_pid = get_pid(task_pid(current));
 	server->opt = *opt;
 	server->generation += 1;
 	server->state = CONN_VALID;
@@ -971,8 +971,8 @@ smb_newconn(struct smb_sb_info *server, 
 	}
 
 	VERBOSE("protocol=%d, max_xmit=%d, pid=%d capabilities=0x%x\n",
-		server->opt.protocol, server->opt.max_xmit, server->conn_pid,
-		server->opt.capabilities);
+		server->opt.protocol, server->opt.max_xmit,
+		pid_nr(server->conn_pid), server->opt.capabilities);
 
 	/* FIXME: this really should be done by smbmount. */
 	if (server->opt.max_xmit > SMB_MAX_PACKET_SIZE) {
diff -puN fs/smbfs/smbiod.c~smbfs-make-conn_pid-a-struct-pid fs/smbfs/smbiod.c
--- a/fs/smbfs/smbiod.c~smbfs-make-conn_pid-a-struct-pid
+++ a/fs/smbfs/smbiod.c
@@ -152,7 +152,7 @@ int smbiod_retry(struct smb_sb_info *ser
 {
 	struct list_head *head;
 	struct smb_request *req;
-	pid_t pid = server->conn_pid;
+	struct pid *pid = get_pid(server->conn_pid);
 	int result = 0;
 
 	VERBOSE("state: %d\n", server->state);
@@ -222,7 +222,7 @@ int smbiod_retry(struct smb_sb_info *ser
 	/*
 	 * Note: use the "priv" flag, as a user process may need to reconnect.
 	 */
-	result = kill_proc(pid, SIGUSR1, 1);
+	result = kill_pid(pid, SIGUSR1, 1);
 	if (result) {
 		/* FIXME: this is most likely fatal, umount? */
 		printk(KERN_ERR "smb_retry: signal failed [%d]\n", result);
@@ -233,6 +233,7 @@ int smbiod_retry(struct smb_sb_info *ser
 	/* FIXME: The retried requests should perhaps get a "time boost". */
 
 out:
+	put_pid(pid);
 	return result;
 }
 
diff -puN include/linux/smb_fs_sb.h~smbfs-make-conn_pid-a-struct-pid include/linux/smb_fs_sb.h
--- a/include/linux/smb_fs_sb.h~smbfs-make-conn_pid-a-struct-pid
+++ a/include/linux/smb_fs_sb.h
@@ -55,7 +55,7 @@ struct smb_sb_info {
 	 * generation is incremented.
 	 */
 	unsigned int generation;
-	pid_t conn_pid;
+	struct pid *conn_pid;
 	struct smb_conn_opt opt;
 	wait_queue_head_t conn_wq;
 	int conn_complete;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
usbatm-update-to-use-the-kthread-api.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

