Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEF51F16B
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037057; cv=none; b=meOv/W5crTxWxlq3BsAGX+HgtmMiIxBcM+YeIsjvp3dyWVTdNU/x6y4yoijEbMyAsCfgCI9TZkRPnBIbcDeOpE97PMdZF3V4a0MmlULiYNfLZiHim11wiG4ghJfH3cRr/HY+kwM3mq2g3Bl+YFrg3whkdsqxBETI+xHq7rcmblQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037057; c=relaxed/simple;
	bh=HVF8dGkSjF7qmqlTrWK6EN9w6kzv5N3g/xpH0X5qq+U=;
	h=Date:To:From:Subject:Message-Id; b=p5d8jcqfwKJPZQInVVy2No2X+79/oO+s6jZ9Ie9S/b7TN94TEZ/2twARg2KAGHIcSGJaonWgHFEpAnmIvAnD0S+oV1oumNOAcMibAF56oLPqtArYbjACxpTQGvmH0GszC7vHBmG13np4Ez18T3rJGSNMJhZVPaY8t4wBSTPF5Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tP7NLXA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tP7NLXA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6D6C2BBFC;
	Mon, 10 Jun 2024 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718037056;
	bh=HVF8dGkSjF7qmqlTrWK6EN9w6kzv5N3g/xpH0X5qq+U=;
	h=Date:To:From:Subject:From;
	b=tP7NLXA6gMdjf2I68fO/3RqNMGGizxqH9+6y98bqSMQv5ge9qE+4srBHmPP8aLwoh
	 +9O/2lBQfOOuZDz4FFsR0fe0ald9bJy0kVzYYMJ8A6lQ1MZWSARpGeZQO1Pud/d4hr
	 bUCfSURoakaDY5sBF3bODpJEEnJlltpPxhB6IVBo=
Date: Mon, 10 Jun 2024 09:30:55 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums.patch added to mm-nonmm-unstable branch
Message-Id: <20240610163056.3A6D6C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: prepare backing device folios for writing after adding checksums
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: prepare backing device folios for writing after adding checksums
Date: Tue, 11 Jun 2024 01:00:28 +0900

Patch series "nilfs2: eliminate the call to inode_attach_wb()".

This series eliminates the inode_attach_wb() call from nilfs2, which was
introduced as a workaround for a kernel bug but is suspected of layer
violation (in fact, it is undesirable since it exposes a reference to the
backing device).

Removal of the inode_attach_wb() call is done by simply using
mark_buffer_dirty() on the backing device's buffers.  To use it safely,
this series will prepare it in patch 1/2, and perform the replacement
itself in patch 2/2.


This patch (of 2):

In preparation for inode_attach_wb(), which is currently called when
attaching the log writer, to be done via mark_buffer_dirty(), change the
order of preparation for log writing.

Specifically, the function call that adds checksums to segment summary and
super root blocks, which correspond to the log header and trailer, is made
before starting writeback of folios containing those blocks.

The current steps are as follows:

1. Put the folios of segment summary blocks in writeback state.
2. Put the folios of data blocks, metadata file blocks, and btree node
   blocks (collectively called payload blocks) into writeback state.
3. Put the super root block folio in writeback state.
4. Add checksums.

Change these as follows:

1. Put the folios of payload blocks in writeback state.
2. Add checksums.
3. Put the folios of segment summary blocks in writeback state.
4. Put the super root block folio in writeback state.

In this order, the contents of segment summaries and super root block
that directly use buffer/folio of the backing device can be determined
including the addition of checksums, before preparing to write.

Step (1), which puts the payload block folios in writeback state, is
performed first because if there are memory-mapped data blocks, a valid
checksum can only be calculated after step (1).

Link: https://lkml.kernel.org/r/20240610160029.7673-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   85 +++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 33 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums
+++ a/fs/nilfs2/segment.c
@@ -1639,41 +1639,30 @@ static void nilfs_begin_folio_io(struct
 	folio_unlock(folio);
 }
 
-static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
+/**
+ * nilfs_prepare_write_logs - prepare to write logs
+ * @logs: logs to prepare for writing
+ * @seed: checksum seed value
+ *
+ * nilfs_prepare_write_logs() adds checksums and prepares the block
+ * buffers/folios for writing logs.  In order to stabilize folios of
+ * memory-mapped file blocks by putting them in writeback state before
+ * calculating the checksums, first prepare to write payload blocks other
+ * than segment summary and super root blocks in which the checksums will
+ * be embedded.
+ */
+static void nilfs_prepare_write_logs(struct list_head *logs, u32 seed)
 {
 	struct nilfs_segment_buffer *segbuf;
 	struct folio *bd_folio = NULL, *fs_folio = NULL;
+	struct buffer_head *bh;
 
-	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
-		struct buffer_head *bh;
-
-		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
-				    b_assoc_buffers) {
-			if (bh->b_folio != bd_folio) {
-				if (bd_folio) {
-					folio_lock(bd_folio);
-					folio_wait_writeback(bd_folio);
-					folio_clear_dirty_for_io(bd_folio);
-					folio_start_writeback(bd_folio);
-					folio_unlock(bd_folio);
-				}
-				bd_folio = bh->b_folio;
-			}
-		}
-
+	/* Prepare to write payload blocks */
+	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			if (bh == segbuf->sb_super_root) {
-				if (bh->b_folio != bd_folio) {
-					folio_lock(bd_folio);
-					folio_wait_writeback(bd_folio);
-					folio_clear_dirty_for_io(bd_folio);
-					folio_start_writeback(bd_folio);
-					folio_unlock(bd_folio);
-					bd_folio = bh->b_folio;
-				}
+			if (bh == segbuf->sb_super_root)
 				break;
-			}
 			set_buffer_async_write(bh);
 			if (bh->b_folio != fs_folio) {
 				nilfs_begin_folio_io(fs_folio);
@@ -1681,6 +1670,40 @@ static void nilfs_segctor_prepare_write(
 			}
 		}
 	}
+	nilfs_begin_folio_io(fs_folio);
+
+	nilfs_add_checksums_on_logs(logs, seed);
+
+	/* Prepare to write segment summary blocks */
+	list_for_each_entry(segbuf, logs, sb_list) {
+		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
+				    b_assoc_buffers) {
+			if (bh->b_folio == bd_folio)
+				continue;
+			if (bd_folio) {
+				folio_lock(bd_folio);
+				folio_wait_writeback(bd_folio);
+				folio_clear_dirty_for_io(bd_folio);
+				folio_start_writeback(bd_folio);
+				folio_unlock(bd_folio);
+			}
+			bd_folio = bh->b_folio;
+		}
+	}
+
+	/* Prepare to write super root block */
+	bh = NILFS_LAST_SEGBUF(logs)->sb_super_root;
+	if (bh) {
+		if (bh->b_folio != bd_folio) {
+			folio_lock(bd_folio);
+			folio_wait_writeback(bd_folio);
+			folio_clear_dirty_for_io(bd_folio);
+			folio_start_writeback(bd_folio);
+			folio_unlock(bd_folio);
+			bd_folio = bh->b_folio;
+		}
+	}
+
 	if (bd_folio) {
 		folio_lock(bd_folio);
 		folio_wait_writeback(bd_folio);
@@ -1688,7 +1711,6 @@ static void nilfs_segctor_prepare_write(
 		folio_start_writeback(bd_folio);
 		folio_unlock(bd_folio);
 	}
-	nilfs_begin_folio_io(fs_folio);
 }
 
 static int nilfs_segctor_write(struct nilfs_sc_info *sci,
@@ -2070,10 +2092,7 @@ static int nilfs_segctor_do_construct(st
 		nilfs_segctor_update_segusage(sci, nilfs->ns_sufile);
 
 		/* Write partial segments */
-		nilfs_segctor_prepare_write(sci);
-
-		nilfs_add_checksums_on_logs(&sci->sc_segbufs,
-					    nilfs->ns_crc_seed);
+		nilfs_prepare_write_logs(&sci->sc_segbufs, nilfs->ns_crc_seed);
 
 		err = nilfs_segctor_write(sci, nilfs);
 		if (unlikely(err))
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums.patch
nilfs2-do-not-call-inode_attach_wb-directly.patch

