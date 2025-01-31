Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2941487C1
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 23:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738366392; cv=none; b=Ys1Tord5QsCVpcF/WJ1DC9SZa4EO2cPm4nqB4RAQiswIyGl4ayj86j/9wi1kmFnsQ/2AH7kC5cwo47EBYgLXiDNIQMMUlvCHCxI3b9LMyqMiQWOFPvmahBGCjdi+bteMt2Xs1vw6AhwkgUrdX/OSeR32GPyQv2ttZNRwanwB7jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738366392; c=relaxed/simple;
	bh=g0L7yHRzPCvCoila6FSv8B1283hxJLGIh9gYiL7fDB4=;
	h=Date:To:From:Subject:Message-Id; b=iHXUq8zVPLexiMy4QhH3LIDiUlNqsDcLofrehdL2I5DvR7YiT24oEkJxA+hvMvEhMm2EhROzprvdfNvJ5J2kpJ764TELK067kYwo78TAwEDylHq92MWDOOXTR3c0hDZarrELv7d7NP33o1eHjFPPwjzPjzOf2/GAcX+4tMfqjOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IdyIBaHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IdyIBaHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D663C4CED1;
	Fri, 31 Jan 2025 23:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738366391;
	bh=g0L7yHRzPCvCoila6FSv8B1283hxJLGIh9gYiL7fDB4=;
	h=Date:To:From:Subject:From;
	b=IdyIBaHcoynkb+JTx14yMVtlqWDui5PunPzm/yJQBiwka7nkwc+yMLQNSsun0KZSf
	 flQaJsqGnTqU/s18spBEF5ysq3Ho4DQet7i2Ffafy/xYzUeEEEs/zAS6FLHXFrvxHT
	 pTc7wO4xYBRdBeTCE6OJIwr4JHrVIwEG/Xh74dXA=
Date: Fri, 31 Jan 2025 15:33:10 -0800
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,masahiroy@kernel.org,lkp@intel.com,arnd@arndb.de,andy.shevchenko@gmail.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-makefileextrawarn-do-not-show-clangs-non-kprintf-warnings-at-w=1.patch added to mm-hotfixes-unstable branch
Message-Id: <20250131233311.8D663C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/Makefile.extrawarn: do not show clang's non-kprintf warnings at W=1
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-makefileextrawarn-do-not-show-clangs-non-kprintf-warnings-at-w=1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-makefileextrawarn-do-not-show-clangs-non-kprintf-warnings-at-w=1.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: scripts/Makefile.extrawarn: do not show clang's non-kprintf warnings at W=1
Date: Fri, 31 Jan 2025 15:55:28 -0700

Clang's -Wformat-overflow and -Wformat-truncation have chosen to check
'%p' unlike GCC but it does not know about the kernel's pointer extensions
in lib/vsprintf.c, so the developers split that part of the warning out
for the kernel to disable because there will always be false positives.

Commit 908dd508276d ("kbuild: enable -Wformat-truncation on clang") did
disabled these warnings but only in a block that would be called when W=1
was not passed, so they would appear with W=1.  Move the disabling of the
non-kprintf warnings to a block that always runs so that they are never
seen, regardless of warning level.

Link: https://lkml.kernel.org/r/20250131-makefile-extrawarn-fix-clang-format-non-kprintf-v1-1-6c6747ada0d4@kernel.org
Fixes: 908dd508276d ("kbuild: enable -Wformat-truncation on clang")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501291646.VtwF98qd-lkp@intel.com/
Cc: Andriy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/scripts/Makefile.extrawarn~scripts-makefileextrawarn-do-not-show-clangs-non-kprintf-warnings-at-w=1
+++ a/scripts/Makefile.extrawarn
@@ -31,6 +31,11 @@ KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUND
 ifdef CONFIG_CC_IS_CLANG
 # The kernel builds with '-std=gnu11' so use of GNU extensions is acceptable.
 KBUILD_CFLAGS += -Wno-gnu
+
+# Clang checks for overflow/truncation with '%p', while GCC does not:
+# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111219
+KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow-non-kprintf)
+KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation-non-kprintf)
 else
 
 # gcc inanely warns about local variables called 'main'
@@ -102,11 +107,6 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow)
 ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation)
-else
-# Clang checks for overflow/truncation with '%p', while GCC does not:
-# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111219
-KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow-non-kprintf)
-KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation-non-kprintf)
 endif
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
_

Patches currently in -mm which might be from nathan@kernel.org are

scripts-makefileextrawarn-do-not-show-clangs-non-kprintf-warnings-at-w=1.patch

