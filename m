Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C3B383C6B
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217308; cv=none; b=i0zRxmWnn8yA+Z+Lg/1sMoE06d8CVWB2EpHm/t4mUETHLbPv+JjEQZPpj7q1bCNQ05lboC4nIbqEeiIAZY/M2gA6Tt7UtBOZVNqJwI8LqWQbla6ioFey8BwiqoqXv9k3OgIt2g/QHWsFU2pGXQS2AH6DxC2noZU/Bm4Jh4tD5wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217308; c=relaxed/simple;
	bh=cKoy1o5pxw1NA7c3J9dwjmkoojJbEa6hC+QMpibfIoM=;
	h=Date:To:From:Subject:Message-Id; b=oRb/PY1UCW/jm7I1UGlPtJjaIllmU0Hd89aDLWIIym0Z20bEyPWlDX/wdh19TcJ2lTl8kRqUePjFY+swtSe+DIy8pFnKvjTa743omoxPLim2rhuZL3z1p+xB0RESiPy2VWQobvdJdSxUJm8no7Fpmr2PAWJCYaPZYrXW/gUCgJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=emRi56Vp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="emRi56Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B861F000E9;
	Tue, 19 May 2026 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779217306;
	bh=W+yUatZF0rwSee9nnCAWFzxLxMwoavSZxbs9Xrd14xA=;
	h=Date:To:From:Subject;
	b=emRi56Vp4YRS7tDTal7jaw7MtpweC3z/esu6yvytB57MBufuhDoU/aGfuqpoh6ud8
	 GlJHVES2DVc021cm7EKNje+6xdW9OBv9T0tVQxwPvlcFMs7l8UXk4Wl7QgCcdx/PbO
	 wSiQfeoX2tWR0MxjBp7CnOvH/cjaQoNYu7Pasa4A=
Date: Tue, 19 May 2026 12:01:46 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] riscv-fix-building-compressed-efi-image.patch removed from -mm tree
Message-Id: <20260519190146.B1B861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: fix building compressed EFI image
has been removed from the -mm tree.  Its filename was
     riscv-fix-building-compressed-efi-image.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: riscv: fix building compressed EFI image
Date: Wed, 13 May 2026 16:44:07 +0300

When building vmlinuz.efi with CONFIG_EFI_ZBOOT enabled,
'__lshrdi3()' is also needed to fix yet another link error:

riscv32-linux-gnu-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
__efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'

And since riscv64 can have CONFIG_EFI_ZBOOT but doesn't need
these library routines, rely on CONFIG_32BIT to manage linking
of lib-ashldi3.o and lib-lshrdi3.o on riscv32 only.

Link: https://lore.kernel.org/20260513134407.884033-9-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Closes: https://lore.kernel.org/linux-riscv/20260409050018.GA371560@inky.localdomain
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro-preview sashiko
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/libstub/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/Makefile~riscv-fix-building-compressed-efi-image
+++ a/drivers/firmware/efi/libstub/Makefile
@@ -95,7 +95,8 @@ CFLAGS_zboot-decompress-gzip.o	+= -I$(sr
 zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
-zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o lib-ashldi3.o
+zboot-riscv-obj-$(CONFIG_32BIT)	+= lib-ashldi3.o lib-lshrdi3.o
+zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)
 zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o lib-ashldi3.o
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
 
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch

