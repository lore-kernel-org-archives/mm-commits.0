Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560654;
	b=Dl1lz91Et/k5GT42riQfDhlRTkD1U+aiOCjooyfIWJyUo7UZiXnq9i7rL7CyAmQMnfBg
	 ra2K/2slnTaQhi51uW6XNg6fW2wohlyf0Uthy2TLmMC9x0P3auirsZaXcLeC5LaK0ROyq
	 TWc13pA3OQHHXIBxPjGpngvNs89BDiO6I4kzMipaCOtzFRk3EUTeoRD29CS5+8seNnhwH
	 BSprFIiOghI8GBYxi4sCuh21bQ9JHX+Q0eMC2Q4PMh+Jiq9zYW0KzauehDWuD1CsRZN4F
	 aVzLC/WV+Wa+jpX5JS4HZEFRFRFpDcJza7PmEoweyu/jQAVmpRshCj/DN8spmjGaBIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560654;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=x9nI9vQ5CvpZvXT6Qx4FfhefS+6E0pVhTaYNpzn8SV0=;
	b=0ld8pIS6leXQi5AfG2UaHLGqRNBqBMuNHCPccyHXmh4G2oIuBTvgbutoSNVhB+HFSEVf
	 98Cv/AzS10Zr2/KDLrCW+awTI5TaR7cCO12CMidMtKQPAkxFtZtxlAehUGP7Pfhmlsa18
	 Xf6nTd0r3/U23xhRcAsR+nAHz3M7F1ai+T+QImCXbfQUv0YeyNWi8o9Wu8DLNg21m0YOp
	 GUw43P52m0Np9kUAN3EBRzVpEe9ta6845iUq3InVwqxGoem5+yJn/3geIt4OwoQtm7++L
	 CJMGHPwNi3VXjDGtynXeDLGQkBh7WAlNC/PSAtjTxGXhzZEKse3Jfd6Xx5p4StbnMmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rxcVKEIZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2820606A31C
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rxcVKEIZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794581F000CC;
	Wed, 21 Oct 2026 05:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560654;
	bh=x9nI9vQ5CvpZvXT6Qx4FfhefS+6E0pVhTaYNpzn8SV0=;
	h=Date:To:From:Subject;
	b=rxcVKEIZHd+FQZQz4ahyuJVIxMclzLJTlwMAU+fgWtciM508BT1FdKrx+8yJ1e+o0
	 tvDDvjDImd/6195YGUZyVTXiQfCX9wmzCRIwsToGBUTnK6DYlei4KabEXTBu88GEIn
	 rLDXupCUp4g4E987efIaDzyS1e7I+W9OoNQWOiNg=
Date: Tue, 20 Oct 2026 22:30:54 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,akpm@linux-foundation.org,adobriyan@gmail.com,sashal@kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-proc-proc-pid-vm-fix-unused-variable-warning-on-non-x86.patch removed from -mm tree
Message-Id: <20261021053054.794581F000CC@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/proc: proc-pid-vm: fix unused variable warning on non-x86
has been removed from the -mm tree.  Its filename was
     selftests-proc-proc-pid-vm-fix-unused-variable-warning-on-non-x86.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: selftests/proc: proc-pid-vm: fix unused variable warning on non-x86
Date: Mon, 12 Oct 2026 07:53:29 -0400

g_vsyscall is only used by the x86_64 test, so clang builds for other
architectures get:

  proc-pid-vm.c:224:21: warning: unused variable 'g_vsyscall' [-Wunused-variable]

The vsyscall strings next to it had the same problem and were marked
__maybe_unused for it. Move all of the vsyscall variables into the
__x86_64__ block that uses them instead, and drop those annotations
along with the local __maybe_unused fallback that was added for them.

Link: https://lore.kernel.org/20261012115330.3777115-1-sashal@kernel.org
Fixes: 17415606f9d8 ("tools/testing/selftests/proc/proc-pid-vm.c: test with vsyscall in mind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---

 tools/testing/selftests/proc/proc-pid-vm.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/proc/proc-pid-vm.c~selftests-proc-proc-pid-vm-fix-unused-variable-warning-on-non-x86
+++ a/tools/testing/selftests/proc/proc-pid-vm.c
@@ -47,10 +47,6 @@
 #include <sys/resource.h>
 #include <linux/fs.h>
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 #include "kselftest.h"
 
 static inline long sys_execveat(int dirfd, const char *pathname, char **argv, char **envp, int flags)
@@ -214,7 +210,6 @@ static int make_exe(const uint8_t *paylo
 
 	return fd1;
 }
-#endif
 
 /*
  * 0: vsyscall VMA doesn't exist	vsyscall=none
@@ -222,15 +217,14 @@ static int make_exe(const uint8_t *paylo
  * 2: vsyscall VMA is r-xp		vsyscall=emulate
  */
 static volatile int g_vsyscall;
-static const char *str_vsyscall __maybe_unused;
+static const char *str_vsyscall;
 
-static const char str_vsyscall_0[] __maybe_unused = "";
-static const char str_vsyscall_1[] __maybe_unused =
+static const char str_vsyscall_0[] = "";
+static const char str_vsyscall_1[] =
 "ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n";
-static const char str_vsyscall_2[] __maybe_unused =
+static const char str_vsyscall_2[] =
 "ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n";
 
-#ifdef __x86_64__
 static void sigaction_SIGSEGV(int _, siginfo_t *__, void *___)
 {
 	_exit(g_vsyscall);
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-mm-report-the-configuration-check-on-stderr.patch

