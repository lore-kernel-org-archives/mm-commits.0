From: akpm@linux-foundation.org
Subject: + fs-exofs-print-a-hex-number-after-a-0x-prefix.patch added to
 -mm tree
Date: Wed, 26 Oct 2016 12:50:29 -0700
Message-ID: <58110905.fE0g6c8xvWxWzfeM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932910AbcJZTua (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 15:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, bhalevy@primarydata.com, joe@perches.com, ooo@electrozaur.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: exofs: print a hex number after a 0x prefix
has been added to the -mm tree.  Its filename is
     fs-exofs-print-a-hex-number-after-a-0x-prefix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-exofs-print-a-hex-number-after-a-0x-prefix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-exofs-print-a-hex-number-after-a-0x-prefix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: fs: exofs: print a hex number after a 0x prefix

It makes the message hard to interpret correctly if a base 10 number is
prefixed by 0x. So change to a hex number.

Link: http://lkml.kernel.org/r/20161026125658.25728-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Boaz Harrosh <ooo@electrozaur.com>
Cc: Benny Halevy <bhalevy@primarydata.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exofs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exofs/dir.c~fs-exofs-print-a-hex-number-after-a-0x-prefix fs/exofs/dir.c
--- a/fs/exofs/dir.c~fs-exofs-print-a-hex-number-after-a-0x-prefix
+++ a/fs/exofs/dir.c
@@ -137,7 +137,7 @@ Espan:
 bad_entry:
 	EXOFS_ERR(
 		"ERROR [exofs_check_page]: bad entry in directory(0x%lx): %s - "
-		"offset=%lu, inode=0x%llu, rec_len=%d, name_len=%d\n",
+		"offset=%lu, inode=0x%llx, rec_len=%d, name_len=%d\n",
 		dir->i_ino, error, (page->index<<PAGE_SHIFT)+offs,
 		_LLU(le64_to_cpu(p->inode_no)),
 		rec_len, p->name_len);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

fs-exofs-print-a-hex-number-after-a-0x-prefix.patch
block-dac960-print-a-hex-number-after-a-0x-prefix.patch
ipack-print-a-hex-number-after-a-0x-prefix.patch
misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch
cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch

