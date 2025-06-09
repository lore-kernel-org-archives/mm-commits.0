Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6B123C4EB
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 02:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749436282; cv=none; b=XwCbZ/GtPtionmTWc5bzvoACqCkVAEMpgv3TcLZ+Du1Gb/fCf4ZYy4BriFikqXqL6QNmU9/mD6RW5H2ILqHq53YDV5DBXWev7pmKWvgKjyjV7DWo6S46ZiqPEjwigYeuJGWvQETO6XDFRLuI2PppWqKBp9My3h0O4PSlvgmzSdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749436282; c=relaxed/simple;
	bh=6Tpy3qNH5/thRXRj0UDhIw2kJKys1dVOB+0BK/eBnII=;
	h=Date:To:From:Subject:Message-Id; b=J0l9wB1BmBZm6Y2Q6wweUllhruGK36J1G9BnW7EK3vDOGaV9XDP5tHXVMsUqymi1hR2xK9rvqPk/bVhfTwCcUduc6gkKoBQotvzRupQ0oGuvFeudIT9wUnT/4W3HlsPh0WtCq49Y7ZyAL+hsyj/QaFj5Sjz9b36JWTWmw2HMfRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/FfVFab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/FfVFab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEC3C4CEEE;
	Mon,  9 Jun 2025 02:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749436282;
	bh=6Tpy3qNH5/thRXRj0UDhIw2kJKys1dVOB+0BK/eBnII=;
	h=Date:To:From:Subject:From;
	b=k/FfVFabA3bhfyGgoScz0UZU+nve0k2oeao5xTgsrMlf6OJKkUyKI9qeWApXk2otp
	 XhkQ0UUqaCtJHHl5e63ROkn8coDOwk4PJCwVO+3VTWgHqYIBlgccBoFOWvhPMwKlF5
	 cBTWj0kYCffjLv0KSfxpvDkKZ4dmhbCqCHioG/yo=
Date: Sun, 08 Jun 2025 19:31:21 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,masahiroy@kernel.org,jack@suse.cz,brauner@kernel.org,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-fix-build-warnings-about-exporth.patch added to mm-hotfixes-unstable branch
Message-Id: <20250609023122.3DEC3C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: fix build warnings about export.h
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     init-fix-build-warnings-about-exporth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-fix-build-warnings-about-exporth.patch

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
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: init: fix build warnings about export.h
Date: Sun, 8 Jun 2025 22:12:35 +0800

After commit a934a57a42f64a4 ("scripts/misc-check: check missing #include
<linux/export.h> when W=1") and 7d95680d64ac8e836c ("scripts/misc-check:
check unnecessary #include <linux/export.h> when W=1"), we get some build
warnings with W=1:

init/main.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing
init/initramfs.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing

So fix these build warnings for the init code.

Link: https://lkml.kernel.org/r/20250608141235.155206-1-chenhuacai@loongson.cn
Fixes: a934a57a42f64a4 ("scripts/misc-check: check missing #include <linux/export.h> when W=1")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    1 +
 init/main.c      |    1 +
 2 files changed, 2 insertions(+)

--- a/init/initramfs.c~init-fix-build-warnings-about-exporth
+++ a/init/initramfs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/init.h>
 #include <linux/async.h>
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/types.h>
--- a/init/main.c~init-fix-build-warnings-about-exporth
+++ a/init/main.c
@@ -13,6 +13,7 @@
 #define DEBUG		/* Enable initcall_debug */
 
 #include <linux/types.h>
+#include <linux/export.h>
 #include <linux/extable.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

init-fix-build-warnings-about-exporth.patch

