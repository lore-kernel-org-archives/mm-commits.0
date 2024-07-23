Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F045130AC8
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701778; cv=none; b=KMk8t7xJ+StNI0XZbQuhxbcUowyEUk8voUGa6Yj6AvrQUShOKz+HrybkMO7SHj6l51tPKP4u7BMud3onfEp3bGg/KDhKj+G9iFX9kyeZc9/D84yffmbYDaH9tIxny3r+ci0qE0DxkaRIMBMzqOkoJ1fi2skmCcrY1cQZoiuNQwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701778; c=relaxed/simple;
	bh=7yryl2UiicwVTAPlVcPoZOfUYYWf3XevxDETSSzx+fE=;
	h=Date:To:From:Subject:Message-Id; b=kyfnrtjrQdYYk2njKvLR46XE1qyUsu8EIpj6Yf1i2p6Jmey6+GQGmWGXD3blTESDk3bHhhx8ohpMgk7vibRme8V0KD8HR89eS5UvTGGWKjzg8z+b6t2XD36ubFfVxfLbawcvS6ElhR0dFlpAb7Vm5oZItSDu9AfPUQQb5vVpFTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HrI9caJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HrI9caJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEE3C116B1;
	Tue, 23 Jul 2024 02:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701778;
	bh=7yryl2UiicwVTAPlVcPoZOfUYYWf3XevxDETSSzx+fE=;
	h=Date:To:From:Subject:From;
	b=HrI9caJQPACyInW7ENFFFkqulB2052fO+BB4tYdP8Qa8UlaC1wnOe0wyXfFATO9XN
	 I/molMvnX9BvWs9nt2/CRAMt0dnOWBLXKCl3JbI20ZtOy0XB2f8CAhVK4Z5wtcLoz4
	 iXu4ylMBQYiXjaJ+FtaJMZ5DqxzyhhcdG8a+AjEI=
Date: Mon, 22 Jul 2024 19:29:37 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-boot-add-imagexz-support.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022938.0BEE3C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: boot: add Image.xz support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-boot-add-imagexz-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-boot-add-imagexz-support.patch

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
Subject: arm64: boot: add Image.xz support
Date: Sun, 21 Jul 2024 16:36:30 +0300

The Image.* targets existed for other compressors already.  Bootloader
support is needed for decompression.

This is for CONFIG_EFI_ZBOOT=n. With CONFIG_EFI_ZBOOT=y, XZ was already
available.

Link: https://lkml.kernel.org/r/20240721133633.47721-16-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Sam James <sam@gentoo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/boot/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/Makefile~arm64-boot-add-imagexz-support
+++ a/arch/arm64/boot/Makefile
@@ -17,7 +17,7 @@
 OBJCOPYFLAGS_Image :=-O binary -R .note -R .note.gnu.build-id -R .comment -S
 
 targets := Image Image.bz2 Image.gz Image.lz4 Image.lzma Image.lzo \
-	Image.zst image.fit
+	Image.zst Image.xz image.fit
 
 $(obj)/Image: vmlinux FORCE
 	$(call if_changed,objcopy)
@@ -40,6 +40,9 @@ $(obj)/Image.lzo: $(obj)/Image FORCE
 $(obj)/Image.zst: $(obj)/Image FORCE
 	$(call if_changed,zstd)
 
+$(obj)/Image.xz: $(obj)/Image FORCE
+	$(call if_changed,xzkern)
+
 $(obj)/image.fit: $(obj)/Image $(obj)/dts/dtbs-list FORCE
 	$(call if_changed,fit)
 
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

maintainers-add-xz-embedded-maintainer.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-fix-comments-and-coding-style.patch
xz-fix-kernel-doc-formatting-errors-in-xzh.patch
xz-improve-the-microlzma-kernel-doc-in-xzh.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
docs-add-xz_extern-to-c_id_attributes.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch
arm64-boot-add-imagexz-support.patch
riscv-boot-add-imagexz-support.patch

