From: akpm@osdl.org
Subject: - md-avoid-reading-past-the-end-of-a-bitmap-file.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:00 -0800
Message-ID: <200701270132.l0R1W0SI031879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbXA0BcL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, yinyang801120@gmail.com, mm-commits@vger.kernel.org


The patch titled
     md: avoid reading past the end of a bitmap file
has been removed from the -mm tree.  Its filename was
     md-avoid-reading-past-the-end-of-a-bitmap-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: avoid reading past the end of a bitmap file
From: NeilBrown <neilb@suse.de>

In most cases we check the size of the bitmap file before reading data from
it.  However when reading the superblock, we always read the first PAGE_SIZE
bytes, which might not always be appropriate.  So limit that read to the size
of the file if appropriate.

Also, we get the count of available bytes wrong in one place, so that too can
read past the end of the file.

Cc: "yang yin" <yinyang801120@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/bitmap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/md/bitmap.c~md-avoid-reading-past-the-end-of-a-bitmap-file drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-avoid-reading-past-the-end-of-a-bitmap-file
+++ a/drivers/md/bitmap.c
@@ -479,9 +479,12 @@ static int bitmap_read_sb(struct bitmap 
 	int err = -EINVAL;
 
 	/* page 0 is the superblock, read it... */
-	if (bitmap->file)
-		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, PAGE_SIZE);
-	else {
+	if (bitmap->file) {
+		loff_t isize = i_size_read(bitmap->file->f_mapping->host);
+		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
+
+		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, bytes);
+	} else {
 		bitmap->sb_page = read_sb_page(bitmap->mddev, bitmap->offset, 0);
 	}
 	if (IS_ERR(bitmap->sb_page)) {
@@ -877,7 +880,8 @@ static int bitmap_init_from_disk(struct 
 			int count;
 			/* unmap the old page, we're done with it */
 			if (index == num_pages-1)
-				count = bytes - index * PAGE_SIZE;
+				count = bytes + sizeof(bitmap_super_t)
+					- index * PAGE_SIZE;
 			else
 				count = PAGE_SIZE;
 			if (index == 0) {
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
