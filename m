Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E519521FF23
	for <mm-commits@vger.kernel.org>; Wed, 22 Jul 2026 00:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784681794; cv=none; b=qAAShdG9nj6wVrAleTB98B8NBYwkXYFDM6KGsXoCr0cp1ECJF7qGS2mps6ZhsjAUOnBmghRapYQNElpYyARII5LvEevMxsckeSrweBp4p3MQ4qev2CkLv82XxPT5KQf4lpL0ouLQvXKq6L9nCaRgN+7h3MUZdL3byYX8uLIkKtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784681794; c=relaxed/simple;
	bh=IODBdcCHuGNv50xo1xIcQjMKDvMl/NGivsBszJLBhzU=;
	h=Date:To:From:Subject:Message-Id; b=ACIrRNdnkXRswmUuT9kQiN+Fn9JbpmFSzNUxZ9x5DXWqa5UAQGul63jmgkCZT2c9/XHciye/DM4jebeelCkwFvPQAeMD3LeX1pkz8QFnFYI8idJYgYqhmKhfpX4XdaQweyhCpo8SnSmvF20q6Yk/3WU0PsSEiRjKA3qoiwu4WsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vQvJcSOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vQvJcSOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB8C1F000E9;
	Wed, 22 Jul 2026 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784681792;
	bh=QkC8beov3OcFW1//HFDPCYS4X3SU9p9u2MvQbQvacZ0=;
	h=Date:To:From:Subject;
	b=vQvJcSOMUR0yBbVpflOzKSQhrmnaXNBnBQf4sBGR6Dg2E4z7bvYxRq4Xn8nmoD+9C
	 LcyyqMkoL75y5iGQO7wgcjBMHiGlY/iigB4Y6tQwk9O1JWau1t2H0alOra7n9HJz3w
	 jTzuTJ8SeIQXmqtvFQBgwGtqRlbcARqNlq7p0jko=
Date: Tue, 21 Jul 2026 17:56:32 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,lgs201920130244@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-free-unused-clusters-on-defrag-move-errors.patch removed from -mm tree
Message-Id: <20260722005632.7EB8C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: free unused clusters on defrag move errors
has been removed from the -mm tree.  Its filename was
     ocfs2-free-unused-clusters-on-defrag-move-errors.patch

This patch was dropped because an updated version will be issued

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

