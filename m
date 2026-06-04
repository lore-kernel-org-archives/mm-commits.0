Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A513BBFAA
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609814; cv=none; b=YSAeYD/Ay3L1mI4EMKPZ50r3v/+jYBH5be17ytZHJF/i6AXE+su72rf77NMG0GKEWXWUmDmnBJB2qbD/NU4RRK+bfFDgzRINViNMLxHd2oTpdZVRGGDScspL1R6xbQ2u4Q9/KqgFGupRhXS4/A74zddS12R/W5VrWIDekEi8W+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609814; c=relaxed/simple;
	bh=lbfjL8R9FcSbX6wj3Ibl0bvg+Gdn7z3zO4FWUJ0UGVI=;
	h=Date:To:From:Subject:Message-Id; b=BOIo2VXf8tDqAXNBaZzbt1hiJ4EZd9yVi3lCdIaQnuzgwp7O4arKRStGNyX7CI16pvFNaO22OXYYrnvqvpEIaBxuLmlSQ0s9Dyaa+jHwWle0ckzHzulDkzWaD1BW/OIYP/cudCXXmRl+mAKiNtIsXIqF74kgsLJXc7IPahxGsZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FU7K01oD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FU7K01oD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DC41F00893;
	Thu,  4 Jun 2026 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609813;
	bh=PS9QDhPzoPjj6gDS2B3ObWTZxTDbUn8A6MRh45UMerQ=;
	h=Date:To:From:Subject;
	b=FU7K01oDjLSgU4D+dhYRtFHV/fdD7pFUdP0ZO8vQItTt/8CwOGfXxu0aenIRVMGJ8
	 79aLAm01Mfo76kAjp6LT/SOVpjD+YZq1kcjADTpeHuyG9WkTKd4/FYTvgbXi4U+CD9
	 rV8AjXSY9g09wwPdFXD8z4liu1bhUwEDwIDhHdEU=
Date: Thu, 04 Jun 2026 14:50:12 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,rollkingzzc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reject-fitrim-ranges-shorter-than-a-cluster.patch removed from -mm tree
Message-Id: <20260604215013.02DC41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: reject FITRIM ranges shorter than a cluster
has been removed from the -mm tree.  Its filename was
     ocfs2-reject-fitrim-ranges-shorter-than-a-cluster.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Cen <rollkingzzc@gmail.com>
Subject: ocfs2: reject FITRIM ranges shorter than a cluster
Date: Thu, 28 May 2026 23:12:47 +0800

ocfs2_trim_mainbm() trims the global bitmap in cluster units, but its
too-short range validation only checks sb->s_blocksize.

On filesystems with a cluster size larger than the block size, a FITRIM
range that is at least one block but shorter than one cluster is accepted
and shifted down to len == 0.  The later start + len - 1 and len -= ... 
arithmetic then underflows and can drive trimming past the requested
range.

Reject ranges shorter than s_clustersize instead.  That preserves the
existing -EINVAL behavior for requests that cannot discard even one
allocation unit and keeps zero-cluster trims out of the group walk.

Link: https://lore.kernel.org/20260528151247.361854-1-rollkingzzc@gmail.com
Fixes: aa89762c5480 ("ocfs2: return EINVAL if the given range to discard is less than block size")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-reject-fitrim-ranges-shorter-than-a-cluster
+++ a/fs/ocfs2/alloc.c
@@ -7576,7 +7576,7 @@ int ocfs2_trim_mainbm(struct super_block
 	len = range->len >> osb->s_clustersize_bits;
 	minlen = range->minlen >> osb->s_clustersize_bits;
 
-	if (minlen >= osb->bitmap_cpg || range->len < sb->s_blocksize)
+	if (minlen >= osb->bitmap_cpg || range->len < osb->s_clustersize)
 		return -EINVAL;
 
 	trace_ocfs2_trim_mainbm(start, len, minlen);
_

Patches currently in -mm which might be from rollkingzzc@gmail.com are


