From: akpm@linux-foundation.org
Subject: + hfsplus-avoid-crash-on-failed-block-map-free.patch added to -mm tree
Date: Tue, 13 Nov 2012 14:35:00 -0800
Message-ID: <20121113223500.BF460100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:38070 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2KMWfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 17:35:03 -0500
Received: by mail-gh0-f202.google.com with SMTP id z15so922240ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 14:35:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, slava@dubeyko.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: avoid crash on failed block map free
has been added to the -mm tree.  Its filename is
     hfsplus-avoid-crash-on-failed-block-map-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: hfsplus: avoid crash on failed block map free

If the read fails we kmap an error code.  This doesn't end well.  Instead
print a critical error and pray.  This mirrors the rest of the fs
behaviour with critical error cases.

Acked-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bitmap.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/bitmap.c~hfsplus-avoid-crash-on-failed-block-map-free fs/hfsplus/bitmap.c
--- a/fs/hfsplus/bitmap.c~hfsplus-avoid-crash-on-failed-block-map-free
+++ a/fs/hfsplus/bitmap.c
@@ -176,12 +176,14 @@ int hfsplus_block_free(struct super_bloc
 	dprint(DBG_BITMAP, "block_free: %u,%u\n", offset, count);
 	/* are all of the bits in range? */
 	if ((offset + count) > sbi->total_blocks)
-		return -2;
+		return -ENOENT;
 
 	mutex_lock(&sbi->alloc_mutex);
 	mapping = sbi->alloc_file->i_mapping;
 	pnr = offset / PAGE_CACHE_BITS;
 	page = read_mapping_page(mapping, pnr, NULL);
+	if (IS_ERR(page))
+		goto kaboom;
 	pptr = kmap(page);
 	curr = pptr + (offset & (PAGE_CACHE_BITS - 1)) / 32;
 	end = pptr + PAGE_CACHE_BITS / 32;
@@ -214,6 +216,8 @@ int hfsplus_block_free(struct super_bloc
 		set_page_dirty(page);
 		kunmap(page);
 		page = read_mapping_page(mapping, ++pnr, NULL);
+		if (IS_ERR(page))
+			goto kaboom;
 		pptr = kmap(page);
 		curr = pptr;
 		end = pptr + PAGE_CACHE_BITS / 32;
@@ -232,4 +236,11 @@ out:
 	mutex_unlock(&sbi->alloc_mutex);
 
 	return 0;
+
+kaboom:
+	printk(KERN_CRIT "hfsplus: unable to mark blocks free: error %ld\n",
+			PTR_ERR(page));
+	mutex_unlock(&sbi->alloc_mutex);
+
+	return -EIO;
 }
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
irq-tsk-comm-is-an-array.patch
drivers-message-fusion-mptscsihc-missing-break.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
fork-unshare-remove-dead-code.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch

