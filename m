Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442BC134CD2
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060160; cv=none; b=leE7ypVZa4akf9ZcNYMhVpGgnz6UKP9fjH5ogrgofNBtoaLypyuyRjKvD03k2v4bKc1Q3QObAQ0J6GObc0yKcYlVIEozrD1/iZxrWkxHul0nNH/on2U+hOgo5vtEMdq+fO2zfBID7nkqKJgsrfL6/SnADS/fhUTJVJiaSZDJ+Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060160; c=relaxed/simple;
	bh=wRcgID7PLIjC22piAs/6s7icvW7QZwku164UqptYHwo=;
	h=Date:To:From:Subject:Message-Id; b=rLSKJNr+O2PBxkysYvRQRgKKX73D2gUEpLwhCuhwP5QgnHx2bYJf1qAfVuz6JM157UoWCWsbhqeQyEbQQQGy9l7HDLfayMueF4u0lEyg9BhGTE4UUrYQLirngCeTwZC3wSfuHH4VK83j5qxj0nSityN//ZnZdx12J/sJfvnqL3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h4PSaDBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h4PSaDBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8E8C433F1;
	Thu, 21 Mar 2024 22:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060159;
	bh=wRcgID7PLIjC22piAs/6s7icvW7QZwku164UqptYHwo=;
	h=Date:To:From:Subject:From;
	b=h4PSaDBaFuYySu9dzICgQ+//y0adnIvJqr4EgTRE6chC/Ak9OF1T6dpWlKCsguN7A
	 HL4UMCyAoP9vUSHXZcUkiH9A3EmWGtdwUUuN8g8D1aprTmVX68+ZdEirpNwRgRb1ag
	 ePwyJ8ki6i/RKuMOZLa63fDav4OfT7YYyPXjjEqw=
Date: Thu, 21 Mar 2024 15:29:19 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-xz-embedded-maintainers.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222919.CC8E8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add XZ Embedded maintainers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-xz-embedded-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-xz-embedded-maintainers.patch

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
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: MAINTAINERS: add XZ Embedded maintainers
Date: Wed, 20 Mar 2024 20:38:34 +0200

Patch series "xz: Updates to license, filters, and compression options".

XZ Embedded, the upstream project, switched from public domain to the BSD
Zero Clause License (0BSD).  Now matching SPDX license identifiers can be
added.

The new ARM64 and RISC-V filters can be used by Squashfs.

Account for the default threading change made in the xz command line tool
version 5.6.0.  Tweak kernel compression options for archs that support XZ
compressed kernel.

Documentation was revised. There are minor cleanups too.


This patch (of 11):

I have been the maintainer of the upstream project since I submitted the
code to Linux in 2010 but I forgot to add myself to MAINTAINERS.  Nowadays
Jia Tan is the other maintainer.

Link: https://lkml.kernel.org/r/20240320183846.19475-1-lasse.collin@tukaani.org
Link: https://lkml.kernel.org/r/20240320183846.19475-2-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/MAINTAINERS~maintainers-add-xz-embedded-maintainers
+++ a/MAINTAINERS
@@ -24387,6 +24387,20 @@ S:	Maintained
 F:	drivers/spi/spi-xtensa-xtfpga.c
 F:	sound/soc/xtensa/xtfpga-i2s.c
 
+XZ EMBEDDED
+M:	Lasse Collin <lasse.collin@tukaani.org>
+M:	Jia Tan <jiat0218@gmail.com>
+S:	Maintained
+W:	https://xz.tukaani.org/xz-embedded/
+B:	https://github.com/tukaani-project/xz-embedded/issues
+C:	irc://irc.libera.chat/tukaani
+F:	Documentation/staging/xz.rst
+F:	include/linux/decompress/unxz.h
+F:	include/linux/xz.h
+F:	lib/decompress_unxz.c
+F:	lib/xz/
+F:	scripts/xz_wrap.sh
+
 YAM DRIVER FOR AX.25
 M:	Jean-Paul Roubelat <jpr@f6fbb.org>
 L:	linux-hams@vger.kernel.org
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

maintainers-add-xz-embedded-maintainers.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
xz-fix-comments-and-coding-style.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch

