Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFE934252B
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967316; cv=none; b=ialKn0caoG2mptItAcfw1t4DyTkrBg7wFDzPOf6ukLSJSB5mv2qTpjJ/TbUWScaTFWr366oRaJeG7F4q9Al4WpwHHLL9wGf2yN9RPjWw6vS7oOO+Nmbj+tsOuOE7bP+FtDXJL24qRasXSC/UBMcdxGyHb6xJKL3tWQSJfT/mDpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967316; c=relaxed/simple;
	bh=uk1MLdJzE7njTv557/g0rMf/RhhLrK/X2hSy80dUFQI=;
	h=Date:To:From:Subject:Message-Id; b=jD1SQINqQuAw8TjMr8WVY7OKinhrYMDjB8YHlvdaHuVhsArnOh/MX92aFgI8GRZqVaSxPLlSrBcwNhQXK0P172I+Je3Kzo626mLjufxWzych9jRkFzQyS815+okv2EHTzPne2BqiXv2PPOl3a9PXYDhaa0FT8z18ouj0Y9E4pC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R3cLRpl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R3cLRpl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA55C16AAE;
	Wed, 21 Jan 2026 03:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967316;
	bh=uk1MLdJzE7njTv557/g0rMf/RhhLrK/X2hSy80dUFQI=;
	h=Date:To:From:Subject:From;
	b=R3cLRpl43/jZAaoV8SCCUOQfbOBe2RC+mWLwwftWoM1oQDPzq4GnDr9krNey5g5Wx
	 SXlHs9EqaHXLGb/65UNln0Mj0US+852o5i3sBWtSK3X+pdAT/SxhZLrAG1c6KnNZHB
	 P0UzCcap0yiQ8hPzeBQ2VRbwuo68D8EmV0pbz+lw=
Date: Tue, 20 Jan 2026 19:48:35 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-annotate-more-flexible-array-members-with-__counted_by_le.patch removed from -mm tree
Message-Id: <20260121034835.DDA55C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: annotate more flexible array members with __counted_by_le()
has been removed from the -mm tree.  Its filename was
     ocfs2-annotate-more-flexible-array-members-with-__counted_by_le.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: annotate more flexible array members with __counted_by_le()
Date: Tue, 21 Oct 2025 13:55:18 +0300

Annotate flexible array members of 'struct ocfs2_local_alloc' and 'struct
ocfs2_inline_data' with '__counted_by_le()' attribute to improve array
bounds checking when CONFIG_UBSAN_BOUNDS is enabled, and prefer the
convenient 'memset()' over an explicit loop to simplify
'ocfs2_clear_local_alloc()'.

Link: https://lkml.kernel.org/r/20251021105518.119953-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    4 +---
 fs/ocfs2/ocfs2_fs.h   |    4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/localalloc.c~ocfs2-annotate-more-flexible-array-members-with-__counted_by_le
+++ a/fs/ocfs2/localalloc.c
@@ -905,13 +905,11 @@ bail:
 static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc)
 {
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
-	int i;
 
 	alloc->id1.bitmap1.i_total = 0;
 	alloc->id1.bitmap1.i_used = 0;
 	la->la_bm_off = 0;
-	for(i = 0; i < le16_to_cpu(la->la_size); i++)
-		la->la_bitmap[i] = 0;
+	memset(la->la_bitmap, 0, le16_to_cpu(la->la_size));
 }
 
 #if 0
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-annotate-more-flexible-array-members-with-__counted_by_le
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -641,7 +641,7 @@ struct ocfs2_local_alloc
 	__le16 la_size;		/* Size of included bitmap, in bytes */
 	__le16 la_reserved1;
 	__le64 la_reserved2;
-/*10*/	__u8   la_bitmap[];
+/*10*/	__u8   la_bitmap[] __counted_by_le(la_size);
 };
 
 /*
@@ -654,7 +654,7 @@ struct ocfs2_inline_data
 				 * for data, starting at id_data */
 	__le16	id_reserved0;
 	__le32	id_reserved1;
-	__u8	id_data[];	/* Start of user data */
+	__u8	id_data[] __counted_by_le(id_count);	/* Start of user data */
 };
 
 /*
_

Patches currently in -mm which might be from dmantipov@yandex.ru are


