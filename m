From: akpm@linux-foundation.org
Subject: - reiserfs-complement-va_start-with-va_end.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:17 -0800
Message-ID: <200802070022.m170MwLg006482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932619AbYBGAoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     reiserfs: complement va_start() with va_end().
has been removed from the -mm tree.  Its filename was
     reiserfs-complement-va_start-with-va_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: complement va_start() with va_end().
From: Richard Knutsson <ricknu-0@student.ltu.se>

Complement va_start() with va_end().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/prints.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/reiserfs/prints.c~reiserfs-complement-va_start-with-va_end fs/reiserfs/prints.c
--- a/fs/reiserfs/prints.c~reiserfs-complement-va_start-with-va_end
+++ a/fs/reiserfs/prints.c
@@ -575,6 +575,8 @@ void print_block(struct buffer_head *bh,
 					printk
 					    ("Block %llu contains unformatted data\n",
 					     (unsigned long long)bh->b_blocknr);
+
+	va_end(args);
 }
 
 static char print_tb_buf[2048];
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
