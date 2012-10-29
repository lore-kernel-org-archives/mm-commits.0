From: akpm@linux-foundation.org
Subject: + selftests-ipc-message-queue-copy-feature-test-update.patch added to -mm tree
Date: Mon, 29 Oct 2012 14:46:42 -0700
Message-ID: <20121029214643.1E704100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:49081 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab2J2Vqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 17:46:44 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so660993yen.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 14:46:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, serge.hallyn@canonical.com, xemul@parallels.com


The patch titled
     Subject: test: IPC message queue copy feature test update
has been added to the -mm tree.  Its filename is
     selftests-ipc-message-queue-copy-feature-test-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: test: IPC message queue copy feature test update

This update fixes coding style problems (80-characters line and others).
Also, it fixes test to work with new IPC sysctls (instead of using
experimental API logic, which was throwed away and replaced by sysctls).

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msg.h                  |    3 
 ipc/compat.c                         |    3 
 tools/testing/selftests/ipc/msgque.c |   83 ++++++++++++++-----------
 3 files changed, 53 insertions(+), 36 deletions(-)

diff -puN include/linux/msg.h~selftests-ipc-message-queue-copy-feature-test-update include/linux/msg.h
--- a/include/linux/msg.h~selftests-ipc-message-queue-copy-feature-test-update
+++ a/include/linux/msg.h
@@ -36,6 +36,7 @@ extern long do_msgsnd(int msqid, long mt
 			size_t msgsz, int msgflg);
 extern long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 		      int msgflg,
-		      long (*msg_fill)(void __user *, struct msg_msg *, size_t));
+		      long (*msg_fill)(void __user *, struct msg_msg *,
+				       size_t));
 
 #endif /* _LINUX_MSG_H */
diff -puN ipc/compat.c~selftests-ipc-message-queue-copy-feature-test-update ipc/compat.c
--- a/ipc/compat.c~selftests-ipc-message-queue-copy-feature-test-update
+++ a/ipc/compat.c
@@ -365,7 +365,8 @@ long compat_sys_msgrcv(int first, int se
 		uptr = compat_ptr(ipck.msgp);
 		msgtyp = ipck.msgtyp;
 	}
-	return do_msgrcv(first, uptr, second, msgtyp, third, compat_do_msg_fill);
+	return do_msgrcv(first, uptr, second, msgtyp, third,
+			 compat_do_msg_fill);
 }
 #else
 long compat_sys_semctl(int semid, int semnum, int cmd, int arg)
diff -puN tools/testing/selftests/ipc/msgque.c~selftests-ipc-message-queue-copy-feature-test-update tools/testing/selftests/ipc/msgque.c
--- a/tools/testing/selftests/ipc/msgque.c~selftests-ipc-message-queue-copy-feature-test-update
+++ a/tools/testing/selftests/ipc/msgque.c
@@ -3,6 +3,7 @@
 #include <string.h>
 #include <errno.h>
 #include <linux/msg.h>
+#include <fcntl.h>
 
 #define MAX_MSG_SIZE		32
 
@@ -19,9 +20,9 @@ struct msg1 {
 #define ANOTHER_MSG_TYPE 26538
 
 struct msgque_data {
+	key_t key;
 	int msq_id;
 	int qbytes;
-	int kern_id;
 	int qnum;
 	int mode;
 	struct msg1 *messages;
@@ -29,41 +30,49 @@ struct msgque_data {
 
 int restore_queue(struct msgque_data *msgque)
 {
-	struct msqid_ds ds;
-	int id, i;
+	int fd, ret, id, i;
+	char buf[32];
 
-	id = msgget(msgque->msq_id,
-		     msgque->mode | IPC_CREAT | IPC_EXCL | IPC_PRESET);
-	if (id == -1) {
-		printf("Failed to create queue\n");
+	fd = open("/proc/sys/kernel/msg_next_id", O_WRONLY);
+	if (fd == -1) {
+		printf("Failed to open /proc/sys/kernel/msg_next_id\n");
 		return -errno;
 	}
+	sprintf(buf, "%d", msgque->msq_id);
 
-	if (id != msgque->msq_id) {
-		printf("Failed to preset id (%d instead of %d)\n",
-							id, msgque->msq_id);
-		return -EFAULT;
+	ret = write(fd, buf, strlen(buf));
+	if (ret != strlen(buf)) {
+		printf("Failed to write to /proc/sys/kernel/msg_next_id\n");
+		return -errno;
 	}
 
-	if (msgctl(id, MSG_STAT, &ds) < 0) {
-		printf("Failed to stat queue\n");
+	id = msgget(msgque->key, msgque->mode | IPC_CREAT | IPC_EXCL);
+	if (id == -1) {
+		printf("Failed to create queue\n");
 		return -errno;
 	}
 
-	ds.msg_perm.key = msgque->msq_id;
-	ds.msg_qbytes = msgque->qbytes;
-	if (msgctl(id, MSG_SET, &ds) < 0) {
-		printf("Failed to update message key\n");
-		return -errno;
+	if (id != msgque->msq_id) {
+		printf("Restored queue has wrong id (%d instead of %d)\n",
+							id, msgque->msq_id);
+		ret = -EFAULT;
+		goto destroy;
 	}
 
 	for (i = 0; i < msgque->qnum; i++) {
-		if (msgsnd(msgque->msq_id, &msgque->messages[i].mtype, msgque->messages[i].msize, IPC_NOWAIT) != 0) {
+		if (msgsnd(msgque->msq_id, &msgque->messages[i].mtype,
+			   msgque->messages[i].msize, IPC_NOWAIT) != 0) {
 			printf("msgsnd failed (%m)\n");
-			return -errno;
+			ret = -errno;
+			goto destroy;
 		};
 	}
 	return 0;
+
+destroy:
+	if (msgctl(id, IPC_RMID, 0))
+		printf("Failed to destroy queue: %d\n", -errno);
+	return ret;
 }
 
 int check_and_destroy_queue(struct msgque_data *msgque)
@@ -72,7 +81,8 @@ int check_and_destroy_queue(struct msgqu
 	int cnt = 0, ret;
 
 	while (1) {
-		ret = msgrcv(msgque->msq_id, &message.mtype, MAX_MSG_SIZE, 0, IPC_NOWAIT);
+		ret = msgrcv(msgque->msq_id, &message.mtype, MAX_MSG_SIZE,
+				0, IPC_NOWAIT);
 		if (ret < 0) {
 			if (errno == ENOMSG)
 				break;
@@ -81,7 +91,8 @@ int check_and_destroy_queue(struct msgqu
 			goto err;
 		}
 		if (ret != msgque->messages[cnt].msize) {
-			printf("Wrong message size: %d (expected %d)\n", ret, msgque->messages[cnt].msize);
+			printf("Wrong message size: %d (expected %d)\n", ret,
+						msgque->messages[cnt].msize);
 			ret = -EINVAL;
 			goto err;
 		}
@@ -115,15 +126,17 @@ err:
 
 int dump_queue(struct msgque_data *msgque)
 {
-	struct msqid_ds ds;
+	struct msqid64_ds ds;
+	int kern_id;
 	int i, ret;
 
-	for (msgque->kern_id = 0; msgque->kern_id < 256; msgque->kern_id++) {
-		ret = msgctl(msgque->kern_id, MSG_STAT, &ds);
+	for (kern_id = 0; kern_id < 256; kern_id++) {
+		ret = msgctl(kern_id, MSG_STAT, &ds);
 		if (ret < 0) {
 			if (errno == -EINVAL)
 				continue;
-			printf("Failed to get stats for IPC queue with id %d\n", msgque->kern_id);
+			printf("Failed to get stats for IPC queue with id %d\n",
+					kern_id);
 			return -errno;
 		}
 
@@ -142,7 +155,8 @@ int dump_queue(struct msgque_data *msgqu
 	msgque->qbytes = ds.msg_qbytes;
 
 	for (i = 0; i < msgque->qnum; i++) {
-		ret = msgrcv(msgque->msq_id, &msgque->messages[i].mtype, MAX_MSG_SIZE, i, IPC_NOWAIT | MSG_COPY);
+		ret = msgrcv(msgque->msq_id, &msgque->messages[i].mtype,
+				MAX_MSG_SIZE, i, IPC_NOWAIT | MSG_COPY);
 		if (ret < 0) {
 			printf("Failed to copy IPC message: %m (%d)\n", errno);
 			return -errno;
@@ -158,33 +172,34 @@ int fill_msgque(struct msgque_data *msgq
 
 	msgbuf.mtype = MSG_TYPE;
 	memcpy(msgbuf.mtext, TEST_STRING, sizeof(TEST_STRING));
-	if (msgsnd(msgque->msq_id, &msgbuf.mtype, sizeof(TEST_STRING), IPC_NOWAIT) != 0) {
+	if (msgsnd(msgque->msq_id, &msgbuf.mtype, sizeof(TEST_STRING),
+				IPC_NOWAIT) != 0) {
 		printf("First message send failed (%m)\n");
 		return -errno;
 	};
 
 	msgbuf.mtype = ANOTHER_MSG_TYPE;
 	memcpy(msgbuf.mtext, ANOTHER_TEST_STRING, sizeof(ANOTHER_TEST_STRING));
-	if (msgsnd(msgque->msq_id, &msgbuf.mtype, sizeof(ANOTHER_TEST_STRING), IPC_NOWAIT) != 0) {
+	if (msgsnd(msgque->msq_id, &msgbuf.mtype, sizeof(ANOTHER_TEST_STRING),
+				IPC_NOWAIT) != 0) {
 		printf("Second message send failed (%m)\n");
 		return -errno;
 	};
 	return 0;
 }
 
-int main (int argc, char **argv)
+int main(int argc, char **argv)
 {
-	key_t key;
 	int msg, pid, err;
 	struct msgque_data msgque;
 
-	key = ftok(argv[0], 822155650);
-	if (key == -1) {
+	msgque.key = ftok(argv[0], 822155650);
+	if (msgque.key == -1) {
 		printf("Can't make key\n");
 		return -errno;
 	}
 
-	msgque.msq_id = msgget(key, IPC_CREAT | IPC_EXCL | 0666);
+	msgque.msq_id = msgget(msgque.key, IPC_CREAT | IPC_EXCL | 0666);
 	if (msgque.msq_id == -1) {
 		printf("Can't create queue\n");
 		goto err_out;
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-add-sysctl-to-specify-desired-next-object-id-wrap-new-sysctls-for-criu-inside-config_checkpoint_restore.patch
ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-message-queue-copy-feature-introduced.patch
ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch
ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-msg_copy-feature.patch
selftests-ipc-message-queue-copy-feature-test.patch
selftests-ipc-message-queue-copy-feature-test-update.patch

