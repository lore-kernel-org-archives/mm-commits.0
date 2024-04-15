Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF55E156867
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713209726; cv=none; b=EJke9v1NRAIo4dJbJ37WSWZs6nEYdELAtx5DfCXM2Yi3qc/JVK7DUOmpajXw2wjhKS3OtG9W8CjyuatlUQ45MaMObmd868154mGMxkqIB36Tu4D94AlQZmQjQ6m9GnjOCypSgElP+buodRJTTbwhMQTPQw0WGKwXKHjpQvxjIgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713209726; c=relaxed/simple;
	bh=cxs90SF/l4SgGb0qin2VUOPwRg3QUHKI4QYZeM0FR64=;
	h=Date:To:From:Subject:Message-Id; b=FoVy8951lYuB+N/YR/qED3iNlYr6Qj+lnD/ooh59+ZTp1c5U0Ove/SAtsz9xNq9ISXlpYgMlHCZkD6zfBT253wRkcvm1IODEyA5SHgmsYCMnYOB0qlGdh1Sex9rFBTiAeIZ75oOutC0ZpE9+rgQIHRFF27v2DbviFwWieSuLS/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LpckoHQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LpckoHQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E7EC2BD11;
	Mon, 15 Apr 2024 19:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713209725;
	bh=cxs90SF/l4SgGb0qin2VUOPwRg3QUHKI4QYZeM0FR64=;
	h=Date:To:From:Subject:From;
	b=LpckoHQdJ7RG16JuF8WA3IItA/CLMcW4qkt1Ndvz/2iisOiOaZLjMvaYIBk18QMBP
	 88VA5x1QcBxaat4N6t/W3LWr/vioYh8PdBk8FPTeigGCjv/70mOC6JMPoYkszd4pBG
	 osUdn3XbBWWoBhTJHYlMSLt08eR5TdVpTxNopQNc=
Date: Mon, 15 Apr 2024 12:35:24 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-remove-redundant-extra-warning-flags.patch added to mm-nonmm-unstable branch
Message-Id: <20240415193525.52E7EC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: remove redundant extra warning flags
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-remove-redundant-extra-warning-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-remove-redundant-extra-warning-flags.patch

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
Subject: kbuild: remove redundant extra warning flags
Date: Mon, 15 Apr 2024 14:20:33 +0200

There is no point in turning individual options off and then on again, or
vice versa, as the last one always wins.  Now that -Wextra always gets
passed first, remove all the redundant lines about warnings that are
implied by either -Wall or -Wextra, and keep only the last one that
disables it in some configurations.

This should not have any effect but keep the Makefile more readable and
the command line shorter.

Link: https://lkml.kernel.org/r/20240415122037.1983124-3-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/scripts/Makefile.extrawarn~kbuild-remove-redundant-extra-warning-flags
+++ a/scripts/Makefile.extrawarn
@@ -37,11 +37,6 @@ else
 KBUILD_CFLAGS += -Wno-main
 endif
 
-# These warnings generated too much noise in a regular build.
-# Use make W=1 to enable them (see scripts/Makefile.extrawarn)
-KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
-KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
-
 # These result in bogus false positives
 KBUILD_CFLAGS += $(call cc-disable-warning, dangling-pointer)
 
@@ -90,16 +85,9 @@ KBUILD_CFLAGS += -Wunused
 #
 ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 
-KBUILD_CFLAGS += $(call cc-option, -Wrestrict)
 KBUILD_CFLAGS += -Wmissing-format-attribute
-KBUILD_CFLAGS += -Wold-style-definition
 KBUILD_CFLAGS += -Wmissing-include-dirs
-KBUILD_CFLAGS += $(call cc-option, -Wunused-but-set-variable)
 KBUILD_CFLAGS += $(call cc-option, -Wunused-const-variable)
-KBUILD_CFLAGS += $(call cc-option, -Wpacked-not-aligned)
-KBUILD_CFLAGS += $(call cc-option, -Wformat-overflow)
-KBUILD_CFLAGS += $(call cc-option, -Wformat-truncation)
-KBUILD_CFLAGS += $(call cc-option, -Wstringop-truncation)
 
 KBUILD_CPPFLAGS += -Wundef
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
@@ -150,9 +138,6 @@ ifneq ($(findstring 2, $(KBUILD_EXTRA_WA
 KBUILD_CFLAGS += -Wdisabled-optimization
 KBUILD_CFLAGS += -Wshadow
 KBUILD_CFLAGS += $(call cc-option, -Wlogical-op)
-KBUILD_CFLAGS += -Wmissing-field-initializers
-KBUILD_CFLAGS += -Wtype-limits
-KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
 KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
 
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN2
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

