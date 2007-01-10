From: akpm@osdl.org
Subject: + qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch added to -mm tree
Date: Tue, 09 Jan 2007 16:59:29 -0800
Message-ID: <200701100059.l0A0xTAD020269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60057 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607AbXAJA7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 19:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fzu@wemgehoertderstaat.de, randy.dunlap@oracle.com, zippel@linux-m68k.org


The patch titled
     qconf: immediately update integer and string values in xconfig display
has been added to the -mm tree.  Its filename is
     qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: qconf: immediately update integer and string values in xconfig display
From: Karsten Wiese <fzu@wemgehoertderstaat.de>

In xconfig's display integer and string values are also shown as part of
the config item's descriptive text.

This patch updates the descriptive text, when the corresponding value has
been changed.  Fix for http://bugzilla.kernel.org/show_bug.cgi?id=7744

Take2 uses updateList() so config values dependending on the changed value
see the change.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |    1 +
 1 files changed, 1 insertion(+)

diff -puN scripts/kconfig/qconf.cc~qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2 scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2
+++ a/scripts/kconfig/qconf.cc
@@ -89,6 +89,7 @@ void ConfigItem::okRename(int col)
 {
 	Parent::okRename(col);
 	sym_set_string_value(menu->sym, text(dataColIdx).latin1());
+	listView()->updateList(this);
 }
 #endif
 
_

Patches currently in -mm which might be from fzu@wemgehoertderstaat.de are

qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
