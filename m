Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1534E2CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958099; cv=none; b=coe4U26qZZYIZL3QTscuxPPgp7alzhFrYpGP5i7wVGLuhZDp7NXz0DL4daTKHOle2rMgcq/n96hiy3ozmUHOD+kvZ28Ju51+FeBYJGB6TzSXwVKbiRw/7NumLqYV5o0olHArqKPDkYz/QcdXAMTyAXf3JZICFAsiaAqg6UOCd4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958099; c=relaxed/simple;
	bh=cC6atPey8tey35JIe7QmYyZGY27mWNus8vp6j5haJLM=;
	h=Date:To:From:Subject:Message-Id; b=O+o7dOtizeqNKWo7q/Byn+Z5+tb8KIZ1M6oHB3pJKX95YU0SyYC1CjPsVMmdZOp5KhTPeLdOkKY10wRpaX3kxNOCDrPOQosCHOWqFp1b40PA3V8DPzdk4nbeA4XtiLtIMEmPO38jluk74u/OloWddWdjYxobg56vjy6LrxOEJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TYqk7Nwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TYqk7Nwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E0FC116B1;
	Mon,  6 May 2024 01:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958098;
	bh=cC6atPey8tey35JIe7QmYyZGY27mWNus8vp6j5haJLM=;
	h=Date:To:From:Subject:From;
	b=TYqk7NwtJRYXqjfMc6VbwmX/5SEWs/F9rE7TO7qWbgzVAM2WmLRzOydy8rDdY+Eku
	 21oL2vToXwRzqO/pVoDOGY92K4AbG589jBuEkXEXQhhwr9+4yOt4sgqGqPRAwit7ez
	 TnZwez67MKqjV9rUuiRtlHtq8jML7WNUTlCEs6ao=
Date: Sun, 05 May 2024 18:14:58 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,dan.carpenter@linaro.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-redundant-assignment-to-variable-status.patch removed from -mm tree
Message-Id: <20240506011458.C6E0FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove redundant assignment to variable status
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-assignment-to-variable-status.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: ocfs2: remove redundant assignment to variable status
Date: Tue, 23 Apr 2024 23:30:18 +0100

Variable status is being assigned and error code that is never read, it is
being assigned inside of a do-while loop.  The assignment is redundant and
can be removed.

Cleans up clang scan build warning:
fs/ocfs2/dlm/dlmdomain.c:1530:2: warning: Value stored to 'status' is never
read [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20240423223018.1573213-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-redundant-assignment-to-variable-status
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1527,7 +1527,6 @@ static void dlm_send_join_asserts(struct
 {
 	int status, node, live;
 
-	status = 0;
 	node = -1;
 	while ((node = find_next_bit(node_map, O2NM_MAX_NODES,
 				     node + 1)) < O2NM_MAX_NODES) {
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


