From: akpm@linux-foundation.org
Subject: [merged] fs-exofs-print-a-hex-number-after-a-0x-prefix.patch
 removed from -mm tree
Date: Fri, 28 Oct 2016 11:30:54 -0700
Message-ID: <5813995e.Z5DvB4LtmKqNhqhL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030401AbcJ1Saz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, bhalevy@primarydata.com, joe@perches.com, ooo@electrozaur.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: exofs: print a hex number after a 0x prefix
has been removed from the -mm tree.  Its filename was
     fs-exofs-print-a-hex-number-after-a-0x-prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


