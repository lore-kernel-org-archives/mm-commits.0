Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA8CDDA9
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 01:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784596551; cv=none; b=C7Sxf71Mqbd3j9kdksKJPuobScLXC06QRS4NwO2OxaZqSU+Ns/GmR4XpnVUaWj/q72irP0mmPhvcyD9w6v8zOJn+i1MeQ7fSszJj9bsrPOuz95GNjw0vCRnKKHCgqQy1lPtbyZ+8XDvc+07Sa4whGREDoEWbrg6eAjoGcTcpVDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784596551; c=relaxed/simple;
	bh=4oq1IK4YUpwrlm471AurHbEuQGGIJoMMadZGEi0lZ98=;
	h=Date:To:From:Subject:Message-Id; b=YrGxBzDG9R4unDOEz6aeb6YgCAmKNKJueyPcr+fHjqdWJSXe/eaHqpyhbZjhVMtqZR6fXY8wownXQlUkTUFnZ6g/MKivLBgfjGk28mv2bmDufy27VAC9qwuFw/APmNNHcNiMIPBPthe9GlvCQns6A+ivKVnZZ3IgKxF5iZsbSHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pNPdbjoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pNPdbjoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E0B1F000E9;
	Tue, 21 Jul 2026 01:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784596549;
	bh=vp84VKpj8Up/TgOvXNCo83Z8MfbaVuPUGDachnsmZgE=;
	h=Date:To:From:Subject;
	b=pNPdbjoC274/xvtIwee0CVk2jKRwQ22LEp5KIrPawadqP+0rw1T9PZz7VttfMywM1
	 ORi3GlPpeHWmFeX+4o/z+KKSQuBpaeI5gY52B/yrLR8IyX3mOVwVE1GT7mFfG63vry
	 RL9AT9Uk0T6X11mNoUuU7hN4Iy2ouRjntNKwptz4=
Date: Mon, 20 Jul 2026 18:15:49 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,lgs201920130244@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-free-unused-clusters-on-defrag-move-errors.patch added to mm-nonmm-unstable branch
Message-Id: <20260721011549.B4E0B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: free unused clusters on defrag move errors
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-free-unused-clusters-on-defrag-move-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-free-unused-clusters-on-defrag-move-errors.patch

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
From: Guangshuo Li <lgs201920130244@gmail.com>
Subject: ocfs2: free unused clusters on defrag move errors
Date: Mon, 20 Jul 2026 22:19:43 +0800

ocfs2_defrag_extent() claims new clusters before calling
__ocfs2_move_extent().  If the move fails before ocfs2_split_extent()
succeeds, the claimed clusters are not referenced by the inode and must be
released.

The current error path only logs the error and continues to
ocfs2_cow_sync_writeback(), which can overwrite the original error with
zero and leave the claimed clusters allocated.

Not every __ocfs2_move_extent() error can free the new clusters.  Once
ocfs2_split_extent() succeeds, the extent tree references them even if
ocfs2_decrease_refcount() or ocfs2_truncate_log_append() subsequently
fails.  Freeing the clusters in that case would leave the extent tree
pointing to clusters marked free.

context->new_phys_cpos is updated immediately after a successful extent
split.  Compare it with the newly claimed physical cluster on error.  If
they differ, the split for the current move did not complete and the
claimed clusters can be freed.  If they match, leave the clusters
allocated because the extent tree already references them.

Return move errors through the transaction cleanup path so that the
original error is preserved instead of being overwritten by writeback.

Link: https://lore.kernel.org/20260720141944.485212-1-lgs201920130244@gmail.com
Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-free-unused-clusters-on-defrag-move-errors
+++ a/fs/ocfs2/move_extents.c
@@ -310,8 +310,12 @@ static int ocfs2_defrag_extent(struct oc
 
 	ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
 				  new_phys_cpos, ext_flags);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		if (context->new_phys_cpos != new_phys_cpos)
+			need_free = 1;
+		goto out_commit;
+	}
 
 	if (partial && (new_len != *len))
 		*len = new_len;
_

Patches currently in -mm which might be from lgs201920130244@gmail.com are

rapidio-clear-mport-net-when-rio_add_net-fails.patch
ocfs2-free-unused-clusters-on-defrag-move-errors.patch

