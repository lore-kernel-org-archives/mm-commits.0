Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4491815A87B;
	Thu,  8 Aug 2024 22:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723157821; cv=none; b=ORD2JhOa0EgrFJeGUYUGfypM9CCWPXkRP9YTWYYy50RETv5Aj2n06FPlYLUVc9mYIuJkl4VL9DSCYyPPGgmhDUPQrhjT+wVbw/SyGS9h8YV1glUbsX1pnWAQKm679bnVhB4+z+lgzAoP2Xem5BHU5CiNqeKvoT5kRXCeFZfvYMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723157821; c=relaxed/simple;
	bh=3xVH7kdp21fwBWu5i57L4nDRGH+wwhISXOyckFXh65g=;
	h=Date:To:From:Subject:Message-Id; b=sMpimHldMmpRyVW7w7AdAYYyYYJ0rTJ8CQ7RudJJ8wBrBPLdZEq42IKdXmSSzHtB+Bb6N9i8J3vzMTY6DcCohBAX7sI50pXWpvxIleWPmNEFR6vXKftw1wAGyczROPCP5/8NxdZgKIohJR8YlpuoxTiaYSihKghKRAt5j62jYAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mod9nZDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mod9nZDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD21C32782;
	Thu,  8 Aug 2024 22:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723157820;
	bh=3xVH7kdp21fwBWu5i57L4nDRGH+wwhISXOyckFXh65g=;
	h=Date:To:From:Subject:From;
	b=mod9nZDWT6qa3OOFuk/qu86I6fEIhxG2ecHwzfjOThQdMqyYWqMpYQxqCa6rZ4FxU
	 j6J77vqKxUnLs6eA0U4NNgA041oGZNKuj0CGbulCRWsFGgNjem0//kO7wrCaOVXgVV
	 BTOcLVpyYHIUXXEJeJDw8/s3kRnUNgi1f+f2GsXg=
Date: Thu, 08 Aug 2024 15:57:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch added to mm-hotfixes-unstable branch
Message-Id: <20240808225700.ACD21C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix state management in error path of log writing function
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch

