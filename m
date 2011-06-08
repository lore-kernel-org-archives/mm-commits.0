From: akpm@linux-foundation.org
Subject: + hfsplus-add-missing-call-to-bio_put.patch added to -mm tree
Date: Tue, 07 Jun 2011 17:04:06 -0700
Message-ID: <201106080004.p58046Vw003709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162Ab1FHAEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 20:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seth.forshee@canonical.com, hch@lst.de, stable@kernel.org


The patch titled
     hfsplus: add missing call to bio_put()
has been added to the -mm tree.  Its filename is
     hfsplus-add-missing-call-to-bio_put.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

hfsplus-add-missing-call-to-bio_put.patch

