Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB52C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjK0RHq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjK0RHl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:07:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E4A10F0
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:07:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A9AC433C8;
        Mon, 27 Nov 2023 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104866;
        bh=nXf35Nam85Ol1OXhzmzFUKiFk8JXrkSCKe3EaaIm9Do=;
        h=Date:To:From:Subject:From;
        b=uIOCdh5iBdXm5VeK0dgZ4GINUOhHtaQdbobkAkF/++DuMuW9RlcXiOxZ3rXA2isqO
         cUt3pJbHP+FVdmwABjM5ZHAX58PrHdeG8isITMOFUYOIZHnprRX7tjj9wV6itqGNmJ
         WwJiiDIno7UgbJqNbASg9uoiVHYsckc9cRBpfKrI=
Date:   Mon, 27 Nov 2023 09:07:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link.patch added to mm-nonmm-unstable branch
Message-Id: <20231127170746.92A9AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: move page release outside of nilfs_delete_entry and nilfs_set_link
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: move page release outside of nilfs_delete_entry and nilfs_set_link
Date: Mon, 27 Nov 2023 23:30:20 +0900

Patch series "nilfs2: Folio conversions for directory paths".

This series applies page->folio conversions to nilfs2 directory
operations.  This reduces hidden compound_head() calls and also converts
deprecated kmap calls to kmap_local in the directory code.

Although nilfs2 does not yet support large folios, Matthew has done his
best here to include support for large folios, which will be needed for
devices with large block sizes.

This series corresponds to the second half of the original post [1], but
with two complementary patches inserted at the beginning and some
adjustments, to prevent a kmap_local constraint violation found during
testing with highmem mapping.

[1] https://lkml.kernel.org/r/20231106173903.1734114-1-willy@infradead.org

I have reviewed all changes and tested this for regular and small block
sizes, both on machines with and without highmem mapping.  No issues
found.


This patch (of 17):

In a few directory operations, the call to nilfs_put_page() for a page
obtained using nilfs_find_entry() or nilfs_dotdot() is hidden in
nilfs_set_link() and nilfs_delete_entry(), making it difficult to track
page release and preventing change of its call position.

By moving nilfs_put_page() out of these functions, this makes the page
get/put correspondence clearer and makes it easier to swap
nilfs_put_page() calls (and kunmap calls within them) when modifying
multiple directory entries simultaneously in nilfs_rename().

Also, update comments for nilfs_set_link() and nilfs_delete_entry() to
reflect changes in their behavior.

To make nilfs_put_page() visible from namei.c, this moves its definition
to nilfs.h and replaces existing equivalents to use it, but the exposure
of that definition is temporary and will be removed on a later kmap ->
kmap_local conversion.

Link: https://lkml.kernel.org/r/20231127143036.2425-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20231127143036.2425-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |   11 +----------
 fs/nilfs2/namei.c |   13 +++++++------
 fs/nilfs2/nilfs.h |    6 ++++++
 3 files changed, 14 insertions(+), 16 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link
+++ a/fs/nilfs2/dir.c
@@ -64,12 +64,6 @@ static inline unsigned int nilfs_chunk_s
 	return inode->i_sb->s_blocksize;
 }
 
-static inline void nilfs_put_page(struct page *page)
-{
-	kunmap(page);
-	put_page(page);
-}
-
 /*
  * Return the offset into page `page_nr' of the last valid
  * byte in that page, plus one.
@@ -413,7 +407,6 @@ ino_t nilfs_inode_by_name(struct inode *
 	return res;
 }
 
-/* Releases the page */
 void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct page *page, struct inode *inode)
 {
@@ -428,7 +421,6 @@ void nilfs_set_link(struct inode *dir, s
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
 	nilfs_commit_chunk(page, mapping, from, to);
-	nilfs_put_page(page);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
 
@@ -533,7 +525,7 @@ out_unlock:
 
 /*
  * nilfs_delete_entry deletes a directory entry by merging it with the
- * previous entry. Page is up-to-date. Releases the page.
+ * previous entry. Page is up-to-date.
  */
 int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 {
@@ -569,7 +561,6 @@ int nilfs_delete_entry(struct nilfs_dir_
 	nilfs_commit_chunk(page, mapping, from, to);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 out:
-	nilfs_put_page(page);
 	return err;
 }
 
--- a/fs/nilfs2/namei.c~nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link
+++ a/fs/nilfs2/namei.c
@@ -280,6 +280,7 @@ static int nilfs_do_unlink(struct inode
 		set_nlink(inode, 1);
 	}
 	err = nilfs_delete_entry(de, page);
+	nilfs_put_page(page);
 	if (err)
 		goto out;
 
@@ -386,6 +387,7 @@ static int nilfs_rename(struct mnt_idmap
 		if (!new_de)
 			goto out_dir;
 		nilfs_set_link(new_dir, new_de, new_page, old_inode);
+		nilfs_put_page(new_page);
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
 		if (dir_de)
@@ -409,9 +411,11 @@ static int nilfs_rename(struct mnt_idmap
 	inode_set_ctime_current(old_inode);
 
 	nilfs_delete_entry(old_de, old_page);
+	nilfs_put_page(old_page);
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
+		nilfs_put_page(dir_page);
 		drop_nlink(old_dir);
 	}
 	nilfs_mark_inode_dirty(old_dir);
@@ -421,13 +425,10 @@ static int nilfs_rename(struct mnt_idmap
 	return err;
 
 out_dir:
-	if (dir_de) {
-		kunmap(dir_page);
-		put_page(dir_page);
-	}
+	if (dir_de)
+		nilfs_put_page(dir_page);
 out_old:
-	kunmap(old_page);
-	put_page(old_page);
+	nilfs_put_page(old_page);
 out:
 	nilfs_transaction_abort(old_dir->i_sb);
 	return err;
--- a/fs/nilfs2/nilfs.h~nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link
+++ a/fs/nilfs2/nilfs.h
@@ -237,6 +237,12 @@ extern struct nilfs_dir_entry *nilfs_dot
 extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
 			   struct page *, struct inode *);
 
+static inline void nilfs_put_page(struct page *page)
+{
+	kunmap(page);
+	put_page(page);
+}
+
 /* file.c */
 extern int nilfs_sync_file(struct file *, loff_t, loff_t, int);
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link.patch
nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch

