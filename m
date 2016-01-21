From: akpm@linux-foundation.org
Subject: [merged] hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:26 -0800
Message-ID: <56a162ce.WhcniIk9WgUD1Cd2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbcAUW71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfs/catalog.c: use list_for_each_entry in hfs_cat_delete
has been removed from the -mm tree.  Its filename was
     hfs-use-list_for_each_entry-in-hfs_cat_delete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: fs/hfs/catalog.c: use list_for_each_entry in hfs_cat_delete

Use list_for_each_entry() instead of list_for_each() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/catalog.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/hfs/catalog.c~hfs-use-list_for_each_entry-in-hfs_cat_delete fs/hfs/catalog.c
--- a/fs/hfs/catalog.c~hfs-use-list_for_each_entry-in-hfs_cat_delete
+++ a/fs/hfs/catalog.c
@@ -214,7 +214,7 @@ int hfs_cat_delete(u32 cnid, struct inod
 {
 	struct super_block *sb;
 	struct hfs_find_data fd;
-	struct list_head *pos;
+	struct hfs_readdir_data *rd;
 	int res, type;
 
 	hfs_dbg(CAT_MOD, "delete_cat: %s,%u\n", str ? str->name : NULL, cnid);
@@ -240,9 +240,7 @@ int hfs_cat_delete(u32 cnid, struct inod
 		}
 	}
 
-	list_for_each(pos, &HFS_I(dir)->open_dir_list) {
-		struct hfs_readdir_data *rd =
-			list_entry(pos, struct hfs_readdir_data, list);
+	list_for_each_entry(rd, &HFS_I(dir)->open_dir_list, list) {
 		if (fd.tree->keycmp(fd.search_key, (void *)&rd->key) < 0)
 			rd->file->f_pos--;
 	}
_

Patches currently in -mm which might be from geliangtang@163.com are


