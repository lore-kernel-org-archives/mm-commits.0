Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E502C3DA6E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiLOXK0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiLOXJr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C225E2983E
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F852B81CD7
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A134C433D2;
        Thu, 15 Dec 2022 23:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145784;
        bh=3C9JyffXseU8yDT/fQljSjf0k5nz8TWUC49jwwynAwQ=;
        h=Date:To:From:Subject:From;
        b=n5NiZK3UseWRl4CXfPhelNvOQ8BX8kzOrj0W7nXjPfdxaGv/2GJAnNcr64T3LwEyP
         fSo66AS9eDRwCd0bzswJ3+XNOQxS7sJEKDXVl1us4ivU0TJsrwDQUqMm9jON9LC5pI
         oppnTYhXbvUcetYlmzf/nx0RBOB5NLdAa4XovZ38=
Date:   Thu, 15 Dec 2022 15:09:43 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch added to mm-unstable branch
Message-Id: <20221215230944.3A134C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: replace obvious uses of b_page with b_folio
has been added to the -mm mm-unstable branch.  Its filename is
     reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch

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
Subject: reiserfs: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:44:01 +0000

These places just use b_page to get to the buffer's address_space or call
page_folio() on b_page to get a folio.

Link: https://lkml.kernel.org/r/20221215214402.3522366-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c         |    4 ++--
 fs/reiserfs/tail_conversion.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/reiserfs/journal.c~reiserfs-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/reiserfs/journal.c
@@ -601,7 +601,7 @@ static int journal_list_still_alive(stru
  */
 static void release_buffer_page(struct buffer_head *bh)
 {
-	struct folio *folio = page_folio(bh->b_page);
+	struct folio *folio = bh->b_folio;
 	if (!folio->mapping && folio_trylock(folio)) {
 		folio_get(folio);
 		put_bh(bh);
@@ -866,7 +866,7 @@ loop_next:
 		 * will ever write the buffer. We're safe if we write the
 		 * page one last time after freeing the journal header.
 		 */
-		if (buffer_dirty(bh) && unlikely(bh->b_page->mapping == NULL)) {
+		if (buffer_dirty(bh) && unlikely(bh->b_folio->mapping == NULL)) {
 			spin_unlock(lock);
 			write_dirty_buffer(bh, 0);
 			spin_lock(lock);
--- a/fs/reiserfs/tail_conversion.c~reiserfs-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/reiserfs/tail_conversion.c
@@ -177,7 +177,7 @@ void reiserfs_unmap_buffer(struct buffer
 	 * BUG() on attempt to write not mapped buffer
 	 */
 	if ((!list_empty(&bh->b_assoc_buffers) || bh->b_private) && bh->b_page) {
-		struct inode *inode = bh->b_page->mapping->host;
+		struct inode *inode = bh->b_folio->mapping->host;
 		struct reiserfs_journal *j = SB_JOURNAL(inode->i_sb);
 		spin_lock(&j->j_dirty_buffers_lock);
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

