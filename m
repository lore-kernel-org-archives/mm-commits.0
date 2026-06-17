Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8DA348463;
	Wed, 17 Jun 2026 22:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735910; cv=none; b=StRfvS8xKHXvfV2eL1Hix7JId9vQsX37BH1S9rQcqeO7LTwrYk/Rqlz/09MntRTw4cEu2vBPn8EoFY2UlhVp6lSS29jxW891eewINhz6YtRgD+ha6Ars45SnPkFVqB93qczKgtmhDonKWKhT+8AQ+cZlByoE7aDbCtg4wY6kqX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735910; c=relaxed/simple;
	bh=1eIcUleMCX+/kSMnHrQ9Jk1a96VglzXsex9s/6EEPVs=;
	h=Date:To:From:Subject:Message-Id; b=DlvQ/DWbEZTzZrPCMtYy8NSeWhr27k30UpgjLAqDgBsiXEV/8hmm92NyRqP6FCXcb8Up08gIx+Fv1LOBDgPLKyIMxiD48d10kCqdh9zzBhqRJVneNhwGetnkt27jtSMrgvIBjgLd7lBFVgcI2RV4G5xMtwIlXaVkMeiafCuYvl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IeQwNNuX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IeQwNNuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DCB1F000E9;
	Wed, 17 Jun 2026 22:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781735908;
	bh=AC6iO3jmeyUmyx4kacH0c/ip4fEYHm40WeGMtmtpysY=;
	h=Date:To:From:Subject;
	b=IeQwNNuXupnKCBKYNNi8WtPt0JbZL6a4SetssiDjlPkrNSB6jXhPR93ETNt/Yoyu8
	 yiucZnEwEQo7jajiTke0fxZMeJRUC8BrC9TezKK8QRIUERPLLGVoRvKOMzJpoZtRZm
	 n8bkzPTHNNqtbew+ixQ8JjgGygtFkRdrPCh1wBF8=
Date: Wed, 17 Jun 2026 15:38:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kylebot@openai.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-avoid-moving-extents-to-occupied-clusters.patch removed from -mm tree
Message-Id: <20260617223828.95DCB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: avoid moving extents to occupied clusters
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-moving-extents-to-occupied-clusters.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kyle Zeng <kylebot@openai.com>
Subject: ocfs2: avoid moving extents to occupied clusters
Date: Thu, 11 Jun 2026 14:35:10 -0700

For non-auto OCFS2_IOC_MOVE_EXT operations, userspace supplies a physical
me_goal.  ocfs2_move_extent() initializes new_phys_cpos from that goal and
expects ocfs2_probe_alloc_group() to replace it with a free run in the
target block group.

The probe currently leaves *phys_cpos unchanged if the scan reaches the
end of the group without finding a free run.  An occupied goal at the last
bit can therefore survive the probe and be passed to
__ocfs2_move_extent(), which copies file data into a cluster still owned
by another inode before the bitmap is updated.

When the probe does find a free run, it also subtracts move_len from the
ending bit.  The start of an N-bit run ending at i is i - N + 1, so the
current calculation can report the bit immediately before the free run.

Clear *phys_cpos before scanning and use the correct free-run start. 
Callers already treat a zero result as -ENOSPC, so failed probes no longer
continue with an occupied caller-controlled goal.

Link: https://lore.kernel.org/20260611213510.16956-1-kylebot@openai.com
Fixes: e6b5859cccfa ("Ocfs2/move_extents: helper to probe a proper region to move in an alloc group.")
Fixes: 236b9254f8d1 ("ocfs2: fix non-auto defrag path not working issue")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
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

 fs/ocfs2/move_extents.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-avoid-moving-extents-to-occupied-clusters
+++ a/fs/ocfs2/move_extents.c
@@ -534,6 +534,8 @@ static void ocfs2_probe_alloc_group(stru
 	u32 base_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
 						 le64_to_cpu(gd->bg_blkno));
 
+	*phys_cpos = 0;
+
 	for (i = base_bit; i < le16_to_cpu(gd->bg_bits); i++) {
 
 		used = ocfs2_test_bit(i, (unsigned long *)gd->bg_bitmap);
@@ -555,7 +557,7 @@ static void ocfs2_probe_alloc_group(stru
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
-			i -= move_len;
+			i = i - move_len + 1;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
_

Patches currently in -mm which might be from kylebot@openai.com are


