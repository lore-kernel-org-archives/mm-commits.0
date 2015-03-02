From: akpm@linux-foundation.org
Subject: + paride-fix-the-verbose-module-param.patch added to -mm tree
Date: Mon, 02 Mar 2015 15:29:57 -0800
Message-ID: <54f4f275.mi8I2ByCcI58vJrr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbbCBX36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 18:29:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, tim@cyberelk.net, mm-commits@vger.kernel.org


The patch titled
     Subject: paride: fix the "verbose" module param
has been added to the -mm tree.  Its filename is
     paride-fix-the-verbose-module-param.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/paride-fix-the-verbose-module-param.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/paride-fix-the-verbose-module-param.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: paride: fix the "verbose" module param

The verbose module parameter can be set to 2 for extremely verbose
messages so the type should be int instead of bool.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tim Waugh <tim@cyberelk.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/paride/pg.c~paride-fix-the-verbose-module-param drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~paride-fix-the-verbose-module-param
+++ a/drivers/block/paride/pg.c
@@ -137,7 +137,7 @@
 
 */
 
-static bool verbose = 0;
+static int verbose;
 static int major = PG_MAJOR;
 static char *name = PG_NAME;
 static int disable = 0;
@@ -168,7 +168,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV,
 
 #include <asm/uaccess.h>
 
-module_param(verbose, bool, 0644);
+module_param(verbose, int, 0644);
 module_param(major, int, 0);
 module_param(name, charp, 0);
 module_param_array(drive0, int, NULL, 0);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
paride-fix-the-verbose-module-param.patch
hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch
memstick-mspro_block-add-missing-curly-braces.patch
linux-next.patch

