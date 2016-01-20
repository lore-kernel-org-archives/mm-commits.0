From: akpm@linux-foundation.org
Subject: [folded-merged]
 ubsan-run-time-undefined-behavior-sanity-checker-fix-5.patch removed from
 -mm tree
Date: Wed, 20 Jan 2016 14:36:17 -0800
Message-ID: <56a00be1.NOnbpCavoa98i/Bm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbcATWgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:36:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-5
has been removed from the -mm tree.  Its filename was
     ubsan-run-time-undefined-behavior-sanity-checker-fix-5.patch

This patch was dropped because it was folded into ubsan-run-time-undefined-behavior-sanity-checker.patch

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

