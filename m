Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB2679F8;
	Thu,  8 Feb 2024 05:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369692; cv=none; b=jqHfYnD0PUrsP83uUHKOwnpMp9aRFanvTTTn7uRSa8otp55jhPSeRMYOmMq9y7CsQHiIWBO6vfTiXojmaEdjQKm5QNrDFGvqs4zeScFzJTEvShTSfEmOkhvD+DhjnVHNxTsN/+meemmfz9hNWqL4yhdljD2H+Tti2e+ocK1msTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369692; c=relaxed/simple;
	bh=77P7cbLLsnqfGsV8SeR/2Gyh23p3Yl6T1HmLy7WUSSA=;
	h=Date:To:From:Subject:Message-Id; b=UPvKQXBG3SIRcYH1HqYHUUcAcONjJ9nr2kGgb2czos9Y/VgAzVq8Y5nLe1wNaP2bAAm8f3S/XQBjkMPlvM1Buts+2A6wGaREk9oxjS+fyaGHkqWFWBcvH8xlaa6qrnHp5JSO2z8N6dha1qS/cckp0EqSeLS7kf6VFwFh+lfZA3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ictLoP+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ictLoP+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A05C433C7;
	Thu,  8 Feb 2024 05:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369692;
	bh=77P7cbLLsnqfGsV8SeR/2Gyh23p3Yl6T1HmLy7WUSSA=;
	h=Date:To:From:Subject:From;
	b=ictLoP+odKUCJJ2MqeACNqgAwJplPCtUAfpcWLvsOnjazTPfsXsugnKbQZ9ewN09b
	 0RO7l/anOynA+grUrLU2YUtHkwpfp0pbvdqHeZNTymlozdKg9vycLTe/pyW59CbaWq
	 GZVZkxM6FCq0daFBYtdq8uacKPCTjJfayheeX/+8=
Date: Wed, 07 Feb 2024 21:21:31 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-potential-bug-in-end_buffer_async_write.patch removed from -mm tree
Message-Id: <20240208052132.00A05C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix potential bug in end_buffer_async_write
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-potential-bug-in-end_buffer_async_write.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix potential bug in end_buffer_async_write
Date: Sun, 4 Feb 2024 01:16:45 +0900

According to a syzbot report, end_buffer_async_write(), which handles the
completion of block device writes, may detect abnormal condition of the
buffer async_write flag and cause a BUG_ON failure when using nilfs2.

Nilfs2 itself does not use end_buffer_async_write().  But, the async_write
flag is now used as a marker by commit 7f42ec394156 ("nilfs2: fix issue
with race condition of competition between segments for dirty blocks") as
a means of resolving double list insertion of dirty blocks in
nilfs_lookup_dirty_data_buffers() and nilfs_lookup_node_buffers() and the
resulting crash.

This modification is safe as long as it is used for file data and b-tree
node blocks where the page caches are independent.  However, it was
irrelevant and redundant to also introduce async_write for segment summary
and super root blocks that share buffers with the backing device.  This
led to the possibility that the BUG_ON check in end_buffer_async_write
would fail as described above, if independent writebacks of the backing
device occurred in parallel.

The use of async_write for segment summary buffers has already been
removed in a previous change.

Fix this issue by removing the manipulation of the async_write flag for
the remaining super root block buffer.

Link: https://lkml.kernel.org/r/20240203161645.4992-1-konishi.ryusuke@gmail.com
Fixes: 7f42ec394156 ("nilfs2: fix issue with race condition of competition between segments for dirty blocks")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+5c04210f7c7f897c1e7f@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/00000000000019a97c05fd42f8c8@google.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-fix-potential-bug-in-end_buffer_async_write
+++ a/fs/nilfs2/segment.c
@@ -1703,7 +1703,6 @@ static void nilfs_segctor_prepare_write(
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			set_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_folio != bd_folio) {
 					folio_lock(bd_folio);
@@ -1714,6 +1713,7 @@ static void nilfs_segctor_prepare_write(
 				}
 				break;
 			}
+			set_buffer_async_write(bh);
 			if (bh->b_folio != fs_folio) {
 				nilfs_begin_folio_io(fs_folio);
 				fs_folio = bh->b_folio;
@@ -1800,7 +1800,6 @@ static void nilfs_abort_logs(struct list
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			clear_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				clear_buffer_uptodate(bh);
 				if (bh->b_folio != bd_folio) {
@@ -1809,6 +1808,7 @@ static void nilfs_abort_logs(struct list
 				}
 				break;
 			}
+			clear_buffer_async_write(bh);
 			if (bh->b_folio != fs_folio) {
 				nilfs_end_folio_io(fs_folio, err);
 				fs_folio = bh->b_folio;
@@ -1896,8 +1896,9 @@ static void nilfs_segctor_complete_write
 				 BIT(BH_Delay) | BIT(BH_NILFS_Volatile) |
 				 BIT(BH_NILFS_Redirected));
 
-			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh == segbuf->sb_super_root) {
+				set_buffer_uptodate(bh);
+				clear_buffer_dirty(bh);
 				if (bh->b_folio != bd_folio) {
 					folio_end_writeback(bd_folio);
 					bd_folio = bh->b_folio;
@@ -1905,6 +1906,7 @@ static void nilfs_segctor_complete_write
 				update_sr = true;
 				break;
 			}
+			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh->b_folio != fs_folio) {
 				nilfs_end_folio_io(fs_folio, 0);
 				fs_folio = bh->b_folio;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch

