From: akpm@linux-foundation.org
Subject: [merged] fs-fat-strip-cp-prefix-from-codepage-in-display.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:50 -0800
Message-ID: <20121218200851.346AC200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64886 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab2LRUIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:53 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63379wib.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dreisner@archlinux.org, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: strip "cp" prefix from codepage in display
has been removed from the -mm tree.  Its filename was
     fs-fat-strip-cp-prefix-from-codepage-in-display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

