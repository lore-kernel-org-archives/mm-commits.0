From: akpm@linux-foundation.org
Subject: +
 kernel-extable-use-address-of-operator-on-section-symbols.patch added to -mm
 tree
Date: Wed, 19 Feb 2020 12:51:38 -0800
Message-ID: <20200219205138.GYS4C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUvj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 15:51:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ndesaulniers@google.com, akpm@linux-foundation.org, natechancellor@gmail.com


The patch titled
     Subject: kernel/extable.c: use address-of operator on section symbols
has been added to the -mm tree.  Its filename is
     kernel-extable-use-address-of-operator-on-section-symbols.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-extable-use-address-of-operator-on-section-symbols.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-extable-use-address-of-operator-on-section-symbols.patch

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
Subject: kernel/extable.c: use address-of operator on section symbols

Clang warns:

../kernel/extable.c:37:52: warning: array comparison always evaluates to
a constant [-Wtautological-compare]
        if (main_extable_sort_needed && __stop___ex_table > __start___ex_table) {
                                                          ^
1 warning generated.

These are not true arrays, they are linker defined symbols, which are just
addresses.  Using the address of operator silences the warning and does
not change the resulting assembly with either clang/ld.lld or gcc/ld
(tested with diff + objdump -Dr).

Link: https://github.com/ClangBuiltLinux/linux/issues/892
Link: http://lkml.kernel.org/r/20200219202036.45702-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/extable.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/extable.c~kernel-extable-use-address-of-operator-on-section-symbols
+++ a/kernel/extable.c
@@ -34,7 +34,8 @@ u32 __initdata __visible main_extable_so
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
 {
-	if (main_extable_sort_needed && __stop___ex_table > __start___ex_table) {
+	if (main_extable_sort_needed &&
+	    &__stop___ex_table > &__start___ex_table) {
 		pr_notice("Sorting __ex_table...\n");
 		sort_extable(__start___ex_table, __stop___ex_table);
 	}
_

Patches currently in -mm which might be from natechancellor@gmail.com are

kernel-extable-use-address-of-operator-on-section-symbols.patch
