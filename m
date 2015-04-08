From: akpm@linux-foundation.org
Subject: + kasan-makefile-shut-up-warnings-if-config_compile_test=y.patch
 added to -mm tree
Date: Wed, 08 Apr 2015 15:39:40 -0700
Message-ID: <5525ae2c.5guH3kljV4XhrEJK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbbDHWjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2015 18:39:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: Makefile: shut up warnings if CONFIG_COMPILE_TEST=y
has been added to the -mm tree.  Its filename is
     kasan-makefile-shut-up-warnings-if-config_compile_test=y.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-makefile-shut-up-warnings-if-config_compile_test%3Dy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-makefile-shut-up-warnings-if-config_compile_test%3Dy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
mm-expose-arch_mmap_rnd-when-available.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix.patch
mm-mempool-kasan-poison-mempool-elements.patch
kasan-makefile-shut-up-warnings-if-config_compile_test=y.patch
gcov-fix-softlockups.patch
linux-next.patch

