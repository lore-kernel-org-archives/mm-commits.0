Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE72F4F5FB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154624; cv=none; b=W52oWXg2bVoSVrAIg7N7YEOtRcScLESk/s4SAorExCUUMfDZLviWmHs+X8ppuQnxKP9eCK2RKWLWcFbX1kWmn6SlK6OmzAe9LuPriMq+lOBD10HIr7QFtrq5gKsWF9sA620Mw7r5t2a5gw8xIJb/K95NnUkT+9kBFa6GC+sNHQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154624; c=relaxed/simple;
	bh=Gga+0i6oioB6ZtcQgJ8NqwRKy25zZlnquxbeSuipJA8=;
	h=Date:To:From:Subject:Message-Id; b=hv8LYXfR+u2U0Ta0Zsxhv2FaBFrOacXe6PoBVbMEQ/sFNQ5IToQ1RBps8hjqQsjtt9b/+tziCPvB93qIUeRL0kB2R7bNyCLjcMrz+35CRhwR9qfjutmEk2OQWUKDvulOu8zERlVWHt3g5sbThvB39Rydsai3PYOXq2YX55fEkYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BB0bStIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BB0bStIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A32EC32781;
	Sun, 19 May 2024 21:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154624;
	bh=Gga+0i6oioB6ZtcQgJ8NqwRKy25zZlnquxbeSuipJA8=;
	h=Date:To:From:Subject:From;
	b=BB0bStIvNwaw4luNTaJl4cbUk95Edx2Y6t0squ4vj/hbE7H0ahcSf4WXyOUyYfWgG
	 R6wjfr2Yv5m2Th0/Jf1wMYIAIGKl0w+KT6AjR6C4pnBSUSZpiRembpgE0RvEf94fdo
	 AMWst30D6wPjldaNqMuCy8ddkse16J2B+/P5HOwU=
Date: Sun, 19 May 2024 14:37:03 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kbuild-enable-wformat-truncation-on-clang.patch removed from -mm tree
Message-Id: <20240519213704.7A32EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kbuild: enable -Wformat-truncation on clang
has been removed from the -mm tree.  Its filename was
     kbuild-enable-wformat-truncation-on-clang.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


