Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644BF78F26
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717337; cv=none; b=rpm5jMBVW+pJk90FP76HG2r5wgPU5kj9bRcRFqhU79xLDY1xg2X8ucOqFFN0vnkWLI/pce3o6MPgGRAU3Q3+RxojrvkWhkmQ8nNMrjgbjNhyuJUPvaMNGegSlosLA++GwNnhS7tJmqm4tipRXazmeMP6C7kfeskb5gvNd+ooRvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717337; c=relaxed/simple;
	bh=XQTzXo/R1p3aP6oThQ+8J2xVgbki5ZCJlX+0+pXhOjs=;
	h=Date:To:From:Subject:Message-Id; b=LhlfCHYvfsTDRnownCvm8M6TFoiXe7ukHkZDEYioFBmxdWc1UJAgEAjv/hqqxQONX356V5FINLDwXKIGkixidpkBq9xQY2cQaIIOK+qmSqaaBH7h5i2PAK+Ae/LwUKSXwU65qI4dgO1I7pEnnmxVzb4+GouDs5ImO8svEeFm0dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j3esPkVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3esPkVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CE4C19425;
	Thu, 14 May 2026 00:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778717337;
	bh=XQTzXo/R1p3aP6oThQ+8J2xVgbki5ZCJlX+0+pXhOjs=;
	h=Date:To:From:Subject:From;
	b=j3esPkVFqHn8b1YTjgLeRnb+iqassfVOHVVygXqYjUBDtYO627dtZ4ybj7SCHDbDe
	 61RXtCqmieJP2HOUl440VrZ31HXNqlXx4BMertpz20ix1QYk/DZ7NKPsK7sfUeCOKR
	 8IVUJDdeMbZytx3dgRd6yLdZVXkiKo/h1RKcbSeA=
Date: Wed, 13 May 2026 17:08:56 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,lkp@intel.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-fix-building-compressed-efi-image.patch added to mm-nonmm-unstable branch
Message-Id: <20260514000857.36CE4C19425@smtp.kernel.org>
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
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

