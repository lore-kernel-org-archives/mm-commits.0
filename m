From: akpm@linux-foundation.org
Subject: + jbd-fix-race-bwtween-write_metadata_buffer-and-get_write_access.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:20:43 -0700
Message-ID: <200907132120.n6DLKhx9027767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbZGMVVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dingdinghua85@gmail.com, tytso@mit.edu


The patch titled
     jbd: fix race bwtween write_metadata_buffer() and get_write_access()
has been added to the -mm tree.  Its filename is
     jbd-fix-race-bwtween-write_metadata_buffer-and-get_write_access.patch

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
Subject: jbd: fix race bwtween write_metadata_buffer() and get_write_access()
From: dingdinghua <dingdinghua85@gmail.com>

The function journal_write_metadata_buffer() calls
jbd_unlock_bh_state(bh_in) too early; this could potentially allow another
thread to call get_write_access on the buffer head, modify the data, and
dirty it, and allowing the wrong data to be written into the journal. 
Fortunately, if we lose this race, the only time this will actually cause
filesystem corruption is if there is a system crash or other unclean
shutdown of the system before the next commit can take place.

Signed-off-by: dingdinghua <dingdinghua85@gmail.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN fs/jbd/journal.c~jbd-fix-race-bwtween-write_metadata_buffer-and-get_write_access fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-fix-race-bwtween-write_metadata_buffer-and-get_write_access
+++ a/fs/jbd/journal.c
@@ -287,6 +287,7 @@ int journal_write_metadata_buffer(transa
 	struct page *new_page;
 	unsigned int new_offset;
 	struct buffer_head *bh_in = jh2bh(jh_in);
+	journal_t *journal = transaction->t_journal;
 
 	/*
 	 * The buffer really shouldn't be locked: only the current committing
@@ -300,6 +301,11 @@ int journal_write_metadata_buffer(transa
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
 	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
+	/* keep subsequent assertions sane */
+	new_bh->b_state = 0;
+	init_buffer(new_bh, NULL, NULL);
+	atomic_set(&new_bh->b_count, 1);
+	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
 
 	/*
 	 * If a new transaction has already done a buffer copy-out, then
@@ -361,14 +367,6 @@ repeat:
 		kunmap_atomic(mapped_data, KM_USER0);
 	}
 
-	/* keep subsequent assertions sane */
-	new_bh->b_state = 0;
-	init_buffer(new_bh, NULL, NULL);
-	atomic_set(&new_bh->b_count, 1);
-	jbd_unlock_bh_state(bh_in);
-
-	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
