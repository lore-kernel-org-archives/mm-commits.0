From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-enable-instrumentation-of-global-variables-fix.patch removed from -mm tree
Date: Fri, 13 Feb 2015 14:30:06 -0800
Message-ID: <54de7aee.SXfndL5yJssJizPo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbBMWaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 17:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-enable-instrumentation-of-global-variables-fix
has been removed from the -mm tree.  Its filename was
     kasan-enable-instrumentation-of-global-variables-fix.patch

This patch was dropped because it was folded into kasan-enable-instrumentation-of-global-variables.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-enable-instrumentation-of-global-variables-fix

Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/Makefile.kasan~kasan-enable-instrumentation-of-global-variables-fix scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-enable-instrumentation-of-global-variables-fix
+++ a/scripts/Makefile.kasan
@@ -5,11 +5,11 @@ else
 	call_threshold := 0
 endif
 
-CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
+CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address --param asan-globals=1
 
 CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
 		-fasan-shadow-offset=$(CONFIG_KASAN_SHADOW_OFFSET) \
-		--param asan-stack=1 \
+		--param asan-stack=1 --param asan-globals=1 \
 		--param asan-instrumentation-with-call-threshold=$(call_threshold))
 
 ifeq ($(call cc-option, $(CFLAGS_KASAN_MINIMAL) -Werror),)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
module_device_table-fix-some-callsites.patch
kasan-enable-instrumentation-of-global-variables.patch
kasan-enable-instrumentation-of-global-variables-fix-2-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch

