From: akpm@linux-foundation.org
Subject: [merged]
 kernel-extable-use-address-of-operator-on-section-symbols.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:00:28 -0700
Message-ID: <20200408020028.elfuInH1R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgDHCA3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, natechancellor@gmail.com, ndesaulniers@google.com


The patch titled
     Subject: kernel/extable.c: use address-of operator on section symbols
has been removed from the -mm tree.  Its filename was
     kernel-extable-use-address-of-operator-on-section-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
