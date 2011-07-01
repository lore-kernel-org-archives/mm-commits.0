From: akpm@linux-foundation.org
Subject: [merged] hfsplus-add-missing-call-to-bio_put.patch removed from -mm tree
Date: Fri, 01 Jul 2011 12:17:13 -0700
Message-ID: <201107011916.p61JGrkY009594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316Ab1GATRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2011 15:17:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seth.forshee@canonical.com, hch@lst.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hfsplus: add missing call to bio_put()
has been removed from the -mm tree.  Its filename was
     hfsplus-add-missing-call-to-bio_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: add missing call to bio_put()
From: Seth Forshee <seth.forshee@canonical.com>

hfsplus leaks bio objects by failing to call bio_put() on the bios it
allocates.  Add the missing call to fix the leak.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@kernel.org>		[2.6.38+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/wrapper.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/wrapper.c~hfsplus-add-missing-call-to-bio_put fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~hfsplus-add-missing-call-to-bio_put
+++ a/fs/hfsplus/wrapper.c
@@ -36,6 +36,7 @@ int hfsplus_submit_bio(struct block_devi
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
+	int ret = 0;
 
 	bio = bio_alloc(GFP_NOIO, 1);
 	bio->bi_sector = sector;
@@ -54,8 +55,10 @@ int hfsplus_submit_bio(struct block_devi
 	wait_for_completion(&wait);
 
 	if (!bio_flagged(bio, BIO_UPTODATE))
-		return -EIO;
-	return 0;
+		ret = -EIO;
+
+	bio_put(bio);
+	return ret;
 }
 
 static int hfsplus_read_mdb(void *bufptr, struct hfsplus_wd *wd)
_

Patches currently in -mm which might be from seth.forshee@canonical.com are

linux-next.patch

