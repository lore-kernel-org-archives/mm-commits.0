From: akpm@linux-foundation.org
Subject: - mxser-remove-ambiguous-redefinition-of-init_work.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:32 -0800
Message-ID: <200702112250.l1BMoWLn015864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60017 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729AbXBKWue (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.jaggi@waterwave.ch, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser: remove ambiguous redefinition of INIT_WORK
has been removed from the -mm tree.  Its filename was
     mxser-remove-ambiguous-redefinition-of-init_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mxser: remove ambiguous redefinition of INIT_WORK
From: Andreas Jaggi <andreas.jaggi@waterwave.ch>

Removes an unused and ambiguous redefinition of INIT_WORK()

Signed-off-by: Andreas Jaggi <andreas.jaggi@waterwave.ch>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.h     |    8 --------
 drivers/char/mxser_new.h |    8 --------
 2 files changed, 16 deletions(-)

diff -puN drivers/char/mxser.h~mxser-remove-ambiguous-redefinition-of-init_work drivers/char/mxser.h
--- a/drivers/char/mxser.h~mxser-remove-ambiguous-redefinition-of-init_work
+++ a/drivers/char/mxser.h
@@ -439,12 +439,4 @@
 
 #define READ_MOXA_MUST_GDL(baseio)	inb((baseio)+MOXA_MUST_GDL_REGISTER)
 
-
-#ifndef INIT_WORK
-#define INIT_WORK(_work, _func, _data){	\
-	_data->tqueue.routine = _func;\
-	_data->tqueue.data = _data;\
-	}
-#endif
-
 #endif
diff -puN drivers/char/mxser_new.h~mxser-remove-ambiguous-redefinition-of-init_work drivers/char/mxser_new.h
--- a/drivers/char/mxser_new.h~mxser-remove-ambiguous-redefinition-of-init_work
+++ a/drivers/char/mxser_new.h
@@ -439,12 +439,4 @@
 
 #define READ_MOXA_MUST_GDL(baseio)	inb((baseio)+MOXA_MUST_GDL_REGISTER)
 
-
-#ifndef INIT_WORK
-#define INIT_WORK(_work, _func, _data){	\
-	_data->tqueue.routine = _func;\
-	_data->tqueue.data = _data;\
-	}
-#endif
-
 #endif
_

Patches currently in -mm which might be from andreas.jaggi@waterwave.ch are

origin.patch
