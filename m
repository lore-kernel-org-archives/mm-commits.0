From: akpm@linux-foundation.org
Subject: [merged] x86-fix-build-failure.patch removed from -mm tree
Date: Fri, 02 Oct 2015 12:36:12 -0700
Message-ID: <560edcac.JFgXghr3uMqRWkUK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbJBTgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 15:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryabinin.a.a@gmail.com, mingo@kernel.org, sedat.dilek@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/include/asm/efi.h: fix build failure
has been removed from the -mm tree.  Its filename was
     x86-fix-build-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: arch/x86/include/asm/efi.h: fix build failure

With KMEMCHECK=y, KASAN=n:

arch/x86/platform/efi/efi.c:673:3: error: implicit declaration of function `memcpy' [-Werror=implicit-function-declaration]
arch/x86/platform/efi/efi_64.c:139:2: error: implicit declaration of function `memcpy' [-Werror=implicit-function-declaration]
arch/x86/include/asm/desc.h:121:2: error: implicit declaration of function `memcpy' [-Werror=implicit-function-declaration]

Don't #undef memcpy if KASAN=n.

Fixes: 769a8089c1fd ("x86, efi, kasan: #undef memset/memcpy/memmove per arch")
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reported-by: Ingo Molnar <mingo@kernel.org>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/efi.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/include/asm/efi.h~x86-fix-build-failure arch/x86/include/asm/efi.h
--- a/arch/x86/include/asm/efi.h~x86-fix-build-failure
+++ a/arch/x86/include/asm/efi.h
@@ -86,6 +86,7 @@ extern u64 asmlinkage efi_call(void *fp,
 extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
 					u32 type, u64 attribute);
 
+#ifdef CONFIG_KASAN
 /*
  * CONFIG_KASAN may redefine memset to __memset.  __memset function is present
  * only in kernel binary.  Since the EFI stub linked into a separate binary it
@@ -95,6 +96,7 @@ extern void __iomem *__init efi_ioremap(
 #undef memcpy
 #undef memset
 #undef memmove
+#endif
 
 #endif /* CONFIG_X86_32 */
 
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are


