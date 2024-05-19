Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2A54F5FB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154621; cv=none; b=dMQH/2ELdnqtu792mVQdga66KF1no6j3eh1vEDtRibiOjnGbsuUwFVXw7ztB+LGXU4EqB6Rxn3GauviHOrAFJIUAuPxqxslLDSzOhsyY4rKFJxdtwnZe0g2G/M9dcJ3hKHdjKDYgIBhziAla28+gQYDCDayic4FgCMwXVHKMczc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154621; c=relaxed/simple;
	bh=IbJtsrYQk8ruCU+Y+qIOYidx24mNswJzMoFphdT0sVI=;
	h=Date:To:From:Subject:Message-Id; b=jGoyHvSiztVhsKjEXSXWIFXC3MAoFg/rCxP2paK3F4ZVloJ3Xa7UU452bTdRfrBXTVFpLQfyjhfXImUNSW+87AeD1whfBOMtp+eVF60E2slDkK7xDwV/jbqvVHG/TngR4EAyB2MOCNpZJNA9LivPdIE7QEBZ8D9gPdSXFF8kMs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ggRmi1zg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ggRmi1zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F67C32781;
	Sun, 19 May 2024 21:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154621;
	bh=IbJtsrYQk8ruCU+Y+qIOYidx24mNswJzMoFphdT0sVI=;
	h=Date:To:From:Subject:From;
	b=ggRmi1zg9uUMBOXNXp093FXC7TrUT72uXGFbcpKpfGXdLmyEa2Uf7JRVrPKtHUeDl
	 sV8LxjHKnCZaMf+RExVEJz4hL+8TCY+qoQM8um07XX5PDrumDISH4KY3HqJKzvYtIl
	 tEbX5lLhC2gjpv4eqLU+mNZYuP6Xe7w+dY7VZh1Q=
Date: Sun, 19 May 2024 14:37:00 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kbuild-turn-on-wextra-by-default.patch removed from -mm tree
Message-Id: <20240519213701.24F67C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kbuild: turn on -Wextra by default
has been removed from the -mm tree.  Its filename was
     kbuild-turn-on-wextra-by-default.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


