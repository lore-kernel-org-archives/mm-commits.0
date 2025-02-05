Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3D315198F
	for <mm-commits@vger.kernel.org>; Wed,  5 Feb 2025 23:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738798524; cv=none; b=rQsWpY41j4TvwBurZvlUwwJeKYnBO5ZPupBAhNsq/5/PtuxXHh2HbBNmlcm1h1iExB6fF9Wq9GSPC/UYZUmbIiK891PpcwE1HvNqPMptQ0kHFNtitMQ7KWw/46OppLse0Rx44yUuySkbdk9OmPztVosZA8BJfpwmdcXh8HmMbno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738798524; c=relaxed/simple;
	bh=rTlqZ6FBfMsdbz2RCS43ZYK0QCmEgpVVGTp/WPmMSuY=;
	h=Date:To:From:Subject:Message-Id; b=ci4aooxd3pt40Qs2h75+Q4WBgo+nbnJb7ei/CMnrV8KIdPQ1i+IS6AFDW5YV4XG+ZhTMqhKHlmK//GYai2Ekq4XM9l51ocMdx0clD18vIhE8Cg6pEcvKL4/E98Qwhu6PemgIrOL8e2u3DctZMktVGq+k3uS5M2ANoimuKby1aXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pYkh2lZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pYkh2lZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD919C4CED1;
	Wed,  5 Feb 2025 23:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738798523;
	bh=rTlqZ6FBfMsdbz2RCS43ZYK0QCmEgpVVGTp/WPmMSuY=;
	h=Date:To:From:Subject:From;
	b=pYkh2lZ5or8uaV/Op1NaugNgpNEC1U8whLOL6IZeUJ1Xj+2jLnNQBcij7v67eF1Uq
	 7jf/12YirC6f18lwhYOarRcUV11AXOZeZiPejEMVpCdijPwjDfUtvIx7F+hruzb0BM
	 ZSDHugMs7uoyBRaT9tUHBxcHVw9alfIsjiZ7wth0=
Date: Wed, 05 Feb 2025 15:35:23 -0800
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,masahiroy@kernel.org,lkp@intel.com,arnd@arndb.de,andy.shevchenko@gmail.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] scripts-makefileextrawarn-do-not-show-clangs-non-kprintf-warnings-at-w=1.patch removed from -mm tree
Message-Id: <20250205233523.AD919C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/Makefile.extrawarn: do not show clang's non-kprintf warnings at W=1
has been removed from the -mm tree.  Its filename was
     scripts-makefileextrawarn-do-not-show-clangs-non-kprintf-warnings-at-w=1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


