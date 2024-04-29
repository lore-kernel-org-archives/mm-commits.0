Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C56C651B6
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408693; cv=none; b=c2Pk27mmvCPqv71F2xgpoXpxzjqm1sgIpL4mgUy+mn7n9K59D5oqLQ98nQ8pLxkuy9jnVd6944huL7325Av8fF+G9VVxm+JVpfJKI0Iy/CPEkBido5ztu3UDa/80dBtt7EFuLMeN9k+WqrD2ZcdTm+Gxb7P4ZEL2cIpQUHsZ15E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408693; c=relaxed/simple;
	bh=I8o1Rj2QjJSw40EdufGCSCHH5Zk5ErfIzfollXy+/fg=;
	h=Date:To:From:Subject:Message-Id; b=KuiFPcJ7Uq1VEfSs0RSZymGIH5eHOhz7rRyEJxsEYEZzT6lC8LOjfMsJ/BpmeXrEAMk7ajv6PEYUExHWSqdmlwCvjMaqhds3I20ThgXad0JhTgPthnEyDR4ZaG9PyWyKcmUBNeweeLkrHBTGRaEQ0cC1Pe+7exWkfvFUbfUoSuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gjECV9ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gjECV9ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CD0C113CD;
	Mon, 29 Apr 2024 16:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714408692;
	bh=I8o1Rj2QjJSw40EdufGCSCHH5Zk5ErfIzfollXy+/fg=;
	h=Date:To:From:Subject:From;
	b=gjECV9ekOt3ANChgr+6lDlzzu83ecvPHE7/Uyd3AK69ykdXVU8dHVFj+7HZr+E3ML
	 QOzHB1JsdWuBIkxDT/3k7W0qKIHszvYtzMgZ8yXpQDvAUGcMBJ+NuD2mYY+m9jVfxR
	 VsRRdy/MNyES0KyO0yapaGLhDdIANIndZThcK8c0=
Date: Mon, 29 Apr 2024 09:38:11 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,usama.anjum@collabora.com,tglx@linutronix.de,skhan@linuxfoundation.org,luto@kernel.org,keescook@chromium.org,broonie@kernel.org,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vdso-fix-runtime-errors-on-loongarch.patch added to mm-hotfixes-unstable branch
Message-Id: <20240429163812.A8CD0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/vDSO: fix runtime errors on LoongArch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-vdso-fix-runtime-errors-on-loongarch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vdso-fix-runtime-errors-on-loongarch.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: selftests/vDSO: fix runtime errors on LoongArch
Date: Sun, 28 Apr 2024 11:05:30 +0800

It could not find __vdso_getcpu and __vdso_gettimeofday when test getcpu
and gettimeofday on LoongArch.

  # make headers && cd tools/testing/selftests/vDSO && make
  # ./vdso_test_getcpu
  Could not find __vdso_getcpu
  # ./vdso_test_gettimeofday
  Could not find __vdso_gettimeofday

One simple way is to add LoongArch case to define version and name, just
like commit d942f231afc0 ("selftests/vDSO: Add riscv getcpu & gettimeofday
test"), but it is not the best way.

Since each architecture has already defined names and versions in
vdso_config.h, it is proper to include vdso_config.h to get version and
name for all archs.

Link: https://lkml.kernel.org/r/20240428030530.24399-3-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vDSO/vdso_test_getcpu.c       |   16 ++----
 tools/testing/selftests/vDSO/vdso_test_gettimeofday.c |   26 ++--------
 2 files changed, 13 insertions(+), 29 deletions(-)

--- a/tools/testing/selftests/vDSO/vdso_test_getcpu.c~selftests-vdso-fix-runtime-errors-on-loongarch
+++ a/tools/testing/selftests/vDSO/vdso_test_getcpu.c
@@ -13,13 +13,7 @@
 
 #include "../kselftest.h"
 #include "parse_vdso.h"
-
-#if defined(__riscv)
-const char *version = "LINUX_4.15";
-#else
-const char *version = "LINUX_2.6";
-#endif
-const char *name = "__vdso_getcpu";
+#include "vdso_config.h"
 
 struct getcpu_cache;
 typedef long (*getcpu_t)(unsigned int *, unsigned int *,
@@ -27,6 +21,8 @@ typedef long (*getcpu_t)(unsigned int *,
 
 int main(int argc, char **argv)
 {
+	const char *version = versions[VDSO_VERSION];
+	const char **name = (const char **)&names[VDSO_NAMES];
 	unsigned long sysinfo_ehdr;
 	unsigned int cpu, node;
 	getcpu_t get_cpu;
@@ -40,9 +36,9 @@ int main(int argc, char **argv)
 
 	vdso_init_from_sysinfo_ehdr(getauxval(AT_SYSINFO_EHDR));
 
-	get_cpu = (getcpu_t)vdso_sym(version, name);
+	get_cpu = (getcpu_t)vdso_sym(version, name[4]);
 	if (!get_cpu) {
-		printf("Could not find %s\n", name);
+		printf("Could not find %s\n", name[4]);
 		return KSFT_SKIP;
 	}
 
@@ -50,7 +46,7 @@ int main(int argc, char **argv)
 	if (ret == 0) {
 		printf("Running on CPU %u node %u\n", cpu, node);
 	} else {
-		printf("%s failed\n", name);
+		printf("%s failed\n", name[4]);
 		return KSFT_FAIL;
 	}
 
--- a/tools/testing/selftests/vDSO/vdso_test_gettimeofday.c~selftests-vdso-fix-runtime-errors-on-loongarch
+++ a/tools/testing/selftests/vDSO/vdso_test_gettimeofday.c
@@ -18,25 +18,13 @@
 
 #include "../kselftest.h"
 #include "parse_vdso.h"
-
-/*
- * ARM64's vDSO exports its gettimeofday() implementation with a different
- * name and version from other architectures, so we need to handle it as
- * a special case.
- */
-#if defined(__aarch64__)
-const char *version = "LINUX_2.6.39";
-const char *name = "__kernel_gettimeofday";
-#elif defined(__riscv)
-const char *version = "LINUX_4.15";
-const char *name = "__vdso_gettimeofday";
-#else
-const char *version = "LINUX_2.6";
-const char *name = "__vdso_gettimeofday";
-#endif
+#include "vdso_config.h"
 
 int main(int argc, char **argv)
 {
+	const char *version = versions[VDSO_VERSION];
+	const char **name = (const char **)&names[VDSO_NAMES];
+
 	unsigned long sysinfo_ehdr = getauxval(AT_SYSINFO_EHDR);
 	if (!sysinfo_ehdr) {
 		printf("AT_SYSINFO_EHDR is not present!\n");
@@ -47,10 +35,10 @@ int main(int argc, char **argv)
 
 	/* Find gettimeofday. */
 	typedef long (*gtod_t)(struct timeval *tv, struct timezone *tz);
-	gtod_t gtod = (gtod_t)vdso_sym(version, name);
+	gtod_t gtod = (gtod_t)vdso_sym(version, name[0]);
 
 	if (!gtod) {
-		printf("Could not find %s\n", name);
+		printf("Could not find %s\n", name[0]);
 		return KSFT_SKIP;
 	}
 
@@ -61,7 +49,7 @@ int main(int argc, char **argv)
 		printf("The time is %lld.%06lld\n",
 		       (long long)tv.tv_sec, (long long)tv.tv_usec);
 	} else {
-		printf("%s failed\n", name);
+		printf("%s failed\n", name[0]);
 		return KSFT_FAIL;
 	}
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

selftests-vdso-fix-building-errors-on-loongarch.patch
selftests-vdso-fix-runtime-errors-on-loongarch.patch

