Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C9015667D
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713209727; cv=none; b=KlwoZioT+ouu2HxPrAvV7un2/CGviBzVyMIBRKkHjA8XrMo7GrGBD9qtEWvW0Bumd9jVVChlZZ8LcvIHCenJuBsAR0bWiiDncY8TWyS0dd7g+R5s3Ut7/5zsRZULAdziVKmPhG9iPabI5gihfP8Uww2kHorGwU3vs9QBNhLoRow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713209727; c=relaxed/simple;
	bh=/LjhTI66NJtKEVsCVPkaxf1kmbgempKA9Arnrm5AGFQ=;
	h=Date:To:From:Subject:Message-Id; b=KidAfQKjYHQPn3PzIOFPR5xeisOVI/romWKI/7oSddUQs/I+NB2M8eMsmjUNZnVu5ocqe+VFJNPI1s2LX4C3XFFvdpizK3H2loITaSRDDq84Pie6iYJ011z/8XSJ8VHXiMs0Wgsrd+o9u08B4b2n+WtO0YOB3GnWUbooB4rhgyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sh6QxdDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sh6QxdDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054F2C113CC;
	Mon, 15 Apr 2024 19:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713209727;
	bh=/LjhTI66NJtKEVsCVPkaxf1kmbgempKA9Arnrm5AGFQ=;
	h=Date:To:From:Subject:From;
	b=sh6QxdDelHamtj0Xehs/rZasTAx5ZC05UCnlBJ6gRE4Axte+SdbBFqpaLW6wzrW35
	 TqLOUDaltnnoxWtaKrM5CF+W4ED05HIB1zNdC6Kikk/deGy1XPaaVxHxtCFHaMWmhl
	 fjG0iPodRMjRzWAT2wRuaMLP4PFoJPOAGykCpdCE=
Date: Mon, 15 Apr 2024 12:35:26 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-turn-on-wrestrict-by-default.patch added to mm-nonmm-unstable branch
Message-Id: <20240415193527.054F2C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: turn on -Wrestrict by default
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-turn-on-wrestrict-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-turn-on-wrestrict-by-default.patch

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
Subject: kbuild: turn on -Wrestrict by default
Date: Mon, 15 Apr 2024 14:20:34 +0200

All known -Wrestrict warnings are addressed now, so don't disable the
warning any more.

Link: https://lkml.kernel.org/r/20240415122037.1983124-4-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/Makefile.extrawarn~kbuild-turn-on-wrestrict-by-default
+++ a/scripts/Makefile.extrawarn
@@ -98,7 +98,6 @@ else
 # Suppress them by using -Wno... except for W=1.
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
-KBUILD_CFLAGS += $(call cc-disable-warning, restrict)
 KBUILD_CFLAGS += $(call cc-disable-warning, packed-not-aligned)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation)
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

