Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA65631;
	Wed, 14 Aug 2024 00:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723596663; cv=none; b=MnyQ3Qb6J6QwURm/8E2qtD6P/0cH5z9UkoXB/wzJuFmj5r4AxbqmE11mVJXuoP4DoyNcI2E9uV4gT897z3U1XicgPVVmY36xRhdHq3m1PdaSAUFn/NMMgnA3cDPACfCyB3A6L9mT5aXYqQsJNfAJgbaIUcoZg1IaGMnlc0rYvwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723596663; c=relaxed/simple;
	bh=t7u2ECsYK5uvE27Rt+8mDQLrqiy6489qgu4fwxQRjxI=;
	h=Date:To:From:Subject:Message-Id; b=YWqKkq5g34QlrB5qVTvgM/4Op+TMv2xJUjzajbbcI2AYfQk+U74pFlfH8HqbD2f07zB4nLmiXaxbVueGowyyAocgfRn0yog0pd8V5XXLoy0V4bk14ia9toWpAV5bhkXoKZ27l7ETtpKhEVLzCaNgCIcp2TFXbp/N5yAetCcJ8ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdXlcOh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdXlcOh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF31C32782;
	Wed, 14 Aug 2024 00:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723596662;
	bh=t7u2ECsYK5uvE27Rt+8mDQLrqiy6489qgu4fwxQRjxI=;
	h=Date:To:From:Subject:From;
	b=ZdXlcOh3gxxUpQuA2iguJMGTdBfpS/AkBG17G2aZ5qSWmVcxCx02EaKX1R+VBJHpH
	 RSvdDH7S2yHTQ3b4kHfcFHS/NAE6zF4qaACIw7tU1qhTwgLBa/GZjG5cyyc5oP8IDZ
	 8ybALVnn6sxRFTVJe0XBbsNZDg0gVhuSWvJaEVqY=
Date: Tue, 13 Aug 2024 17:51:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch removed from -mm tree
Message-Id: <20240814005102.AAF31C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix state management in error path of log writing function
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix state management in error path of log writing function
Date: Thu, 8 Aug 2024 08:07:42 +0900

After commit a694291a6211 ("nilfs2: separate wait function from
nilfs_segctor_write") was applied, the log writing function
nilfs_segctor_do_construct() was able to issue I/O requests continuously
even if user data blocks were split into multiple logs across segments,
but two potential flaws were introduced in its error handling.

First, if nilfs_segctor_begin_construction() fails while creating the
second or subsequent logs, the log writing function returns without
calling nilfs_segctor_abort_construction(), so the writeback flag set on
pages/folios will remain uncleared.  This causes page cache operations to
hang waiting for the writeback flag.  For example,
truncate_inode_pages_final(), which is called via nilfs_evict_inode() when
an inode is evicted from memory, will hang.

Second, the NILFS_I_COLLECTED flag set on normal inodes remain uncleared. 
As a result, if the next log write involves checkpoint creation, that's
fine, but if a partial log write is performed that does not, inodes with
NILFS_I_COLLECTED set are erroneously removed from the "sc_dirty_files"
list, and their data and b-tree blocks may not be written to the device,
corrupting the block mapping.

Fix these issues by correcting the jump destination of the error branch in
nilfs_segctor_do_construct() and the condition for calling
nilfs_redirty_inodes(), which clears the NILFS_I_COLLECTED flag.

Link: https://lkml.kernel.org/r/20240807230742.11151-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: a694291a6211 ("nilfs2: separate wait function from nilfs_segctor_write")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-fix-state-management-in-error-path-of-log-writing-function
+++ a/fs/nilfs2/segment.c
@@ -2056,7 +2056,7 @@ static int nilfs_segctor_do_construct(st
 
 		err = nilfs_segctor_begin_construction(sci, nilfs);
 		if (unlikely(err))
-			goto out;
+			goto failed;
 
 		/* Update time stamp */
 		sci->sc_seg_ctime = ktime_get_real_seconds();
@@ -2120,10 +2120,9 @@ static int nilfs_segctor_do_construct(st
 	return err;
 
  failed_to_write:
-	if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
-		nilfs_redirty_inodes(&sci->sc_dirty_files);
-
  failed:
+	if (mode == SC_LSEG_SR && nilfs_sc_cstage_get(sci) >= NILFS_ST_IFILE)
+		nilfs_redirty_inodes(&sci->sc_dirty_files);
 	if (nilfs_doing_gc())
 		nilfs_redirty_inodes(&sci->sc_gc_inodes);
 	nilfs_segctor_abort_construction(sci, nilfs, err);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


