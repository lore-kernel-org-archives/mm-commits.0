From: akpm@linux-foundation.org
Subject: + kasan-rework-kconfig-settings.patch added to -mm tree
Date: Fri, 22 Dec 2017 14:41:51 -0800
Message-ID: <5a3d8a2f.XTV/3dp0HwXtj2VX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47708 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756091AbdLVWlw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Dec 2017 17:41:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mchehab@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rework Kconfig settings
has been added to the -mm tree.  Its filename is
     kasan-rework-kconfig-settings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-rework-kconfig-settings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-rework-kconfig-settings.patch

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
Subject: kasan: rework Kconfig settings

We get a lot of very large stack frames using gcc-7.0.1 with the default
-fsanitize-address-use-after-scope --param asan-stack=1 options, which can
easily cause an overflow of the kernel stack, e.g.

drivers/gpu/drm/i915/gvt/handlers.c:2434:1: warning: the frame size of 46176 bytes is larger than 3072 bytes
drivers/net/wireless/ralink/rt2x00/rt2800lib.c:5650:1: warning: the frame size of 23632 bytes is larger than 3072 bytes
lib/atomic64_test.c:250:1: warning: the frame size of 11200 bytes is larger than 3072 bytes
drivers/gpu/drm/i915/gvt/handlers.c:2621:1: warning: the frame size of 9208 bytes is larger than 3072 bytes
drivers/media/dvb-frontends/stv090x.c:3431:1: warning: the frame size of 6816 bytes is larger than 3072 bytes
fs/fscache/stats.c:287:1: warning: the frame size of 6536 bytes is larger than 3072 bytes

To reduce this risk, -fsanitize-address-use-after-scope is now split out
into a separate CONFIG_KASAN_EXTRA Kconfig option, leading to stack frames
that are smaller than 2 kilobytes most of the time on x86_64.  An earlier
version of this patch also prevented combining KASAN_EXTRA with
KASAN_INLINE, but that is no longer necessary with gcc-7.0.1.

All patches to get the frame size below 2048 bytes with CONFIG_KASAN=y and
CONFIG_KASAN_EXTRA=n have been merged by maintainers now, so we can bring
back that default now.  KASAN_EXTRA=y still causes lots of warnings but
now defaults to !COMPILE_TEST to disable it in allmodconfig, and it
remains disabled in all other defconfigs since it is a new option.  I
arbitrarily raise the warning limit for KASAN_EXTRA to 3072 to reduce the
noise, but an allmodconfig kernel still has around 50 warnings on gcc-7.

I experimented a bit more with smaller stack frames and have another
follow-up series that reduces the warning limit for 64-bit architectures
to 1280 bytes (without CONFIG_KASAN).

With earlier versions of this patch series, I also had patches to address
the warnings we get with KASAN and/or KASAN_EXTRA, using a
"noinline_if_stackbloat" annotation.  That annotation now got replaced
with a gcc-8 bugfix (see
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81715) and a workaround for
older compilers, which means that KASAN_EXTRA is now just as bad as before
and will lead to an instant stack overflow in a few extreme cases.

This reverts parts of commit commit 3f181b4 ("lib/Kconfig.debug: disable
-Wframe-larger-than warnings with KASAN=y").  Two patches in linux-next
should be merged first to avoid introducing warnings in an allmodconfig
build:
3cd890dbe2a4 ("media: dvb-frontends: fix i2c access helpers for KASAN")
16c3ada89cff ("media: r820t: fix r820t_write_reg for KASAN")

Link: http://lkml.kernel.org/r/20171221134744.2295529-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug      |    2 +-
 lib/Kconfig.kasan      |   11 +++++++++++
 scripts/Makefile.kasan |    3 +++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~kasan-rework-kconfig-settings lib/Kconfig.debug
--- a/lib/Kconfig.debug~kasan-rework-kconfig-settings
+++ a/lib/Kconfig.debug
@@ -217,7 +217,7 @@ config ENABLE_MUST_CHECK
 config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192
-	default 0 if KASAN
+	default 3072 if KASAN_EXTRA
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
 	default 1280 if (!64BIT && PARISC)
 	default 1024 if (!64BIT && !PARISC)
diff -puN lib/Kconfig.kasan~kasan-rework-kconfig-settings lib/Kconfig.kasan
--- a/lib/Kconfig.kasan~kasan-rework-kconfig-settings
+++ a/lib/Kconfig.kasan
@@ -20,6 +20,17 @@ config KASAN
 	  Currently CONFIG_KASAN doesn't work with CONFIG_DEBUG_SLAB
 	  (the resulting kernel does not boot).
 
+config KASAN_EXTRA
+	bool "KAsan: extra checks"
+	depends on KASAN && DEBUG_KERNEL && !COMPILE_TEST
+	help
+	  This enables further checks in the kernel address sanitizer, for now
+	  it only includes the address-use-after-scope check that can lead
+	  to excessive kernel stack usage, frame size warnings and longer
+	  compile time.
+	  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 has more
+
+
 choice
 	prompt "Instrumentation type"
 	depends on KASAN
diff -puN scripts/Makefile.kasan~kasan-rework-kconfig-settings scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-rework-kconfig-settings
+++ a/scripts/Makefile.kasan
@@ -38,5 +38,8 @@ else
 
 endif
 
+ifdef CONFIG_KASAN_EXTRA
 CFLAGS_KASAN += $(call cc-option, -fsanitize-address-use-after-scope)
 endif
+
+endif
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch
bugh-work-around-gcc-pr82365-in-bug.patch
kasan-rework-kconfig-settings.patch

