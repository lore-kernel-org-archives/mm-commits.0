From: akpm@linux-foundation.org
Subject: + block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:51:42 -0800
Message-ID: <20130109235143.05475200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:48562 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab3AIXvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:51:45 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so146633wey.4
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:51:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, koverstreet@google.com


The patch titled
     Subject: Fix build error due to bio_endio_batch
has been added to the -mm tree.  Its filename is
     block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: Fix build error due to bio_endio_batch

This patch fixes build error of recent mmotm.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bio.h~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix include/linux/bio.h
--- a/include/linux/bio.h~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix
+++ a/include/linux/bio.h
@@ -69,6 +69,8 @@
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
 
+void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
+
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
@@ -542,8 +544,6 @@ static inline struct bio *bio_list_get(s
 	return bio;
 }
 
-void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
