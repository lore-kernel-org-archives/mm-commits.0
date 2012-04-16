From: akpm@linux-foundation.org
Subject: + c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv.patch added to -mm tree
Date: Mon, 16 Apr 2012 15:12:09 -0700
Message-ID: <20120416221209.3B400A03A4@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52536 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2DPWMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 18:12:12 -0400
Received: by wgbdt11 with SMTP id dt11so293655wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 15:12:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, arnd@arndb.de, cmetcalf@tilera.com, fweisbec@gmail.com, gorcunov@openvz.org, lucas.de.marchi@gmail.com, mtk.manpages@gmail.com, serue@us.ibm.com, xemul@parallels.com


The patch titled
     Subject: c/r: ipc: selftest tor new MSG_PEEK_ALL flag for msgrcv()
has been added to the -mm tree.  Its filename is
     c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv.patch

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
Subject: c/r: ipc: selftest tor new MSG_PEEK_ALL flag for msgrcv()

This test sends two messages, then peeks at them and checks that they are
equal to the original messages.  Then it receives messages and checks once
more to make sure that messages are not corrupted or lost after the peek
operation.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/Makefile          |   31 ++
 tools/testing/selftests/ipc/msgque_peek_all.c |  170 ++++++++++++++++
 2 files changed, 201 insertions(+)

diff -puN /dev/null tools/testing/selftests/ipc/Makefile
--- /dev/null
+++ a/tools/testing/selftests/ipc/Makefile
@@ -0,0 +1,31 @@
+ifeq ($(strip $(V)),)
+	E = @echo
+	Q = @
+else
+	E = @\#
+	Q =
+endif
+export E Q
+
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
+all:
+ifeq ($(ARCH),X86)
+	$(E) "  CC run_test"
+	$(Q) gcc msgque_peek_all.c -o run_test
+else
+	$(E) "Not an x86 target, can't build kcmp selftest"
+endif
+
+clean:
+	$(E) "  CLEAN"
+	$(Q) rm -fr ./run_test
diff -puN /dev/null tools/testing/selftests/ipc/msgque_peek_all.c
--- /dev/null
+++ a/tools/testing/selftests/ipc/msgque_peek_all.c
@@ -0,0 +1,170 @@
+#define _GNU_SOURCE
+#include <sched.h>
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/sem.h>
+#include <sys/ipc.h>
+#include <sys/msg.h>
+#include <signal.h>
+#include <errno.h>
+
+#define __round_mask(x, y)	((__typeof__(x))((y) - 1))
+#define round_up(x, y)		((((x) - 1) | __round_mask(x, y)) + 1)
+
+#ifndef MSG_PEEK_ALL
+#define MSG_PEEK_ALL		040000
+/* message buffer for msgrcv in case of array calls */
+struct msgbuf_a {
+	long mtype;	/* type of message */
+	int msize;	/* size of message */
+	char mtext[0];	/* message text */
+};
+#endif
+
+const char *test_doc="Tests sysv5 msg queues supporting by checkpointing";
+const char *test_author="Stanislav Kinsbursky <skinsbursky@openvz.org>";
+
+#define MAX_MSG_LENGTH		32
+
+struct my_msg {
+	long mtype;
+	char mtext[MAX_MSG_LENGTH];
+};
+
+struct my_msg messages[] = {
+	{ 1, "Test sysv5 msg" },
+	{ 26538, "Yet another test sysv5 msg"},
+	{ 0, "" }
+};
+
+static int receive_messages(int msgq)
+{
+	int i, ret;
+	struct my_msg msgbuf;
+
+	i = 0;
+	while(messages[i].mtype > 0) {
+		ret = msgrcv(msgq, &msgbuf, MAX_MSG_LENGTH,
+				messages[i].mtype, IPC_NOWAIT);
+		if (ret < 0) {
+			printf("Child: msgrcv failed (%m)\n");
+			return -errno;
+		}
+		if (ret != strlen(messages[i].mtext) + 1) {
+			printf("Received message[%i] size is wrong: %d "
+					"(should be %ld)\n", i,
+					ret, strlen(messages[i].mtext) + 1);
+			return -EINVAL;
+		}
+		if (memcmp(msgbuf.mtext, messages[i].mtext, ret)) {
+			printf("Received message content is wrong\n");
+			return -EINVAL;
+		}
+		i++;
+	}
+	return 0;
+}
+
+static int peek_messages(int msgq)
+{
+	void *msg_array, *ptr;
+	int array_size;
+	struct msqid_ds ds;
+	int id, ret, i;
+
+	ret = msgctl(msgq, IPC_STAT, &ds);
+	if (ret < 0) {
+		printf("Failed to get stats for IPC message queue (%m)\n");
+		return -errno;
+	}
+
+	/*
+	 * Here we allocate memory for struct msgbuf_a twice becase messages in
+	 * array will be aligned by struct msgbuf_a.
+	 */
+	array_size = ds.msg_qnum * sizeof(struct msgbuf_a) * 2 + ds.msg_cbytes;
+	msg_array = malloc(array_size);
+	if (msg_array == 0)
+		return -ENOMEM;
+
+	ret = msgrcv(msgq, msg_array, array_size, 0, IPC_NOWAIT | MSG_PEEK_ALL);
+	if (ret < 0) {
+		printf("Failed to receive IPC messages array (%m)");
+		return -errno;
+	}
+
+	i = 0;
+	ptr = msg_array;
+	while (i < ds.msg_qnum) {
+		struct msgbuf_a *msg = ptr;
+
+		if (msg->mtype != messages[i].mtype) {
+			printf("Peeked message type is wrong: %ld (should be %ld)\n",
+				msg->mtype, messages[i].mtype);
+			return -EINVAL;
+		}
+		if (memcmp(msg->mtext, messages[i].mtext, msg->msize)) {
+			printf("Peeked message content is wrong\n");
+			return -EINVAL;
+		}
+		ptr += round_up(msg->msize + sizeof(struct msgbuf_a), sizeof(struct msgbuf_a));
+		i++;
+	}
+	return 0;
+}
+
+static int send_messages(int msgq)
+{
+	int i = 0;
+
+	while(messages[i].mtype > 0) {
+		if (msgsnd(msgq, &messages[i], strlen(messages[i].mtext) + 1, IPC_NOWAIT) != 0) {
+			printf("Parent: msgsnd[%i] failed (%m)", i);
+			return -errno;
+		};
+		i++;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	key_t key;
+	int msgq, ret;
+
+	key = ftok(argv[0], 822155650);
+	if (key == -1) {
+		printf("Can't make key");
+		return -errno;
+	}
+
+	msgq = msgget(key, IPC_CREAT | IPC_EXCL | 0666);
+	if (msgq == -1) {
+		msgq = msgget(key, 0666);
+		if (msgq == -1) {
+			printf("Can't get queue");
+			return -errno;
+		}
+	}
+
+	ret = send_messages(msgq);
+	if (ret)
+		goto out;
+	ret = peek_messages(msgq);
+	if (ret)
+		goto out;
+	ret = receive_messages(msgq);
+	if (ret)
+		goto out;
+out:
+	if (msgctl(msgq, IPC_RMID, 0)) {
+		printf("Failed to destroy message queue (%m)\n");
+		return -errno;
+	}
+	return ret;
+}
_
Subject: Subject: c/r: ipc: selftest tor new MSG_PEEK_ALL flag for msgrcv()

Patches currently in -mm which might be from skinsbursky@parallels.com are

linux-next.patch
c-r-ipc-message-queue-receive-cleanup.patch
c-r-ipc-message-queue-stealing-feature-introduced.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv.patch

