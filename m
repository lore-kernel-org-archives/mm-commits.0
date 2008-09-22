From: akpm@linux-foundation.org
Subject: + toshiba_acpi-depends-on-input.patch added to -mm tree
Date: Mon, 22 Sep 2008 15:40:11 -0700
Message-ID: <200809222240.m8MMeBmT001803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYIVWlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 18:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, arvidjaar@mail.ru, lenb@kernel.org, rpurdie@rpsys.net


The patch titled
     toshiba_acpi: depends on INPUT
has been added to the -mm tree.  Its filename is
     toshiba_acpi-depends-on-input.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: toshiba_acpi: depends on INPUT
From: Randy Dunlap <randy.dunlap@oracle.com>

CONFIG_ACPI_TOSHIBA can =y when CONFIG_INPUT=m, so prevent that
combination and its subsequent build errors:

toshiba_acpi.c:(.text+0x3e877): undefined reference to `input_event'
toshiba_acpi.c:(.text+0x3e98a): undefined reference to `input_unregister_polled_device'
toshiba_acpi.c:(.text+0x3e994): undefined reference to `input_free_polled_device'
toshiba_acpi.c:(.init.text+0x21b4): undefined reference to `input_allocate_polled_device'
toshiba_acpi.c:(.init.text+0x2263): undefined reference to `input_register_polled_device'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/Kconfig~toshiba_acpi-depends-on-input drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~toshiba_acpi-depends-on-input
+++ a/drivers/acpi/Kconfig
@@ -270,7 +270,7 @@ config ACPI_PANASONIC
 
 config ACPI_TOSHIBA
 	tristate "Toshiba Laptop Extras"
-	depends on X86
+	depends on X86 && INPUT
 	select INPUT_POLLDEV
 	select NET
 	select RFKILL
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-allow-structs-whose-members-are-all-private.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
drivers-net-hp-plusc-fix-build-error.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

