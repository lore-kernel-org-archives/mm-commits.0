From: akpm@linux-foundation.org
Subject: [merged] block-improve-the-bio_add_page-and-bio_add_pc_page-descriptions.patch removed from -mm tree
Date: Wed, 01 Jun 2011 13:34:05 -0700
Message-ID: <201106012033.p51KXcfB008106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab1FAUdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 16:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agruen@kernel.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     block: improve the bio_add_page() and bio_add_pc_page() descriptions
has been removed from the -mm tree.  Its filename was
     block-improve-the-bio_add_page-and-bio_add_pc_page-descriptions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: improve the bio_add_page() and bio_add_pc_page() descriptions
From: Andreas Gruenbacher <agruen@kernel.org>

The descriptions of bio_add_page() and bio_add_pc_page() are slightly
inconsistent; improve them.

Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/bio.c~block-improve-the-bio_add_page-and-bio_add_pc_page-descriptions fs/bio.c
--- a/fs/bio.c~block-improve-the-bio_add_page-and-bio_add_pc_page-descriptions
+++ a/fs/bio.c
@@ -638,10 +638,11 @@ static int __bio_add_page(struct request
  *	@offset: vec entry offset
  *
  *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block
- *	device limitations. The target block device must allow bio's
- *      smaller than PAGE_SIZE, so it is always possible to add a single
- *      page to an empty bio. This should only be used by REQ_PC bios.
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
+ *
+ *	This should only be used by REQ_PC bios.
  */
 int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
 		    unsigned int len, unsigned int offset)
@@ -659,10 +660,9 @@ EXPORT_SYMBOL(bio_add_pc_page);
  *	@offset: vec entry offset
  *
  *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block
- *	device limitations. The target block device must allow bio's
- *      smaller than PAGE_SIZE, so it is always possible to add a single
- *      page to an empty bio.
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
  */
 int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 		 unsigned int offset)
_

Patches currently in -mm which might be from agruen@kernel.org are

linux-next.patch

