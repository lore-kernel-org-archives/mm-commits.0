Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E384145329
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810150; cv=none; b=NJEpPf1zrXPASmaPzDm6CfHAe+lWwCpsEo8j3sqW/LtcF/dWsL1mRoh3rAXy1TVOvKoTfhX4lnx5xIXNP4dcYs2tr0jCHz23V/DdMdadgxqWwBobT6JGTHIfmKFwlJXpajSbZPgMQUxFCvBKvQfAFXS/utdR+SHYo7bKR+9JMKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810150; c=relaxed/simple;
	bh=gHhGtQ7/dZdeFHTmImUls8EczrOL2NUq0S4n3ZSvHQE=;
	h=Date:To:From:Subject:Message-Id; b=IDKmbRSA81MlNhpfiDSoQnIfSMdLnYHg8BzjG3itT4KcuRO2DETwCoLUaPBQS8l/EMDuXETVGrV8mnyWaRfwrwzC/zxWc4zzEzcAsp+a/xAkLfKEIP04yee2IiiX2XiBIvV+2FJ4sCLxYvy48n/fK4fslKnlMhycgU1hw+6e1Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aGBpfsfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aGBpfsfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C345C4CEEB;
	Sun, 14 Sep 2025 00:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810150;
	bh=gHhGtQ7/dZdeFHTmImUls8EczrOL2NUq0S4n3ZSvHQE=;
	h=Date:To:From:Subject:From;
	b=aGBpfsfLkNx5+E/BwIq7IGESaAtM3N+tgaWMLeDRtYLaZEMQ44Cr+7jQ4Yrpox9pq
	 AzhavWaBlsfnI0smS0VNwGdotiD7dpjx4MEj8zQuEtmnUkbF3ugs2Hwpnv4ZrGDtex
	 t2J8YoeX86hPKPAzm6SxR3E77TUf6sF0ISK8tSu4=
Date: Sat, 13 Sep 2025 17:35:49 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,reddybalavignesh9979@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-proc-mark-vsyscall-strings-maybe-unused.patch removed from -mm tree
Message-Id: <20250914003550.0C345C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: proc: mark vsyscall strings maybe-unused
has been removed from the -mm tree.  Its filename was
     selftests-proc-mark-vsyscall-strings-maybe-unused.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


