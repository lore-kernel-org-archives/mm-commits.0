From: akpm@linux-foundation.org
Subject: + fs-fat-fixes-some-small-checkpatch-issues-in-dirc.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:23:36 -0700
Message-ID: <20120820202337.40C24100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:48815 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2HTUXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:23:38 -0400
Received: by obbwc20 with SMTP id wc20so4044910obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:23:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs/fat: fix some small checkpatch issues in dir.c
has been added to the -mm tree.  Its filename is
     fs-fat-fixes-some-small-checkpatch-issues-in-dirc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: fs/fat: fix some small checkpatch issues in dir.c

Simply remove the spacing between function definitions and
EXPORT_SYMBOL_GPL calls, which were previously generating warnings.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/fat/dir.c~fs-fat-fixes-some-small-checkpatch-issues-in-dirc fs/fat/dir.c
--- a/fs/fat/dir.c~fs-fat-fixes-some-small-checkpatch-issues-in-dirc
+++ a/fs/fat/dir.c
@@ -537,7 +537,6 @@ end_of_dir:
 
 	return err;
 }
-
 EXPORT_SYMBOL_GPL(fat_search_long);
 
 struct fat_ioctl_filldir_callback {
@@ -892,7 +891,6 @@ int fat_get_dotdot_entry(struct inode *d
 	}
 	return -ENOENT;
 }
-
 EXPORT_SYMBOL_GPL(fat_get_dotdot_entry);
 
 /* See if directory is empty */
@@ -915,7 +913,6 @@ int fat_dir_empty(struct inode *dir)
 	brelse(bh);
 	return result;
 }
-
 EXPORT_SYMBOL_GPL(fat_dir_empty);
 
 /*
@@ -961,7 +958,6 @@ int fat_scan(struct inode *dir, const un
 	}
 	return -ENOENT;
 }
-
 EXPORT_SYMBOL_GPL(fat_scan);
 
 static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
@@ -1049,7 +1045,6 @@ int fat_remove_entries(struct inode *dir
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(fat_remove_entries);
 
 static int fat_zeroed_cluster(struct inode *dir, sector_t blknr, int nr_used,
@@ -1161,7 +1156,6 @@ error_free:
 error:
 	return err;
 }
-
 EXPORT_SYMBOL_GPL(fat_alloc_new_dir);
 
 static int fat_add_new_entries(struct inode *dir, void *slots, int nr_slots,
@@ -1377,5 +1371,4 @@ error_remove:
 		__fat_remove_entries(dir, pos, free_slots);
 	return err;
 }
