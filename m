Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E1D395AE3
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 03:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644775; cv=none; b=cdptjLECu9D/GS6z5rVhQSpfO+HObcMR8ixW4rNOE03/u/IzbIGgRDpdfN5AMeqxkFl05yoix2XvptwPE/tkTyOPgulNruOfF/XkJSfKsQS10wsdoy09llzzACcv8uFTR9bhclllgy/fOTbIJR4A61PI6P9SFq3pTqaU0s+rams=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644775; c=relaxed/simple;
	bh=GlOjjdGeYsy4lsn1BLQ1PG1HooEZIm7lC2lVRhJYx3E=;
	h=Date:To:From:Subject:Message-Id; b=mR/sCMS3yvRLknQACVesZVvdpUGWV3BT2wqfxXFAe0XhJoVYlhbU45PkeQ3VupbRRDDZEJhSuhEBHCSNxIqASfVAozrzDZww1rjglrMpdOi2p3ZVRRnPoxJQzF7uXapsHPNwypszLpP0rbkZGLtpgnPAfg7uy5WfyighZY0SuXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S5nmu/rL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S5nmu/rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA02C2BCC7;
	Wed, 13 May 2026 03:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778644775;
	bh=GlOjjdGeYsy4lsn1BLQ1PG1HooEZIm7lC2lVRhJYx3E=;
	h=Date:To:From:Subject:From;
	b=S5nmu/rLSjrQ3nQ8ktZpNYQ/HTNNX7qg019tDfYkB3OwO/WwDbPi3Nr0xIQPooQmP
	 5rekfEQEOl65n5wpRTCDVbzYPWv0Wz5V4YugAp99CrOqwviAj+637OuSY4a8CMMyE/
	 a0BcFoYx7Vm4V9iKB7Z47Duc+RaLYFkE9FdSWit8=
Date: Tue, 12 May 2026 20:59:34 -0700
To: mm-commits@vger.kernel.org,pjw@kernel.org,palmer@dabbelt.com,nathan@kernel.org,lkp@intel.com,kees@kernel.org,djwong@kernel.org,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] riscv-export-symbols-needed-for-riscv32-efi-stub.patch removed from -mm tree
Message-Id: <20260513035935.1BA02C2BCC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: export symbols needed for riscv32 EFI stub
has been removed from the -mm tree.  Its filename was
     riscv-export-symbols-needed-for-riscv32-efi-stub.patch

This patch was dropped because an updated version will be issued

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

Link: https://lore.kernel.org/20260403103338.1122415-7-dmantipov@yandex.ru
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

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch

