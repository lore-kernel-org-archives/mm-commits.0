From: akpm@linux-foundation.org
Subject: +
 nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch added
 to -mm tree
Date: Mon, 16 Mar 2015 15:51:29 -0700
Message-ID: <55075e71.KqFQ0Ji4C98v+EqH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbbCPWva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 18:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: do not use async write flag for segment summary buffers
has been added to the -mm tree.  Its filename is
     nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: do not use async write flag for segment summary buffers

The async write flag is introduced to nilfs2 in the commit 7f42ec394156
("nilfs2: fix issue with race condition of competition between segments
for dirty blocks"), but the flag only makes sense for data buffers and
btree node buffers.  It is not needed for segment summary buffers.

This gets rid of the latter uses as part of refactoring of atomic bit
operations on buffer state bitmap.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/nilfs2/segment.c~nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers
+++ a/fs/nilfs2/segment.c
@@ -1588,7 +1588,6 @@ static void nilfs_segctor_prepare_write(
 
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
-			set_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page) {
 					lock_page(bd_page);
@@ -1688,7 +1687,6 @@ static void nilfs_abort_logs(struct list
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
-			clear_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page)
 					end_page_writeback(bd_page);
@@ -1768,7 +1766,6 @@ static void nilfs_segctor_complete_write
 				    b_assoc_buffers) {
 			set_buffer_uptodate(bh);
 			clear_buffer_dirty(bh);
-			clear_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page)
 					end_page_writeback(bd_page);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch
nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap.patch
nilfs2-use-bgl_lock_ptr.patch
nilfs2-unify-type-of-key-arguments-in-bmap-interface.patch
nilfs2-add-bmap-function-to-seek-a-valid-key.patch
nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch
nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl.patch

