Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A169A334360
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 21:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755726033; cv=none; b=B4mMm757iNNR56NkojCWTNZiKDyvj04MeHyA1m9NDh1jAtEg9IKHuv6vNTIpLbBws0D9XcRq10+TsaQj78KtUD4HPP7Y1pDW4iImjmvwoledPgrabRfm3Lx3BHUnIt09ECUoHKCAQSW7IIYrMwPHCvctcyprAGVgxaPrjMdMWwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755726033; c=relaxed/simple;
	bh=uut2imRHSd8Xyf2HGEOleZ1JfqGCBjiVr4aUUkHTJu4=;
	h=Date:To:From:Subject:Message-Id; b=evKNGVZe0BzG0R7RM1fUj5TNVms3nI0fdeEz8h/XLIrU3cym2W7SjU1hE60bi9ly8uUCKyNJ1FaE0PUNZyRnXbI5azxWx7jyuVwChorJSNDVF4FbxNmtNUOhvJBQNWX8uB3dpQw06HQ55wy76ZxwCxm6zcOb5gPjgNsoQ1/C41E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rTrjjOGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rTrjjOGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CBBC4CEE7;
	Wed, 20 Aug 2025 21:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755726033;
	bh=uut2imRHSd8Xyf2HGEOleZ1JfqGCBjiVr4aUUkHTJu4=;
	h=Date:To:From:Subject:From;
	b=rTrjjOGJ1mZFVD8jffNWPQ5zlQmnMsAlzINS7M5DINhfKh8HmGPmiBz0DOKxGYIcn
	 skYfgngKtLqSpWDJf4VnejofchusBfbCv5uX2yZyGf+XTdTullYvXuzY5ZSNV3LAs9
	 Eiuyk4lC0O6bBLflvNOrkQSe6c838KxA+m+z1soQ=
Date: Wed, 20 Aug 2025 14:40:32 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,reddybalavignesh9979@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-mark-vsyscall-strings-maybe-unused.patch added to mm-nonmm-unstable branch
Message-Id: <20250820214033.17CBBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: proc: mark vsyscall strings maybe-unused
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-mark-vsyscall-strings-maybe-unused.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-mark-vsyscall-strings-maybe-unused.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Subject: selftests: proc: mark vsyscall strings maybe-unused
Date: Wed, 20 Aug 2025 23:26:10 +0530

The str_vsyscall_* constants in proc-pid-vm.c triggers
-Wunused-const-variable warnings with gcc-13.32 and clang 18.1.

Define and apply __maybe_unused locally to suppress the warnings.  No
functional change

Fixes compiler warning:
warning: `str_vsyscall_*' defined but not used[-Wunused-const-variable]

Link: https://lkml.kernel.org/r/20250820175610.83014-1-reddybalavignesh9979@gmail.com
Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-pid-vm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/proc/proc-pid-vm.c~selftests-proc-mark-vsyscall-strings-maybe-unused
+++ a/tools/testing/selftests/proc/proc-pid-vm.c
@@ -47,6 +47,10 @@
 #include <sys/resource.h>
 #include <linux/fs.h>
 
+#ifndef __maybe_unused
+#define __maybe_unused __attribute__((__unused__))
+#endif
+
 #include "../kselftest.h"
 
 static inline long sys_execveat(int dirfd, const char *pathname, char **argv, char **envp, int flags)
@@ -218,12 +222,12 @@ static int make_exe(const uint8_t *paylo
  * 2: vsyscall VMA is r-xp		vsyscall=emulate
  */
 static volatile int g_vsyscall;
-static const char *str_vsyscall;
+static const char *str_vsyscall __maybe_unused;
 
-static const char str_vsyscall_0[] = "";
-static const char str_vsyscall_1[] =
+static const char str_vsyscall_0[] __maybe_unused = "";
+static const char str_vsyscall_1[] __maybe_unused =
 "ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n";
-static const char str_vsyscall_2[] =
+static const char str_vsyscall_2[] __maybe_unused =
 "ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n";
 
 #ifdef __x86_64__
_

Patches currently in -mm which might be from reddybalavignesh9979@gmail.com are

selftests-proc-mark-vsyscall-strings-maybe-unused.patch

