From: akpm@linux-foundation.org
Subject: - md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:01 -0700
Message-ID: <200710242141.l9OLf1lj013908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367AbXJXVlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: fix an unsigned compare to allow creation of bitmaps with v1.0 metadata
has been removed from the -mm tree.  Its filename was
     md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: fix an unsigned compare to allow creation of bitmaps with v1.0 metadata
From: NeilBrown <neilb@suse.de>

As page->index is unsigned, this all becomes an unsigned comparison, which
 almost always returns an error.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/bitmap.c~md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata
+++ a/drivers/md/bitmap.c
@@ -274,7 +274,7 @@ static int write_sb_page(struct bitmap *
 			if (bitmap->offset < 0) {
 				/* DATA  BITMAP METADATA  */
 				if (bitmap->offset
-				    + page->index * (PAGE_SIZE/512)
+				    + (long)(page->index * (PAGE_SIZE/512))
 				    + size/512 > 0)
 					/* bitmap runs in to metadata */
 					return -EINVAL;
_

Patches currently in -mm which might be from neilb@suse.de are

git-md-accel.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
