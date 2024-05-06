Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE51320B
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955335; cv=none; b=lNacdCmbeax1ZXX6fubebgjH5lWheqQRiM/ZrLoiMqD6LjtGl8ljEg2L9R4H9HuL0dvKoByotuEcRT/b+GJQb5AA23MLyqpJXW0TsJqESVbXvTX1r0kt7416OC+A6Te2mnqZuPPqjwqp9fzsxeM4B8eEg5I0Dupmj4oCmEe5Eeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955335; c=relaxed/simple;
	bh=D/ftbAv3ce3TyoZkx32jEmrDpLMZPYiFMy/AgCP0hZI=;
	h=Date:To:From:Subject:Message-Id; b=NR6Fu5g5xKGDEy7BeIKIulUvyvDRLbI0pBHMBCtSpnuyw+qlSzf8ZkpwKNDvjcPsjbdW83xJIWKtPXOXHZrWhroqIXafS6IpdPXn5xt1cNAv1136cH2ztwQnyqnaRXY3GaJB80foXkC2u4687w+5pAGjPt9ZDduNAi4KmD33OIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Khkkeb6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Khkkeb6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205CAC113CC;
	Mon,  6 May 2024 00:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955335;
	bh=D/ftbAv3ce3TyoZkx32jEmrDpLMZPYiFMy/AgCP0hZI=;
	h=Date:To:From:Subject:From;
	b=Khkkeb6EGyfgg7ZOQilHgpYesnpwDN2hQL4BnHI/sTyL8Scvj1/vOXrvGUmkHiDzA
	 jkcd6Pe6gNYPKZ45LcZTw49Vjlei3QvpKZkLwy76DDSUwwHecZC2HF3tUSIyR8UcRt
	 APchKZYsfkNhYYkaTcsH8PsPkqGDFQhR692EWNZ0=
Date: Sun, 05 May 2024 17:28:54 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,usama.anjum@collabora.com,tglx@linutronix.de,skhan@linuxfoundation.org,luto@kernel.org,keescook@chromium.org,broonie@kernel.org,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-vdso-fix-building-errors-on-loongarch.patch removed from -mm tree
Message-Id: <20240506002855.205CAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/vDSO: fix building errors on LoongArch
has been removed from the -mm tree.  Its filename was
     selftests-vdso-fix-building-errors-on-loongarch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


