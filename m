Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6271C3314B9
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244588; cv=none; b=QuIcnPX6yqui5g4ZEBn7XSKnzDNpUKzRwTdCW0ixVBKD5X4WEQ6Lf1IE+fpbCDuvcTH7W430V+LYqEsMXtPGZWuL0yBS9sjHVB55CEEgGhcTXfECq1sql/vohxFVuZUE6GQ63rglcZl7MMLMr98Cg9U8juHWiELBTPXI8AyHlho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244588; c=relaxed/simple;
	bh=94NNTrT0AMaZX94jRHAAR+7CYIZ//Ia4El+5Xj1VMmQ=;
	h=Date:To:From:Subject:Message-Id; b=aEpN5sAunY1TXU8Q2itiA+Q0nvRLIjmbTq7wCmk8/lB1vU/tPl4cSI+NSqEn5xsTN0fTIkxv28cZQ94mLiSVmRMmlm0waj2zVygo2iKF8fusEHwH6ythuz5dCp/rXRdUEtClgBszBTz19C+XtRwWpCmsxoM/2l8jGOSoRhxZigU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNgxbA0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNgxbA0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DEEC2BCB5;
	Wed, 15 Apr 2026 09:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244588;
	bh=94NNTrT0AMaZX94jRHAAR+7CYIZ//Ia4El+5Xj1VMmQ=;
	h=Date:To:From:Subject:From;
	b=eNgxbA0xq6mqAI7JucIhGon1V2OUOR71/hnlo5RitHUnBSaCKThbKm7ufJ8XeNFbt
	 YZSeZk6D7gR9iSWAUdyxf+zKfRFR0A/ScevkMbgZgTAz5B1cV+iTaX7THTjctp/nIJ
	 I1JiVzTPpa0scHRzprDobOZHLYRauJokAll3y+iY=
Date: Wed, 15 Apr 2026 02:16:25 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-extent-block-list-fields-during-block-read.patch removed from -mm tree
Message-Id: <20260415091627.97DEEC2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate extent block list fields during block read
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-extent-block-list-fields-during-block-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate extent block list fields during block read
Date: Fri, 3 Apr 2026 17:08:02 +0800

Add extent list validation to ocfs2_validate_extent_block() so that
corrupted on-disk fields are caught early at block read time rather than
during extent tree traversal.

Two checks are added:

  - l_count must equal the expected value from
    ocfs2_extent_recs_per_eb(), catching blocks with a corrupted record
    count before any array iteration.

  - l_next_free_rec must not exceed l_count, preventing out-of-bounds
    access when iterating over extent records.

Link: https://lkml.kernel.org/r/20260403090803.3860971-4-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-validate-extent-block-list-fields-during-block-read
+++ a/fs/ocfs2/alloc.c
@@ -917,11 +917,32 @@ static int ocfs2_validate_extent_block(s
 		goto bail;
 	}
 
-	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation)
+	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
 		rc = ocfs2_error(sb,
 				 "Extent block #%llu has an invalid h_fs_generation of #%u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le32_to_cpu(eb->h_fs_generation));
+		goto bail;
+	}
+
+	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
+		rc = ocfs2_error(sb,
+				 "Extent block #%llu has invalid l_count %u (expected %u)\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(eb->h_list.l_count),
+				 ocfs2_extent_recs_per_eb(sb));
+		goto bail;
+	}
+
+	if (le16_to_cpu(eb->h_list.l_next_free_rec) > le16_to_cpu(eb->h_list.l_count)) {
+		rc = ocfs2_error(sb,
+				 "Extent block #%llu has invalid l_next_free_rec %u (l_count %u)\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(eb->h_list.l_next_free_rec),
+				 le16_to_cpu(eb->h_list.l_count));
+		goto bail;
+	}
+
 bail:
 	return rc;
 }
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


