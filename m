Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8196B1862B8
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855670; cv=none; b=YLkcPYe3Sl2wRqX3TN1Gl6sA0xm3MaJqenpw8EcvX0W3P0ZZb7wEBzP+YaFL4UpekTjg3k8sbmXcn03PnrrW6oiWomeKljPL3lWIILFtuOolNQ5GTvuUMYPrmFXu/0EXkHrv7K36p/rOOiWerTZsdX3vHUG9wvJ78SfqcGoi/ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855670; c=relaxed/simple;
	bh=SgTDqts0E79LALw7BPU6yFhqPYX4mWIHkY+Wk+3JGSs=;
	h=Date:To:From:Subject:Message-Id; b=nUApm4Cxhf1PE6Six2vomNs/b81Pxa9ECw2D5UyzggvifIwds9vEIUa07+VhffRwW+oxYLACutEv1xDcqjexuOzUN+ye8MXjssUX2d7bnVLxKBkv3pb6mWbO85tuk/Rvlt5rv/Htn52a4a7zXXQM5h6d8tpAcHWRrLzCzFhcbIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ekm5jOKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ekm5jOKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5501FC4CECF;
	Wed,  6 Nov 2024 01:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855670;
	bh=SgTDqts0E79LALw7BPU6yFhqPYX4mWIHkY+Wk+3JGSs=;
	h=Date:To:From:Subject:From;
	b=Ekm5jOKaiLz2cHO6llwJGHj/IexBoqrmOxB/KEoRXDu9aaAcxxR5Qbzr5j3aQjFN2
	 PPbJdzrMDYDX1ZPwnN43VCZhSDbl7mxKU1Tp9CvcJ0SjXWj7RsC6El/YZdk/hcGN9c
	 eYKgXcZUz88JPJTua5Z+qU3qTmyA3H05OescHM24=
Date: Tue, 05 Nov 2024 17:14:29 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,algonell@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-fix-a-typo.patch removed from -mm tree
Message-Id: <20241106011430.5501FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: cluster: fix a typo
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-fix-a-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Kreimer <algonell@gmail.com>
Subject: ocfs2: cluster: fix a typo
Date: Sun, 27 Oct 2024 15:35:18 +0200

Fix a typo: panicing -> panicking.

Via codespell.

Link: https://lkml.kernel.org/r/20241027133540.22090-1-algonell@gmail.com
Signed-off-by: Andrew Kreimer <algonell@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/quorum.c~ocfs2-cluster-fix-a-typo
+++ a/fs/ocfs2/cluster/quorum.c
@@ -60,7 +60,7 @@ static void o2quo_fence_self(void)
 	switch (o2nm_single_cluster->cl_fence_method) {
 	case O2NM_FENCE_PANIC:
 		panic("*** ocfs2 is very sorry to be fencing this system by "
-		      "panicing ***\n");
+		      "panicking ***\n");
 		break;
 	default:
 		WARN_ON(o2nm_single_cluster->cl_fence_method >=
_

Patches currently in -mm which might be from algonell@gmail.com are


