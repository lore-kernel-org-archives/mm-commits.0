From: akpm@linux-foundation.org
Subject: + selftests-ipc-message-queue-copy-feature-test.patch added to -mm tree
Date: Wed, 24 Oct 2012 14:40:38 -0700
Message-ID: <20121024214039.A716620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:38479 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161051Ab2JXVkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 17:40:42 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so62074fae.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 14:40:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: selftests: IPC message queue copy feature test
has been added to the -mm tree.  Its filename is
     selftests-ipc-message-queue-copy-feature-test.patch

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
Subject: selftests: IPC message queue copy feature test

This test can be used to check wheither kernel supports IPC message queue
copy and restore features (required by CRIU project).

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/Makefile |   25 ++
 tools/testing/selftests/ipc/msgque.c |  231 +++++++++++++++++++++++++
 2 files changed, 256 insertions(+)

diff -puN /dev/null tools/testing/selftests/ipc/Makefile
--- /dev/null
+++ a/tools/testing/selftests/ipc/Makefile
@@ -0,0 +1,25 @@
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
+ifeq ($(ARCH),i386)
+        ARCH := X86
+	CFLAGS := -DCONFIG_X86_32 -D__i386__
+endif
+ifeq ($(ARCH),x86_64)
+	ARCH := X86
+	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
+endif
+
+CFLAGS += -I../../../../usr/include/
+
+all:
+ifeq ($(ARCH),X86)
+	gcc $(CFLAGS) msgque.c -o msgque_test
+else
+	echo "Not an x86 target, can't build msgque selftest"
+endif
+
+run_tests: all
+	./msgque_test
+
+clean:
+	rm -fr ./msgque_test
diff -puN /dev/null tools/testing/selftests/ipc/msgque.c
--- /dev/null
+++ a/tools/testing/selftests/ipc/msgque.c
@@ -0,0 +1,231 @@
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <linux/msg.h>
+
+#define MAX_MSG_SIZE		32
+
+struct msg1 {
+	int msize;
+	long mtype;
+	char mtext[MAX_MSG_SIZE];
+};
+
+#define TEST_STRING "Test sysv5 msg"
+#define MSG_TYPE 1
+
+#define ANOTHER_TEST_STRING "Yet another test sysv5 msg"
+#define ANOTHER_MSG_TYPE 26538
+
+struct msgque_data {
+	int msq_id;
+	int qbytes;
+	int kern_id;
+	int qnum;
+	int mode;
+	struct msg1 *messages;
+};
+
+int restore_queue(struct msgque_data *msgque)
+{
+	struct msqid_ds ds;
+	int id, i;
+
+	id = msgget(msgque->msq_id,
+		     msgque->mode | IPC_CREAT | IPC_EXCL | IPC_PRESET);
+	if (id == -1) {
+		printf("Failed to create queue\n");
+		return -errno;
+	}
+
+	if (id != msgque->msq_id) {
+		printf("Failed to preset id (%d instead of %d)\n",
+							id, msgque->msq_id);
+		return -EFAULT;
+	}
+
+	if (msgctl(id, MSG_STAT, &ds) < 0) {
+		printf("Failed to stat queue\n");
+		return -errno;
+	}
+
+	ds.msg_perm.key = msgque->msq_id;
+	ds.msg_qbytes = msgque->qbytes;
+	if (msgctl(id, MSG_SET, &ds) < 0) {
+		printf("Failed to update message key\n");
+		return -errno;
+	}
+
+	for (i = 0; i < msgque->qnum; i++) {
+		if (msgsnd(msgque->msq_id, &msgque->messages[i].mtype, msgque->messages[i].msize, IPC_NOWAIT) != 0) {
+			printf("msgsnd failed (%m)\n");
+			return -errno;
+		};
+	}
+	return 0;
+}
+
+int check_and_destroy_queue(struct msgque_data *msgque)
+{
+	struct msg1 message;
+	int cnt = 0, ret;
+
+	while (1) {
+		ret = msgrcv(msgque->msq_id, &message.mtype, MAX_MSG_SIZE, 0, IPC_NOWAIT);
+		if (ret < 0) {
+			if (errno == ENOMSG)
+				break;
+			printf("Failed to read IPC message: %m\n");
+			ret = -errno;
+			goto err;
+		}
+		if (ret != msgque->messages[cnt].msize) {
+			printf("Wrong message size: %d (expected %d)\n", ret, msgque->messages[cnt].msize);
+			ret = -EINVAL;
+			goto err;
+		}
+		if (message.mtype != msgque->messages[cnt].mtype) {
+			printf("Wrong message type\n");
+			ret = -EINVAL;
+			goto err;
+		}
+		if (memcmp(message.mtext, msgque->messages[cnt].mtext, ret)) {
+			printf("Wrong message content\n");
+			ret = -EINVAL;
+			goto err;
+		}
+		cnt++;
+	}
+
+	if (cnt != msgque->qnum) {
+		printf("Wrong message number\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = 0;
+err:
+	if (msgctl(msgque->msq_id, IPC_RMID, 0)) {
+		printf("Failed to destroy queue: %d\n", -errno);
+		return -errno;
+	}
+	return ret;
+}
+
+int dump_queue(struct msgque_data *msgque)
+{
+	struct msqid_ds ds;
+	int i, ret;
+
+	for (msgque->kern_id = 0; msgque->kern_id < 256; msgque->kern_id++) {
+		ret = msgctl(msgque->kern_id, MSG_STAT, &ds);
+		if (ret < 0) {
+			if (errno == -EINVAL)
+				continue;
+			printf("Failed to get stats for IPC queue with id %d\n", msgque->kern_id);
+			return -errno;
+		}
+
+		if (ret == msgque->msq_id)
+			break;
+	}
+
+	msgque->messages = malloc(sizeof(struct msg1) * ds.msg_qnum);
+	if (msgque->messages == NULL) {
+		printf("Failed to get stats for IPC queue\n");
+		return -ENOMEM;
+	}
+
+	msgque->qnum = ds.msg_qnum;
+	msgque->mode = ds.msg_perm.mode;
+	msgque->qbytes = ds.msg_qbytes;
+
+	for (i = 0; i < msgque->qnum; i++) {
+		ret = msgrcv(msgque->msq_id, &msgque->messages[i].mtype, MAX_MSG_SIZE, i, IPC_NOWAIT | MSG_COPY);
+		if (ret < 0) {
+			printf("Failed to copy IPC message: %m (%d)\n", errno);
+			return -errno;
+		}
+		msgque->messages[i].msize = ret;
+	}
+	return 0;
+}
+
+int fill_msgque(struct msgque_data *msgque)
+{
+	struct msg1 msgbuf;
+
+	msgbuf.mtype = MSG_TYPE;
+	memcpy(msgbuf.mtext, TEST_STRING, sizeof(TEST_STRING));
+	if (msgsnd(msgque->msq_id, &msgbuf.mtype, sizeof(TEST_STRING), IPC_NOWAIT) != 0) {
+		printf("First message send failed (%m)\n");
+		return -errno;
+	};
+
+	msgbuf.mtype = ANOTHER_MSG_TYPE;
+	memcpy(msgbuf.mtext, ANOTHER_TEST_STRING, sizeof(ANOTHER_TEST_STRING));
+	if (msgsnd(msgque->msq_id, &msgbuf.mtype, sizeof(ANOTHER_TEST_STRING), IPC_NOWAIT) != 0) {
+		printf("Second message send failed (%m)\n");
+		return -errno;
+	};
+	return 0;
+}
+
+int main (int argc, char **argv)
+{
+	key_t key;
+	int msg, pid, err;
+	struct msgque_data msgque;
+
+	key = ftok(argv[0], 822155650);
+	if (key == -1) {
+		printf("Can't make key\n");
+		return -errno;
+	}
+
+	msgque.msq_id = msgget(key, IPC_CREAT | IPC_EXCL | 0666);
+	if (msgque.msq_id == -1) {
+		printf("Can't create queue\n");
+		goto err_out;
+	}
+
+	err = fill_msgque(&msgque);
+	if (err) {
+		printf("Failed to fill queue\n");
+		goto err_destroy;
+	}
+
+	err = dump_queue(&msgque);
+	if (err) {
+		printf("Failed to dump queue\n");
+		goto err_destroy;
+	}
+
+	err = check_and_destroy_queue(&msgque);
+	if (err) {
+		printf("Failed to check and destroy queue\n");
+		goto err_out;
+	}
+
+	err = restore_queue(&msgque);
+	if (err) {
+		printf("Failed to restore queue\n");
+		goto err_destroy;
+	}
+
+	err = check_and_destroy_queue(&msgque);
+	if (err) {
+		printf("Failed to test queue\n");
+		goto err_out;
+	}
+	return 0;
+
+err_destroy:
+	if (msgctl(msgque.msq_id, IPC_RMID, 0)) {
+		printf("Failed to destroy queue: %d\n", -errno);
+		return -errno;
+	}
+err_out:
+	return err;
+}
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch
proc-check-vma-vm_file-before-dereferencing.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-message-queue-copy-feature-introduced.patch
selftests-ipc-message-queue-copy-feature-test.patch

