Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5362E137C44
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 19:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711653373; cv=none; b=VfjvKwTjG5U9/KgesTR1dblFFgGGb2NrKUJ8VwJKdlZ+Cb6pLkOg/hbwuKLVQNnHd9C/dt6Fc8DNbCEDMRZB+GpR9gqnlpC4nRK/PIBUW5U8hO76CRMKG53/xf/OC8NmozOt2J7gzCvvqZ2FoIK+fAVntaQ51azy581vYmfiIfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711653373; c=relaxed/simple;
	bh=XG5M6cNfAloIWOppXPr6HMkvUGaDBsovGfSh1Dr6gBk=;
	h=Date:To:From:Subject:Message-Id; b=BUDBUYXXzRgr8ELP9wYwQ1SVwenDespG1qXL33XmGEaOld2/j04GUpYQ5+l33ctcKHZ9XuPlCfU9rqCOsaVswDQpWJiJXR4sFa4qO/Zhkv70LsJV2nOyNI6kULg3FobMGHpeBVXmqUOGaekUEymwHekzaGdPs3LyeqYEknWPhLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TbEQq00f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TbEQq00f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC30AC433F1;
	Thu, 28 Mar 2024 19:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711653372;
	bh=XG5M6cNfAloIWOppXPr6HMkvUGaDBsovGfSh1Dr6gBk=;
	h=Date:To:From:Subject:From;
	b=TbEQq00fEZWVTfBIh3IvAhorVC0TZxJHPh7JOakjXHtbO/pWzhDdRRev6FqMQ4A+z
	 DduJR/OsWpBsgSoTUxXyA2kMDi42Flr/zDhlgBvyfNpXiWw27tBtCaIzVWPpXijRxv
	 l17fqBQWN9sTNy7tYujKx+yHLmxLVs/aIFeXU0Zo=
Date: Thu, 28 Mar 2024 12:16:12 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-adjust-enabling-place-for-la-window.patch added to mm-nonmm-unstable branch
Message-Id: <20240328191612.BC30AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: adjust enabling place for la window
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-adjust-enabling-place-for-la-window.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-adjust-enabling-place-for-la-window.patch

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
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: adjust enabling place for la window
Date: Thu, 28 Mar 2024 20:52:01 +0800

Patch series "improve write IO performance when fragmentation is high",
v6.


This patch (of 4):

After introducing gd->bg_contig_free_bits, the code path
'ocfs2_cluster_group_search() => ocfs2_local_alloc_seen_free_bits()'
becomes death when all the gd->bg_contig_free_bits are set to the correct
value.  This patch relocates ocfs2_local_alloc_seen_free_bits() to a more
appropriate location.  (The new place being ocfs2_block_group_set_bits().)

In ocfs2_local_alloc_seen_free_bits(), the scope of the spin-lock has been
adjusted to reduce meaningless lock races.  e.g: when userspace creates &
deletes 1 cluster_size files in parallel, acquiring the spin-lock in
ocfs2_local_alloc_seen_free_bits() is totally pointless and impedes IO
performance.

Link: https://lkml.kernel.org/r/20240328125203.20892-3-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |   11 ++++++-----
 fs/ocfs2/suballoc.c   |    9 ++-------
 2 files changed, 8 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/localalloc.c~ocfs2-adjust-enabling-place-for-la-window
+++ a/fs/ocfs2/localalloc.c
@@ -212,14 +212,15 @@ static inline int ocfs2_la_state_enabled
 void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
 				      unsigned int num_clusters)
 {
-	spin_lock(&osb->osb_lock);
-	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
-	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
-		if (num_clusters >= osb->local_alloc_default_bits) {
+	if (num_clusters >= osb->local_alloc_default_bits) {
+		spin_lock(&osb->osb_lock);
+		if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
+		    osb->local_alloc_state == OCFS2_LA_THROTTLED) {
 			cancel_delayed_work(&osb->la_enable_wq);
 			osb->local_alloc_state = OCFS2_LA_ENABLED;
 		}
-	spin_unlock(&osb->osb_lock);
+		spin_unlock(&osb->osb_lock);
+	}
 }
 
 void ocfs2_la_enable_worker(struct work_struct *work)
--- a/fs/ocfs2/suballoc.c~ocfs2-adjust-enabling-place-for-la-window
+++ a/fs/ocfs2/suballoc.c
@@ -1372,6 +1372,7 @@ int ocfs2_block_group_set_bits(handle_t
 	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
 	unsigned int start = bit_off + num_bits;
 	u16 contig_bits;
+	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
 
 	/* All callers get the descriptor via
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
@@ -1421,6 +1422,7 @@ int ocfs2_block_group_set_bits(handle_t
 		if (contig_bits > max_contig_bits)
 			max_contig_bits = contig_bits;
 		bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
+		ocfs2_local_alloc_seen_free_bits(osb, max_contig_bits);
 	} else {
 		bg->bg_contig_free_bits = 0;
 	}
@@ -1587,13 +1589,6 @@ static int ocfs2_cluster_group_search(st
 		 * of bits. */
 		if (min_bits <= res->sr_bits)
 			search = 0; /* success */
-		else if (res->sr_bits) {
-			/*
-			 * Don't show bits which we'll be returning
-			 * for allocation to the local alloc bitmap.
-			 */
-			ocfs2_local_alloc_seen_free_bits(osb, res->sr_bits);
-		}
 	}
 
 	return search;
_

Patches currently in -mm which might be from heming.zhao@suse.com are

ocfs2-improve-write-io-performance-when-fragmentation-is-high.patch
ocfs2-adjust-enabling-place-for-la-window.patch
ocfs2-speed-up-chain-list-searching.patch
ocfs2-fix-sparse-warnings.patch

