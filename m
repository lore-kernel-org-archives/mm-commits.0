Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794766550;
	b=TFOjF1e7K+C2k9Ho8feMEwuJetq5SKNxzKa5xdg9WuCcjON6Ez9tITF1vv/9f02AEoNI
	 zU3mBC8WAl6jKSFxJpQ8Ejfzgi8p7xtvxstMc/xNCUZc9KbCGCQ4QOa8hyxy/VVi2b6+D
	 Ojsm76RLsEyUyybdBAN5iuyD9HRmmbddhNIoyGT9XKoLdU7/0Z33gcOePuAj4d0IELkXr
	 xXzjNpodShaD0U709mcQ/BzCXI3tCGJAE3cHBWu28aY4aSQpmd/DGL2LtzVEoD3h7l3Qm
	 jVA0kQ1Ytqonm9mvtRIl9WsIfd7Or7wk80xYNo+ihtu5bVaIja7f8wNc2MF8SCyKtDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794766550;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4GtI61GHNakQCP+WrXbDLSu3z4Pov8vuE7xg+ASbM/A=;
	b=CwlZoE6wBSr7MSLKy9xlkcmVIZfvxW5hN92PpFXJG9mGrxsnrWBYOBJrnN+iloneMhG6
	 T5+RbRoyqGOGN/j2Q1yicjD8cPkbQ3298NZw/uSTU114MMD+M2U+HSvymjBB1+OUIoxvp
	 FNR32J9n0kryr3I8eQM23hQ8byr1ad5K5Hpgxm0IIpJMF7tdNUmjnWE/UppfHudYl22TL
	 f38cE1FnDRLF9oq3UGb9XL0CLkkjfPx3hsks+tdpcoFu69nWmVe6ZjTgitEFr24KqAWDb
	 kdZ9yhjxnk2kpwDsDfIbo24XNs7zEJ8JeiYNdK8J+ZPjqnMTo1oxLHeb1a6ZVokuOUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k12nsYVy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B48606A31E
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k12nsYVy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDF41F000C4;
	Sun, 15 Nov 2026 18:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794766549;
	bh=4GtI61GHNakQCP+WrXbDLSu3z4Pov8vuE7xg+ASbM/A=;
	h=Date:To:From:Subject;
	b=k12nsYVyxKFU5x4SP5oB6pzZWi8NQZLKay6mHSRIWXMnkpjtCmijPkWEQ7sGbrA18
	 fHg82gxs23kCUSfxsiRwO4Nwi5yvnihyuryADCt4HHv1KNgk0ngeERCr1TgCIFfhDa
	 mcbvC5ALmBM5FUiUCY3rfvax6RbeLm9/E13mrn7g=
Date: Sun, 15 Nov 2026 10:15:48 -0800
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,mripard@kernel.org,
	maarten.lankhorst@linux.intel.com,bp@alien8.de,joe@perches.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-drm-drivers-and-misc-gpu-patches.patch added to mm-nonmm-unstable branch
Message-Id: <20261115181549.5BDF41F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: DRM DRIVERS AND MISC GPU PATCHES
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-drm-drivers-and-misc-gpu-patches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-drm-drivers-and-misc-gpu-patches.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: DRM DRIVERS AND MISC GPU PATCHES
Date: Sun, 01 Nov 2026 00:41:12 -0700

There's a small defect in get_maintainers.pl that allows
incomplete file pattern matching.

Update the "F: include/drm/drm pattern" to specify only the actual files
covered instead of a prefixed partial path to these .h files.

Link: https://lore.kernel.org/576e04e1d8f0d5ac0805d450b9c87e69f7f0d2c8.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Borislav Petkov <bp@alien8.de>

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-drm-drivers-and-misc-gpu-patches
+++ a/MAINTAINERS
@@ -8884,7 +8884,7 @@ F:	Documentation/devicetree/bindings/gpu
 F:	Documentation/gpu/
 F:	drivers/gpu/drm/
 F:	drivers/gpu/vga/
-F:	include/drm/drm
+F:	include/drm/drm*.h
 F:	include/linux/vga*
 F:	include/uapi/drm/
 X:	drivers/gpu/drm/amd/
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainerpl-fix-inexact-file-pattern-matching.patch
maintainers-drm-drivers-and-misc-gpu-patches.patch

