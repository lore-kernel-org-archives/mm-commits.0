Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC302C21E8
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236257; cv=none; b=XEYlzN0o5GfzvlGZVLvt0CmbCpd4YcJw9TntutxY90mthMk4YMEJU/RiaWsjBwc0V5YbaAPYs7cYR3Wx101x4vG6mXNlG6QDliqisvhobjiJGYwsiTbbc8ZhHy2sS9eakkCc2IBgM8h8UXfDrxIxTJgHeV6N0HGBHEI0bsMYmsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236257; c=relaxed/simple;
	bh=Hu7iZuCUS+SFnd42VEdUQawIQZ+BxQmaWWNXAuJyjug=;
	h=Date:To:From:Subject:Message-Id; b=pQNf+dBLVRTQCGc5NEit8UCi6W1hSY1a9jTLGP4bZD8Hd4UUyVJ1jXavQzXavkkpFdPdaHN5g4F/ObAOLvVdddEbxlbzqBeAIoVpiQcXRgP42d6XQe+LFFlqIsHEXjb6lOyMhPKmmCnWZvS+wYUvRJtvcghfpHhBOgCneuiBSds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uBA3ScXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uBA3ScXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BE0C4CEF7;
	Fri,  3 Apr 2026 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775236256;
	bh=Hu7iZuCUS+SFnd42VEdUQawIQZ+BxQmaWWNXAuJyjug=;
	h=Date:To:From:Subject:From;
	b=uBA3ScXUDrIn5WW6PXo8ijzwgptHfUFpBAw0gJoTkHhOZVGBh/zo6YSjbtkWYXhUy
	 cQtC2vvs8VBp20AvI66c5vcakjebgU7LsMj8fxd9PXa9igmWe1juxCjoMOMaZB70Zz
	 1NlR2t1e/aao24zJKk5j9eQxyNW0dIA4ugmXshkE=
Date: Fri, 03 Apr 2026 10:10:56 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-export-symbols-needed-for-riscv32-efi-stub.patch added to mm-nonmm-unstable branch
Message-Id: <20260403171056.B3BE0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: export symbols needed for riscv32 EFI stub
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-export-symbols-needed-for-riscv32-efi-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-export-symbols-needed-for-riscv32-efi-stub.patch

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
Subject: riscv: export symbols needed for riscv32 EFI stub
Date: Fri, 3 Apr 2026 13:33:38 +0300

Fix the following link error observed when building EFI-enabled kernel
with CONFIG_EFI_STUB=y and CONFIG_EFI_GENERIC_STUB=y:

riscv32-linux-gnu-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
__efistub_cmdline.c:(.init.text+0x1f2): undefined reference to `__efistub___ashldi3'
riscv32-linux-gnu-ld: __efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'

Note: compile (gcc 15.2.1 and clang 21.1.8) tested only.

Link: https://lkml.kernel.org/r/20260403103338.1122415-7-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603041925.KLKqpK6N-lkp@intel.com
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/image-vars.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/riscv/kernel/image-vars.h~riscv-export-symbols-needed-for-riscv32-efi-stub
+++ a/arch/riscv/kernel/image-vars.h
@@ -32,6 +32,15 @@ __efistub___init_text_end	= __init_text_
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
 
+#ifdef CONFIG_CC_IS_GCC
+/*
+ * Double-word integer shifts are used by the library code and so EFI stub as
+ * well. Not needed for clang and please let me know if anyone understands why.
+ */
+PROVIDE(__efistub___lshrdi3    = __lshrdi3);
+PROVIDE(__efistub___ashldi3    = __ashldi3);
+#endif /* CONFIG_CC_IS_GCC */
+
 #endif
 
 #endif /* __RISCV_KERNEL_IMAGE_VARS_H */
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-export-symbols-needed-for-riscv32-efi-stub.patch

