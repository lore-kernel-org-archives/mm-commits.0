Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DD97465;
	Tue,  5 Mar 2024 00:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599273; cv=none; b=sfwa3Xpi3jJUozuEFjw/zFxPbnyip5Fb6EzM93/rH+pHm3Ra2Yl0ECNGpLw7Hy9CYlQuaiJ1GWxfcqc3tSzkHzcRFkakKjkbI748SaUOT7OJ6QUaj2lkN9nr8GrGFQEtXRzzzyNdZ+JVU/kYk0tQbAaGOp8iTTjRjAgw2A9xODM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599273; c=relaxed/simple;
	bh=Y3tlLWdcMDYAY7zxuJRvCRdzPbV26/WfeDZyE3FJCcI=;
	h=Date:To:From:Subject:Message-Id; b=SOL0QeKvAHU+ivAj1nvwdO+am1awMViE0IGNv+yRdtNQFgfN7t6Wlq+KJ9rZeEpSU8Asiwnt8qt86ZrZcDURL7JzDIjOC/9h51wwo/qIrTl9oeGNvPRpcmv9uqgqKHOilVPi30eOvSHHkYsU5B3bqyJntf2D001XFheI69UFXu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DR1Cufk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DR1Cufk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A2EC43390;
	Tue,  5 Mar 2024 00:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709599272;
	bh=Y3tlLWdcMDYAY7zxuJRvCRdzPbV26/WfeDZyE3FJCcI=;
	h=Date:To:From:Subject:From;
	b=DR1Cufk1JCBD2nexgukWAwQBYEZtMqsPdrGw1955hz5pcP3ERzOA7IgGHvvJom33A
	 BkZoE/XURii26kZ/MNqEDxUIC67fZZHfhC6YoI6xtoPGo9sXQpSa6+B4wh3H29zVJ2
	 Y2N2z0bcT1/YTjv++CkkVkm2lPaXhLBu2cUozQ1s=
Date: Mon, 04 Mar 2024 16:41:12 -0800
To: mm-commits@vger.kernel.org,yaolu@kylinos.cn,tsi@tuyoix.net,surenb@google.com,stable@vger.kernel.org,rdunlap@infradead.org,pmladek@suse.com,paul@paul-moore.com,nphamcs@gmail.com,nathan@kernel.org,masahiroy@kernel.org,hannes@cmpxchg.org,gustavoars@kernel.org,gregkh@linuxfoundation.org,christophe.leroy@csgroup.eu,ardb@kernel.org,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] init-kconfig-lower-gcc-version-check-for-warray-bounds.patch removed from -mm tree
Message-Id: <20240305004112.A0A2EC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/Kconfig: lower GCC version check for -Warray-bounds
has been removed from the -mm tree.  Its filename was
     init-kconfig-lower-gcc-version-check-for-warray-bounds.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Paul Moore <paul@paul-moore.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marc Aurèle La France <tsi@tuyoix.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
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


