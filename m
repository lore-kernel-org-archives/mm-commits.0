From: akpm@linux-foundation.org
Subject: + remove-__init_refok-and-__initdata_refok.patch added to -mm tree
Date: Wed, 30 Jan 2008 15:00:55 -0800
Message-ID: <200801302300.m0UN0tjl029187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762536AbYA3XBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 18:01:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, sam@ravnborg.org


The patch titled
     Remove __INIT_REFOK and __INITDATA_REFOK
has been added to the -mm tree.  Its filename is
     remove-__init_refok-and-__initdata_refok.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove __INIT_REFOK and __INITDATA_REFOK
From: Ralf Baechle <ralf@linux-mips.org>

Commit 312b1485fb509c9bc32eda28ad29537896658cb8 made __INIT_REFOK expand
into .section .section ".ref.text", "ax".  Since the assembler doesn't
tolerate stuttering in the source that broke all MIPS builds.

Since with this change Sam downgraded __INIT_REFOK to just a backward
compat thing and there being only a single use in the MIPS arch code the
best solution is to delete both of __INIT_REFOK and __INITDATA_REFOK (which
was equally broken) being unused anyway these can be deleted.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/init.h~remove-__init_refok-and-__initdata_refok include/linux/init.h
--- a/include/linux/init.h~remove-__init_refok-and-__initdata_refok
+++ a/include/linux/init.h
@@ -124,9 +124,6 @@
 #define __REF            .section       ".ref.text", "ax"
 #define __REFDATA        .section       ".ref.data", "aw"
 #define __REFCONST       .section       ".ref.rodata", "aw"
-/* backward compatibility */
-#define __INIT_REFOK     .section	__REF
-#define __INITDATA_REFOK .section	__REFDATA
 
 #ifndef __ASSEMBLY__
 /*
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-acpi.patch
git-mips.patch
git-net.patch
git-watchdog.patch
git-x86.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-inclusions-of-linux-autoconfh.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
calibrate_delay-must-be-__cpuinit.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
dzc-use-a-helper-to-cast-from-struct-uart_port.patch
dzc-resource-management.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
avoid-overflows-in-kernel-timec.patch
remove-__init_refok-and-__initdata_refok.patch
