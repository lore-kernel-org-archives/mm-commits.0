Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B50C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiLOXKD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiLOXJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DFA62EB9
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9306AB81CD6
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E4BC433EF;
        Thu, 15 Dec 2022 23:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145767;
        bh=69vc8LDFIBUAZwNAfu0D0Lv275PDnJAi0WcMDJdzlAg=;
        h=Date:To:From:Subject:From;
        b=Q7JpiKo8PcCap/y4NH7++kOyQW3omQxic2+fB3iW6+qp98Zs6WAdS4qvnRo5171n1
         iKO3NV6gfm6jZOu1XBw+PrGxODRriQ2SE2w62GDLVv1K5twtKgAa4U1cxiN4nysb5g
         iEZxUTuUnnMpuOt8rZyXl5Ldgr+2K3M2vqTvxVTI=
Date:   Thu, 15 Dec 2022 15:09:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-replace-obvious-uses-of-b_page-with-b_folio.patch added to mm-unstable branch
Message-Id: <20221215230927.47E4BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: replace obvious uses of b_page with b_folio
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch will later appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:43:52 +0000

These cases just check if it's NULL, or use b_page to get to the page's
address space.  They are assumptions that b_page never points to a tail
page.

Link: https://lkml.kernel.org/r/20221215214402.3522366-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/buffer.c~buffer-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/buffer.c
@@ -321,7 +321,7 @@ static void end_buffer_async_read_io(str
 {
 	/* Decrypt if needed */
 	if (uptodate &&
-	    fscrypt_inode_uses_fs_layer_crypto(bh->b_page->mapping->host)) {
+	    fscrypt_inode_uses_fs_layer_crypto(bh->b_folio->mapping->host)) {
 		struct decrypt_bh_ctx *ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
 
 		if (ctx) {
@@ -570,7 +570,7 @@ void write_boundary_block(struct block_d
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct address_space *buffer_mapping = bh->b_page->mapping;
+	struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 	mark_buffer_dirty(bh);
 	if (!mapping->private_data) {
@@ -1073,7 +1073,7 @@ __getblk_slow(struct block_device *bdev,
  * and then attach the address_space's inode to its superblock's dirty
  * inode list.
  *
- * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
+ * mark_buffer_dirty() is atomic.  It takes bh->b_folio->mapping->private_lock,
  * i_pages lock and mapping->host->i_lock.
  */
 void mark_buffer_dirty(struct buffer_head *bh)
@@ -1117,8 +1117,8 @@ void mark_buffer_write_io_error(struct b
 
 	set_buffer_write_io_error(bh);
 	/* FIXME: do we need to set this in both places? */
-	if (bh->b_page && bh->b_page->mapping)
-		mapping_set_error(bh->b_page->mapping, -EIO);
+	if (bh->b_folio && bh->b_folio->mapping)
+		mapping_set_error(bh->b_folio->mapping, -EIO);
 	if (bh->b_assoc_map)
 		mapping_set_error(bh->b_assoc_map, -EIO);
 	rcu_read_lock();
@@ -1154,7 +1154,7 @@ void __bforget(struct buffer_head *bh)
 {
 	clear_buffer_dirty(bh);
 	if (bh->b_assoc_map) {
-		struct address_space *buffer_mapping = bh->b_page->mapping;
+		struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 		spin_lock(&buffer_mapping->private_lock);
 		list_del_init(&bh->b_assoc_buffers);
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch

