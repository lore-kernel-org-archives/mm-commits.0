Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ED33A168E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 02:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791858040; cv=none; b=l5fazqyiueeS5cUOJhH3GTBq9E3LbbEJXADuX3/YjixqrKEPCSAGOmQWh1XN324OSSCrdvK1BVnrGNRSKuH9TMtdGsGyYzFSpbbaBt6Hwx3FbAPgNix5ig1GqpP07iVdJlpeXbItViTJxCcQKoh8MsqxJzB7H126ivnwZ+3pffI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791858040; c=relaxed/simple;
	bh=UBUMeFLThd0qkO7bsMW2jTD6gt9FQSyIp3rMr3IWBi4=;
	h=Date:To:From:Subject:Message-Id; b=ObM3KBgTXkePxC7s6O7l6B+n243ToRHBZLqx4cfhLZupzlc76WqXjuVvTpdKs5zkwbj4T3JUymh3GBIGfGhgmh7ovLWvzDELQpp0NuqCcuewu70D8f/CrABL3Wz9q4aG3g0Wb87xQnc4+0uvDy67FEugeNmFUb0zvPj+r2yvI3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEKI4n+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEKI4n+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0595D1F00893;
	Tue, 13 Oct 2026 02:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791858039;
	bh=ON06Ie1t6ICBUWU7XDEYmeW/7fcFGmcAm9/t2YCYrWE=;
	h=Date:To:From:Subject;
	b=TEKI4n+tqMyORSYxf7cLtm7R3Dds7W5VfWpOG3F/0lERCxqWpb1KWel7ffIsV4npE
	 Q+01ASq3v8/pApA9oE9iNpA06EKzm9A7I/RPBq6XhQfCucf+WStK9I17THNU0XSyHD
	 JD+jB3y6jMWW4EP5ikLKwpHXUps+qfQw/lWMWyRc=
Date: Mon, 12 Oct 2026 19:20:38 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,akpm@linux-foundation.org,adobriyan@gmail.com,sashal@kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-proc-pid-vm-fix-unused-variable-warning-on-non-x86.patch added to mm-nonmm-unstable branch
Message-Id: <20261013022039.0595D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: proc-pid-vm: fix unused variable warning on non-x86
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-proc-pid-vm-fix-unused-variable-warning-on-non-x86.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-proc-pid-vm-fix-unused-variable-warning-on-non-x86.patch

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
Fixes: 17415606f9d8b ("tools/testing/selftests/proc/proc-pid-vm.c: test with vsyscall in mind")
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

selftests-proc-proc-pid-vm-fix-unused-variable-warning-on-non-x86.patch

