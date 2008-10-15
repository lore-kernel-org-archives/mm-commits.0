From: akpm@linux-foundation.org
Subject: - toshiba_acpi-depends-on-input.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:13:22 -0700
Message-ID: <200810152113.m9FLDM98005555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267AbYJOVOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, arvidjaar@mail.ru, lenb@kernel.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     toshiba_acpi: depends on INPUT
has been removed from the -mm tree.  Its filename was
     toshiba_acpi-depends-on-input.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
documentation-explain-memory-barriers.patch
taint-fix-kernel-doc.patch
framebuffer-fix-carminefb-section-mismatch.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

