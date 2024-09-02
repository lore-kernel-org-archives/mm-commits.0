Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7573E23BE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248777; cv=none; b=cQri+cdL9z6bbWPRAUnBtUOxjEoAvaryO7TISXp6DeKNEB1TZ9pEcyf3pp1Z+Riw8BfSlXoC7xkKd2zJjtq/dif3LidDGc99mUCJg76ASSeSGWJ9b/3gHBXE+KHXOceQw9HPFrg6UEv1iFOWzIeMzb+WSl/Qg/drzaTILrE4Fro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248777; c=relaxed/simple;
	bh=dJ91whNXUj0FZQ+qJfLlYn0QfMi8PMqKFL/XzfCw/NM=;
	h=Date:To:From:Subject:Message-Id; b=uPSnolcrSHfilg8R5kpixVsLwfJgR8W4C+naW2eD7BScIx2iBVQhEo5/XQwWJychbFPqF738z2acHCGY2wrkyr57CSbok/NYFlOaO/1W3+PjzNBE4VQJjUbcHgFk+d3dPxKgPQhaOPq+VKrck3u06PnPasuM7Irf/PRyNTPe2VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YZ+2AvGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YZ+2AvGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A7DC4CEC2;
	Mon,  2 Sep 2024 03:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248777;
	bh=dJ91whNXUj0FZQ+qJfLlYn0QfMi8PMqKFL/XzfCw/NM=;
	h=Date:To:From:Subject:From;
	b=YZ+2AvGcGACqAB2NXT+S6jYXXhMymF/EnyOEOauK3uSbDq7tWDEnW3qzM66qaM+zu
	 dyrKdqRI4wJtnJTggEvJopyjTPT2dQhm/1bOL0bDkip48kPqqqeFk0gdUl6WldbGtI
	 zfMtD0eTiuqGgdM2ADjwAnzvp05TZtVAj2HwgDyM=
Date: Sun, 01 Sep 2024 20:46:16 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm64-boot-add-imagexz-support.patch removed from -mm tree
Message-Id: <20240902034617.49A7DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: boot: add Image.xz support
has been removed from the -mm tree.  Its filename was
     arm64-boot-add-imagexz-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


