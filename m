From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-use-address-of-operator-on-section-symbols.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:36:01 -0700
Message-ID: <20200403203601.sP2GZvHa_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org, natechancellor@gmail.com, ndesaulniers@google.com


The patch titled
     Subject: mm/kmemleak.c: use address-of operator on section symbols
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-use-address-of-operator-on-section-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: mm/kmemleak.c: use address-of operator on section symbols

Clang warns:

../mm/kmemleak.c:1955:28: warning: array comparison always evaluates to a constant [-Wtautological-compare]
        if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)
                                  ^
../mm/kmemleak.c:1955:60: warning: array comparison always evaluates to a constant [-Wtautological-compare]
        if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)


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

kernel-extable-use-address-of-operator-on-section-symbols.patch
dynamic_debug-use-address-of-operator-on-section-symbols.patch
