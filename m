From: akpm@linux-foundation.org
Subject: + mount-options-fix-fat.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:34 -0800
Message-ID: <200801292322.m0TNMY2i009707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbYA2XWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hirofumi@mail.parknet.co.jp


The patch titled
     mount options: fix fat
has been added to the -mm tree.  Its filename is
     mount-options-fix-fat.patch

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
Subject: mount options: fix fat
From: Miklos Szeredi <mszeredi@suse.cz>

Add flush option to /proc/mounts for msdos and vfat filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/fat/inode.c~mount-options-fix-fat fs/fat/inode.c
--- a/fs/fat/inode.c~mount-options-fix-fat
+++ a/fs/fat/inode.c
@@ -837,6 +837,8 @@ static int fat_show_options(struct seq_f
 		if (!opts->numtail)
 			seq_puts(m, ",nonumtail");
 	}
+	if (sbi->options.flush)
+		seq_puts(m, ",flush");
 
 	return 0;
 }
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
