From: akpm@linux-foundation.org
Subject: - drivers-block-pktcdvdc-avoid-useless-memset.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:53 -0700
Message-ID: <200807112351.m6BNprHa011082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554AbYGKXwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaillet.christophe@wanadoo.fr, jens.axboe@oracle.com, petero2@telia.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/pktcdvd.c: avoid useless memset
has been removed from the -mm tree.  Its filename was
     drivers-block-pktcdvdc-avoid-useless-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/pktcdvd.c: avoid useless memset
From: Christophe Jaillet <jaillet.christophe@wanadoo.fr>

Avoid the 'memset(...,0, ...)' before calling 'init_cdrom_command' because
this function already does it.

Signed-off-by: Christophe Jaillet <jaillet.christophe@wanadoo.fr>
Acked-by: Peter Osterlund <petero2@telia.com>
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

linux-next.patch
drivers-media-video-videobuf-dma-sgc-avoid-clearing-memory-twice.patch

