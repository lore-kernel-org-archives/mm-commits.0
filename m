From: akpm@linux-foundation.org
Subject: [withdrawn]
 umh-fix-processed-error-when-umh_wait_proc-is-used.patch removed from -mm
 tree
Date: Tue, 30 Jun 2020 19:35:41 -0700
Message-ID: <20200701023541.HgPc9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGACft (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yangtiezhu@loongson.cn, viro@zeniv.linux.org.uk, slyfox@gentoo.org, shuah@kernel.org, serge@hallyn.com, roopa@cumulusnetworks.com, ravenexp@gmail.com, philipp.reisner@linbit.com, nikolay@cumulusnetworks.com, lars.ellenberg@linbit.com, kuba@kernel.org, keescook@chromium.org, josh@joshtriplett.org, jmorris@namei.org, jarkko.sakkinen@linux.intel.com, hch@infradead.org, gregkh@linuxfoundation.org, dhowells@redhat.com, davem@davemloft.net, chuck.lever@oracle.com, christian.brauner@ubuntu.com, chainsaw@gentoo.org, bfields@fieldses.org, axboe@kernel.dk, ast@kernel.org, mcgrof@kernel.org


The patch titled
     Subject: umh: fix processed error when UMH_WAIT_PROC is used
has been removed from the -mm tree.  Its filename was
     umh-fix-processed-error-when-umh_wait_proc-is-used.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: umh: fix processed error when UMH_WAIT_PROC is used

When UMH_WAIT_PROC is used we call kernel_wait4().  This is the *only*
place in the kernel where we actually inspect the error code.  Prior to
this patch we returned the value from the wait call, and that technically
requires us to use wrappers such as WEXITSTATUS().  We either fix all
callers to start using WEXITSTATUS() and friends *or* we do address this
within the umh code and let the callers get the actual error code.

The way we use kernel_wait4() on the umh is with the options set to 0, and
when this is done the wait call only waits for terminated children. 
Because of this, there is no point to complicate checks for the umh with
W*() calls.  That would make the checks complex, redundant, and simply not
needed.

By making the umh do the checks for us we keep users kernel_wait4() at
bay, and promote avoiding introduction of further W*() macros and the
complexities this can bring.

There were only a few callers which properly checked for the error status
using open-coded solutions.  We remove them as they are no longer needed,
and also remove open coded implicit uses of W*() uses which should never
trigger given that the options passed to wait is 0.

The only helpers we really need are for termination, so we just include
those, and we prefix our W*() helpers with K.

Since all this does is *correct* an error code, if one was found, this
change only fixes reporting the *correct* error, and there are two places
where this matters, and which this patch fixes:

  * request_module() used to fail with an error code of
    256 when a module was not found. Now it properly
    returns 1.

  * fs/nfsd/nfs4recover.c: we never were disabling the
    upcall as the error code of -ENOENT or -EACCES was
    *never* properly checked for.

Link: http://lkml.kernel.org/r/20200610154923.27510-5-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Sergey Kvachonok <ravenexp@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Vroon <chainsaw@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_nl.c |   20 ++++++++------------
 fs/nfsd/nfs4recover.c        |    2 +-
 include/linux/sched/task.h   |   13 +++++++++++++
 kernel/umh.c                 |    4 ++--
 net/bridge/br_stp_if.c       |   10 ++--------
 security/keys/request_key.c  |    2 +-
 6 files changed, 27 insertions(+), 24 deletions(-)

--- a/drivers/block/drbd/drbd_nl.c~umh-fix-processed-error-when-umh_wait_proc-is-used
+++ a/drivers/block/drbd/drbd_nl.c
@@ -382,13 +382,11 @@ int drbd_khelper(struct drbd_device *dev
 	notify_helper(NOTIFY_CALL, device, connection, cmd, 0);
 	ret = call_usermodehelper(drbd_usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
-		drbd_warn(device, "helper command: %s %s %s exit code %u (0x%x)\n",
-				drbd_usermode_helper, cmd, mb,
-				(ret >> 8) & 0xff, ret);
+		drbd_warn(device, "helper command: %s %s %s failed with exit code %u (0x%x)\n",
+				drbd_usermode_helper, cmd, mb, ret, ret);
 	else
-		drbd_info(device, "helper command: %s %s %s exit code %u (0x%x)\n",
-				drbd_usermode_helper, cmd, mb,
-				(ret >> 8) & 0xff, ret);
+		drbd_info(device, "helper command: %s %s %s completed successfully\n",
+				drbd_usermode_helper, cmd, mb);
 	sib.sib_reason = SIB_HELPER_POST;
 	sib.helper_exit_code = ret;
 	drbd_bcast_event(device, &sib);
@@ -424,13 +422,11 @@ enum drbd_peer_state conn_khelper(struct
 
 	ret = call_usermodehelper(drbd_usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
-		drbd_warn(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
-			  drbd_usermode_helper, cmd, resource_name,
-			  (ret >> 8) & 0xff, ret);
+		drbd_warn(connection, "helper command: %s %s %s failed with exit code %u (0x%x)\n",
+			  drbd_usermode_helper, cmd, resource_name, ret, ret);
 	else
-		drbd_info(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
-			  drbd_usermode_helper, cmd, resource_name,
-			  (ret >> 8) & 0xff, ret);
+		drbd_info(connection, "helper command: %s %s %s completed successfully\n",
+			  drbd_usermode_helper, cmd, resource_name);
 	/* TODO: conn_bcast_event() ?? */
 	notify_helper(NOTIFY_RESPONSE, NULL, connection, cmd, ret);
 
--- a/fs/nfsd/nfs4recover.c~umh-fix-processed-error-when-umh_wait_proc-is-used
+++ a/fs/nfsd/nfs4recover.c
@@ -1820,7 +1820,7 @@ nfsd4_umh_cltrack_upcall(char *cmd, char
 
 	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
 	/*
-	 * Disable the upcall mechanism if we're getting an ENOENT or EACCES
+	 * Disable the upcall mechanism if we're getting an -ENOENT or -EACCES
 	 * error. The admin can re-enable it on the fly by using sysfs
 	 * once the problem has been fixed.
 	 */
--- a/include/linux/sched/task.h~umh-fix-processed-error-when-umh_wait_proc-is-used
+++ a/include/linux/sched/task.h
@@ -103,6 +103,19 @@ struct mm_struct *copy_init_mm(void);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 extern long kernel_wait4(pid_t, int __user *, int, struct rusage *);
 
+/* Only add helpers for actual use cases in the kernel */
+#define KWEXITSTATUS(status)		(__KWEXITSTATUS(status))
+#define KWIFEXITED(status)		(__KWIFEXITED(status))
+
+/* Nonzero if STATUS indicates normal termination.  */
+#define __KWIFEXITED(status)     (__KWTERMSIG(status) == 0)
+
+/* If KWIFEXITED(STATUS), the low-order 8 bits of the status.  */
+#define __KWEXITSTATUS(status)   (((status) & 0xff00) >> 8)
+
+/* If KWIFSIGNALED(STATUS), the terminating signal.  */
+#define __KWTERMSIG(status)      ((status) & 0x7f)
+
 extern void free_task(struct task_struct *tsk);
 
 /* sched_exec is called by processes performing an exec */
--- a/kernel/umh.c~umh-fix-processed-error-when-umh_wait_proc-is-used
+++ a/kernel/umh.c
@@ -154,8 +154,8 @@ static void call_usermodehelper_exec_syn
 		 * the real error code is already in sub_info->retval or
 		 * sub_info->retval is 0 anyway, so don't mess with it then.
 		 */
-		if (ret)
-			sub_info->retval = ret;
+		if (KWIFEXITED(ret))
+			sub_info->retval = KWEXITSTATUS(ret);
 	}
 
 	/* Restore default kernel sig handler */
--- a/net/bridge/br_stp_if.c~umh-fix-processed-error-when-umh_wait_proc-is-used
+++ a/net/bridge/br_stp_if.c
@@ -133,14 +133,8 @@ static int br_stp_call_user(struct net_b
 
 	/* call userspace STP and report program errors */
 	rc = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);
-	if (rc > 0) {
-		if (rc & 0xff)
-			br_debug(br, BR_STP_PROG " received signal %d\n",
-				 rc & 0x7f);
-		else
-			br_debug(br, BR_STP_PROG " exited with code %d\n",
-				 (rc >> 8) & 0xff);
-	}
+	if (rc != 0)
+		br_debug(br, BR_STP_PROG " failed with exit code %d\n", rc);
 
 	return rc;
 }
--- a/security/keys/request_key.c~umh-fix-processed-error-when-umh_wait_proc-is-used
+++ a/security/keys/request_key.c
@@ -193,7 +193,7 @@ static int call_sbin_request_key(struct
 	ret = call_usermodehelper_keys(request_key, argv, envp, keyring,
 				       UMH_WAIT_PROC);
 	kdebug("usermode -> 0x%x", ret);
-	if (ret >= 0) {
+	if (ret != 0) {
 		/* ret is the exit/wait code */
 		if (test_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags) ||
 		    key_validate(key) < 0)
_

Patches currently in -mm which might be from mcgrof@kernel.org are

selftests-simplify-kmod-failure-value.patch
