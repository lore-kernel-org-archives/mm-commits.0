Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793593553;
	b=wqVxJIupGJxe4d/v+Wz4rxOERusRacvMqy0hAA+YuG2mjJnYFYJTcBQNvYZKgw5cYIDX
	 EzlL9c0z8R48Kjh3fSZY2FvpOhtDx07CcAAK0hyKIqjX4E1V+T1EzRMt8uijl5M/c4r2r
	 JCZSFn3Br+oO3W8hXphIyQLiUI5rkjn0iG7HF5AvfOl5auAetBKvJBnojf0Px9w+5H7yv
	 3BbIYHUy2UGoVBi4eO+wc+BzTcW0koswHs1rUy1oQuyMUdGlLeDiou4Qv+BlsGkROaOze
	 F7ssBG6oAHpRDxkTQXmMNTWQ8b38NQFQjDaopZawSeYzWfISHFl3rG6dE9/NlHFBM+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793593553;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2MrpTyQAi82J9Dv1AAVRPe2HTsfG3NHrrr5R1hY1SXU=;
	b=zzJ6tQ+wUh+6F6E0y/RgsPy04IRB9xEuRKpuxYtH7hqr5DP4XGhceSWpMwIYwk6Cce9k
	 qF/p48s2HVOoaIBNrOVSs9oF7VQTU9jY+OERS1KTM3F5r/NQNld3Tcz3CY9s+24+kjwCR
	 YEJOmwFLSNWA1wBdyM6nbMgfpYBkchrSA23rTeh/bgEdzeO1I8vEmcAIqrSKkV0Z5G0Af
	 G3FU/WslxhrWS2KxQNtx01G2eMQf6JMcu/V6IqtwOiJBbtmrIgQ6ciBJ7VaBgUMzcVYSL
	 38egNG0nAOq9YiW1h5iZ4uXD9Ivp7ECmgPZvUsENHXNIIlzhyVnnw8WrjygCsdfD94A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PjOzh7uq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5D4606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 04:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PjOzh7uq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736471F000C1;
	Mon,  2 Nov 2026 04:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793593552;
	bh=2MrpTyQAi82J9Dv1AAVRPe2HTsfG3NHrrr5R1hY1SXU=;
	h=Date:To:From:Subject;
	b=PjOzh7uq99M9PDlO17m6QJIjORLSDcHo1sObcsCcAkQM4R51IwJyiasGG8dr2JRry
	 TaycwZgbMLZUz9VINaWiaoeHjzGbV2wh1jmUmeMIrssqQoF3qNQys0MZGyijsske/O
	 ZW4J4+CqIQhxcsNqruA5vW1WjmeldxBZGm6cPKRI=
Date: Sun, 01 Nov 2026 20:25:51 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,adobriyan@gmail.com,
	drifabdelmalekmohamedsaid@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-proc-empty-vm-wait-for-childs-sigsegv-instead-of-sleep1.patch added to mm-nonmm-unstable branch
Message-Id: <20261102042552.736471F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/proc: proc-empty-vm: wait for child's SIGSEGV instead of sleep(1)
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-proc-empty-vm-wait-for-childs-sigsegv-instead-of-sleep1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-proc-empty-vm-wait-for-childs-sigsegv-instead-of-sleep1.patch

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
From: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
Subject: selftests/proc: proc-empty-vm: wait for child's SIGSEGV instead of sleep(1)
Date: Fri, 23 Oct 2026 19:34:33 +0100

The test had a TODO asking for a reliable way to know when the child's
munmap() has finished, and used sleep(1) in the meantime.

Unmapping the whole address space leaves the child with no code to run, so
it segfaults.  Since it is traced, the SIGSEGV stop is reported to the
parent through waitpid(), which is exactly the signal the TODO wanted. 
Wait for it there and drop the sleep and the TODO.

The stop is now consumed up front, so SIGKILL the child before the final
reap.

Link: https://lore.kernel.org/20261023183434.9109-1-drifabdelmalekmohamedsaid@gmail.com
Fixes: 5bc73bb3451b ("proc: test how it holds up with mapping'less process")
Signed-off-by: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   24 +++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~selftests-proc-proc-empty-vm-wait-for-childs-sigsegv-instead-of-sleep1
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -41,6 +41,7 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <unistd.h>
+#include <signal.h>
 
 #ifdef __amd64__
 #define TEST_VSYSCALL
@@ -500,13 +501,18 @@ int main(void)
 #endif
 		return EXIT_FAILURE;
 	} else {
-		/*
-		 * TODO find reliable way to signal parent that munmap(2) completed.
-		 * Child can't do it directly because it effectively doesn't exist
-		 * anymore. Looking at child's VM files isn't 100% reliable either:
-		 * due to a bug they may not become empty or empty-like.
-		 */
-		sleep(1);
+		int wstatus;
+		pid_t p;
+
+		for (;;) {
+			p = waitpid(pid, &wstatus, 0);
+			if (p == -1 && errno == EINTR)
+				continue;
+			break;
+		}
+		assert(p == pid);
+		assert(WIFSTOPPED(wstatus));
+		assert(WSTOPSIG(wstatus) == SIGSEGV);
 
 		if (rv == EXIT_SUCCESS) {
 			rv = test_proc_pid_maps(pid);
@@ -525,10 +531,8 @@ int main(void)
 		}
 
 		/* Cut the rope. */
-		int wstatus;
+		kill(pid, SIGKILL);
 		waitpid(pid, &wstatus, 0);
-		assert(WIFSTOPPED(wstatus));
-		assert(WSTOPSIG(wstatus) == SIGSEGV);
 	}
 
 	return rv;
_

Patches currently in -mm which might be from drifabdelmalekmohamedsaid@gmail.com are

selftests-proc-proc-empty-vm-wait-for-childs-sigsegv-instead-of-sleep1.patch

