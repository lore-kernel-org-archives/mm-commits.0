From: akpm@linux-foundation.org
Subject: + ipc-constify-ipc_ops.patch added to -mm tree
Date: Wed, 09 Apr 2014 16:00:36 -0700
Message-ID: <5345d114.TYpRzm7XbZr18KJ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbaDIXAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 19:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pageexec@freemail.hu, manfred@colorfullife.com, davidlohr@hp.com, minipli@googlemail.com

Subject: + ipc-constify-ipc_ops.patch added to -mm tree
To: minipli@googlemail.com,davidlohr@hp.com,manfred@colorfullife.com,pageexec@freemail.hu
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 16:00:36 -0700


The patch titled
     Subject: ipc: constify ipc_ops
has been added to the -mm tree.  Its filename is
     ipc-constify-ipc_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-constify-ipc_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-constify-ipc_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: ipc: constify ipc_ops

There is no need to recreate the very same ipc_ops structure on every
kernel entry for msgget/semget/shmget.  Just declare it static and be done
with it.  While at it, constify it as we don't modify the structure at
runtime.

Found in the PaX patch, written by the PaX Team.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    9 ++++-----
 ipc/sem.c  |   10 +++++-----
 ipc/shm.c  |   10 +++++-----
 ipc/util.c |    8 ++++----
 ipc/util.h |    2 +-
 5 files changed, 19 insertions(+), 20 deletions(-)

diff -puN ipc/msg.c~ipc-constify-ipc_ops ipc/msg.c
--- a/ipc/msg.c~ipc-constify-ipc_ops
+++ a/ipc/msg.c
@@ -306,15 +306,14 @@ static inline int msg_security(struct ke
 SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
 {
 	struct ipc_namespace *ns;
-	struct ipc_ops msg_ops;
+	static const struct ipc_ops msg_ops = {
+		.getnew = newque,
+		.associate = msg_security,
+	};
 	struct ipc_params msg_params;
 
 	ns = current->nsproxy->ipc_ns;
 
-	msg_ops.getnew = newque;
-	msg_ops.associate = msg_security;
-	msg_ops.more_checks = NULL;
-
 	msg_params.key = key;
 	msg_params.flg = msgflg;
 
diff -puN ipc/sem.c~ipc-constify-ipc_ops ipc/sem.c
--- a/ipc/sem.c~ipc-constify-ipc_ops
+++ a/ipc/sem.c
@@ -564,7 +564,11 @@ static inline int sem_more_checks(struct
 SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
 {
 	struct ipc_namespace *ns;
-	struct ipc_ops sem_ops;
+	static const struct ipc_ops sem_ops = {
+		.getnew = newary,
+		.associate = sem_security,
+		.more_checks = sem_more_checks,
+	};
 	struct ipc_params sem_params;
 
 	ns = current->nsproxy->ipc_ns;
@@ -572,10 +576,6 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 	if (nsems < 0 || nsems > ns->sc_semmsl)
 		return -EINVAL;
 
-	sem_ops.getnew = newary;
-	sem_ops.associate = sem_security;
-	sem_ops.more_checks = sem_more_checks;
-
 	sem_params.key = key;
 	sem_params.flg = semflg;
 	sem_params.u.nsems = nsems;
diff -puN ipc/shm.c~ipc-constify-ipc_ops ipc/shm.c
--- a/ipc/shm.c~ipc-constify-ipc_ops
+++ a/ipc/shm.c
@@ -609,15 +609,15 @@ static inline int shm_more_checks(struct
 SYSCALL_DEFINE3(shmget, key_t, key, size_t, size, int, shmflg)
 {
 	struct ipc_namespace *ns;
-	struct ipc_ops shm_ops;
+	static const struct ipc_ops shm_ops = {
+		.getnew = newseg,
+		.associate = shm_security,
+		.more_checks = shm_more_checks,
+	};
 	struct ipc_params shm_params;
 
 	ns = current->nsproxy->ipc_ns;
 
-	shm_ops.getnew = newseg;
-	shm_ops.associate = shm_security;
-	shm_ops.more_checks = shm_more_checks;
-
 	shm_params.key = key;
 	shm_params.flg = shmflg;
 	shm_params.u.size = size;
diff -puN ipc/util.c~ipc-constify-ipc_ops ipc/util.c
--- a/ipc/util.c~ipc-constify-ipc_ops
+++ a/ipc/util.c
@@ -317,7 +317,7 @@ int ipc_addid(struct ipc_ids *ids, struc
  * when the key is IPC_PRIVATE.
  */
 static int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
-		struct ipc_ops *ops, struct ipc_params *params)
+		const struct ipc_ops *ops, struct ipc_params *params)
 {
 	int err;
 
@@ -344,7 +344,7 @@ static int ipcget_new(struct ipc_namespa
  */
 static int ipc_check_perms(struct ipc_namespace *ns,
 			   struct kern_ipc_perm *ipcp,
-			   struct ipc_ops *ops,
+			   const struct ipc_ops *ops,
 			   struct ipc_params *params)
 {
 	int err;
@@ -375,7 +375,7 @@ static int ipc_check_perms(struct ipc_na
  * On success, the ipc id is returned.
  */
 static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
-		struct ipc_ops *ops, struct ipc_params *params)
+		const struct ipc_ops *ops, struct ipc_params *params)
 {
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
@@ -678,7 +678,7 @@ out:
  * Common routine called by sys_msgget(), sys_semget() and sys_shmget().
  */
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
-			struct ipc_ops *ops, struct ipc_params *params)
+			const struct ipc_ops *ops, struct ipc_params *params)
 {
 	if (params->key == IPC_PRIVATE)
 		return ipcget_new(ns, ids, ops, params);
diff -puN ipc/util.h~ipc-constify-ipc_ops ipc/util.h
--- a/ipc/util.h~ipc-constify-ipc_ops
+++ a/ipc/util.h
@@ -201,7 +201,7 @@ static inline bool ipc_valid_object(stru
 
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
-			struct ipc_ops *ops, struct ipc_params *params);
+			const struct ipc_ops *ops, struct ipc_params *params);
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
 		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
 #endif
_

Patches currently in -mm which might be from minipli@googlemail.com are

origin.patch
ipc-constify-ipc_ops.patch

