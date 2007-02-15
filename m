From: akpm@linux-foundation.org
Subject: - qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:01 -0800
Message-ID: <200702150847.l1F8l1as024956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965337AbXBOIrK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fzu@wemgehoertderstaat.de, randy.dunlap@oracle.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     qconf: immediately update integer and string values in xconfig display
has been removed from the -mm tree.  Its filename was
     qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    1 +
 1 file changed, 1 insertion(+)

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

origin.patch
