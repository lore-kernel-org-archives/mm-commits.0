Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115E515686C
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713209733; cv=none; b=IKAEQF9a18DLBUEGdsqwENP4tXmjKURnGoKXPug/UKe3pkAOGfOLuTeNs2XttsYhEABuRZGIJTy1OZ03V0QFxkFrnVygcOXiuux93b+5b3fTWbH+u0/QyprodIClXt+KzDV0Viu1i+CPLyydIp48VdqqYFfsGwywBtptS0w9YU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713209733; c=relaxed/simple;
	bh=yF3TothgiL2VcSlWTqUKkXCmCOIkG/dzh4+WCMjpMpQ=;
	h=Date:To:From:Subject:Message-Id; b=BbfCraZosOMXrKFAulucwbaN+FNPwotImy5gVLIyYXOZwxWSUfRe8T2aLv+XvZFJaACj/md2/o0Z6aHgJjXTrD9YvN9v+IfKy6QGd15QVF5at7yUXsYiuyI8+fXmm2OKOJsKDj0z1xYW1lduEDyZeR8AOR/9DoTUtSbkroexH1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hZty+/fD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hZty+/fD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61174C113CC;
	Mon, 15 Apr 2024 19:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713209732;
	bh=yF3TothgiL2VcSlWTqUKkXCmCOIkG/dzh4+WCMjpMpQ=;
	h=Date:To:From:Subject:From;
	b=hZty+/fD1J3GEfGsvC0xCaxhr9JEJrtRhj2llaEdws4zeV5pt5ZwGPsY32MvjycU5
	 RiooUZ8+6gbw9Fg2v4MKSl3Sj0oH39yUItSCiR35dQ6UqEhxFQXeAPjyOPG3leX9YJ
	 /nABnjY56NGYP9VGYesESin+JOTcRA755X9+tf/M=
Date: Mon, 15 Apr 2024 12:35:31 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-enable-wstringop-truncation-globally.patch added to mm-nonmm-unstable branch
Message-Id: <20240415193532.61174C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: enable -Wstringop-truncation globally
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-enable-wstringop-truncation-globally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-enable-wstringop-truncation-globally.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kbuild: enable -Wstringop-truncation globally
Date: Mon, 15 Apr 2024 14:20:37 +0200

The remaining warnings of this type have been addressed, so it can now be
enabled by default, rather than only for W=1.

Link: https://lkml.kernel.org/r/20240415122037.1983124-7-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/Makefile.extrawarn~kbuild-enable-wstringop-truncation-globally
+++ a/scripts/Makefile.extrawarn
@@ -108,7 +108,6 @@ else
 KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow-non-kprintf)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation-non-kprintf)
 endif
-KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
 KBUILD_CFLAGS += -Wno-override-init # alias for -Wno-initializer-overrides in clang
 
_

Patches currently in -mm which might be from arnd@arndb.de are

fix-missing-vmalloch-includes-fix-5.patch
kcov-avoid-clang-out-of-range-warning.patch
test_hexdump-avoid-string-truncation-warning.patch
block-partitions-ldm-convert-strncpy-to-strscpy.patch
blktrace-convert-strncpy-to-strscpy_pad.patch
kbuild-turn-on-wextra-by-default.patch
kbuild-remove-redundant-extra-warning-flags.patch
kbuild-turn-on-wrestrict-by-default.patch
kbuild-enable-wformat-truncation-on-clang.patch
kbuild-enable-wcast-function-type-strict-unconditionally.patch
kbuild-enable-wstringop-truncation-globally.patch

