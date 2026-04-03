Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD012DEA9B
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236469; cv=none; b=NoONKpESaDwt4ATBhUoakatmR4DSayPcbzJdJDmWT/tbIOEU38oodbcH75HSZOexexkuX7qGHgtW3pBkuj1OZ9FPoblFrnnO+hxE+F9VaYdpMNQn62Ll36fIlXTKL+GkoXozRUWGl/m+2ZVCOC0GQI4wmMFSl0DIqlgNC7eYUIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236469; c=relaxed/simple;
	bh=UZjDuiV1zVp98Dco19ZccgN8dB5mlKj2us0sUUTKYts=;
	h=Date:To:From:Subject:Message-Id; b=D5aj6noaTqJJgmerfIcpaprfJLPynk8R3/F4C//3dsfLK1klr1Wr0vLFMS/vwEKRTPKVGNDwGS3V2rJo2dEMUuSXiEM2C3RsdpdCtj/KB7i/Nf1VLMLt/V3rAjnGCf1/v10XAqRbg1mcc/Wq6vkWiczO3Dm2x1wtvHlQyQj4KMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nEHvfOlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nEHvfOlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E03C4CEF7;
	Fri,  3 Apr 2026 17:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775236468;
	bh=UZjDuiV1zVp98Dco19ZccgN8dB5mlKj2us0sUUTKYts=;
	h=Date:To:From:Subject:From;
	b=nEHvfOlTJJRBvW48ovvy7i/893RNZikHAeOketSZr+3sqhsxxVaPIkL2j1UinXsXl
	 YWaH1EzvMQehdJ2Xggdos1bf5fgU264vTfNS5/cb3G1MoJjakYBO8Lh31U4CWB20A7
	 axufSkgybUb0RTCdFhbae2fNL4jZhzCz9eeWvAwU=
Date: Fri, 03 Apr 2026 10:14:28 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-extent-block-list-fields-during-block-read.patch added to mm-nonmm-unstable branch
Message-Id: <20260403171428.86E03C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate extent block list fields during block read
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-extent-block-list-fields-during-block-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-extent-block-list-fields-during-block-read.patch

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
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
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

ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline.patch
ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch
ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch
ocfs2-validate-extent-block-list-fields-during-block-read.patch
ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch

