Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2016115686D
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713209724; cv=none; b=N5rIqIHti7mprTn0xxg0I56wDkhIvzzV3buydXKwesh6emojnV7dGhj3DbVNCjPuta8mGvPUHJTvwsH4S2mepCzVDzO/jR36BxNXrw+ImL3EPFTjusapeNX9pWw0veYvhCWEZdawcruZOlU6WV/Nl6CEbNBGHqtPJ7WYzCZPFTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713209724; c=relaxed/simple;
	bh=9RMqD4Q7NqmZdfYcSlfBx0S9llRKaOOQfADpeA9Hdoo=;
	h=Date:To:From:Subject:Message-Id; b=UOpRX5lnf13ky7QqBmj4UVNYv0v3qVHVe2b2WuDTn1ZnJVMJ9qiT8hcFKP+JGmNPHaseMTizrXjM4TfN+S28QNFvpvJhKoiPT8oXxJsgiuWjfd+N+C8qOCPCXoYlJ9auGjHwY2fDVTK2lDZf8gOwk6rjmIbbSgctP6NnEwgfJzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vX3d4I4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vX3d4I4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B326C2BD11;
	Mon, 15 Apr 2024 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713209723;
	bh=9RMqD4Q7NqmZdfYcSlfBx0S9llRKaOOQfADpeA9Hdoo=;
	h=Date:To:From:Subject:From;
	b=vX3d4I4ZAKLWUm2fn0cQetrmJREsAllHi7svAFpCd3wkxZeej3K6i0doz1hTkOT0+
	 w9g27IdetETj+YJFHDM6yDBf8LnU5lG409gmCkwQhAGsQnGuWQImaYK7tHWq2FUcBN
	 203qkd9H67k07Bi+l9zKSNdKyCw1mFtUDgY0ULnM=
Date: Mon, 15 Apr 2024 12:35:22 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-turn-on-wextra-by-default.patch added to mm-nonmm-unstable branch
Message-Id: <20240415193523.7B326C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: turn on -Wextra by default
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-turn-on-wextra-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-turn-on-wextra-by-default.patch

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
Subject: kbuild: turn on -Wextra by default
Date: Mon, 15 Apr 2024 14:20:32 +0200

Patch series "kbuild: enable more warnings by default", v3.

All the warning fixes I sent for these warnings have been merged into
mainline or linux-next, so let's turn them on by default.


This patch (of 6):

The -Wextra option controls a number of different warnings that differ
slightly by compiler version.  Some are useful in general, others are
better left at W=1 or higher.  Based on earlier work, the ones that should
be disabled by default are left for the higher warning levels already, and
a lot of the useful ones have no remaining output when enabled.

Move the -Wextra option up into the set of default-enabled warnings and
just rely on the individual ones getting disabled as needed.

The -Wunused warning was always grouped with this, so turn it on by
default as well, except for the -Wunused-parameter warning that really has
no value at all for the kernel since many interfaces have intentionally
unused arguments.

Link: https://lkml.kernel.org/r/20240415122037.1983124-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20240415122037.1983124-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/scripts/Makefile.extrawarn~kbuild-turn-on-wextra-by-default
+++ a/scripts/Makefile.extrawarn
@@ -82,12 +82,14 @@ KBUILD_CFLAGS += $(call cc-option,-Werro
 # Warn if there is an enum types mismatch
 KBUILD_CFLAGS += $(call cc-option,-Wenum-conversion)
 
+KBUILD_CFLAGS += -Wextra
+KBUILD_CFLAGS += -Wunused
+
 #
 # W=1 - warnings which may be relevant and do not occur too often
 #
 ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 
-KBUILD_CFLAGS += -Wextra -Wunused -Wno-unused-parameter
 KBUILD_CFLAGS += $(call cc-option, -Wrestrict)
 KBUILD_CFLAGS += -Wmissing-format-attribute
 KBUILD_CFLAGS += -Wold-style-definition
@@ -190,6 +192,7 @@ else
 
 # The following turn off the warnings enabled by -Wextra
 KBUILD_CFLAGS += -Wno-sign-compare
+KBUILD_CFLAGS += -Wno-unused-parameter
 
 endif
 
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

