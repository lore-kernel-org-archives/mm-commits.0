From: akpm@linux-foundation.org
Subject: - cciss-error-implicit-declaration-of-function-sg_init_table.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:39:51 -0700
Message-ID: <200804130239.m3D2dpY9032428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755544AbYDMCky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpagano@gentoo.org, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: error: implicit declaration of function 'sg_init_table'
has been removed from the -mm tree.  Its filename was
     cciss-error-implicit-declaration-of-function-sg_init_table.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

git-block.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
