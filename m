Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52E732E68D
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967378; cv=none; b=qo/yGQVUzfS6FPQPjFVnljkonOlROYStHtskSlvCkiP3wOCQTxn3DJ7ERH/F6Scp38yngfs3suH+nHJYsHpJv/a/uRD8vidaR9Uw8jWAZSzOb5ZJuniWYcwpE4svg4dM52rRRYNemcDVcf0KA5idNZ5cInzXDlX+vutyPnrU2Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967378; c=relaxed/simple;
	bh=iGy4G3sQLtZxmuwfGDDP383zxurt1PltcnS1URi01Rc=;
	h=Date:To:From:Subject:Message-Id; b=qk9wL06I5mQrl/hi2aPIjyXYxc6N+DrAxQ32LhoKmzPqh6pHxqns0uUPGjE7SfjCDsFnS9LcgOcOwIXGc4ib22+msPbxhtno1p9oeGC7nhfjVUgvJPiNAyh525n5PqYGHJqWen2+wUvgZKm5Mec3PEh9AUzuJgn8Wt9V2AVrqNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/dVHzRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/dVHzRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFDFC16AAE;
	Wed, 21 Jan 2026 03:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967377;
	bh=iGy4G3sQLtZxmuwfGDDP383zxurt1PltcnS1URi01Rc=;
	h=Date:To:From:Subject:From;
	b=a/dVHzRa2TZmylo6MEHC68qlXnTTaMJYFRdbyiqron+/sAH2jaj8TpqbjG0LYGu35
	 Hi2KI2lfK46TsvAWTG+cpPLymgcKsiBF8qN9yNBw3Rgg1LGvD9R6WJtqQh9zTu2X2d
	 rnO1KdfrgsqfbSYOEy0hSBGuDi/Q1XN+kAT5REa4=
Date: Tue, 20 Jan 2026 19:49:36 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,Julia.Lawall@inria.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-adjust-function-name-reference.patch removed from -mm tree
Message-Id: <20260121034937.1AFDFC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: adjust function name reference
has been removed from the -mm tree.  Its filename was
     ocfs2-adjust-function-name-reference.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@inria.fr>
Subject: ocfs2: adjust function name reference
Date: Tue, 30 Dec 2025 15:25:13 +0100

There is no function dlm_mast_regions().  However, dlm_match_regions() is
passed the buffer "local", which it uses internally, so it seems like
dlm_match_regions() was intended.

Link: https://lkml.kernel.org/r/20251230142513.95467-1-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-adjust-function-name-reference
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1105,7 +1105,7 @@ static int dlm_query_region_handler(stru
 	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
 	     qr->qr_domain);
 
-	/* buffer used in dlm_mast_regions() */
+	/* buffer used in dlm_match_regions() */
 	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
 	if (!local)
 		return -ENOMEM;
_

Patches currently in -mm which might be from Julia.Lawall@inria.fr are


