From: akpm@osdl.org
Subject: + mxser-remove-ambiguous-redefinition-of-init_work.patch added to -mm tree
Date: Fri, 15 Dec 2006 13:36:54 -0800
Message-ID: <200612152136.kBFLasQw030568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46755 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbWLOVg6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 16:36:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas.jaggi@waterwave.ch, jirislaby@gmail.com


The patch titled
     mxser: remove ambiguous redefinition of INIT_WORK
has been added to the -mm tree.  Its filename is
     mxser-remove-ambiguous-redefinition-of-init_work.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mxser: remove ambiguous redefinition of INIT_WORK
From: Andreas Jaggi <andreas.jaggi@waterwave.ch>

Removes an unused and ambiguous redefinition of INIT_WORK()

Signed-off-by: Andreas Jaggi <andreas.jaggi@waterwave.ch>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

mxser-remove-ambiguous-redefinition-of-init_work.patch

