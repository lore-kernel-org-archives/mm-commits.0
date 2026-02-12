Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2AB17B50F
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939989; cv=none; b=QNsrUS9N1zR1E1dGwS3WoKd3SNIyNH0Bw3ABtp3jf2WtjCJuSTtysnnC75B7Cy+vwk5CI95VwJI4CDuz9zfcCojD4mfRfs9E8mKwOSOPgqEKlandy1+ueUdde3jMTyNf6qxgxe0NKXuqzw5PV/m5VaCq3mwETl+ETnyKEJAzD3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939989; c=relaxed/simple;
	bh=qR2OwlNZcOyA0a83g1V5BiO0TIHAYEEdTzFtZ6NhOWg=;
	h=Date:To:From:Subject:Message-Id; b=E9hTaKp7QsGJL1cC+N8lgiVye+RBtRgACbI8OFcQRTeme11T1MXPC/xXwskCXIT9Y9MOj/cYYyRR32/lqerTpSzWhPZVxSkasAudC4vSd6JuH0Z2WHmPMRvJHTvk/fx7nppxGwnIL8m3rmHIFTtRHeDRWJgsSqz72AbhVR77xUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wtQL3FBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wtQL3FBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144EEC4CEF7;
	Thu, 12 Feb 2026 23:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939989;
	bh=qR2OwlNZcOyA0a83g1V5BiO0TIHAYEEdTzFtZ6NhOWg=;
	h=Date:To:From:Subject:From;
	b=wtQL3FBnhJLImQLoxPNSBZaMxEw6cHj4VyGBI625nkuptZtmvUxvkHAbhOy2GiGVG
	 WD6C9ahp5THvPxwt6eQyIO2tAv/sTRJCBCWF01rBvDvD4TsRrkmnbcY5OHhwehpPXk
	 TY/BGgATXu7xGYeqsl9ewgV24tfwAeY73o35BGRM=
Date: Thu, 12 Feb 2026 15:46:28 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,liuye@kylinos.cn,cyphar@cyphar.com,aris@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-memfd-use-ipc-semaphore-instead-of-sigstop-sigcont.patch removed from -mm tree
Message-Id: <20260212234629.144EEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT
has been removed from the -mm tree.  Its filename was
     selftests-memfd-use-ipc-semaphore-instead-of-sigstop-sigcont.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 6469b66e3f5a ("selftests: improve vm.memfd_noexec sysctl tests")
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


