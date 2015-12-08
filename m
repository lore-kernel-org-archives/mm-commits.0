From: akpm@linux-foundation.org
Subject: + hfs-use-list_for_each_entry-in-hfs_cat_delete.patch added to
 -mm tree
Date: Tue, 08 Dec 2015 14:32:28 -0800
Message-ID: <56675a7c.d1KDHb7Q8LAVPenJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbLHWc3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:32:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfs/catalog.c: use list_for_each_entry in hfs_cat_delete
has been added to the -mm tree.  Its filename is
     hfs-use-list_for_each_entry-in-hfs_cat_delete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfs-use-list_for_each_entry-in-hfs_cat_delete.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-slab-use-list_first_entry_or_null.patch
mm-slab-use-list_for_each_entry-in-cache_flusharray.patch
mm-slabc-add-a-helper-function-get_first_slab.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
mm-swapfilec-use-list_nextfirst_entry.patch
mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page.patch
mm-ksmc-use-list_for_each_entry_safe.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
dma-mapping-use-offset_in_page-macro.patch

