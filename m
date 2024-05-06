Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638A2320B
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955336; cv=none; b=uLlG18L2/hah63Yn2zk77113Z2IW+eT6KTC/MXAw1i3Z6MsbGnUWYa5civteU9I47Pz463bmFXgwRulQawah9RPHQNAZcFmVlMms5NYrjR6T8APyVPZ6jvRzq7mwWl2O9erh8SEIPzKTCUGWKrBdJC6zm8o/eY4nElYnw+KdjZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955336; c=relaxed/simple;
	bh=nDOh66KxFKow8bzWSRZdjB+tgoDBxnH1gFjmQ92Od5M=;
	h=Date:To:From:Subject:Message-Id; b=oCekEgcpX1P9Sqkb079PizlE2ZTxLoS66rkn5DZGuIGIDDg57PfRq4p+kVn2IPGROP9doVBb3PN58AX6jbBhbKpVIHOdNVq6WW3iaYyN2eHWjFhECl8E2bkNojAbRAGYWCWmRKuzCctsU9aYlLzXbddG2jMXc6yTvyC2COuy5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z02Iejub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z02Iejub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B273C113CC;
	Mon,  6 May 2024 00:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955336;
	bh=nDOh66KxFKow8bzWSRZdjB+tgoDBxnH1gFjmQ92Od5M=;
	h=Date:To:From:Subject:From;
	b=Z02Iejub4nD/tNSeV5l1f50pn5S5lPyp4/ZLjZKkA/0i1QicJvuFt/9sx3NhahKnY
	 VAaqVhDVZh4DeQlRRYPjHSpDsPmiXhHhCeJdFaeO4HCi2/HYE3/e3bK2Dk/WFP2V5/
	 YNYSokIC5cUeT+0ojkkiWW2qV2CxNvjWYPtmOejs=
Date: Sun, 05 May 2024 17:28:55 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,usama.anjum@collabora.com,tglx@linutronix.de,skhan@linuxfoundation.org,luto@kernel.org,keescook@chromium.org,broonie@kernel.org,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-vdso-fix-runtime-errors-on-loongarch.patch removed from -mm tree
Message-Id: <20240506002856.3B273C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/vDSO: fix runtime errors on LoongArch
has been removed from the -mm tree.  Its filename was
     selftests-vdso-fix-runtime-errors-on-loongarch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


