From: akpm@linux-foundation.org
Subject: +
 ubsan-dont-mark-__ubsan_handle_builtin_unreachable-as-noreturn.patch added
 to -mm tree
Date: Fri, 02 Feb 2018 11:51:26 -0800
Message-ID: <5a74c13e.YPAN5mYMGKrYq6u2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752824AbeBBTv1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Feb 2018 14:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ak@linux.intel.com, aryabinin@virtuozzo.com, nico@linaro.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: don't mark __ubsan_handle_builtin_unreachable as noreturn
has been added to the -mm tree.  Its filename is
     ubsan-dont-mark-__ubsan_handle_builtin_unreachable-as-noreturn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-dont-mark-__ubsan_handle_builtin_unreachable-as-noreturn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-dont-mark-__ubsan_handle_builtin_unreachable-as-noreturn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ubsan: don't mark __ubsan_handle_builtin_unreachable as noreturn

gcc-8 complains about the prototype for this function:

lib/ubsan.c:432:1: error: ignoring attribute 'noreturn' in declaration of a built-in function '__ubsan_handle_builtin_unreachable' because it conflicts with attribute 'const' [-Werror=attributes]

This removes the noreturn attribute.

Link: http://lkml.kernel.org/r/20180202154813.1625742-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/ubsan.c~ubsan-dont-mark-__ubsan_handle_builtin_unreachable-as-noreturn lib/ubsan.c
--- a/lib/ubsan.c~ubsan-dont-mark-__ubsan_handle_builtin_unreachable-as-noreturn
+++ a/lib/ubsan.c
@@ -423,7 +423,7 @@ void __ubsan_handle_shift_out_of_bounds(
 EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
 
 
-void __noreturn
+void
 __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
 {
 	unsigned long flags;
_

Patches currently in -mm which might be from arnd@arndb.de are

locking-qrwlock-include-asm-byteorderh-as-needed.patch
kbuild-always-define-endianess-in-kconfigh.patch
ubsan-dont-mark-__ubsan_handle_builtin_unreachable-as-noreturn.patch
kasan-added-functions-for-unpoisoning-stack-variables-fix-fix.patch
bugh-work-around-gcc-pr82365-in-bug.patch
bitmap-replace-bitmap_fromto_u32array-fix.patch
nilfs2-use-time64_t-internally.patch
pps-parport-use-timespec64-instead-of-timespec.patch
kasan-rework-kconfig-settings.patch

