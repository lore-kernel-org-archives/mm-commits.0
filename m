From: akpm@linux-foundation.org
Subject: + qconf-hide-empty-list-items.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:20:07 -0800
Message-ID: <200702130520.l1D5K7ii022502@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54892 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161069AbXBMFUU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:20:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, olecom@flower.upol.cz, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     qconf: hide empty list items
has been added to the -mm tree.  Its filename is
     qconf-hide-empty-list-items.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
qconf-fix-showing-help-info-on-failed-search.patch
qconf-back-button-behaviour-normalization.patch
qconf-hide-empty-list-items.patch
