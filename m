Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CA9372677
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028792; cv=none; b=Q2rSmGZpH87R64drPR+9AyHuLFkT7nTQR6YJf4WUvMfrGdeSejwhrpQJZb52t15E72Q+txYEcRDfwZYdQHbXaO+KhkqEIBQJlLAOBlFy52UxLul1nIMQuj7tOGyrrfB7rhTBi5HUezSQTZ4Cr6aMgzWcHJJhZ80YG2beUTlqX44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028792; c=relaxed/simple;
	bh=wdht+un2Wg3OQ4+P0NASTQyCXM8jEilY5xn9QxyiObw=;
	h=Date:To:From:Subject:Message-Id; b=oSOD25iJ60BgOGS4G1q9k6X6kXQ4zge/UHtMRXKHHyqLB1fkJTaewV2kXDZIXdwrnU2RgD018JXqpcHut+qEbw6foD7664LDuOOB1OIOtL7dIzhj6LYxwAQYDBH3g+mG1APd48saCjS+buEzOik11Vi8c+QOEE1JWBvqWKoJdoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=go5xEBwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="go5xEBwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5BC1F00898;
	Fri, 29 May 2026 04:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028791;
	bh=RGkPJS/cvbRN13aJehtL3tYhVFxkgJbt538GadVMquY=;
	h=Date:To:From:Subject;
	b=go5xEBwNVqiDt7Sy6kFnSRqyo9S/s4hUCwcPD/Lg+6WAfzJyVRaSjEUf5cDs6wwya
	 t9nume69wSWfDeKhQ/Dv/wsBc7kZNVvHHzyoyC8WQUqX6CKa6I1vuJRHKYrVsYQxtr
	 TLhpiXx5h/EY6VoIMkDTYYL577G1a6czG5ILAtow=
Date: Thu, 28 May 2026 21:26:30 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] riscv-fix-building-compressed-efi-image.patch removed from -mm tree
Message-Id: <20260529042630.EE5BC1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: fix building compressed EFI image
has been removed from the -mm tree.  Its filename was
     riscv-fix-building-compressed-efi-image.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: riscv: fix building compressed EFI image
Date: Tue, 19 May 2026 20:22:59 +0300

When building vmlinuz.efi with CONFIG_EFI_ZBOOT enabled, '__lshrdi3()'
is also needed to fix yet another link error observed when building
riscv32 and loongarch32 images:

riscv32-linux-gnu-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
__efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'

/usr/bin/loongarch32-linux-gnu-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L47':
__efistub_cmdline.c:(.init.text+0x26c): undefined reference to `__efistub___lshrdi3'

And since both riscv64 and loongarch64 can have CONFIG_EFI_ZBOOT but
doesn't need these library routines, rely on CONFIG_32BIT to manage
linking of lib-ashldi3.o and lib-lshrdi3.o on 32-bit variants only.

[dmantipov@yandex.ru: fix loongarch32]
  Link: https://lore.kernel.org/8095016e47aceab4830c2523ce78af968ec0497e.camel@yandex.ru
Link: https://lore.kernel.org/20260519172259.908980-9-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Closes: https://lore.kernel.org/linux-riscv/20260409050018.GA371560@inky.localdomain
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro-preview sashiko
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andriy Shevchenko <andriy.shevchenko@intel.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/libstub/Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/libstub/Makefile~riscv-fix-building-compressed-efi-image
+++ a/drivers/firmware/efi/libstub/Makefile
@@ -95,8 +95,10 @@ CFLAGS_zboot-decompress-gzip.o	+= -I$(sr
 zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
-zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o lib-ashldi3.o
-zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o lib-ashldi3.o
+zboot-riscv-obj-$(CONFIG_32BIT)	:= lib-ashldi3.o lib-lshrdi3.o
+zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)
+zboot-loongarch-obj-$(CONFIG_32BIT) := lib-ashldi3.o lib-lshrdi3.o
+zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o $(zboot-loongarch-obj-y)
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
 
 lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch

