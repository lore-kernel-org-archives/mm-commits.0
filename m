Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795401417;
	b=4sr3iwXsnhLS1mgZE/NybB6FuX47wrHAiiLiRKLbcNmnd0DAlbRR09l5jFZP+HNj+vhf
	 InX8x+VcXej6jJYfaMH5Kdox7TccXr7TLx+cfuGd8+iXT3lYRHsS49z1TyyBdxLnEQmkW
	 yBoh7lhQN5QZS1tmwKZI33kmB2y35DRrqXjIC2nWx8RV9+dB591HgGGesWk+KZpUa+2V7
	 c+QdhAj97JSZsSiTSpHS8XwdzJuOjDeqd7Lp1Mf5Q13N4rWeyfrwkW0ZLf/7RMD6hqrDP
	 QTKCZRMmmlZaveh+aD0gx/ZE0zZTgCxuV0T/XEacNclcvgmFjpDNQW29cFmC583i3rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795401417;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Azy4kkAU8CmYcQtQcLDXCu8p3eLi5Mic+kvICQ7KALI=;
	b=j3XPbvWLH1puiUYfNlr+VmrZ7z84nQVOGaZKIIVg7yKrjKFGCIM7QhvRv5KaQfgiglKF
	 2sjEsGlOdq3tVTvpuh4ZPaX2wpHQIAnq154a5REoQNFcgVu1gfF9ZrSuIXKsVmabzTFkp
	 oaqUWjzu3C5ORNeUKRpnlo7MGEBFpABJzJonWkfcJJ3AY+1LpTJ1WLrUcYM6aynWQ5+8b
	 YW5W/KQUK925sunbeA+20w75pPw0rO2v5QcOc8Y3QW3uvTuSXhQ1YX/EyRLxesHf3y4KO
	 zU5rQnumoeUhZBd+MTj0wkRB3fdNUSbe4vl1bVZ4i77QEAWxPwj8V29AkHuqH9Dig+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aoTVVTrM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1DB606A337;
	Mon, 23 Nov 2026 02:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aoTVVTrM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497D91F000D4;
	Mon, 23 Nov 2026 02:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795401416;
	bh=Azy4kkAU8CmYcQtQcLDXCu8p3eLi5Mic+kvICQ7KALI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=aoTVVTrMYA9NMgvX4U1kKDDr0bcv/Q0/VeMTE+8vUz7EAkaUJnBYUUCZZXmWlYLyd
	 pxzqDzSA18OR8UHrCS6p8Tq9r2dxnGBOcY+n/w2AGs533GTKTHvN8YepvCaXRAX7UJ
	 q/QUnlV47zFyMxc4Geke5y5eoSQ3I+keL4VZBz+o=
Date: Sun, 22 Nov 2026 18:36:55 -0800
To: mm-commits@vger.kernel.org,wakel@google.com,w@1wt.eu,
	stable@vger.kernel.org,shuah@kernel.org,linux@weissschuh.net,
	sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261105125701.1605281-4-sashal@kernel.org>
References: <20261105125701.1605281-4-sashal@kernel.org>
Subject: + selftests-size-use-nolibc-startup-and-syscall-wrappers.patch added to mm-nonmm-unstable branch
Message-Id: <20261123023656.497D91F000D4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/size: use nolibc startup and syscall wrappers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-size-use-nolibc-startup-and-syscall-wrappers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-size-use-nolibc-startup-and-syscall-wrappers.patch

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
Subject: selftests/size: use nolibc startup and syscall wrappers
Date: Thu, 05 Nov 2026 07:57:01 -0500

get_size provides its own _start and is linked statically against the C
library with -nostartfiles.  That combination assumes startup and TLS
details that vary between architectures and C library versions: errno
lives in thread-local storage that is never set up, and the static link
expects symbols from the skipped startup files.  CI builds have failed
with undefined _init/_fini on ARM with clang and an undefined _DYNAMIC on
LoongArch.

Build the test with the in-tree nolibc instead.  nolibc provides the
startup code, so the test returns from main(), and it provides the write()
and syscall() wrappers without the TLS errno problem.  A failing sysinfo()
is now reported as a TAP failure instead of crashing the test.  Keep the
static link and the existing TAP output.

Since the test no longer uses the system C library headers, the kernel
UAPI headers have to be installed before it is built.  Add the headers
target as an order-only prerequisite, as nolibc-test does, so that a
standalone build installs them.  Link libgcc only when the selected
compiler is GCC, which needs it for division helpers on ARM, and detect
that from the compiler rather than from LLVM so that CC=clang builds do
not try to link a libgcc that clang does not provide.

nolibc does not support arc, csky, microblaze, nios2 or xtensa, so the
test can no longer be built for those architectures.  This conversion also
makes the separate i386 vDSO workaround proposed for get_size unnecessary.

Link: https://patch.msgid.link/20261105125701.1605281-4-sashal@kernel.org
Link: https://lore.kernel.org/r/20260929043637.1917707-1-wakel@google.com
Fixes: 3ce51050fadd ("selftest: size: Add size test for Linux kernel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Wake Liu <wakel@google.com>
Cc: <stable@vger.kernel.org> # 6.18.x

 tools/testing/selftests/size/Makefile   |    9 +++++-
 tools/testing/selftests/size/get_size.c |   33 ++++++----------------
 2 files changed, 17 insertions(+), 25 deletions(-)

--- a/tools/testing/selftests/size/get_size.c~selftests-size-use-nolibc-startup-and-syscall-wrappers
+++ a/tools/testing/selftests/size/get_size.c
@@ -11,26 +11,12 @@
  * own execution.  It also attempts to have as few dependencies
  * on kernel features as possible.
  *
- * It should be statically linked, with startup libs avoided.  It uses
- * no library calls except the syscall() function for the following 3
- * syscalls:
- *   sysinfo(), write(), and _exit()
- *
- * For output, it avoids printf (which in some C libraries
- * has large external dependencies) by  implementing it's own
- * number output and print routines, and using __builtin_strlen()
- *
- * The test may crash if any of the above syscalls fails because in some
- * libc implementations (e.g. the GNU C Library) errno is saved in
- * thread-local storage, which does not get initialized due to avoiding
- * startup libs.
+ * It is statically linked with nolibc startup and syscall wrappers.
+ * For output, it avoids printf by implementing its own print routines.
  */
 
-#include <sys/sysinfo.h>
-#include <unistd.h>
-#include <sys/syscall.h>
-
-#define STDOUT_FILENO 1
+#include <nolibc.h>
+#include <linux/sysinfo.h>
 
 static int print(const char *s)
 {
@@ -39,7 +25,7 @@ static int print(const char *s)
 	while (s[len] != '\0')
 		len++;
 
-	return syscall(SYS_write, STDOUT_FILENO, s, len);
+	return write(STDOUT_FILENO, s, len);
 }
 
 static inline char *num_to_str(unsigned long num, char *buf, int len)
@@ -80,8 +66,7 @@ static int print_k_value(const char *s,
 	return ccode;
 }
 
-/* this program has no main(), as startup libraries are not used */
-void _start(void)
+int main(void)
 {
 	int ccode;
 	struct sysinfo info;
@@ -91,12 +76,12 @@ void _start(void)
 	print("TAP version 13\n");
 	print("# Testing system size.\n");
 
-	ccode = syscall(SYS_sysinfo, &info);
+	ccode = syscall(__NR_sysinfo, &info);
 	if (ccode < 0) {
 		print("not ok 1");
 		print(test_name);
 		print(" ---\n reason: \"could not get sysinfo\"\n ...\n");
-		syscall(SYS_exit, ccode);
+		return 1;
 	}
 	print("ok 1");
 	print(test_name);
@@ -112,5 +97,5 @@ void _start(void)
 	print(" ...\n");
 	print("1..1\n");
 
-	syscall(SYS_exit, 0);
+	return 0;
 }
--- a/tools/testing/selftests/size/Makefile~selftests-size-use-nolibc-startup-and-syscall-wrappers
+++ a/tools/testing/selftests/size/Makefile
@@ -1,6 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS := -static -ffreestanding -nostartfiles -s
+CFLAGS = -Os -static -nostdlib -nostdinc -ffreestanding -fno-stack-protector -s
+CFLAGS += -isystem $(top_srcdir)/tools/include/nolibc $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := get_size
 
 include ../lib.mk
+
+CC_IS_GCC := $(shell printf '\043if defined(__GNUC__) && !defined(__clang__)\nGCC\n\043endif\n' | \
+	$(CC) $(CFLAGS) -E -P -x c - 2>/dev/null)
+LDLIBS += $(if $(filter GCC,$(CC_IS_GCC)),-lgcc)
+
+$(OUTPUT)/get_size: | headers
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch
kselftest-alloc_tag-use-the-ll64-types-on-powerpc64.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch
selftests-prctl-select-the-tests-by-arch-alone.patch
selftests-prctl-skip-the-anonymous-vma-naming-test-when-unsupported.patch
selftests-kexec-select-tests-using-the-target-compiler.patch
selftests-size-use-nolibc-startup-and-syscall-wrappers.patch

