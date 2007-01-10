From: akpm@osdl.org
Subject: - qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch removed from -mm tree
Date: Tue, 09 Jan 2007 16:58:23 -0800
Message-ID: <200701100058.l0A0wNiZ020266@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606AbXAJA6j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 19:58:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fzu@wemgehoertderstaat.de, randy.dunlap@oracle.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     qconf: immediately update integer and string values in xconfig display
has been removed from the -mm tree.  Its filename was
     qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: qconf: immediately update integer and string values in xconfig display
From: Karsten Wiese <fzu@wemgehoertderstaat.de>

In xconfig's display integer and string values are also shown as part of
the config item's descriptive text.

This patch updates the descriptive text, when the corresponding value has
been changed.  Fix for http://bugzilla.kernel.org/show_bug.cgi?id=7744

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/kconfig/qconf.cc~qconf-immediately-update-integer-and-string-values-in-xconfig-display scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-immediately-update-integer-and-string-values-in-xconfig-display
+++ a/scripts/kconfig/qconf.cc
@@ -89,6 +89,8 @@ void ConfigItem::okRename(int col)
 {
 	Parent::okRename(col);
 	sym_set_string_value(menu->sym, text(dataColIdx).latin1());
+	sym_calc_value(menu->sym);
+	updateMenu();
 }
 #endif
 
_

Patches currently in -mm which might be from fzu@wemgehoertderstaat.de are

qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch
