Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD572D47E2
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 22:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755813960; cv=none; b=pynFqZIKaOQ2LlvqTWyw0VgDtnxFbcFtCiW2cXt4OG0yhyrUXfMbbt6kbXSlaH/pn9vew+IH579xA7fguNjK26bMAtn2CWo60CN2IisrREX8q/mmlLR55UEIyr/+sfAV7To1qV8Wnnf55uGsTsV+SiDaLntPZdyQ/zbUn6H8Sd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755813960; c=relaxed/simple;
	bh=qlS//05XvbkH3xYP0dsELR+43u5AsYFzg2GhPheCFcs=;
	h=Date:To:From:Subject:Message-Id; b=CITiAMBHXO/OcX6/QmuX14d0rSKOo5J/oQRYUb3iKtm9vRLJWqUXZ7Y7BGfN5WSY4iMXN2FxaOEoQPEpRwB9O1V8dRZ76Nv6VC40MU5dj8+gZHTaeYe1bS46yDHiX2ATIFHlPz3IdvS9dbaYZ6OqjHdwmeZhhhiU3Pr++/3+shs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tRhIjcF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tRhIjcF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43305C4CEEB;
	Thu, 21 Aug 2025 22:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755813959;
	bh=qlS//05XvbkH3xYP0dsELR+43u5AsYFzg2GhPheCFcs=;
	h=Date:To:From:Subject:From;
	b=tRhIjcF487SlXnTnJoKqwefYs38LSa0qIlLWepK5G2KsqBknGLg9g6dKSII2ufnZM
	 0PdppWUZew82qo2ahhDgERUzNZfYvXPsWBzjqeXDKuKQuYC6M0UIDfBMKsCyawawma
	 46/eAwKbzX65N3MzIbr1EGuY9bMLoqhLkZ/UaGr4=
Date: Thu, 21 Aug 2025 15:05:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org,reddybalavignesh9979@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-centralise-maybe-unused-definition-in-kselftesth.patch added to mm-nonmm-unstable branch
Message-Id: <20250821220559.43305C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: centralise maybe-unused definition in kselftest.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-centralise-maybe-unused-definition-in-kselftesth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-centralise-maybe-unused-definition-in-kselftesth.patch

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
Subject: selftests: centralise maybe-unused definition in kselftest.h
Date: Thu, 21 Aug 2025 15:41:59 +0530

Several selftests subdirectories duplicated the define __maybe_unused,
leading to redundant code.  Move to kselftest.h header and remove other
definitions.

This addresses the duplication noted in the proc-pid-vm warning fix

Link: https://lkml.kernel.org/r/20250821101159.2238-1-reddybalavignesh9979@gmail.com
Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Link:https://lore.kernel.org/lkml/20250820143954.33d95635e504e94df01930d0@linux-foundation.org/
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest.h                    |    4 ++++
 tools/testing/selftests/landlock/audit.h               |    6 ++----
 tools/testing/selftests/landlock/common.h              |    4 ----
 tools/testing/selftests/mm/pkey-helpers.h              |    3 ---
 tools/testing/selftests/net/psock_lib.h                |    4 ----
 tools/testing/selftests/perf_events/watermark_signal.c |    2 --
 tools/testing/selftests/proc/proc-pid-vm.c             |    4 ----
 tools/testing/selftests/ublk/utils.h                   |    2 --
 8 files changed, 6 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/kselftest.h~selftests-centralise-maybe-unused-definition-in-kselftesth
+++ a/tools/testing/selftests/kselftest.h
@@ -96,6 +96,10 @@
 #define __unused         __attribute__((__unused__))
 #endif
 
+#ifndef __maybe_unused
+#define __maybe_unused __attribute__((__unused__))
+#endif
+
 /* counters */
 struct ksft_count {
 	unsigned int ksft_pass;
--- a/tools/testing/selftests/landlock/audit.h~selftests-centralise-maybe-unused-definition-in-kselftesth
+++ a/tools/testing/selftests/landlock/audit.h
@@ -20,14 +20,12 @@
 #include <sys/time.h>
 #include <unistd.h>
 
+#include "../kselftest.h"
+
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 #endif
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 #define REGEX_LANDLOCK_PREFIX "^audit([0-9.:]\\+): domain=\\([0-9a-f]\\+\\)"
 
 struct audit_filter {
--- a/tools/testing/selftests/landlock/common.h~selftests-centralise-maybe-unused-definition-in-kselftesth
+++ a/tools/testing/selftests/landlock/common.h
@@ -22,10 +22,6 @@
 
 #define TMP_DIR "tmp"
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 /* TEST_F_FORK() should not be used for new tests. */
 #define TEST_F_FORK(fixture_name, test_name) TEST_F(fixture_name, test_name)
 
--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-centralise-maybe-unused-definition-in-kselftesth
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -84,9 +84,6 @@ extern void abort_hooks(void);
 #ifndef noinline
 # define noinline __attribute__((noinline))
 #endif
-#ifndef __maybe_unused
-# define __maybe_unused __attribute__((__unused__))
-#endif
 
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 int sys_pkey_free(unsigned long pkey);
--- a/tools/testing/selftests/net/psock_lib.h~selftests-centralise-maybe-unused-definition-in-kselftesth
+++ a/tools/testing/selftests/net/psock_lib.h
@@ -22,10 +22,6 @@
 
 #define PORT_BASE			8000
 
-#ifndef __maybe_unused
-# define __maybe_unused		__attribute__ ((__unused__))
-#endif
-
 static __maybe_unused void pair_udp_setfilter(int fd)
 {
 	/* the filter below checks for all of the following conditions that
--- a/tools/testing/selftests/perf_events/watermark_signal.c~selftests-centralise-maybe-unused-definition-in-kselftesth
+++ a/tools/testing/selftests/perf_events/watermark_signal.c
@@ -17,8 +17,6 @@
 
 #include "../kselftest_harness.h"
 
-#define __maybe_unused __attribute__((__unused__))
-
 static int sigio_count;
 
 static void handle_sigio(int signum __maybe_unused,
--- a/tools/testing/selftests/proc/proc-pid-vm.c~selftests-centralise-maybe-unused-definition-in-kselftesth
+++ a/tools/testing/selftests/proc/proc-pid-vm.c
@@ -47,10 +47,6 @@
 #include <sys/resource.h>
 #include <linux/fs.h>
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 #include "../kselftest.h"
 
 static inline long sys_execveat(int dirfd, const char *pathname, char **argv, char **envp, int flags)
--- a/tools/testing/selftests/ublk/utils.h~selftests-centralise-maybe-unused-definition-in-kselftesth
+++ a/tools/testing/selftests/ublk/utils.h
@@ -2,8 +2,6 @@
 #ifndef KUBLK_UTILS_H
 #define KUBLK_UTILS_H
 
-#define __maybe_unused __attribute__((unused))
-
 #ifndef min
 #define min(a, b) ((a) < (b) ? (a) : (b))
 #endif
_

Patches currently in -mm which might be from reddybalavignesh9979@gmail.com are

selftests-proc-mark-vsyscall-strings-maybe-unused.patch
selftests-centralise-maybe-unused-definition-in-kselftesth.patch

