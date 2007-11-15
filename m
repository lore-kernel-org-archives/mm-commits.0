From: akpm@linux-foundation.org
Subject: - rd-fix-data-corruption-on-memory-pressure.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:28 -0800
Message-ID: <200711152110.lAFLASEA015565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932637AbXKOVRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, ebiederm@xmission.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     rd: fix data corruption on memory pressure
has been removed from the -mm tree.  Its filename was
     rd-fix-data-corruption-on-memory-pressure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rd: fix data corruption on memory pressure
From: Christian Borntraeger <borntraeger@de.ibm.com>

We have seen ramdisk based install systems, where some pages of mapped
libraries and programs were suddendly zeroed under memory pressure.  This
should not happen, as the ramdisk avoids freeing its pages by keeping them
dirty all the time.

It turns out that there is a case, where the VM makes a ramdisk page clean,
without telling the ramdisk driver.  On memory pressure shrink_zone runs
and it starts to run shrink_active_list.  There is a check for
buffer_heads_over_limit, and if true, pagevec_strip is called. 
pagevec_strip calls try_to_release_page.  If the mapping has no releasepage
callback, try_to_free_buffers is called.  try_to_free_buffers has now a
special logic for some file systems to make a dirty page clean, if all
buffers are clean.  Thats what happened in our test case.

The simplest solution is to provide a noop-releasepage callback for the
ramdisk driver.  This avoids try_to_free_buffers for ramdisk pages.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/block/rd.c~rd-fix-data-corruption-on-memory-pressure drivers/block/rd.c
--- a/drivers/block/rd.c~rd-fix-data-corruption-on-memory-pressure
+++ a/drivers/block/rd.c
@@ -189,6 +189,18 @@ static int ramdisk_set_page_dirty(struct
 	return 0;
 }
 
+/*
+ * releasepage is called by pagevec_strip/try_to_release_page if
+ * buffers_heads_over_limit is true. Without a releasepage function
+ * try_to_free_buffers is called instead. That can unset the dirty
+ * bit of our ram disk pages, which will be eventually freed, even
+ * if the page is still in use.
+ */
+static int ramdisk_releasepage(struct page *page, gfp_t dummy)
+{
+	return 0;
+}
+
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
 	.prepare_write	= ramdisk_prepare_write,
@@ -196,6 +208,7 @@ static const struct address_space_operat
 	.writepage	= ramdisk_writepage,
 	.set_page_dirty	= ramdisk_set_page_dirty,
 	.writepages	= ramdisk_writepages,
+	.releasepage	= ramdisk_releasepage,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

origin.patch
git-kvm.patch
git-s390.patch
