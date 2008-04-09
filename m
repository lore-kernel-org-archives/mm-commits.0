From: akpm@linux-foundation.org
Subject: + cciss-error-implicit-declaration-of-function-sg_init_table.patch added to -mm tree
Date: Wed, 09 Apr 2008 16:09:57 -0700
Message-ID: <200804092309.m39N9vpY001970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbYDIXLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 19:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpagano@gentoo.org, jens.axboe@oracle.com, mike.miller@hp.com


The patch titled
     cciss: error: implicit declaration of function 'sg_init_table'
has been added to the -mm tree.  Its filename is
     cciss-error-implicit-declaration-of-function-sg_init_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: cciss: error: implicit declaration of function 'sg_init_table'
=46rom: Mike Pagano <mpagano@gentoo.org>

This patch adds the missing include directive <linux/scatterlist.h> to =
the
cciss.c source file.  =A0 This was discovered by our release team when =
building
the kernel for the Alpha architecture.

Errors were found as references to functions 'sg_init_table' and 'sg_pa=
ge' do
not exist without the include for Alpha.

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-error-implicit-declaration-of-fun=
ction-sg_init_table drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-error-implicit-declaration-of-functio=
n-sg_init_table
+++ a/drivers/block/cciss.c
@@ -50,6 +50,7 @@
 #include <scsi/sg.h>
 #include <scsi/scsi_ioctl.h>
 #include <linux/cdrom.h>
+#include <linux/scatterlist.h>
=20
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(subm=
in))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
_

Patches currently in -mm which might be from mpagano@gentoo.org are

cciss-error-implicit-declaration-of-function-sg_init_table.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
