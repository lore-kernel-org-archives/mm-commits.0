From: akpm@linux-foundation.org
Subject: [merged] scripts-kconfig-qconfcc-fix-a-compiliation-error-when-using-make-xconfig.patch removed from -mm tree
Date: Mon, 04 Feb 2013 12:31:06 -0800
Message-ID: <20130204203106.A04AB5A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:46059 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab3BDUbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 15:31:07 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so681983qeb.2
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 12:31:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rkmahefa@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/kconfig/qconf.cc: fix a compiliation error when using make xconfig
has been removed from the -mm tree.  Its filename was
     scripts-kconfig-qconfcc-fix-a-compiliation-error-when-using-make-xconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
Subject: scripts/kconfig/qconf.cc: fix a compiliation error when using make xconfig

When using make xconfig, the following compilation error appears :
   /usr/include/qt3/qvaluelist.h:427:13: error: `ptrdiff_t' does not name a type
Including stddef.h in scripts/kconfig/qconf.cc permits to avoid this error.

Signed-off-by: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/kconfig/qconf.cc~scripts-kconfig-qconfcc-fix-a-compiliation-error-when-using-make-xconfig scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~scripts-kconfig-qconfcc-fix-a-compiliation-error-when-using-make-xconfig
+++ a/scripts/kconfig/qconf.cc
@@ -6,6 +6,7 @@
 #include <qglobal.h>
 
 #if QT_VERSION < 0x040000
+#include <stddef.h>
 #include <qmainwindow.h>
 #include <qvbox.h>
 #include <qvaluelist.h>
_

Patches currently in -mm which might be from rkmahefa@gmail.com are

linux-next.patch

