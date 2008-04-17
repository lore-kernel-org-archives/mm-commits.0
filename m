From: akpm@linux-foundation.org
Subject: + ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:46:34 -0700
Message-ID: <200804172146.m3HLkYpi029480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbYDQVri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, serue@us.ibm.com


The patch titled
     eCryptfs: fix refs to pid and user_ns
has been added to the -mm tree.  Its filename is
     ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: fix refs to pid and user_ns
From: Michael Halcrow <mhalcrow@us.ibm.com>

Have eCryptfs properly reference the pid and user_ns objects.  Copy user_ns
out of nsproxy in case nsproxy goes away after we drop the lock.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/messaging.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/messaging.c~ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns
+++ a/fs/ecryptfs/messaging.c
@@ -20,6 +20,8 @@
  * 02111-1307, USA.
  */
 #include <linux/sched.h>
+#include <linux/user_namespace.h>
+#include <linux/nsproxy.h>
 #include "ecryptfs_kernel.h"
 
 static LIST_HEAD(ecryptfs_msg_ctx_free_list);
@@ -210,8 +212,8 @@ ecryptfs_spawn_daemon(struct ecryptfs_da
 		goto out;
 	}
 	(*daemon)->euid = euid;
-	(*daemon)->user_ns = user_ns;
-	(*daemon)->pid = pid;
+	(*daemon)->user_ns = get_user_ns(user_ns);
+	(*daemon)->pid = get_pid(pid);
 	(*daemon)->task = current;
 	mutex_init(&(*daemon)->mux);
 	INIT_LIST_HEAD(&(*daemon)->msg_ctx_out_queue);
@@ -300,6 +302,10 @@ int ecryptfs_exorcise_daemon(struct ecry
 	hlist_del(&daemon->euid_chain);
 	if (daemon->task)
 		wake_up_process(daemon->task);
+	if (daemon->pid)
+		put_pid(daemon->pid);
+	if (daemon->user_ns)
+		put_user_ns(daemon->user_ns);
 	mutex_unlock(&daemon->mux);
 	memset(daemon, 0, sizeof(*daemon));
 	kfree(daemon);
@@ -370,6 +376,7 @@ int ecryptfs_process_response(struct ecr
 	struct ecryptfs_msg_ctx *msg_ctx;
 	size_t msg_size;
 	struct nsproxy *nsproxy;
+	struct user_namespace *current_user_ns;
 	int rc;
 
 	if (msg->index >= ecryptfs_message_buf_len) {
@@ -393,8 +400,9 @@ int ecryptfs_process_response(struct ecr
 		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto wake_up;
 	}
+	current_user_ns = nsproxy->user_ns;
 	rc = ecryptfs_find_daemon_by_euid(&daemon, msg_ctx->task->euid,
-					  nsproxy->user_ns);
+					  current_user_ns);
 	rcu_read_unlock();
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	if (rc) {
@@ -412,7 +420,7 @@ int ecryptfs_process_response(struct ecr
 		       euid, msg_ctx->task->euid);
 		goto unlock;
 	}
-	if (nsproxy->user_ns != user_ns) {
+	if (current_user_ns != user_ns) {
 		rc = -EBADMSG;
 		printk(KERN_WARNING "%s: Received message from user_ns "
 		       "[0x%p]; expected message from user_ns [0x%p]\n",
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
remove-ecryptfs_header_cache_0.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
ecryptfs-add-missing-lock-around-notify_change.patch
ecryptfs-introduce-device-handle-for-userspace-daemon-communications.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns.patch
remove-duplicated-unlikely-in-is_err.patch
notify_change-callers-must-hold-i_mutex.patch

