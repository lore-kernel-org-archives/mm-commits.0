Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB26145336
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293217; cv=none; b=SMuki6NM248mKRTNNlDHIRNCpQKdhzi5vNNeo/MwpJMRvcuX1g8zE9NWkuhgQgBrvJxnj34ppW+4ZuS+9PemeGcO+tSYRc6QM+9NMJumBE4hNEgmtnsKfsVhePbI6HnUwZhDLaHECSgSb0NsrioKoa3j7kDA3WvNbRVHtOQRvBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293217; c=relaxed/simple;
	bh=eYNQgq+J/ZcPLRS27b60gU8JOwIkKRRCH6yR28ejI5Y=;
	h=Date:To:From:Subject:Message-Id; b=IZF08gLwalfii4QW7757DnYkOieD1FBUe3x0SCEbF0IIzQgd1TaUxZ1dda+dcVgncF9ddwrfweXmsKlwV5vmoadS1hNHM0Y0rayjyYzVHgNdTu7VMY+2u9ove9dyEpRIuMwsbqwftCRplqGP78kdtqeZIRqA2H8DqvFvk6Pcy/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UkXU8p18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UkXU8p18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64A2C32782;
	Tue, 25 Jun 2024 05:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293217;
	bh=eYNQgq+J/ZcPLRS27b60gU8JOwIkKRRCH6yR28ejI5Y=;
	h=Date:To:From:Subject:From;
	b=UkXU8p18w5EOWeqRFXcIZk+XXjSNfUFtM1EVgbu7BXUMLwOLTSwX5BdlWHYHVFU5U
	 8VdT8odR4Be4LtitPLAQgRA5z7MOeZEQsCYvYUdFV0xfdO6Lz+RqenfqDU81RsUqNo
	 UQ2rnilrq7/Zehwsq5F/YsP0iUmPWVeKX91HNo5Q=
Date: Mon, 24 Jun 2024 22:26:57 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-do-not-call-inode_attach_wb-directly.patch removed from -mm tree
Message-Id: <20240625052657.A64A2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not call inode_attach_wb() directly
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-call-inode_attach_wb-directly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not call inode_attach_wb() directly
Date: Tue, 11 Jun 2024 01:00:29 +0900

Call mark_buffer_dirty() for segment summary and super root block buffers
on the backing device's page cache, thereby indirectly calling
inode_attach_wb().

Then remove the no longer needed call to inode_attach_wb() in
nilfs_attach_log_writer(), resolving the concern about its layer-violating
use.

Link: https://lkml.kernel.org/r/20240610160029.7673-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-do-not-call-inode_attach_wb-directly
+++ a/fs/nilfs2/segment.c
@@ -1678,6 +1678,7 @@ static void nilfs_prepare_write_logs(str
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
+			mark_buffer_dirty(bh);
 			if (bh->b_folio == bd_folio)
 				continue;
 			if (bd_folio) {
@@ -1694,6 +1695,7 @@ static void nilfs_prepare_write_logs(str
 	/* Prepare to write super root block */
 	bh = NILFS_LAST_SEGBUF(logs)->sb_super_root;
 	if (bh) {
+		mark_buffer_dirty(bh);
 		if (bh->b_folio != bd_folio) {
 			folio_lock(bd_folio);
 			folio_wait_writeback(bd_folio);
@@ -2843,8 +2845,6 @@ int nilfs_attach_log_writer(struct super
 	if (!nilfs->ns_writer)
 		return -ENOMEM;
 
-	inode_attach_wb(nilfs->ns_bdev->bd_mapping->host, NULL);
-
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
 	if (unlikely(err))
 		nilfs_detach_log_writer(sb);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-inode-number-range-checks.patch
nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch
nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes.patch

