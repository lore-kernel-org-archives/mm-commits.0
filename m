From: akpm@linux-foundation.org
Subject: - qconf-fix-showing-help-info-on-failed-search.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:07 -0800
Message-ID: <200702150847.l1F8l73t024962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39892 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965346AbXBOIrY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@mail.ru, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     qconf: fix showing help info on failed search
has been removed from the -mm tree.  Its filename was
     qconf-fix-showing-help-info-on-failed-search.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qconf: fix showing help info on failed search
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

qconf does not clear help text in search window if previous search has been
failed.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@mail.ru>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/kconfig/qconf.cc~qconf-fix-showing-help-info-on-failed-search scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-fix-showing-help-info-on-failed-search
+++ a/scripts/kconfig/qconf.cc
@@ -1248,6 +1248,7 @@ void ConfigSearchWindow::search(void)
 
 	free(result);
 	list->list->clear();
+	info->clear();
 
 	result = sym_re_search(editField->text().latin1());
 	if (!result)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
