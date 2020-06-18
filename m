From: akpm@linux-foundation.org
Subject: + kernel-panicc-make-oops_may_print-return-bool.patch added
 to -mm tree
Date: Wed, 17 Jun 2020 18:52:36 -0700
Message-ID: <20200618015236.1kc--%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731702AbgFRBwh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lixuefeng@loongson.cn, keescook@chromium.org, yangtiezhu@loongson.cn


The patch titled
     Subject: kernel/panic.c: make oops_may_print() return bool
has been added to the -mm tree.  Its filename is
     kernel-panicc-make-oops_may_print-return-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-panicc-make-oops_may_print-return-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-panicc-make-oops_may_print-return-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: kernel/panic.c: make oops_may_print() return bool

The return value of oops_may_print() is true or false, so change its type
to reflect that.

Link: http://lkml.kernel.org/r/1591103358-32087-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 kernel/panic.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/kernel.h~kernel-panicc-make-oops_may_print-return-bool
+++ a/include/linux/kernel.h
@@ -322,7 +322,7 @@ void nmi_panic(struct pt_regs *regs, con
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
-extern int oops_may_print(void);
+extern bool oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
--- a/kernel/panic.c~kernel-panicc-make-oops_may_print-return-bool
+++ a/kernel/panic.c
@@ -505,7 +505,7 @@ static void do_oops_enter_exit(void)
  * Return true if the calling CPU is allowed to print oops-related info.
  * This is a bit racy..
  */
-int oops_may_print(void)
+bool oops_may_print(void)
 {
 	return pause_on_oops_flag == 0;
 }
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

selftests-kmod-use-variable-name-in-kmod_test_0001.patch
kmod-remove-redundant-be-an-in-the-comment.patch
test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch
kernel-panicc-make-oops_may_print-return-bool.patch
lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch
