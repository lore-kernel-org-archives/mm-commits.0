From: akpm@linux-foundation.org
Subject: + hfsplus-rework-processing-errors-in-hfsplus_free_extents.patch added to -mm tree
Date: Wed, 28 Nov 2012 14:37:31 -0800
Message-ID: <20121128223731.B6C90100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:57496 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab2K1Whf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 17:37:35 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1695183vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 14:37:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@infradead.org, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: rework processing errors in hfsplus_free_extents()
has been added to the -mm tree.  Its filename is
     hfsplus-rework-processing-errors-in-hfsplus_free_extents.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: rework processing errors in hfsplus_free_extents()

Currently, it doesn't process error codes from the hfsplus_block_free()
call in hfsplus_free_extents() method.  Add some error code processing.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-rework-processing-errors-in-hfsplus_free_extents fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-rework-processing-errors-in-hfsplus_free_extents
+++ a/fs/hfsplus/extents.c
@@ -329,6 +329,7 @@ static int hfsplus_free_extents(struct s
 {
 	u32 count, start;
 	int i;
+	int err = 0;
 
 	hfsplus_dump_extent(extent);
 	for (i = 0; i < 8; extent++, i++) {
@@ -345,18 +346,33 @@ found:
 	for (;;) {
 		start = be32_to_cpu(extent->start_block);
 		if (count <= block_nr) {
-			hfsplus_block_free(sb, start, count);
+			err = hfsplus_block_free(sb, start, count);
+			if (err) {
+				printk(KERN_ERR "hfs: can't free extent\n");
+				dprint(DBG_EXTENT, " start: %u count: %u\n",
+					start, count);
+			}
 			extent->block_count = 0;
 			extent->start_block = 0;
 			block_nr -= count;
 		} else {
 			count -= block_nr;
-			hfsplus_block_free(sb, start + count, block_nr);
+			err = hfsplus_block_free(sb, start + count, block_nr);
+			if (err) {
+				printk(KERN_ERR "hfs: can't free extent\n");
+				dprint(DBG_EXTENT, " start: %u count: %u\n",
+					start, count);
+			}
 			extent->block_count = cpu_to_be32(count);
 			block_nr = 0;
 		}
-		if (!block_nr || !i)
-			return 0;
+		if (!block_nr || !i) {
+			/*
+			 * Try to free all extents and
+			 * return only last error
+			 */
+			return err;
+		}
 		i--;
 		extent--;
 		count = be32_to_cpu(extent->block_count);
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-rework-processing-errors-in-hfsplus_free_extents.patch

