Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1733F19CC06
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739577920; cv=none; b=MNHKQxjoyGEjbh8PqkSk4lYjtk0sBuAPXJ2FkHIjPWCSmlSJLvyh9o8lqOWJvEoAatTXiyZKlzpDDCMUFHpP14i8WmAXnfDsHZZaYwpaOW7u9vSyYygHLT5tqQ4SnjnWpUlx6Znef7X76yVtU8rtuy6N6gF3npSWzNGsGyEGEXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739577920; c=relaxed/simple;
	bh=FtDBJCiaQFQmOPijU0Scn5bM7i4SlPG5eTl5tmmmP+Q=;
	h=Date:To:From:Subject:Message-Id; b=qi7QGk25p7TmVzzjLk4+LFN2odBFwwuJkbNO4nWpBlNkWOhFrt/3hiUMutTM2wLcFLRZG5u4Fgb7W5Z7Tx/BKJ/QX1QsyHovVNRBxJG4THegqTB3zArEcLtgfGYA8tBwwydStlfhYxe73iz5WhqGhTLAfnEF4+D0L1iC/CBYuUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTOyYDvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTOyYDvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C0CC4CEE2;
	Sat, 15 Feb 2025 00:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739577919;
	bh=FtDBJCiaQFQmOPijU0Scn5bM7i4SlPG5eTl5tmmmP+Q=;
	h=Date:To:From:Subject:From;
	b=JTOyYDvNgK5UVNvH9B06QhnxLPD6INqSAvyUiXaanAKR21xo/q+7QCL4t3Dtho2F3
	 27CHjWw6ifbAMQCmpdjWXO3jJiW/6QslDP3ZE21VnOaTnuoZRKPHZ0eY49q7GFJ7R4
	 6iVSgw0V/i2K/0H+0QeQlEeN2ASre9HrqVt04w/0=
Date: Fri, 14 Feb 2025 16:05:18 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,kurt.hackel@oracle.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,kovalev@altlinux.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-l_tree_depth-to-avoid-out-of-bounds-access.patch added to mm-nonmm-unstable branch
Message-Id: <20250215000519.73C0CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate l_tree_depth to avoid out-of-bounds access
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-l_tree_depth-to-avoid-out-of-bounds-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-l_tree_depth-to-avoid-out-of-bounds-access.patch

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
From: Vasiliy Kovalev <kovalev@altlinux.org>
Subject: ocfs2: validate l_tree_depth to avoid out-of-bounds access
Date: Fri, 14 Feb 2025 11:49:08 +0300

The l_tree_depth field is 16-bit (__le16), but the actual maximum depth is
limited to OCFS2_MAX_PATH_DEPTH.

Add a check to prevent out-of-bounds access if l_tree_depth has an invalid
value, which may occur when reading from a corrupted mounted disk [1].

Link: https://lkml.kernel.org/r/20250214084908.736528-1-kovalev@altlinux.org
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd [1]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/alloc.c~ocfs2-validate-l_tree_depth-to-avoid-out-of-bounds-access
+++ a/fs/ocfs2/alloc.c
@@ -1803,6 +1803,14 @@ static int __ocfs2_find_path(struct ocfs
 
 	el = root_el;
 	while (el->l_tree_depth) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
+				    le16_to_cpu(el->l_tree_depth));
+			ret = -EROFS;
+			goto out;
+		}
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n",
_

Patches currently in -mm which might be from kovalev@altlinux.org are

ocfs2-validate-l_tree_depth-to-avoid-out-of-bounds-access.patch

