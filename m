Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398212;
	b=XTwUTqNaPlTojiEuIA3eyYn9HIi6ANXHGVwZTowCLaXn712rqeDY04KmyE43dcHnNvcx
	 P7YbTsYBV/JaejQAGT9ueUwSilGoZZjtuTWzpPRlKvZ+A5kvjHOkBuxcQA9Nm2EX7TaVk
	 lcAuLwTQiFLB1oc8vDDP7jYbpt5sZNX3XJAaeOGUGpU8B8S/9k7R6nehQGmhQzoixTwKT
	 te31S5MuWJt5/Re8EfUeDi2Yme0HRbW3AWpOuooMCM0ILUO42VIKMg0u6jghB0L83Bwk0
	 g7JClhgQi/1bsSkTqio6QbjBlyq+IQOz9UBAP84DPHpu6lVmXUfwvvfjRRPr5gdJ/pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398212;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5zy/dBrXrbgHyyBs0J9Fzl5iD21hrozvcdWfsYCabU4=;
	b=K2AnPczhtbFdMXUM525qqq5+FVQ+qixVW2Zd5vtEZGMpI7onAqDqXKoXD0k61wRQJsiH
	 ww75MJL3oMMi/fydz7ZtfkgLAFmUz+7axRHToQwcQMoAFQjrdI/mCb7ihZmyJxZug55rK
	 6n9sW0PGSRwvT1PvL9giiiVxIcEPuwX6gqBc5T4XtlRA4b9mZJhFMfIipD4IpvvJ6tXP2
	 reg2zmVBvsKaokiEhhk33VvKxNgrc/Htgai5Hj8WklgIBWV/chwoOeLwbgzvvUn8Lf346
	 m1YN7hmbSLCef7AfU6Z8rufegmbz2PNGMAMGjaTDrIYQoXlzgzPN2VhpS1GLaLnFtCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jBIfz4Hy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2E0606A31D;
	Fri, 30 Oct 2026 22:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jBIfz4Hy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE691F000C1;
	Fri, 30 Oct 2026 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793398211;
	bh=5zy/dBrXrbgHyyBs0J9Fzl5iD21hrozvcdWfsYCabU4=;
	h=Date:To:From:Subject;
	b=jBIfz4HybzWTwLQGNdWDba9wBynrSHUDOXw+Bhr0EHJ98lmS6ozFdyq/46EwCyQxy
	 2wkN7YUnuqWI0uAFttSDGg4yP/ByQjg9myERSt2t2QisziRjkeJ+G2AxffU41O5K+E
	 nLUt6WFjcIQ/lz5fFp3mFj5szo9hZLAwxJH6Ruuo=
Date: Fri, 30 Oct 2026 15:10:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	shubhang@os.amperecomputing.com,shuaibinglu@126.com,shuah@kernel.org,
	manfred@colorfullife.com,jan.koester@tuxist.de,dave@stgolabs.net,
	cl@gentwo.org,sh@gentwo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-fix-msg_qbytes-truncation-in-ipc_set.patch added to mm-nonmm-unstable branch
Message-Id: <20261030221011.1DE691F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/msg: fix msg_qbytes truncation in IPC_SET
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-fix-msg_qbytes-truncation-in-ipc_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-fix-msg_qbytes-truncation-in-ipc_set.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Subject: ipc/msg: fix msg_qbytes truncation in IPC_SET
Date: Thu, 29 Oct 2026 12:35:50 -0700

The msg_qbytes field in the struct msqid64_ds userspace ABI is an unsigned
long.  Commit 889b331724c82 ("ipc/msg.c: consolidate all xxxctl_down()
functions") passes that value to msgctl_down() as an int.

On ABIs where unsigned long is wider than unsigned int, this narrows
msg_qbytes before validation and assignment.  For example, an unprivileged
queue owner can request msg_qbytes = 0x100000000.  The conversion to int
changes this value to zero, which passes the msg_ctlmnb check.  IPC_SET
then succeeds and sets q_qbytes to zero instead of rejecting the requested
value with EPERM.

For callers with CAP_SYS_RESOURCE, values with bit 31 set are also
incorrectly sign-extended when assigned to q_qbytes.  In particular,
UINT_MAX becomes ULONG_MAX rather than the requested UINT_MAX.

Keep msg_qbytes as unsigned long through validation and assignment.  Also
preserve its type in ipcctl_obtain_check(), which passes it to the
unsigned-long audit field.

Add a regression test which drops CAP_SYS_RESOURCE and verifies that
IPC_SET with a value above UINT_MAX fails with EPERM where unsigned long
is wider than unsigned int.  Skip the test when it is not, capabilities
are unavailable, or System V message queues are unavailable.

Link: https://lore.kernel.org/20261029-ipc-msg-qbytes-v3-1-fc3f4307c85b@gentwo.org
Fixes: 889b331724c8 ("ipc/msg.c: consolidate all xxxctl_down() functions")
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lu Shuaibing <shuaibinglu@126.com>
Cc: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Cc: Christopher Lameter (Ampere) <cl@gentwo.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jan Koester <jan.koester@tuxist.de>
Cc: <stable@vger.kernel.org>
---

 ipc/msg.c                                   |    2 
 ipc/util.c                                  |    3 
 ipc/util.h                                  |    3 
 tools/testing/selftests/ipc/Makefile        |    2 
 tools/testing/selftests/ipc/msgctl_qbytes.c |   84 ++++++++++++++++++
 5 files changed, 90 insertions(+), 4 deletions(-)

--- a/ipc/msg.c~ipc-msg-fix-msg_qbytes-truncation-in-ipc_set
+++ a/ipc/msg.c
@@ -399,7 +399,7 @@ copy_msqid_from_user(struct msqid64_ds *
  * NOTE: no locks must be held, the rwsem is taken inside this function.
  */
 static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
-			struct ipc64_perm *perm, int msg_qbytes)
+			struct ipc64_perm *perm, unsigned long msg_qbytes)
 {
 	struct kern_ipc_perm *ipcp;
 	struct msg_queue *msq;
--- a/ipc/util.c~ipc-msg-fix-msg_qbytes-truncation-in-ipc_set
+++ a/ipc/util.c
@@ -718,7 +718,8 @@ int ipc_update_perm(struct ipc64_perm *i
  */
 struct kern_ipc_perm *ipcctl_obtain_check(struct ipc_namespace *ns,
 					struct ipc_ids *ids, int id, int cmd,
-					struct ipc64_perm *perm, int extra_perm)
+					struct ipc64_perm *perm,
+					unsigned long extra_perm)
 {
 	kuid_t euid;
 	int err = -EPERM;
--- a/ipc/util.h~ipc-msg-fix-msg_qbytes-truncation-in-ipc_set
+++ a/ipc/util.h
@@ -180,7 +180,8 @@ void ipc64_perm_to_ipc_perm(struct ipc64
 int ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
 struct kern_ipc_perm *ipcctl_obtain_check(struct ipc_namespace *ns,
 					     struct ipc_ids *ids, int id, int cmd,
-					     struct ipc64_perm *perm, int extra_perm);
+					     struct ipc64_perm *perm,
+					     unsigned long extra_perm);
 
 static inline void ipc_update_pid(struct pid **pos, struct pid *pid)
 {
--- a/tools/testing/selftests/ipc/Makefile~ipc-msg-fix-msg_qbytes-truncation-in-ipc_set
+++ a/tools/testing/selftests/ipc/Makefile
@@ -12,7 +12,7 @@ endif
 
 CFLAGS += $(KHDR_INCLUDES)
 
-TEST_GEN_PROGS := msgque
+TEST_GEN_PROGS := msgctl_qbytes msgque
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/ipc/msgctl_qbytes.c a/tools/testing/selftests/ipc/msgctl_qbytes.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/ipc/msgctl_qbytes.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <errno.h>
+#include <limits.h>
+#include <linux/capability.h>
+#include <stdio.h>
+#include <sys/msg.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+
+static int drop_cap_sys_resource(void)
+{
+	struct __user_cap_header_struct hdr = {
+		.version = _LINUX_CAPABILITY_VERSION_3,
+	};
+	struct __user_cap_data_struct data[_LINUX_CAPABILITY_U32S_3];
+	unsigned int index = CAP_SYS_RESOURCE / 32;
+	__u32 mask = 1U << (CAP_SYS_RESOURCE % 32);
+
+	if (syscall(SYS_capget, &hdr, data))
+		return -1;
+
+	data[index].effective &= ~mask;
+	data[index].permitted &= ~mask;
+
+	return syscall(SYS_capset, &hdr, data);
+}
+
+int main(void)
+{
+	struct msqid_ds ds;
+	int msqid;
+	int ret;
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+#if ULONG_MAX <= UINT_MAX
+	ksft_exit_skip("requires unsigned long wider than unsigned int\n");
+#endif
+
+	if (drop_cap_sys_resource()) {
+		if (errno == ENOSYS)
+			ksft_exit_skip("capabilities are unavailable\n");
+		ksft_exit_fail_perror("drop CAP_SYS_RESOURCE");
+	}
+
+	msqid = msgget(IPC_PRIVATE, 0600);
+	if (msqid == -1) {
+		if (errno == ENOSYS)
+			ksft_exit_skip("System V message queues are unavailable\n");
+		ksft_exit_fail_perror("msgget");
+	}
+
+	ret = msgctl(msqid, IPC_STAT, &ds);
+	if (ret == -1) {
+		ksft_perror("msgctl(IPC_STAT)");
+		goto out_fail;
+	}
+
+	/*
+	 * Without CAP_SYS_RESOURCE, a value above UINT_MAX must be rejected
+	 * rather than truncated to zero.
+	 */
+	ds.msg_qbytes = (unsigned long)UINT_MAX + 1;
+	errno = 0;
+	ret = msgctl(msqid, IPC_SET, &ds);
+	if (ret == -1 && errno == EPERM) {
+		ksft_test_result_pass("IPC_SET rejects oversized msg_qbytes\n");
+		msgctl(msqid, IPC_RMID, NULL);
+		ksft_exit_pass();
+	}
+
+	if (ret == -1)
+		ksft_perror("msgctl(IPC_SET)");
+	else
+		ksft_print_msg("msgctl(IPC_SET) unexpectedly succeeded\n");
+
+out_fail:
+	msgctl(msqid, IPC_RMID, NULL);
+	ksft_test_result_fail("IPC_SET accepted oversized msg_qbytes\n");
+	ksft_exit_fail();
+}
_

Patches currently in -mm which might be from sh@gentwo.org are

ipc-msg-fix-msg_qbytes-truncation-in-ipc_set.patch

