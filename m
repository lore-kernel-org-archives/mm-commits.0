From: akpm@linux-foundation.org
Subject: + esp-fix-section-mismatch-warning.patch added to -mm tree
Date: Fri, 10 Oct 2008 13:15:37 -0700
Message-ID: <200810102015.m9AKFbbe030260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760926AbYJJUP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 16:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, arobinso@nyx.net


The patch titled
     esp: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     esp-fix-section-mismatch-warning.patch

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
Subject: esp: fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Not critical.

WARNING: drivers/char/esp.o(.text+0x278): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_version
The function show_serial_version() references
the variable __initdata serial_version.
This is often because show_serial_version lacks a __initdata
annotation or the annotation of serial_version is wrong.

WARNING: drivers/char/esp.o(.text+0x27d): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_name
The function show_serial_version() references
the variable __initdata serial_name.
This is often because show_serial_version lacks a __initdata
annotation or the annotation of serial_name is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew J. Robinson <arobinso@nyx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/esp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/esp.c~esp-fix-section-mismatch-warning drivers/char/esp.c
--- a/drivers/char/esp.c~esp-fix-section-mismatch-warning
+++ a/drivers/char/esp.c
@@ -2249,7 +2249,7 @@ static int esp_open(struct tty_struct *t
  * driver.
  */
 
-static void show_serial_version(void)
+static void __init show_serial_version(void)
 {
 	printk(KERN_INFO "%s version %s (DMA %u)\n",
 		serial_name, serial_version, dma);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-tip.patch
git-hid.patch
git-net.patch
git-sound.patch
git-block.patch
git-drm.patch
git-security-testing.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
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
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
documentation-explain-memory-barriers.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

