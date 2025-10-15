Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1E649659
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 03:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760498075; cv=none; b=QhS63atWz6aXonJRu1O3KiEvMbrsYErxEa5yCxPanQLZlrccL+45mYrZprDwDUczRk64hWKHjw7ZGz9QKxEASwdhadBfA5TUsXzZYaAAIsC36Eb46c24pfuzk7ekcaoUXZasWzJlhpnmAucUzNpb7QmzrIQvLNuw+L/49CyvmsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760498075; c=relaxed/simple;
	bh=oLhOMgZzBdC2+QHO3Ylga+ba49L5obJnag4D2jqR2/c=;
	h=Date:To:From:Subject:Message-Id; b=ueVwWyB4H0uzXPRjgHSeWnUM3jPTE5yt4IZSCv10BffA/GY4rplRHX0gRs7I8NwNDSSvvDxhREowo36steEjS00KyHwxFxgjjLRpwtbNNzTZw/4YW+m3/WZG6MYW8Cs+H8w2iyHAaGFIq4AwewDRQSNcQX0edjgJ5WUl+ri2LyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R77g+gEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R77g+gEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92542C4CEF1;
	Wed, 15 Oct 2025 03:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760498074;
	bh=oLhOMgZzBdC2+QHO3Ylga+ba49L5obJnag4D2jqR2/c=;
	h=Date:To:From:Subject:From;
	b=R77g+gEQ64tpjkfyETnXAV36pKHmpc0FXdtMIWlgNVkpxI9NEQkhaH30IwCjvMxC1
	 z454dtxVCiIqEEx4AIw2szLlDfILyZxrb0CMMvpCH5cfURYMn0xcYIxyQJZP7Euu5S
	 6rDtpmzKuFWgmdMYm6bPesUJIO9Ng9jH4usL9ZmE=
Date: Tue, 14 Oct 2025 20:14:33 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251015031434.92542C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix __counted_by_le() usage in ocfs2_expand_inline_dx_root()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch

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
Subject: ocfs2: fix __counted_by_le() usage in ocfs2_expand_inline_dx_root()
Date: Tue, 14 Oct 2025 10:03:24 +0300

After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
with '__counted_by_le(l_count)', 'l_count' should be initialized
before touching 'l_recs[]' with 'memset()' to avoid false positives
from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.

Link: https://lkml.kernel.org/r/20251014070324.130313-1-dmantipov@yandex.ru
Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix
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
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch

