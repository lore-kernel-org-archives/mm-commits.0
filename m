From: akpm@linux-foundation.org
Subject: + dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:38 -0700
Message-ID: <200705090054.l490scEV006361@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935120AbXEIAyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf.kirch@oracle.com, agk@redhat.com, jens.axboe@oracle.com


The patch titled
     dm crypt: fix avoid cloned bio ref after free
has been added to the -mm tree.  Its filename is
     dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm crypt: fix avoid cloned bio ref after free
From: Olaf Kirch <olaf.kirch@oracle.com>

Do not access the bio after generic_make_request

We should never access a bio after generic_make_request - there's no guarantee
it still exists.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/md/dm-crypt.c~dm-crypt-fix-avoid-cloned-bio-ref-after-free drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-crypt-fix-avoid-cloned-bio-ref-after-free
+++ a/drivers/md/dm-crypt.c
@@ -655,9 +655,12 @@ static void process_write(struct crypt_i
 
 		generic_make_request(clone);
 
+		/* Do not reference clone after this - it
+		 * may be gone already. */
+
 		/* out of memory -> run queues */
 		if (remaining)
-			congestion_wait(bio_data_dir(clone), HZ/100);
+			congestion_wait(WRITE, HZ/100);
 	}
 }
 
_

Patches currently in -mm which might be from olaf.kirch@oracle.com are

origin.patch
dm-crypt-fix-call-to-clone_init.patch
dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
dm-crypt-fix-remove-first_clone.patch
dm-crypt-use-smaller-bvecs-in-clones.patch
