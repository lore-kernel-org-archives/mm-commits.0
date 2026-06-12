Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B3A13B58A;
	Fri, 12 Jun 2026 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781227386; cv=none; b=HF4b7meT6Nov6WIrzIfb9YayOiJp3Rh9IGumkUZDeaimeuX5PCTSvoSXwV+T0rSLSXewtu0drXV3x0hDFj7grl2dlPTaQpdbuItYdl9wa1mEimCeO0xyjGBw2iebgMbtoe3tFI23jG6drM/TkHI+2lGCv/a/2G9jP1kHfzAFguI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781227386; c=relaxed/simple;
	bh=YySmRN2InHe0zbzE26gk6WYa22vR2Y/cLM5ZStbxsHg=;
	h=Date:To:From:Subject:Message-Id; b=j4TT8iERSoct44POWLTYO3eCXbglSPKvjcQx7Bf1aWa+FcbIv2HMEeKh73Rf0beb/Kz9H0mQUMuey6+uzaTAfASB5e+gyKz4+hfFMTai0GFntcoMT6lbtKQY5jiFJ/gaahcOaQw9q9wxxaW6ho2EUY69GE2cOb3du9bIaSsGggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tXIR/rVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tXIR/rVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911CB1F000E9;
	Fri, 12 Jun 2026 01:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781227381;
	bh=KlkYP8VAdnveSJkJ3+ASbCy7DrQBC0Wwd1FAHB51ztU=;
	h=Date:To:From:Subject;
	b=tXIR/rVS79NH/97n8iBv7Qp4hyJ1S+6buAjLw3qcwqZxBupPGZpZAugMcGNrVWVrQ
	 Xg6I+2+2XGDlxR1lf/v8pPnO8L8hDLHIi4fHq07aa05JH2BCRdVRd7y9SelqrJlI4E
	 hlMU0UIHTSaCy1F0FmPjRvOXcI+ndmgzZ/FeFfys=
Date: Thu, 11 Jun 2026 18:23:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,icb@fastmail.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec.patch added to mm-nonmm-unstable branch
Message-Id: <20260612012301.911CB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ian Bridges <icb@fastmail.org>
Subject: ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec
Date: Wed, 10 Jun 2026 19:23:11 -0500

[BUG]
On-disk corruption setting l_next_free_rec to 0 in an inode's embedded
extent list triggers a UBSAN panic on the next write to that file.

[CAUSE]
ocfs2_sum_rightmost_rec() computes
i = le16_to_cpu(el->l_next_free_rec) - 1
and accesses el->l_recs[i] without validating i. When l_next_free_rec
is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
past the end of the array. Either case violates the
__counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.

[FIX]
Validate the inode's embedded extent list when the inode is read, in
ocfs2_validate_inode_block(): l_count must be non-zero and no larger
than the inode block can hold, and l_next_free_rec must not exceed
l_count. A corrupt list is rejected at read time, before the b-tree
code can index l_recs[] out of bounds.

Link: https://lore.kernel.org/ain_780qc0P4ypNd@dev
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec
+++ a/fs/ocfs2/inode.c
@@ -1696,6 +1696,38 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_extents(di)) {
+		struct ocfs2_extent_list *el = &di->id2.i_list;
+		u16 count = le16_to_cpu(el->l_count);
+		u16 next_free = le16_to_cpu(el->l_next_free_rec);
+
+		if (count == 0) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_count is zero\n",
+					 (unsigned long long)bh->b_blocknr);
+			goto bail;
+		}
+		/*
+		 * The exact capacity depends on i_xattr_inline_size, another
+		 * unvalidated on-disk field. Inline xattrs only shrink the
+		 * list, so the no-xattr maximum is a safe upper bound that a
+		 * valid l_count never exceeds.
+		 */
+		if (count > ocfs2_extent_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
+					 (unsigned long long)bh->b_blocknr, count,
+					 ocfs2_extent_recs_per_inode(sb));
+			goto bail;
+		}
+		if (next_free > count) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
+					 (unsigned long long)bh->b_blocknr, next_free, count);
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
_

Patches currently in -mm which might be from icb@fastmail.org are

ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec.patch

