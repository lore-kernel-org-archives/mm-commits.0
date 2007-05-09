From: akpm@linux-foundation.org
Subject: - dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:33 -0700
Message-ID: <200705092148.l49LmXKP002602@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759441AbXEIVtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf.kirch@oracle.com, agk@redhat.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     dm crypt: fix avoid cloned bio ref after free
has been removed from the -mm tree.  Its filename was
     dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 4 insertions(+), 1 deletion(-)

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
