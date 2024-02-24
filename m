Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EA619A;
	Sat, 24 Feb 2024 00:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708733941; cv=none; b=L+U6CjHQPrnJa5F9pxS/PFHJl4pAhLQPdJUK5DHptNhl3GLxo8FbgbCDJ/WcQ7nqaec1HQKmeRGzu6nk0AS59tXq+46q9BWffpbipN6T9gMKt8BIAMMP6jkBMz2P5cEdEEw3vlzc6GM/YqHHDfydrdzUtBP8KBVss83LzJ1RP2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708733941; c=relaxed/simple;
	bh=Z4Ip5Uq33WoTzQTHGO6CRnXk7192eWoaFxRkEvFISe8=;
	h=Date:To:From:Subject:Message-Id; b=HoRD0U+sP7Hxtkf7N4KIyTQ6L2falFJqaBbCtpPrqQ6kmce+C28uk8QJtLqEjdccgnQ2b0x7FckyxBXmYmyZhXrpSZNES9CD203MQ7qefY53ZWHORGcAGUXQqePbKZP92Y+5ZJR8X1d2Z1ikNU2XxcbajLBMcSwHmrbeEaYJkvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qWNBgcUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qWNBgcUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11868C433F1;
	Sat, 24 Feb 2024 00:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708733941;
	bh=Z4Ip5Uq33WoTzQTHGO6CRnXk7192eWoaFxRkEvFISe8=;
	h=Date:To:From:Subject:From;
	b=qWNBgcUAXQlvzeeY03hMO4Z/0d4K1MYgVlsednyxH/Q2lxPJwT7eaBh4su/jkb4l2
	 jRyknRegyMDVU7VpVOk5FJQZ2e9IyqW8/0+DfnB7Cx0ho6qug5Pf+L48MbaqhcWGDI
	 p5BPcFVJxO8H5tvLDcwO2VuglAMsgn5NIlvUu+kY=
Date: Fri, 23 Feb 2024 16:19:00 -0800
To: mm-commits@vger.kernel.org,yaolu@kylinos.cn,tsi@tuyoix.net,surenb@google.com,stable@vger.kernel.org,rdunlap@infradead.org,pmladek@suse.com,paul@paul-moore.com,nphamcs@gmail.com,nathan@kernel.org,masahiroy@kernel.org,hannes@cmpxchg.org,gustavoars@kernel.org,gregkh@linuxfoundation.org,christophe.leroy@csgroup.eu,ardb@kernel.org,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-kconfig-lower-gcc-version-check-for-warray-bounds.patch added to mm-hotfixes-unstable branch
Message-Id: <20240224001901.11868C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/Kconfig: lower GCC version check for -Warray-bounds
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     init-kconfig-lower-gcc-version-check-for-warray-bounds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-kconfig-lower-gcc-version-check-for-warray-bounds.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: init/Kconfig: lower GCC version check for -Warray-bounds
Date: Fri, 23 Feb 2024 09:08:27 -0800

We continue to see false positives from -Warray-bounds even in GCC 10,
which is getting reported in a few places[1] still:

security/security.c:811:2: warning: `memcpy' offset 32 is out of the bounds [0, 0] [-Warray-bounds]

Lower the GCC version check from 11 to 10.

Link: https://lkml.kernel.org/r/20240223170824.work.768-kees@kernel.org
Reported-by: Lu Yao <yaolu@kylinos.cn>
Closes: https://lore.kernel.org/lkml/20240117014541.8887-1-yaolu@kylinos.cn/
Link: https://lore.kernel.org/linux-next/65d84438.620a0220.7d171.81a7@mx.google.com [1]
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marc Aurèle La France <tsi@tuyoix.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/init/Kconfig~init-kconfig-lower-gcc-version-check-for-warray-bounds
+++ a/init/Kconfig
@@ -876,14 +876,14 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
-# Currently, disable gcc-11+ array-bounds globally.
+# Currently, disable gcc-10+ array-bounds globally.
 # It's still broken in gcc-13, so no upper bound yet.
-config GCC11_NO_ARRAY_BOUNDS
+config GCC10_NO_ARRAY_BOUNDS
 	def_bool y
 
 config CC_NO_ARRAY_BOUNDS
 	bool
-	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC11_NO_ARRAY_BOUNDS
+	default y if CC_IS_GCC && GCC_VERSION >= 100000 && GCC10_NO_ARRAY_BOUNDS
 
 # Currently, disable -Wstringop-overflow for GCC globally.
 config GCC_NO_STRINGOP_OVERFLOW
_

Patches currently in -mm which might be from keescook@chromium.org are

init-kconfig-lower-gcc-version-check-for-warray-bounds.patch

