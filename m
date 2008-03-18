From: akpm@linux-foundation.org
Subject: + zisofs-fix-readpage-outside-i_size.patch added to -mm tree
Date: Mon, 17 Mar 2008 22:18:01 -0700
Message-ID: <200803180518.m2I5I1U5015838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbYCRFSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 01:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, chris@linuxinfotag.de, jack@suse.cz


The patch titled
     zisofs: fix readpage() outside i_size
has been added to the -mm tree.  Its filename is
     zisofs-fix-readpage-outside-i_size.patch

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
Subject: zisofs: fix readpage() outside i_size
From: Dave Young <hidave.darkstar@gmail.com>

A read request outside i_size will be handled in do_generic_file_read().  So
we just return 0 to avoid getting -EIO as normal reading, let
do_generic_file_read do the rest.

At the same time we need unlock the page to avoid system stuck.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10227

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Report-by: Christian Perle <chris@linuxinfotag.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/compress.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/isofs/compress.c~zisofs-fix-readpage-outside-i_size fs/isofs/compress.c
--- a/fs/isofs/compress.c~zisofs-fix-readpage-outside-i_size
+++ a/fs/isofs/compress.c
@@ -72,6 +72,16 @@ static int zisofs_readpage(struct file *
 	offset = index & ~zisofs_block_page_mask;
 	blockindex = offset >> zisofs_block_page_shift;
 	maxpage = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+	/* Here the outsize request we just return 0 because
+	do_generic_file_read will handle this for us */
+
+	if (page->index >= maxpage) {
+		SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
+
 	maxpage = min(zisofs_block_pages, maxpage-offset);
 
 	for ( i = 0 ; i < maxpage ; i++, offset++ ) {
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

zisofs-fix-readpage-outside-i_size.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
isolate-ratelimit-from-printkc-for-other-use.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
use-warn_on_secs-in-rcupreempth.patch

