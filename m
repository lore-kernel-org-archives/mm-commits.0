Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBDA14F10F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248840; cv=none; b=pIEhv75toovVVPfAplm0CYEwYrQ9mOGGbtSudpKnrTZ7iqfY5jp9TBQFCaPxr46FMkmYpaHU/Qi/swDMHElMMParifCDy/6DG8M17CHalW2JCik2ShRSPHhc3X6Yff1ckVEhZ2QqUq0TqDnolW7VOqduUnOquWJRF7pGBZG4N0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248840; c=relaxed/simple;
	bh=mlfqLZCEMcvdfn6xRyQ5io92gHM+4CipNHFOaoxwok4=;
	h=Date:To:From:Subject:Message-Id; b=oZ/HCN0rSq6tMp5ey161fU4ajZfUbypE2u0TiJxVGo3tr+BMGwWJhV2PW3fqWetHXtA5xkqEaDadLWmbptFTYpr2vWaG+sRbeqMIkLl4bterwki7wChYjMd8X5iXxR+bI9+sDRjUby9kgMFFuCEVVTGO7drZ4fJV8UD7k03tUJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pU+nHDhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pU+nHDhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64881C4CEC2;
	Mon,  2 Sep 2024 03:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248840;
	bh=mlfqLZCEMcvdfn6xRyQ5io92gHM+4CipNHFOaoxwok4=;
	h=Date:To:From:Subject:From;
	b=pU+nHDhl8AOxVzUM7TLFbGwzZ1neOPxAXdqno7Eq+csxl43B7g5aN9eaBFLi+jmfo
	 RBlSTOv4n9ycUVcJblK7uQCC0X6tK1t2ut9WIC4XjrutV23YdgRTQAC31b07rkbjLK
	 v4dqkI3wTPlascWUWLDZP8NSrKIae0ECfxXkbkKY=
Date: Sun, 01 Sep 2024 20:47:19 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch removed from -mm tree
Message-Id: <20240902034720.64881C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not propagate ENOENT error from nilfs_sufile_mark_dirty()
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not propagate ENOENT error from nilfs_sufile_mark_dirty()
Date: Thu, 22 Aug 2024 00:46:27 +0900

nilfs_sufile_mark_dirty(), which marks a block in the sufile metadata file
as dirty in preparation for log writing, returns -ENOENT to the caller if
the block containing the segment usage of the specified segment is
missing.

This internal code can propagate through the log writer to system calls
such as fsync.  To prevent this, treat this case as a filesystem error and
return -EIO instead.

Link: https://lkml.kernel.org/r/20240821154627.11848-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/sufile.c~nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty
+++ a/fs/nilfs2/sufile.c
@@ -513,8 +513,15 @@ int nilfs_sufile_mark_dirty(struct inode
 
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
-	if (ret)
+	if (unlikely(ret)) {
+		if (ret == -ENOENT) {
+			nilfs_error(sufile->i_sb,
+				    "segment usage for segment %llu is unreadable due to a hole block",
+				    (unsigned long long)segnum);
+			ret = -EIO;
+		}
 		goto out_sem;
+	}
 
 	kaddr = kmap_local_page(bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


