From: akpm@linux-foundation.org
Subject: + ubsan-run-time-undefined-behavior-sanity-checker-fix-5.patch
 added to -mm tree
Date: Mon, 04 Jan 2016 13:03:29 -0800
Message-ID: <568ade21.9d/NeLR26ulWQct2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbcADVD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 16:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-5
has been added to the -mm tree.  Its filename is
     ubsan-run-time-undefined-behavior-sanity-checker-fix-5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-run-time-undefined-behavior-sanity-checker-fix-5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-run-time-undefined-behavior-sanity-checker-fix-5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-5

Don't use 'bounds-strict' checker. It's a new checker that showed up
in GCC 6. It appeared to cause a lot of false positives in dynamically
allocated structs which has array as the last field, e.g:
	[   72.707515] UBSAN: Undefined behaviour in kernel/pid.c:506:23
	[   72.707517] index 2 is out of range for type 'upid [1]'

Anyway, we have KASAN for these kind of bugs, so we won't lose much by
disabling bounds-strict.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.ubsan |    1 -
 1 file changed, 1 deletion(-)

diff -puN scripts/Makefile.ubsan~ubsan-run-time-undefined-behavior-sanity-checker-fix-5 scripts/Makefile.ubsan
--- a/scripts/Makefile.ubsan~ubsan-run-time-undefined-behavior-sanity-checker-fix-5
+++ a/scripts/Makefile.ubsan
@@ -6,7 +6,6 @@ ifdef CONFIG_UBSAN
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=null)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=signed-integer-overflow)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds-strict)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=object-size)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=returns-nonnull-attribute)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

kernel-printk-specify-alignment-for-struct-printk_log.patch
mac80211-prevent-build-failure-with-config_ubsan=y.patch
ubsan-run-time-undefined-behavior-sanity-checker.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-2.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-4.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-5.patch

