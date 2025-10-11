Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F709241695
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760208822; cv=none; b=eK43/ndQN0c0QS4JrvcXx01IlcBlPKnTkeJoDnrS0Cb7J/vQhWmklerCTFjzLad6pHYDV1p8I9eypgEBdq0jOdqSEDOEV5jlw7h9WzjgYiozHZ8n8SdtdUquC4JZX45xPheor+lwIpYozJ1mz0Ev0+xGH2a9cDCUpehvTW6Jx1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760208822; c=relaxed/simple;
	bh=1OtwSTAcJVHVwd68KPxs97gXW1cJlj0djW2FQwZQnUE=;
	h=Date:To:From:Subject:Message-Id; b=LvBj3M/K50RQjZzmTsfOuW/BkMWF6hZ6aCbmaIWSLGBV5NJPvAmPfujwUoI1bkk/zP4p3nIlUL89g9rfmN5xnu89dwH63GXyRvYUxqCbX8XoWFNtH0vjN3VoI0QjU3imaYse/TiEInXRIUDN6tAbWd6kQv/QNUchHc05izfS3dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fOyPUHcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fOyPUHcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D169FC4CEF4;
	Sat, 11 Oct 2025 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760208821;
	bh=1OtwSTAcJVHVwd68KPxs97gXW1cJlj0djW2FQwZQnUE=;
	h=Date:To:From:Subject:From;
	b=fOyPUHcsgNU6HOg0beW7Dk3fp7nWYf16oePQS2Jul3cNtDTmYuucGRwv2Y83fQcL9
	 MnryK2Lbkxt9trO6bNE39lHxMhysybEQh/NdOKALuC+qNZ7+LFL+Z2udCqWe1j7rDi
	 f+AMXP8ai8ZtYvK2s06o0m6G0qIpNbRf2GpGMerg=
Date: Sat, 11 Oct 2025 11:53:41 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch added to mm-nonmm-unstable branch
Message-Id: <20251011185341.D169FC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: annotate flexible array members with __counted_by_le()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch

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
Subject: ocfs2: annotate flexible array members with __counted_by_le()
Date: Tue, 7 Oct 2025 15:35:26 +0300

Annotate flexible array members of 'struct ocfs2_extent_list',
'struct ocfs2_chain_list', 'struct ocfs2_truncate_log',
'struct ocfs2_dx_entry_list', 'ocfs2_refcount_list' and
'struct ocfs2_xattr_header' with  '__counted_by_le()'
attribute to improve array bounds checking when
CONFIG_UBSAN_BOUNDS is enabled.

Link: https://lkml.kernel.org/r/20251007123526.213150-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

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

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch

