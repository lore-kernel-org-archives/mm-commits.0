Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6C330ACF8
	for <mm-commits@vger.kernel.org>; Mon,  2 Feb 2026 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770062787; cv=none; b=Z1kZqnfKDQv41UNfcUiLVl8VmVuTyGDFp4VYtWbflmpEYawjKm2mRaCMf/0REktAYniNN2pUC2436kURZam80aOsjUmXcoipJ/V/eK/pRebQ9UKoWf/CXuDLCkYG+lyyNmax6rrPkiJpzv7hyev/YqaxLhYFCrt/N2j9tt0yilg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770062787; c=relaxed/simple;
	bh=5hEV9pglfaSvvnNOBV4P1/wTW9p5esLynbyI9MUdBtw=;
	h=Date:To:From:Subject:Message-Id; b=iXryVVD7ct35ONaFBj331gTNe6T3cvRC6HspNw/+69ImMyT4Bk7CQsztmAUjTQs6f0AU47v/JUn4WrYE2fbSHFMe1K4g9JCgmZVCAKbMCXBViBUeHGXW83eCieni9B3KwRABcbhk6dZTyDm0oxS2pxDYjN+YDcw87oyjiYLgKhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0NfnYaZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0NfnYaZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3AFC116C6;
	Mon,  2 Feb 2026 20:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770062787;
	bh=5hEV9pglfaSvvnNOBV4P1/wTW9p5esLynbyI9MUdBtw=;
	h=Date:To:From:Subject:From;
	b=0NfnYaZwP6AD8f/tgOj55RYtTE0VFdAtulxv3l+aB5re7QYZznjXbPewmYA4U1jok
	 tnIHw4/5gk7N7515/Rnye2UML9wZviNuDp2PUQQiQOSf4DzrS8EDRJAPLj68S8oSVg
	 T05dGjuhZKXNWBxFH0CX2Kco2FqRcy/sseKlP9RM=
Date: Mon, 02 Feb 2026 12:06:26 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,liuye@kylinos.cn,cyphar@cyphar.com,aris@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-use-ipc-semaphore-instead-of-sigstop-sigcont.patch added to mm-nonmm-unstable branch
Message-Id: <20260202200627.4E3AFC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-memfd-use-ipc-semaphore-instead-of-sigstop-sigcont.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-use-ipc-semaphore-instead-of-sigstop-sigcont.patch

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
From: Aristeu Rozanski <aris@redhat.com>
Subject: selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT
Date: Mon, 2 Feb 2026 09:38:05 -0500

selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

In order to synchronize new processes to test inheritance of memfd_noexec
sysctl, memfd_test sets up the sysctl with a value before creating the new
process.  The new process then sends itself a SIGSTOP in order to wait for
the parent to flip the sysctl value and send a SIGCONT signal.

This would work as intended if it wasn't the fact that the new process is
being created with CLONE_NEWPID, which creates a new PID namespace and the
new process has PID 1 in this namespace.  There're restrictions on sending
signals to PID 1 and, although it's relaxed for other than root PID
namespace, it's biting us here.  In this specific case the SIGSTOP sent by
the new process is ignored (no error to kill() is returned) and it never
stops its execution.  This is usually not noticiable as the parent usually
manages to set the new sysctl value before the child has a chance to run
and the test succeeds.  But if you run the test in a loop, it eventually
reproduces:

	while [ 1 ]; do ./memfd_test >log 2>&1 || break; done; cat log

So this patch replaces the SIGSTOP/SIGCONT synchronization with IPC
semaphore.

Link: https://lkml.kernel.org/r/a7776389-b3d6-4b18-b438-0b0e3ed1fd3b@work
Fixes: 6469b66e3f5a3 ("selftests: improve vm.memfd_noexec sysctl tests")
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: liuye <liuye@kylinos.cn>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |  113 +++++++++++++++++--
 1 file changed, 105 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-use-ipc-semaphore-instead-of-sigstop-sigcont
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -18,6 +18,9 @@
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/wait.h>
+#include <sys/types.h>
+#include <sys/ipc.h>
+#include <sys/sem.h>
 #include <unistd.h>
 #include <ctype.h>
 
@@ -39,6 +42,20 @@
 		    F_SEAL_EXEC)
 
 #define MFD_NOEXEC_SEAL	0x0008U
+union semun {
+	int val;
+	struct semid_ds *buf;
+	unsigned short int *array;
+	struct seminfo *__buf;
+};
+
+/*
+ * we use semaphores on nested wait tasks due the use of CLONE_NEWPID: the
+ * child will be PID 1 and can't send SIGSTOP to themselves due special
+ * treatment of the init task, so the SIGSTOP/SIGCONT synchronization
+ * approach can't be used here.
+ */
+#define SEM_KEY 0xdeadbeef
 
 /*
  * Default is not to test hugetlbfs
@@ -1333,8 +1350,22 @@ static int sysctl_nested(void *arg)
 
 static int sysctl_nested_wait(void *arg)
 {
-	/* Wait for a SIGCONT. */
-	kill(getpid(), SIGSTOP);
+	int sem = semget(SEM_KEY, 1, 0600);
+	struct sembuf sembuf;
+
+	if (sem < 0) {
+		perror("semget:");
+		abort();
+	}
+	sembuf.sem_num = 0;
+	sembuf.sem_flg = 0;
+	sembuf.sem_op = 0;
+
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		abort();
+	}
+
 	return sysctl_nested(arg);
 }
 
@@ -1355,7 +1386,9 @@ static void test_sysctl_sysctl2_failset(
 
 static int sysctl_nested_child(void *arg)
 {
-	int pid;
+	int pid, sem;
+	union semun semun;
+	struct sembuf sembuf;
 
 	printf("%s nested sysctl 0\n", memfd_str);
 	sysctl_assert_write("0");
@@ -1389,23 +1422,53 @@ static int sysctl_nested_child(void *arg
 			   test_sysctl_sysctl2_failset);
 	join_thread(pid);
 
+	sem = semget(SEM_KEY, 1, IPC_CREAT | 0600);
+	if (sem < 0) {
+		perror("semget:");
+		return 1;
+	}
+	semun.val = 1;
+	sembuf.sem_op = -1;
+	sembuf.sem_flg = 0;
+	sembuf.sem_num = 0;
+
 	/* Verify that the rules are actually inherited after fork. */
 	printf("%s nested sysctl 0 -> 1 after fork\n", memfd_str);
 	sysctl_assert_write("0");
 
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl1_failset);
 	sysctl_assert_write("1");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 0 -> 2 after fork\n", memfd_str);
 	sysctl_assert_write("0");
 
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2_failset);
 	sysctl_assert_write("2");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	/*
@@ -1415,28 +1478,62 @@ static int sysctl_nested_child(void *arg
 	 */
 	printf("%s nested sysctl 2 -> 1 after fork\n", memfd_str);
 	sysctl_assert_write("2");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2);
 	sysctl_assert_write("1");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 2 -> 0 after fork\n", memfd_str);
 	sysctl_assert_write("2");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2);
 	sysctl_assert_write("0");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 1 -> 0 after fork\n", memfd_str);
 	sysctl_assert_write("1");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl1);
 	sysctl_assert_write("0");
-	kill(pid, SIGCONT);
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
+	semctl(sem, 0, IPC_RMID);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from aris@redhat.com are

selftests-memfd-use-ipc-semaphore-instead-of-sigstop-sigcont.patch

