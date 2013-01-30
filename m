From: akpm@linux-foundation.org
Subject: + scripts-kconfig-qconfcc-fix-a-compiliation-error-when-using-make-xconfig.patch added to -mm tree
Date: Tue, 29 Jan 2013 16:49:53 -0800
Message-ID: <20130130004953.A35735A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:65387 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3A3Aty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 19:49:54 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so105349qcq.3
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 16:49:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rkmahefa@gmail.com, mmarek@suse.cz


The patch titled
     Subject: scripts/kconfig/qconf.cc: fix a compiliation error when using make xconfig
has been added to the -mm tree.  Its filename is
     scripts-kconfig-qconfcc-fix-a-compiliation-error-when-using-make-xconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-kconfig-qconfcc-fix-a-compiliation-error-when-using-make-xconfig.patch

