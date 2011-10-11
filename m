From: akpm@google.com
Subject: + paride-fix-potential-information-leak-in-pg_read.patch added to -mm tree
Date: Tue, 11 Oct 2011 14:22:16 -0700
Message-ID: <201110112122.p9BLMG2n028077@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:31490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1JKVW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 17:22:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, axboe@kernel.dk, tim@cyberelk.net


The patch titled
     Subject: paride: fix potential information leak in pg_read()
has been added to the -mm tree.  Its filename is
     paride-fix-potential-information-leak-in-pg_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: paride: fix potential information leak in pg_read()

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
memory-hotplug-release-lock-on-an-error-path.patch
bio-change-some-signed-vars-to-unsigned.patch
paride-fix-potential-information-leak-in-pg_read.patch

