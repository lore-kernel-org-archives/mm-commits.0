From: akpm@linux-foundation.org
Subject: - eeepc-laptop-use-standard-interfaces-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:17 -0700
Message-ID: <200810182311.m9INBH0h027709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbYJRXMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, corentincj@iksaif.net, hmh@hmh.eng.br, mjg@redhat.com, sziwan@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     eeepc: depends on RFKILL
has been removed from the -mm tree.  Its filename was
     eeepc-laptop-use-standard-interfaces-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -409,6 +409,7 @@ config EEEPC_LAPTOP
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on HWMON
 	depends on EXPERIMENTAL
+	depends on RFKILL
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch

