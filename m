From: akpm@linux-foundation.org
Subject: + eeepc-laptop-use-standard-interfaces-fix.patch added to -mm tree
Date: Wed, 17 Sep 2008 14:32:17 -0700
Message-ID: <200809172132.m8HLWIG3031469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbYIQVeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, corentincj@iksaif.net, hmh@hmh.eng.br, mjg@redhat.com, sziwan@users.sourceforge.net


The patch titled
     eeepc: depends on RFKILL
has been added to the -mm tree.  Its filename is
     eeepc-laptop-use-standard-interfaces-fix.patch

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
Subject: eeepc: depends on RFKILL
From: Randy Dunlap <randy.dunlap@oracle.com>

EEEPC_LAPTOP uses RFKILL, so the former should depend on RFKILL.
Build errors happen when EEEPC_LAPTOP=y and RFKILL=m.

eeepc-laptop.c:(.text+0xd5a7b): undefined reference to `rfkill_allocate'
eeepc-laptop.c:(.text+0xd5b04): undefined reference to `rfkill_register'
eeepc-laptop.c:(.text+0xd5b48): undefined reference to `rfkill_allocate'
eeepc-laptop.c:(.text+0xd5bd4): undefined reference to `rfkill_register'
eeepc-laptop.c:(.text+0xd5ece): undefined reference to `rfkill_unregister'
eeepc-laptop.c:(.text+0xd5ef6): undefined reference to `rfkill_unregister'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~eeepc-laptop-use-standard-interfaces-fix drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~eeepc-laptop-use-standard-interfaces-fix
+++ a/drivers/misc/Kconfig
@@ -410,6 +410,7 @@ config EEEPC_LAPTOP
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on HWMON
 	depends on EXPERIMENTAL
+	depends on RFKILL
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-allow-structs-whose-members-are-all-private.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
drivers-net-hp-plusc-fix-build-error.patch
eeepc-laptop-use-standard-interfaces-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

