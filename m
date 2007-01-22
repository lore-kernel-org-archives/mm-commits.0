From: akpm@osdl.org
Subject: + qconf-fix-showing-help-info-on-failed-search.patch added to -mm tree
Date: Mon, 22 Jan 2007 13:25:37 -0800
Message-ID: <200701222125.l0MLPdPD002548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXAVVZz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 16:25:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, gorcunov@mail.ru, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     qconf: fix showing help info on failed search
has been added to the -mm tree.  Its filename is
     qconf-fix-showing-help-info-on-failed-search.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: qconf: fix showing help info on failed search
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

qconf does not clear help text in search window if previous search has been
failed.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@mail.ru>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |    1 +
 1 files changed, 1 insertion(+)

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

qconf-fix-showing-help-info-on-failed-search.patch
