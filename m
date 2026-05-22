Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD749460
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 00:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779408650; cv=none; b=JMdjxL6iUvvgyPOnK/SDy636KZiN2Y8knPpFX/zn8fSPLTIOXY6hvacVH4vEYBRcGKk9Uk5GvxNKZ+oEq8c6eVIgI9bicDPVRXNSAQB/ADw6IBwFet7eR7pdxKkKMVX6WcIA6H5efhj3R9DyzZVDv9L4EpVPiz+tk52w2f6eTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779408650; c=relaxed/simple;
	bh=j2j7FUQieNj0KfiX+yISPqBKJ409FDMh+4bG8sPcirI=;
	h=Date:To:From:Subject:Message-Id; b=Tcmywem4DLKd2A8/Mk1Y02LUxPPCeK3qKrTUIjvuuGfrZ7s8W8+ESwD0Nt3gU7yyubhvN8m6c4TWHn9Ajtm+BRaS3mLMiwxSUtzCsqAmtoh1+ZRA2RJBYIbXR1PNepGgnQFuOYc6Ua1BhifD18BF5h4PeSQs13l3NMY1M6vmSXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oE3otfuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oE3otfuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193251F000E9;
	Fri, 22 May 2026 00:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779408649;
	bh=kpJAo3TOrOvhdOBPh9Rn8J5RD1y49JcYUZtQYFkIcXA=;
	h=Date:To:From:Subject;
	b=oE3otfuMDgFnhYc0vctgXiEWV0NwwnIfDEqx5Mntrr2eCe6Tzcu+K8udqStH4Uryz
	 lURPMuai5mfSd0NBG5lhGJzI9RSdN2AyCHsZhSrATYWUtEXdJcxLs+RZOoK/bDWuXM
	 dM4LWuuFn5Wmh3VVNq01813v3jnzsvuc3UQkIEb0=
Date: Thu, 21 May 2026 17:10:48 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-fix-building-compressed-efi-image-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260522001049.193251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv-fix-building-compressed-efi-image-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-fix-building-compressed-efi-image-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-fix-building-compressed-efi-image-fix.patch

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

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch
riscv-fix-building-compressed-efi-image-fix.patch

