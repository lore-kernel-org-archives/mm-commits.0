From: akpm@linux-foundation.org
Subject: - qconf-hide-empty-list-items.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:21 -0800
Message-ID: <200702150847.l1F8lLSL024974@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39902 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965350AbXBOIr3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, olecom@flower.upol.cz, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     qconf: hide empty list items
has been removed from the -mm tree.  Its filename was
     qconf-hide-empty-list-items.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qconf: hide empty list items
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

This patch fixes showing empty config list items if "Option/Show All
Options" is turned on.  For example empty items appears on list of 'Block
Layer' menu.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Oleg Verych <olecom@flower.upol.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/kconfig/qconf.cc~qconf-hide-empty-list-items scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-hide-empty-list-items
+++ a/scripts/kconfig/qconf.cc
@@ -606,6 +606,8 @@ void ConfigList::updateMenuList(P* paren
 
 		visible = menu_is_visible(child);
 		if (showAll || visible) {
+			if (!child->sym && !child->list && !child->prompt)
+				continue;
 			if (!item || item->menu != child)
 				item = new ConfigItem(parent, last, child, visible);
 			else
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
