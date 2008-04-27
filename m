From: akpm@linux-foundation.org
Subject: + add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:07:51 -0700
Message-ID: <200804271907.m3RJ7pZF020438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762989AbYD0THy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     Add balance_dirty_pages_ratelimited() to cont_expand_zero()
has been added to the -mm tree.  Its filename is
     add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch

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
Subject: Add balance_dirty_pages_ratelimited() to cont_expand_zero()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

On the systems, ftruncate() which expand size for FAT became the cause
of OOM.  The cont_expand_zero() filled all memory with dirty pages,
and since disk is very slow, limit of page scanning was exceeded, then
it triggered OOM.

This adds balance_dirty_pages_ratelimited() to avoid filling memory
with dirty pages.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/buffer.c~add-balance_dirty_pages_ratelimited-to-cont_expand_zero fs/buffer.c
--- a/fs/buffer.c~add-balance_dirty_pages_ratelimited-to-cont_expand_zero
+++ a/fs/buffer.c
@@ -2245,6 +2245,8 @@ static int cont_expand_zero(struct file 
 			goto out;
 		BUG_ON(err != len);
 		err = 0;
+
+		balance_dirty_pages_ratelimited(mapping);
 	}
 
 	/* page covers the boundary, find the boundary offset */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-kill-is_bad_inode-check.patch
fat-fat_notify_change-and-check_mode-cleanup.patch
fat-fat_setattr-fix.patch
fat-add-allow_utime-option.patch
fat-update-free_clusters-even-if-it-is-untrusted.patch
fat-remove-fat_clusters_flush.patch
add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch
vfat-bug-fix-for-vfat-cannot-handle-filename-with-255.patch
fat-use-__getname.patch
fat_valid_media-remove-pointless-test.patch
fat-detect-media-without-partition-table-correctly.patch
fatfs-fix-build-warning-with-64k-page_size.patch
fat-use-get-put_unaligned_-helpers.patch

