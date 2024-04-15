Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A43D156F5A
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713209729; cv=none; b=EllF2KHmm9qq7l2cMP0Aa78W+FXOFTQZd49nm5I5zLSiWr6DjcyYVPChjurxJmHeMiSX+ZAnxlR8UmNPLm3Z466FX5YYED7OSWYGIbjbsS0Emyy0Z+dp120CvkEy8hHk2fYPy8n+MblmxGqOxgQWBu41yMy84oVb9NJ3czTYvZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713209729; c=relaxed/simple;
	bh=NZekJPJ8wQEK99clC9nfg6Ekk3NPf9XqQSAndNNuqqY=;
	h=Date:To:From:Subject:Message-Id; b=DmdAOGkhrLxr4BftTK9E7O9ADWv/o5AiOm2pUt73d5p4NfKEZdbz6rjb2GHhofHVjEdyIKWAROsGwbQA5J8Dr6OKovhnq/6CjTR0e4mQJM+mpuK8BGFSZ6rLAtA0CCcereMQrjFgMmpcjTwvfuorI/zepZm4zM8Al8NsvBL07AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RnkG11od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RnkG11od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BC7C2BD11;
	Mon, 15 Apr 2024 19:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713209729;
	bh=NZekJPJ8wQEK99clC9nfg6Ekk3NPf9XqQSAndNNuqqY=;
	h=Date:To:From:Subject:From;
	b=RnkG11ode9rEqkkN7xYSv4yShEl2EczkbyEH3M4/bh/GINKpyz6MoU/tPiLHVIB0g
	 6SblRwXr3429oHbR6by1sktdyCWc9+dP22bsWyP6F3G8NRZk0PefRtCEPYVeUS2adw
	 LRlwSKbhO7N5aN6f3Gh0Gd6WxD9lgRDqjpF9nyYY=
Date: Mon, 15 Apr 2024 12:35:28 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-enable-wformat-truncation-on-clang.patch added to mm-nonmm-unstable branch
Message-Id: <20240415193528.E8BC7C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: enable -Wformat-truncation on clang
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-enable-wformat-truncation-on-clang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-enable-wformat-truncation-on-clang.patch

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
Subject: kbuild: enable -Wformat-truncation on clang
Date: Mon, 15 Apr 2024 14:20:35 +0200

This warning option still produces output on gcc but is now clean when
building with clang, so enable it conditionally on the compiler for now.

As far as I can tell, the remaining warnings with gcc are the result of
analysing the code more deeply across inlining, while clang only does this
within a function.

Link: https://lore.kernel.org/lkml/20240326230511.GA2796782@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/linux-patches/20231002-disable-wformat-truncation-overflow-non-kprintf-v1-1-35179205c8d9@kernel.org/
Link: https://lkml.kernel.org/r/20240415122037.1983124-5-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/Makefile.extrawarn~kbuild-enable-wformat-truncation-on-clang
+++ a/scripts/Makefile.extrawarn
@@ -100,7 +100,14 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
 KBUILD_CFLAGS += $(call cc-disable-warning, packed-not-aligned)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow)
+ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation)
+else
+# Clang checks for overflow/truncation with '%p', while GCC does not:
+# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111219
+KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow-non-kprintf)
+KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation-non-kprintf)
+endif
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
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

