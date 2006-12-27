From: akpm@osdl.org
Subject: + qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:09:36 -0800
Message-ID: <200612270909.kBR99a4s006434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42663 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbWL0JJt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:09:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fzu@wemgehoertderstaat.de, randy.dunlap@oracle.com, zippel@linux-m68k.org


The patch titled
     qconf: immediately update integer and string values in xconfig display
has been added to the -mm tree.  Its filename is
     qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: qconf: immediately update integer and string values in xconfig display
From: Karsten Wiese <fzu@wemgehoertderstaat.de>

In xconfig's display integer and string values are also shown as part of
the config item's descriptive text.

This patch updates the descriptive text, when the corresponding value has
been changed.  Fix for http://bugzilla.kernel.org/show_bug.cgi?id=7744

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
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

