From: akpm@linux-foundation.org
Subject: + reiserfs-complement-va_start-with-va_end.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:17:26 -0800
Message-ID: <200711292017.lATKHQnt005352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759914AbXK2URd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se


The patch titled
     reiserfs: complement va_start() with va_end().
has been added to the -mm tree.  Its filename is
     reiserfs-complement-va_start-with-va_end.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
kernel-compliment-va_copy-with-va_end.patch
net-irda-parametersc-trivial-fixes.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
