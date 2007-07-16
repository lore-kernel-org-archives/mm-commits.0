From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-connector.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:37 -0700
Message-ID: <200707162052.l6GKqbYd001558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776AbXGPVcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: connector
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-connector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: connector
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/connector/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/connector/Kconfig~use-menuconfig-objects-connector drivers/connector/Kconfig
--- a/drivers/connector/Kconfig~use-menuconfig-objects-connector
+++ a/drivers/connector/Kconfig
@@ -1,6 +1,5 @@
-menu "Connector - unified userspace <-> kernelspace linker"
 
-config CONNECTOR
+menuconfig CONNECTOR
 	tristate "Connector - unified userspace <-> kernelspace linker"
 	depends on NET
 	---help---
@@ -10,6 +9,8 @@ config CONNECTOR
 	  Connector support can also be built as a module.  If so, the module
 	  will be called cn.ko.
 
+if CONNECTOR
+
 config PROC_EVENTS
 	boolean "Report process events to userspace"
 	depends on CONNECTOR=y
@@ -18,4 +19,4 @@ config PROC_EVENTS
 	  Provide a connector that reports process events to userspace. Send
 	  events such as fork, exec, id change (uid, gid, suid, etc), and exit.
 
-endmenu
+endif # CONNECTOR
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
