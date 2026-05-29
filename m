Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637052E739A
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028236; cv=none; b=XWWr1ZLnJMtXaNR0ME/rx26h3D5ugLSg7K99bhIfZstCAUT4pzOYdzBLOMazHn3O8zj4gc8CCrbERE/fwBeLUwGVFg1AgBVou7Doefipr7bHwfWOAhhyosZMZI+L/UHcPyr6zKPa1nxHxtz/6BmgKC8DmKc49pO81Az+7oi9N5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028236; c=relaxed/simple;
	bh=UIwN5T9FOuyrV0BNxzRxF3vpHRtM+L3ti6Z3nKGT9rk=;
	h=Date:To:From:Subject:Message-Id; b=dMSGybH1BwYZO0Wr35VkwRsZ5F0zjBYzJbsGilKAP5yNw8fjpbhrejbRU4k7BCWM4OpOJ9w1bVwKT0oDPTe2ZKckf4ukQ8pIiladMwCS7o/9alWx6uy1WNWc/lfIC8XaP8GV7dvimV2yLhufvIXTGa0g/nf8OENtv18XarhsKv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NeFRanoe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NeFRanoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2638F1F00893;
	Fri, 29 May 2026 04:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028235;
	bh=2ivjNgUPPm09Cryh1kmjqGohzTIrYE7LThQA2SRSDrI=;
	h=Date:To:From:Subject;
	b=NeFRanoecBeq4jaK08T9gw498YD+uQbtnTu1Ew4fhyOGP+Ya6Oa8APU5wNPjoiEWi
	 B9DvwqGCnaso7gaaqsic4e+9Aj7PG5Lx/EriW9OcvbvZqv9fmSyd5d/jD4M15p8+zD
	 TJa2V7R/iYFFYvjcGJSmz3Lc/pegHMZUPvjCE6F8=
Date: Thu, 28 May 2026 21:17:14 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] riscv-fix-building-compressed-efi-image-fix.patch removed from -mm tree
Message-Id: <20260529041715.2638F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv-fix-building-compressed-efi-image-fix
has been removed from the -mm tree.  Its filename was
     riscv-fix-building-compressed-efi-image-fix.patch

This patch was dropped because it was folded into riscv-fix-building-compressed-efi-image.patch

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: riscv-fix-building-compressed-efi-image-fix
Date: Sat, 25 Apr 2026 06:07:22 +0300

fix loongarch32

Link: https://lore.kernel.org/8095016e47aceab4830c2523ce78af968ec0497e.camel@yandex.ru
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

 drivers/firmware/efi/libstub/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/libstub/Makefile~riscv-fix-building-compressed-efi-image-fix
+++ a/drivers/firmware/efi/libstub/Makefile
@@ -95,9 +95,10 @@ CFLAGS_zboot-decompress-gzip.o	+= -I$(sr
 zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
-zboot-riscv-obj-$(CONFIG_32BIT)	+= lib-ashldi3.o lib-lshrdi3.o
+zboot-riscv-obj-$(CONFIG_32BIT)	:= lib-ashldi3.o lib-lshrdi3.o
 zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)
-zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o lib-ashldi3.o
+zboot-loongarch-obj-$(CONFIG_32BIT) := lib-ashldi3.o lib-lshrdi3.o
+zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o $(zboot-loongarch-obj-y)
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
 
 lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch
lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch

