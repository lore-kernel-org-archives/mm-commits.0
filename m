From: akpm@linux-foundation.org
Subject: + drivers-block-pktcdvdc-avoid-useless-memset.patch added to -mm tree
Date: Mon, 23 Jun 2008 20:36:40 -0700
Message-ID: <200806240336.m5O3af6i030905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbYFXDgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 23:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaillet.christophe@wanadoo.fr, jens.axboe@oracle.com, petero2@telia.com


The patch titled
     drivers/block/pktcdvd.c: avoid useless memset
has been added to the -mm tree.  Its filename is
     drivers-block-pktcdvdc-avoid-useless-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/pktcdvd.c: avoid useless memset
From: Christophe Jaillet <jaillet.christophe@wanadoo.fr>

Avoid the 'memset(...,0, ...)' before calling 'init_cdrom_command' because
this function already does it.

Signed-off-by: Christophe Jaillet <jaillet.christophe@wanadoo.fr>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/pktcdvd.c~drivers-block-pktcdvdc-avoid-useless-memset drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~drivers-block-pktcdvdc-avoid-useless-memset
+++ a/drivers/block/pktcdvd.c
@@ -2082,7 +2082,6 @@ static noinline_for_stack int pkt_write_
 	unsigned char buf[64];
 	int ret;
 
-	memset(buf, 0, sizeof(buf));
 	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
 	cgc.sense = &sense;
 	cgc.buflen = pd->mode_offset + 12;
@@ -2129,7 +2128,6 @@ static noinline_for_stack int pkt_get_ma
 	unsigned char *cap_buf;
 	int ret, offset;
 
-	memset(buf, 0, sizeof(buf));
 	cap_buf = &buf[sizeof(struct mode_page_header) + pd->mode_offset];
 	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_UNKNOWN);
 	cgc.sense = &sense;
_

Patches currently in -mm which might be from jaillet.christophe@wanadoo.fr are

drivers-block-pktcdvdc-avoid-useless-memset.patch

