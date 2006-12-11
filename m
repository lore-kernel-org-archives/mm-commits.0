From: akpm@osdl.org
Subject: + smbfs-make-conn_pid-a-struct-pid.patch added to -mm tree
Date: Mon, 11 Dec 2006 13:26:14 -0800
Message-ID: <200612112126.kBBLQEWM008042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38172 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763123AbWLKV0Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 16:26:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     smbfs: Make conn_pid a struct pid
has been added to the -mm tree.  Its filename is
     smbfs-make-conn_pid-a-struct-pid.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 
@@ -537,7 +538,7 @@ static int smb_fill_super(struct super_b
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

origin.patch
revert-identifier-to-nsproxy.patch
vt-fix-comments-to-not-refer-to-kill_proc.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
n_r3964-use-struct-pid-to-track-user-space-clients.patch
smbfs-make-conn_pid-a-struct-pid.patch
ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

