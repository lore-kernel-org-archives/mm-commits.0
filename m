Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6E24F5FB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154622; cv=none; b=LVZCwAi+ENQRXIftbNgstXaWUjwiYt8YhB3bVsRITRm0JBRBfMX8jl/U4z0ZN4tV84Trc45j3azKjNqV2nsEyf/Tqjp61JcYdoP7PUARAMIMbngvhtl/7zaw0TtbMU8r24rsAIV3dFRxMCBresoe7te1p4+yWXrhQxQPkKamIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154622; c=relaxed/simple;
	bh=mpbx6hHVcMdXVUcXndjVfwDANdfnMo+vfET8TkTeQaE=;
	h=Date:To:From:Subject:Message-Id; b=arwXTWxSJlxGvO648qr30tTjytbKxdxMPxB5i+rf0Nb63cvZFPMtydDQQrD6V4Vk6hxKcuYJP6pDmig56F4zABUN7xhuqlJKePDPuQ13skP2up01GbM0uFu5xExYJmpy2oGD/8HdBDYdhMWT2vxF5BgmqKUNiYXBmh2O23jZ1s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eooJEI0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eooJEI0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2B8C32781;
	Sun, 19 May 2024 21:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154622;
	bh=mpbx6hHVcMdXVUcXndjVfwDANdfnMo+vfET8TkTeQaE=;
	h=Date:To:From:Subject:From;
	b=eooJEI0avSUEINbhrpSD9XEj9l6ONTHI7wiRiMxQkXtwDEMsvzk5d+H6t62O9QPZ0
	 NwXz1js6vlyYpR9zjCArSrriKVj1rQ8JYZk0uoLgOTKRAgCDdB+qluUrC/y+aIYwCW
	 q+ikmCzEn8BIP+vrW9j1ZPd+FmTBKPcCFnujvV6s=
Date: Sun, 19 May 2024 14:37:01 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kbuild-remove-redundant-extra-warning-flags.patch removed from -mm tree
Message-Id: <20240519213702.3D2B8C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kbuild: remove redundant extra warning flags
has been removed from the -mm tree.  Its filename was
     kbuild-remove-redundant-extra-warning-flags.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


