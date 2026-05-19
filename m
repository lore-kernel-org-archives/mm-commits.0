Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459AA3EA959
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217998; cv=none; b=WfnDPeKAqgX4FAeMKG4Ih/WOtkON9yeeNKiQXshd40YIr7oXkEz7dCJUbejvjMJq2BxuGhwz9UKDPepXKmMSY10mxVjsECD3aPYFIapLr3cGfOEgGCzwHRQfZkMUIbY3OKwKIs2CJt3bdJtFWfoQAiUlBU9inU8A2RB/4nIw1dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217998; c=relaxed/simple;
	bh=oO6Vc7q0q+ox9gxWlxRsAvAoiyImp9/zEbja81jfHjI=;
	h=Date:To:From:Subject:Message-Id; b=n9qZv3qoRAHChnIQ2YDEv6tx75p207EyYpbOibKTGHKQlIklsUsZzM434PUkDTZWzrPzqgR2MhF8GXd+b0XAY/PFMuPo0cur5WIl6fqEim7tFk588txOHeMOvO7PAqAzGO427dHJKKR4uUV8KGJsyJSN1LoO29i0Z1KIEAlWN2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O2s0DVmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O2s0DVmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6481F000E9;
	Tue, 19 May 2026 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779217996;
	bh=ftjPwhH5P0w5LUPIGyBDXgIZry/eH21EcSQqj1EEvdU=;
	h=Date:To:From:Subject;
	b=O2s0DVmFft7RqYyUFu0V26Pfh7//3pZEgP1PPVJdVI8B/AOcijYx+b+UwOA3ky3+H
	 FK8A9Y9Nz1yJYf/yR0HNUudvEhDOp7HkfaGaQrr1erafXwjxtLBj319o7E0KuciWcE
	 4i8ecs1uZ7Txy0utytlHraGFvAc4yM8+cTsiwm4E=
Date: Tue, 19 May 2026 12:13:16 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-fix-building-compressed-efi-image.patch added to mm-nonmm-unstable branch
Message-Id: <20260519191316.CD6481F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: fix building compressed EFI image
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-fix-building-compressed-efi-image.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-fix-building-compressed-efi-image.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: riscv: fix building compressed EFI image
Date: Tue, 19 May 2026 20:22:59 +0300

When building vmlinuz.efi with CONFIG_EFI_ZBOOT enabled, '__lshrdi3()' is
also needed to fix yet another link error:

riscv32-linux-gnu-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
__efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'

And since riscv64 can have CONFIG_EFI_ZBOOT but doesn't need these library
routines, rely on CONFIG_32BIT to manage linking of lib-ashldi3.o and
lib-lshrdi3.o on riscv32 only.

Link: https://lore.kernel.org/20260519172259.908980-9-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Closes: https://lore.kernel.org/linux-riscv/20260409050018.GA371560@inky.localdomain
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro-preview sashiko
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andriy Shevchenko <andriy.shevchenko@intel.com>
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
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

