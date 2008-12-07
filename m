From: akpm@linux-foundation.org
Subject: - block-reorder-struct-bio-to-remove-padding-on-64bit.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:36 -0800
Message-ID: <200812070005.mB705aeu021501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbYLGAGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:06:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: reorder struct bio to remove padding on 64bit
has been removed from the -mm tree.  Its filename was
     block-reorder-struct-bio-to-remove-padding-on-64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: reorder struct bio to remove padding on 64bit
From: Richard Kennedy <richard@rsk.demon.co.uk>

Remove 8 bytes of padding from struct bio which also removes 16 bytes from
struct bio_pair to make it 248 bytes.  bio_pair then fits into one fewer
cache lines & into a smaller slab.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bio.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/bio.h~block-reorder-struct-bio-to-remove-padding-on-64bit include/linux/bio.h
--- a/include/linux/bio.h~block-reorder-struct-bio-to-remove-padding-on-64bit
+++ a/include/linux/bio.h
@@ -90,10 +90,11 @@ struct bio {
 
 	unsigned int		bi_comp_cpu;	/* completion CPU */
 
+	atomic_t		bi_cnt;		/* pin count */
+
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
 	bio_end_io_t		*bi_end_io;
-	atomic_t		bi_cnt;		/* pin count */
 
 	void			*bi_private;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch
linux-next.patch

