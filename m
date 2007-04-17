From: akpm@linux-foundation.org
Subject: - dm-do-not-access-the-bio-after-generic_make_request.patch removed from -mm tree
Date: Mon, 16 Apr 2007 22:17:13 -0700
Message-ID: <200704170517.l3H5HDDn020994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbXDQFRj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 01:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf.kirch@oracle.com, agk@redhat.com, christophe@saout.de, mm-commits@vger.kernel.org


The patch titled
     dm: do not access the bio after generic_make_request
has been removed from the -mm tree.  Its filename was
     dm-do-not-access-the-bio-after-generic_make_request.patch

This patch was dropped because changes in the dm tree broke it

------------------------------------------------------
Subject: dm: do not access the bio after generic_make_request
From: Olaf Kirch <olaf.kirch@oracle.com>

We should never access a bio after generic_make_request - there's no guarantee
it still exists.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Acked-by: Christophe Saout <christophe@saout.de>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/md/dm-crypt.c~dm-do-not-access-the-bio-after-generic_make_request drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-do-not-access-the-bio-after-generic_make_request
+++ a/drivers/md/dm-crypt.c
@@ -669,9 +669,12 @@ static void process_write(struct crypt_i
 
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
dm-do-not-access-the-bio-after-generic_make_request.patch
dm-get-rid-of-first_clone-in-dm-crypt.patch
dm-allocate-smaller-clones.patch
