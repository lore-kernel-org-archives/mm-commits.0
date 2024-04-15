Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AF015686C
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713209731; cv=none; b=njJBvireMFmpRWxjGT5kXLjc1Siy8/hZtjvdSgzIY85NVfiCUWMIhML4Cx1wUw0etJSAfRr7nVtRmpN99vwSE+7EMrGwcFHdoaKQtDsGURFvMu33QNV/hDL0WOU5B/R+ZktaERhJ0/PxV2oJp/+2CrUHPCD95LsfhjzfBTap0PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713209731; c=relaxed/simple;
	bh=dWNzmrVveXsfu++dVcLV+rxJ5logqmA5+1zACksfix4=;
	h=Date:To:From:Subject:Message-Id; b=gwqaCl/d3MblLHEBN7f3+6nNuS5MNHB3hFbR3lq6hBLEZgMjLyMM8U64GddCc7oUtVqvcufmbmPfDweuFLIny413Kwn9y3mj0pD1R16ENLLGrilIz9yooS3eKiotG8M1Z6t+x7AOLoRupc0IOZhaN4efSPNjr2rqv2EK6Ok3pyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aZS3wNw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aZS3wNw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1983C113CC;
	Mon, 15 Apr 2024 19:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713209730;
	bh=dWNzmrVveXsfu++dVcLV+rxJ5logqmA5+1zACksfix4=;
	h=Date:To:From:Subject:From;
	b=aZS3wNw8rVIMdcycOTgnRsmUC2+q0x3aNwr8PlFnrp8t5bIxLzOrUpuzL0+IK4ZK0
	 PxArYu+AWNpXlsbZ+ERpFuEx4k1/KBKgDIRGlv0DkoA7sHO5blXDHgpbd8YQdH6kV6
	 6ZWN91uBQpVJgABaHPadjs1FPwuJNJdlspaZig7A=
Date: Mon, 15 Apr 2024 12:35:30 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-enable-wcast-function-type-strict-unconditionally.patch added to mm-nonmm-unstable branch
Message-Id: <20240415193530.B1983C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: enable -Wcast-function-type-strict unconditionally
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-enable-wcast-function-type-strict-unconditionally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-enable-wcast-function-type-strict-unconditionally.patch

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
Subject: kbuild: enable -Wcast-function-type-strict unconditionally
Date: Mon, 15 Apr 2024 14:20:36 +0200

All known function cast warnings are now addressed, so the warning can be
enabled globally to catch new ones more quickly.

Link: https://lkml.kernel.org/r/20240415122037.1983124-6-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/Makefile.extrawarn~kbuild-enable-wcast-function-type-strict-unconditionally
+++ a/scripts/Makefile.extrawarn
@@ -129,7 +129,6 @@ endif
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
-KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 KBUILD_CFLAGS += -Wno-enum-compare-conditional
 KBUILD_CFLAGS += -Wno-enum-enum-conversion
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

