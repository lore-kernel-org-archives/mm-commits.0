Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43955143739
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291646; cv=none; b=Pjr5/m1k+IUFf/y/RobYeAh7NrHv2DcMSoEhhTGWDUMIEaWWYQ6Jvy664F8NXswFXoZyKsLk9nCZ07cbH8W8MnUE+EN/zuRysCKJIXZ2dTPtx8HPPiYuZAk3q0gbZWoURqeQApsxLpJFdmIvSG32MT16OH1rskNsaHEjMPrJ9TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291646; c=relaxed/simple;
	bh=uTCEuItvYTidKBfq32R3BhMH+RhjzQsSQcs4GEMiJRc=;
	h=Date:To:From:Subject:Message-Id; b=I0pwwRrC1xfcI8GOH745PRFHg5Pfdpc93pPdJBryOEOHUKqPevfJWY7izDJjcmkK7/qTNKNUZ8zKeKeYk4H8d5+nud4dWO1YjoOQaWbnL6Vns+DhoW6tTc30fxlh7o0kTjPxEtgOaE2FEikOrQr7hCcx/gxmzjtYd7i8EZyefAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wGK32iv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wGK32iv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E5BC32782;
	Tue, 25 Jun 2024 05:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291646;
	bh=uTCEuItvYTidKBfq32R3BhMH+RhjzQsSQcs4GEMiJRc=;
	h=Date:To:From:Subject:From;
	b=wGK32iv5yHw//jwgOAMBa7SrYm0aUIcAvqWswmu+226IXCI9xQ7atfxdTLpNhjcjN
	 Syz44hiXPGvLzvYIuYu/+hEwf3c5nx0bDTuzi9wju5vYFBsRwvym/myE/jlsBLkPT2
	 i06WK5OoiCF/N+teWaMbH71Jqofkc6VuXi1Yw56Y=
Date: Mon, 24 Jun 2024 22:00:45 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,keescook@chromium.org,elver@google.com,andreyknvl@gmail.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ubsan-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625050046.17E5BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ubsan: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     ubsan-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: ubsan: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 19:06:48 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_ubsan.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_ubsan-v1-1-c2a80d258842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_ubsan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_ubsan.c~ubsan-add-missing-module_description-macro
+++ a/lib/test_ubsan.c
@@ -156,4 +156,5 @@ static void __exit test_ubsan_exit(void)
 module_exit(test_ubsan_exit);
 
 MODULE_AUTHOR("Jinbum Park <jinb.park7@gmail.com>");
+MODULE_DESCRIPTION("UBSAN unit test");
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

backtracetest-add-module_description.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-for-lib-test_ko.patch
kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

