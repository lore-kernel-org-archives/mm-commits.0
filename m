From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-use-address-of-operator-on-section-symbols.patch added to -mm
 tree
Date: Thu, 20 Feb 2020 17:35:24 -0800
Message-ID: <20200221013524.DBWq_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbgBUBf0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 20:35:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ndesaulniers@google.com, catalin.marinas@arm.com, natechancellor@gmail.com


The patch titled
     Subject: mm/kmemleak.c: use address-of operator on section symbols
has been added to the -mm tree.  Its filename is
     mm-kmemleak-use-address-of-operator-on-section-symbols.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-use-address-of-operator-on-section-symbols.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-use-address-of-operator-on-section-symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: mm/kmemleak.c: use address-of operator on section symbols

Clang warns:

These are not true arrays, they are linker defined symbols, which are just
addresses.  Using the address of operator silences the warning and does
not change the resulting assembly with either clang/ld.lld or gcc/ld
(tested with diff + objdump -Dr).

Link: https://github.com/ClangBuiltLinux/linux/issues/895
Link: http://lkml.kernel.org/r/20200220051551.44000-1-natechancellor@gmail.com
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-address-of-operator-on-section-symbols
+++ a/mm/kmemleak.c
@@ -1947,7 +1947,7 @@ void __init kmemleak_init(void)
 	create_object((unsigned long)__bss_start, __bss_stop - __bss_start,
 		      KMEMLEAK_GREY, GFP_ATOMIC);
 	/* only register .data..ro_after_init if not within .data */
-	if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)
+	if (&__start_ro_after_init < &_sdata || &__end_ro_after_init > &_edata)
 		create_object((unsigned long)__start_ro_after_init,
 			      __end_ro_after_init - __start_ro_after_init,
 			      KMEMLEAK_GREY, GFP_ATOMIC);
_

Patches currently in -mm which might be from natechancellor@gmail.com are

mm-kmemleak-use-address-of-operator-on-section-symbols.patch
kernel-extable-use-address-of-operator-on-section-symbols.patch
