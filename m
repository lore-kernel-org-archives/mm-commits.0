From: akpm@linux-foundation.org
Subject: + fs-fat-strip-cp-prefix-from-codepage-in-display.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:44:18 -0800
Message-ID: <20121127204418.9CD78100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45764 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab2K0UoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:44:20 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1522560vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:44:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dreisner@archlinux.org, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs/fat: strip "cp" prefix from codepage in display
has been added to the -mm tree.  Its filename is
     fs-fat-strip-cp-prefix-from-codepage-in-display.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Reisner <dreisner@archlinux.org>
Subject: fs/fat: strip "cp" prefix from codepage in display

Option parsing code expects an unsigned integer for the codepage option,
but prefixes and stores this option with "cp" before passing to
load_nls().  This makes the displayed option in /proc an invalid one. 
Strip the prefix when printing so that the displayed option is valid for
reuse.

Signed-off-by: Dave Reisner <dreisner@archlinux.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fs-fat-strip-cp-prefix-from-codepage-in-display fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-strip-cp-prefix-from-codepage-in-display
+++ a/fs/fat/inode.c
@@ -726,7 +726,8 @@ static int fat_show_options(struct seq_f
 	if (opts->allow_utime)
 		seq_printf(m, ",allow_utime=%04o", opts->allow_utime);
 	if (sbi->nls_disk)
-		seq_printf(m, ",codepage=%s", sbi->nls_disk->charset);
+		/* strip "cp" prefix from displayed option */
+		seq_printf(m, ",codepage=%s", &sbi->nls_disk->charset[2]);
 	if (isvfat) {
 		if (sbi->nls_io)
 			seq_printf(m, ",iocharset=%s", sbi->nls_io->charset);
_

Patches currently in -mm which might be from dreisner@archlinux.org are

fs-fat-strip-cp-prefix-from-codepage-in-display.patch

