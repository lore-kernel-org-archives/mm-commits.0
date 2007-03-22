From: akpm@linux-foundation.org
Subject: + dm-do-not-access-the-bio-after-generic_make_request.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:51:48 -0700
Message-ID: <200703222151.l2MLpmx7031227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53416 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161108AbXCVVwI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christophe@saout.de, agk@redhat.com, olaf.kirch@oracle.com


The patch titled
     dm: do not access the bio after generic_make_request
has been added to the -mm tree.  Its filename is
     dm-do-not-access-the-bio-after-generic_make_request.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm: do not access the bio after generic_make_request
From: Christophe Saout <christophe@saout.de>

We should never access a bio after generic_make_request - there's no guarantee
it still exists.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Acked-by: Christophe Saout <christophe@saout.de>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/md/dm-crypt.c~dm-do-not-access-the-bio-after-generic_make_request drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-do-not-access-the-bio-after-generic_make_request
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

Patches currently in -mm which might be from christophe@saout.de are

dm-call-clone_init-early.patch
dm-do-not-access-the-bio-after-generic_make_request.patch
dm-get-rid-of-first_clone-in-dm-crypt.patch
dm-allocate-smaller-clones.patch
