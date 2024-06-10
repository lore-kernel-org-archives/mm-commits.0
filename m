Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8739E1F16B
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037058; cv=none; b=DmZ86R9TUuEs83OerJymZUzr5pxBx6vMtQIRP0i6HoJQHJfiHqkw7rLvx3swLWg+yhL2aZe9hAkECZSJIEaMdeaG1OinGT0Tg9/FPDDg0ViuXhuk4qoRKX9C+0ltwLBLy8Bu/DJjQIpkCB/OS54/h9XqY3jIDlSGUQrycaD2KAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037058; c=relaxed/simple;
	bh=DOUZFB93vGEOhw4xRfPVhWTrxk2W2rwO/3S5R8uLi1I=;
	h=Date:To:From:Subject:Message-Id; b=jpJ2XboK9mT6sAwNlel9w4oNLwbr+Icnjya/uhLHaWc66stnRyB5FVpbD2ao2MOM84SQpkmGIto+V1SKWnD1zoK+6FY8tyzhNzL1D8Aobfj8a+QtuNC1XqRZmoMYTcm4NesCR0udwLpGTCNvYHt+uwD683sS6Fes4TKzgQxPvDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2VioO7gV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2VioO7gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4EBC2BBFC;
	Mon, 10 Jun 2024 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718037058;
	bh=DOUZFB93vGEOhw4xRfPVhWTrxk2W2rwO/3S5R8uLi1I=;
	h=Date:To:From:Subject:From;
	b=2VioO7gVNnGqvWY9FiiBhAcCwoM5utqTsOmfrYOu38dfJmYUuBwVh1fwKd9fFEzxS
	 8Wzr5jSMVj5pfrg5VoxfA6+enNubDC+3yyaqi9fHSChiCq5D52gNWsca/de1A6EZem
	 ka9gDN6ow/ZLGrAD3tI0Loc8WkVrIFIJO9XqhMAA=
Date: Mon, 10 Jun 2024 09:30:57 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-call-inode_attach_wb-directly.patch added to mm-nonmm-unstable branch
Message-Id: <20240610163058.1B4EBC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not call inode_attach_wb() directly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-call-inode_attach_wb-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-call-inode_attach_wb-directly.patch

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

nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums.patch
nilfs2-do-not-call-inode_attach_wb-directly.patch

