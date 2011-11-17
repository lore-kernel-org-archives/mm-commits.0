From: akpm@linux-foundation.org
Subject: [merged] paride-fix-potential-information-leak-in-pg_read.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:53 -0800
Message-ID: <201111172021.pAHKLrgH023422@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:38321 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:56 -0500
Received: by mail-ww0-f74.google.com with SMTP id 5so49875wwe.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, axboe@kernel.dk, tim@cyberelk.net, mm-commits@vger.kernel.org


The patch titled
     Subject: paride: fix potential information leak in pg_read()
has been removed from the -mm tree.  Its filename was
     paride-fix-potential-information-leak-in-pg_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: paride: fix potential information leak in pg_read()

Smatch has a new check for Rosenberg type information leaks where structs
are copied to the user with uninitialized stack data in them.  i In this
case, the pg_write_hdr struct has a hole in it.

struct pg_write_hdr {
        char                       magic;                /*     0     1 */
        char                       func;                 /*     1     1 */
        /* XXX 2 bytes hole, try to pack */
        int                        dlen;                 /*     4     4 */

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tim Waugh <tim@cyberelk.net>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pg.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/paride/pg.c~paride-fix-potential-information-leak-in-pg_read drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~paride-fix-potential-information-leak-in-pg_read
+++ a/drivers/block/paride/pg.c
@@ -630,6 +630,7 @@ static ssize_t pg_read(struct file *filp
 		if (dev->status & 0x10)
 			return -ETIME;
 
+	memset(&hdr, 0, sizeof(hdr));
 	hdr.magic = PG_MAGIC;
 	hdr.dlen = dev->dlen;
 	copy = 0;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch

