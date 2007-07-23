From: akpm@linux-foundation.org
Subject: - dm-io-fix-panic-on-large-request.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:33:45 -0700
Message-ID: <200707230933.l6N9XjYm016322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757350AbXGWJen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mbroz@redhat.com, agk@redhat.com, cebbert@redhat.com, christophe@saout.de, kaber@trash.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dm io: fix panic on large request
has been removed from the -mm tree.  Its filename was
     dm-io-fix-panic-on-large-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm io: fix panic on large request
From: Milan Broz <mbroz@redhat.com>

Flush workqueue before releasing bioset and mopools in dm-crypt.  There can
be finished but not yet released request.

Call chain causing oops:
  run workqueue
    dec_pending
      bio_endio(...);
      	<remove device request - remove mempool>
      mempool_free(io, cc->io_pool);

This usually happens when cryptsetup create temporary
luks mapping in the beggining of crypt device activation.

When dm-core calls destructor crypt_dtr, no new request
are possible.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Cc: Christophe Saout <christophe@saout.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/md/dm-crypt.c~dm-io-fix-panic-on-large-request drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-io-fix-panic-on-large-request
+++ a/drivers/md/dm-crypt.c
@@ -920,6 +920,8 @@ static void crypt_dtr(struct dm_target *
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
+	flush_workqueue(_kcryptd_workqueue);
+
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
 	mempool_destroy(cc->io_pool);
_

Patches currently in -mm which might be from mbroz@redhat.com are
