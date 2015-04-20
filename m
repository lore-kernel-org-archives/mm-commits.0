From: akpm@linux-foundation.org
Subject: [merged]
 kasan-makefile-shut-up-warnings-if-config_compile_test=y.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:28 -0700
Message-ID: <553550c8.XzOPDJDwLVzCFXdQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbDTTLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: Makefile: shut up warnings if CONFIG_COMPILE_TEST=y
has been removed from the -mm tree.  Its filename was
     kasan-makefile-shut-up-warnings-if-config_compile_test=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan: Makefile: shut up warnings if CONFIG_COMPILE_TEST=y

It might be annoying to constantly see this:

	scripts/Makefile.kasan:16: Cannot use CONFIG_KASAN: -fsanitize=kernel-address is not supported by compiler

while performing allmodconfig/allyesconfig build tests.
Disable this warning if CONFIG_COMPILE_TEST=y.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN scripts/Makefile.kasan~kasan-makefile-shut-up-warnings-if-config_compile_test=y scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-makefile-shut-up-warnings-if-config_compile_test=y
+++ a/scripts/Makefile.kasan
@@ -13,12 +13,16 @@ CFLAGS_KASAN := $(call cc-option, -fsani
 		--param asan-instrumentation-with-call-threshold=$(call_threshold))
 
 ifeq ($(call cc-option, $(CFLAGS_KASAN_MINIMAL) -Werror),)
+   ifneq ($(CONFIG_COMPILE_TEST),y)
         $(warning Cannot use CONFIG_KASAN: \
             -fsanitize=kernel-address is not supported by compiler)
+   endif
 else
     ifeq ($(CFLAGS_KASAN),)
-        $(warning CONFIG_KASAN: compiler does not support all options.\
-            Trying minimal configuration)
+        ifneq ($(CONFIG_COMPILE_TEST),y)
+            $(warning CONFIG_KASAN: compiler does not support all options.\
+                Trying minimal configuration)
+        endif
         CFLAGS_KASAN := $(CFLAGS_KASAN_MINIMAL)
     endif
 endif
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
linux-next.patch

