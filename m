From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-oprofile.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:28 -0700
Message-ID: <200707162052.l6GKqSrx001549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760059AbXGPVcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, phil.el@wanadoo.fr, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - oprofile
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-oprofile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - oprofile
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/i386/Kconfig~use-menuconfig-objects-ii-oprofile arch/i386/Kconfig
--- a/arch/i386/Kconfig~use-menuconfig-objects-ii-oprofile
+++ a/arch/i386/Kconfig
@@ -1212,8 +1212,12 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-menu "Instrumentation Support"
+menuconfig INSTRUMENTATION
+	bool "Instrumentation Support"
 	depends on EXPERIMENTAL
+	default y
+
+if INSTRUMENTATION
 
 source "arch/i386/oprofile/Kconfig"
 
@@ -1226,7 +1230,8 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
-endmenu
+
+endif # INSTRUMENTATION
 
 source "arch/i386/Kconfig.debug"
 
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
