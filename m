Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5B139FD9
	for <mm-commits@vger.kernel.org>; Sat, 18 Oct 2025 00:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746752; cv=none; b=DBJ/RzX9AwjJMaeXH6g6nFL7a0FBF/e6bJQx4pw5pcyCDSJmLL9U5GJ3agbGRwjXL9UgqS/FLWiROGn4yiIa8v0+6ekJn6L7mYsTcCmdqXlDbhzBbKsGvtJfjZyEzYM3nmRj7c5LI5w9vUxNdfwZVOZlaOskYWJpfuCkL38ZCio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746752; c=relaxed/simple;
	bh=wlqBfyJAuNuB2D+uPp9PLIqz7/DClZ9zEYlwiJ8kTTc=;
	h=Date:To:From:Subject:Message-Id; b=IQmiYKQ9cAZuY8JD1xJMqawhK5YTyNlzt4bgT83PJAhKv1V+eH2vZyXRYLr66hWZd4sDlHiVjq8gR5B4vPdYY0w2oCrJ4HmwcLTWPywGDQrUie04TNFTSbbSOWz+GB8CH4Fs/ZOpE+lluaBMDZQWSoYJcQDGX2yB/T8pYXP6BPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rcnlZJXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rcnlZJXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A6DC4CEE7;
	Sat, 18 Oct 2025 00:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760746750;
	bh=wlqBfyJAuNuB2D+uPp9PLIqz7/DClZ9zEYlwiJ8kTTc=;
	h=Date:To:From:Subject:From;
	b=rcnlZJXfZIlEdy0rW6w4Cdsi++cCzjZ4ixfG2UUKLS2waVbi0HtLNXhz0mCQNRqm8
	 X+DKcJX98RqZEjyv/kMsvQmanu5epVIcgmZjhdrHZOvcjLYGdGxaIcgLkA+9j4cKXB
	 ukUpn7mD+rE6zMi8B7rgGg79LyjG5YpipmAd0OP4=
Date: Fri, 17 Oct 2025 17:19:09 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-introduce-chain-list-sanity-check-with-ocfs2_check_chain_list.patch added to mm-nonmm-unstable branch
Message-Id: <20251018001910.53A6DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: introduce chain list sanity check with ocfs2_check_chain_list()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-introduce-chain-list-sanity-check-with-ocfs2_check_chain_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-introduce-chain-list-sanity-check-with-ocfs2_check_chain_list.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: introduce chain list sanity check with ocfs2_check_chain_list()
Date: Fri, 17 Oct 2025 14:34:22 +0300

Fix an array-index-out-of-bounds error reported by UBSAN:

UBSAN: array-index-out-of-bounds in fs/ocfs2/suballoc.c:380:22
index 0 is out of range for type 'struct ocfs2_chain_rec[] __counted_by(cl_count)' (aka 'struct ocfs2_chain_rec[]')

Introduce 'ocfs2_check_chain_list()' to check whether a) the maximum
amount of chain records in 'struct ocfs2_chain_list' matches the value
calculated based on the filesystem block size, and b) the next free slot
index is within the valid range, and use the aforementioned function in
'ocfs2_block_group_alloc()' and 'ocfs2_claim_suballoc_bits()'.

Link: https://lkml.kernel.org/r/20251017113422.243762-1-dmantipov@yandex.ru
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Heming Zhao <heming.zhao@suse.com>> ---
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/ocfs2/suballoc.c~ocfs2-introduce-chain-list-sanity-check-with-ocfs2_check_chain_list
+++ a/fs/ocfs2/suballoc.c
@@ -649,6 +649,16 @@ bail:
 	return status ? ERR_PTR(status) : bg_bh;
 }
 
+static int ocfs2_check_chain_list(struct ocfs2_chain_list *cl,
+				  struct super_block *sb)
+{
+	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb))
+		return -EINVAL;
+	if (le16_to_cpu(cl->cl_next_free_rec) >= le16_to_cpu(cl->cl_count))
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * We expect the block group allocator to already be locked.
  */
@@ -671,6 +681,10 @@ static int ocfs2_block_group_alloc(struc
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	status = ocfs2_check_chain_list(cl, alloc_inode->i_sb);
+	if (status)
+		goto bail;
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);
@@ -1992,6 +2006,9 @@ static int ocfs2_claim_suballoc_bits(str
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	status = ocfs2_check_chain_list(cl, ac->ac_inode->i_sb);
+	if (status)
+		goto bail;
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch
ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch
ocfs2-introduce-chain-list-sanity-check-with-ocfs2_check_chain_list.patch

