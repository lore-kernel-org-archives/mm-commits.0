Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC8D14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908577; cv=none; b=mBX29HzknSPWwZbBKurHm2VvL88MYhPIioAEgAN0rlMjlfPl8r261sOxkYp9k4jWD4MoVezPpnyqz5WVlHdSiZcmprPfr+ud0oJVM+qNLvbWZkuZGQxuT69dP4znD5jsD/dJUsCVKZ8iJMU1fgtLEbrjYIViGWs+GOlT9EFkpMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908577; c=relaxed/simple;
	bh=21tepw1B9gAqBdeTDNTFAGKt5dAPPiWMUy5tYYOHW2A=;
	h=Date:To:From:Subject:Message-Id; b=EMRmlHu4nkVpDya5ItGqBhWP93NUk2sA2C9QvX6+QSGeR4ceotDOdfz2pNRw5VHyX2htkuY2prh1pDtWFA51XV8LKx3IwhacEv5fm3pgFJG8Z9Y+3fRGNzNvFbtD/1R30d2m6PmIFpZmqqMBdnXG5VNmbfEHqCmvKX7FnCkMZk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YoEJeOU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YoEJeOU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3618C116D0;
	Wed, 12 Nov 2025 00:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908576;
	bh=21tepw1B9gAqBdeTDNTFAGKt5dAPPiWMUy5tYYOHW2A=;
	h=Date:To:From:Subject:From;
	b=YoEJeOU1y694RKSadPr+Q60lc8ptWljLa4SyDkqKewLPem3AuyryP+sR7c774hUuE
	 S5Nd/iPKOz9tuJB9YASYto42QsWl22XGS6IXyj+Np9PP/1Md216DoshdHBhtomb9D7
	 QvQoPfADPwLfEnaV8zeb1iixD3Z3eFwHYSbdCr40=
Date: Tue, 11 Nov 2025 16:49:36 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch removed from -mm tree
Message-Id: <20251112004936.B3618C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: annotate flexible array members with __counted_by_le()
has been removed from the -mm tree.  Its filename was
     ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: annotate flexible array members with __counted_by_le()
Date: Tue, 7 Oct 2025 15:35:26 +0300

Annotate flexible array members of 'struct ocfs2_extent_list',
'struct ocfs2_chain_list', 'struct ocfs2_truncate_log',
'struct ocfs2_dx_entry_list', 'ocfs2_refcount_list' and
'struct ocfs2_xattr_header' with  '__counted_by_le()'
attribute to improve array bounds checking when
CONFIG_UBSAN_BOUNDS is enabled.

[dmantipov@yandex.ru: fix __counted_by_le() usage in ocfs2_expand_inline_dx_root()]
  Link: https://lkml.kernel.org/r/20251014070324.130313-1-dmantipov@yandex.ru
Link: https://lkml.kernel.org/r/20251007123526.213150-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c      |    9 +++++++--
 fs/ocfs2/ocfs2_fs.h |   22 ++++++++++++++--------
 2 files changed, 21 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-annotate-flexible-array-members-with-__counted_by_le
+++ a/fs/ocfs2/dir.c
@@ -4104,10 +4104,15 @@ static int ocfs2_expand_inline_dx_root(s
 	}
 
 	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
-	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
-	       offsetof(struct ocfs2_dx_root_block, dr_list));
+
+	dx_root->dr_list.l_tree_depth = 0;
 	dx_root->dr_list.l_count =
 		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+	dx_root->dr_list.l_next_free_rec = 0;
+	memset(&dx_root->dr_list.l_recs, 0,
+	       osb->sb->s_blocksize -
+	       (offsetof(struct ocfs2_dx_root_block, dr_list) +
+		offsetof(struct ocfs2_extent_list, l_recs)));
 
 	/* This should never fail considering we start with an empty
 	 * dx_root. */
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-annotate-flexible-array-members-with-__counted_by_le
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -468,7 +468,8 @@ struct ocfs2_extent_list {
 	__le16 l_reserved1;
 	__le64 l_reserved2;		/* Pad to
 					   sizeof(ocfs2_extent_rec) */
-/*10*/	struct ocfs2_extent_rec l_recs[];	/* Extent records */
+					/* Extent records */
+/*10*/	struct ocfs2_extent_rec l_recs[] __counted_by_le(l_count);
 };
 
 /*
@@ -482,7 +483,8 @@ struct ocfs2_chain_list {
 	__le16 cl_count;		/* Total chains in this list */
 	__le16 cl_next_free_rec;	/* Next unused chain slot */
 	__le64 cl_reserved1;
-/*10*/	struct ocfs2_chain_rec cl_recs[];	/* Chain records */
+					/* Chain records */
+/*10*/	struct ocfs2_chain_rec cl_recs[] __counted_by_le(cl_count);
 };
 
 /*
@@ -494,7 +496,8 @@ struct ocfs2_truncate_log {
 /*00*/	__le16 tl_count;		/* Total records in this log */
 	__le16 tl_used;			/* Number of records in use */
 	__le32 tl_reserved1;
-/*08*/	struct ocfs2_truncate_rec tl_recs[];	/* Truncate records */
+					/* Truncate records */
+/*08*/	struct ocfs2_truncate_rec tl_recs[] __counted_by_le(tl_count);
 };
 
 /*
@@ -796,9 +799,10 @@ struct ocfs2_dx_entry_list {
 					 * possible in de_entries */
 	__le16		de_num_used;	/* Current number of
 					 * de_entries entries */
-	struct	ocfs2_dx_entry		de_entries[];	/* Indexed dir entries
-							 * in a packed array of
-							 * length de_num_used */
+					/* Indexed dir entries in a packed
+					 * array of length de_num_used.
+					 */
+	struct	ocfs2_dx_entry		de_entries[] __counted_by_le(de_count);
 };
 
 #define OCFS2_DX_FLAG_INLINE	0x01
@@ -934,7 +938,8 @@ struct ocfs2_refcount_list {
 	__le16 rl_used;		/* Current number of used records */
 	__le32 rl_reserved2;
 	__le64 rl_reserved1;	/* Pad to sizeof(ocfs2_refcount_record) */
-/*10*/	struct ocfs2_refcount_rec rl_recs[];	/* Refcount records */
+				/* Refcount records */
+/*10*/	struct ocfs2_refcount_rec rl_recs[] __counted_by_le(rl_count);
 };
 
 
@@ -1020,7 +1025,8 @@ struct ocfs2_xattr_header {
 						    buckets.  A block uses
 						    xb_check and sets
 						    this field to zero.) */
-	struct ocfs2_xattr_entry xh_entries[]; /* xattr entry list. */
+						/* xattr entry list. */
+	struct ocfs2_xattr_entry xh_entries[] __counted_by_le(xh_count);
 };
 
 /*
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

