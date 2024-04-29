Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C35A84E1B
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408690; cv=none; b=aiXhRXN5GQCbFP6D+SiY4pnw71HcEkZ3YYmgWw6a1jMnNU9hVLruwJDMRjWAFYooNB3aWSlnNBkqdhObnlIFgM4kRRUmfuX54dKiXoszvZ6psh79S8EkgPv/6ECgZe+bwdUKzDFGSts7WLKU9aivL08J01P9Vqydncz2Pib5YDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408690; c=relaxed/simple;
	bh=SbdBYUEP1IE0LYPglBarqoZA9ixIIhIA7SSHfrhofr8=;
	h=Date:To:From:Subject:Message-Id; b=SABtt9uBa1PGYtWzgRs+3V9W9WK0INiXxE+GXFwN2eEtPtU0eFNsOan6wipm5pbWEolWJ9+P0l1nk6ntn6aVhm3UnhR2RUqedEfFCNBvVFcRI+70phdQF0Z6oQXpIqwU3souTq9zyec1X1qqVe4vC0JKLjXWEKho71chxdIBjAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SnTZF+xS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SnTZF+xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF47BC113CD;
	Mon, 29 Apr 2024 16:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714408690;
	bh=SbdBYUEP1IE0LYPglBarqoZA9ixIIhIA7SSHfrhofr8=;
	h=Date:To:From:Subject:From;
	b=SnTZF+xS9V4ir1bst5DmVu/8IOcBSTGsApTLTKUnBsNomzyLgUTAY6iR37B1hK84S
	 4UOllrXkCcpm0yt+D03+PtZU1DP6UOnnvfUW20DXmDStJlA1QMmC7XxGeqsEsxBV7d
	 yWk7bQmmT1qBjgw4EESKQIGVVQ86+Fe2haBzSi/0=
Date: Mon, 29 Apr 2024 09:38:08 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,usama.anjum@collabora.com,tglx@linutronix.de,skhan@linuxfoundation.org,luto@kernel.org,keescook@chromium.org,broonie@kernel.org,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vdso-fix-building-errors-on-loongarch.patch added to mm-hotfixes-unstable branch
Message-Id: <20240429163809.DF47BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/vDSO: fix building errors on LoongArch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-vdso-fix-building-errors-on-loongarch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vdso-fix-building-errors-on-loongarch.patch

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
Subject: selftests/vDSO: fix building errors on LoongArch
Date: Sun, 28 Apr 2024 11:05:29 +0800

Patch series "selftests/vDSO: Fix errors on LoongArch", v4.


This patch (of 2):

There exist the following errors when build vDSO selftests on LoongArch:

  # make headers && cd tools/testing/selftests/vDSO && make
  ...
  error: 'VDSO_VERSION' undeclared (first use in this function)
  ...
  error: 'VDSO_NAMES' undeclared (first use in this function)

We can see the following code in arch/loongarch/vdso/vdso.lds.S:

VERSION
{
        LINUX_5.10 {
        global:
                __vdso_getcpu;
                __vdso_clock_getres;
                __vdso_clock_gettime;
                __vdso_gettimeofday;
                __vdso_rt_sigreturn;
        local: *;
        };
}

so VDSO_VERSION should be 6 and VDSO_NAMES should be 1 for LoongArch,
add them to fix the building errors on LoongArch.

Link: https://lkml.kernel.org/r/20240428030530.24399-1-yangtiezhu@loongson.cn
Link: https://lkml.kernel.org/r/20240428030530.24399-2-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vDSO/vdso_config.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vDSO/vdso_config.h~selftests-vdso-fix-building-errors-on-loongarch
+++ a/tools/testing/selftests/vDSO/vdso_config.h
@@ -53,15 +53,19 @@
 #if __riscv_xlen == 32
 #define VDSO_32BIT		1
 #endif
+#elif defined(__loongarch__)
+#define VDSO_VERSION		6
+#define VDSO_NAMES		1
 #endif
 
-static const char *versions[6] = {
+static const char *versions[7] = {
 	"LINUX_2.6",
 	"LINUX_2.6.15",
 	"LINUX_2.6.29",
 	"LINUX_2.6.39",
 	"LINUX_4",
 	"LINUX_4.15",
+	"LINUX_5.10"
 };
 
 static const char *names[2][6] = {
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

selftests-vdso-fix-building-errors-on-loongarch.patch
selftests-vdso-fix-runtime-errors-on-loongarch.patch

