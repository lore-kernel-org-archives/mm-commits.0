Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9817A13C9DE
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713993736; cv=none; b=T0EzTYeFw54cga1gXR1wNZ1uh05y0rpfV3q+dNUQWysSviY0QVqbj7mo/B9gDaOMtLMVSXR+lOBCmsFM2RRWZZGj19XjjgLK3ETA2eYxyeKtKUUwvE36BVtKUZqEr5iNqeR8BO9vp5ArJZv1xsg77xL3wPY6oF6HI67G70UWTW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713993736; c=relaxed/simple;
	bh=bjPFyK5cGvUDdvcnOyOQ8lEiNYlkCCiHDUdPGWun6PM=;
	h=Date:To:From:Subject:Message-Id; b=ZHlqAy8trjVn4GKFIlylsK6AWncrMtG5fgSf+ReHg5e675G3JQWtyivcEBMiEkh1BJ+GIsOtc7yvtCubXCdU5ynIVdFnW3fdplCnfXv7eFoaWmADc3r1Yy7zVswbqxMDrLlXMc8+K5yDY5ST7KTa0/7cWqLeVjYxIFOi9xe22vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nGR7XYUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nGR7XYUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06651C113CD;
	Wed, 24 Apr 2024 21:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713993736;
	bh=bjPFyK5cGvUDdvcnOyOQ8lEiNYlkCCiHDUdPGWun6PM=;
	h=Date:To:From:Subject:From;
	b=nGR7XYUxql04wShO3GqZqRKuwRVWH+cS8LSMfmeE9ImHGNYpqRYzmbPwzmdxKu0pU
	 pPQUrKTfdsWrj+ccb46BcwE8Xkl4/1DRkj1WvLrE8lpR/VV9nTSpC70juqFH3+VyT4
	 UArqcyzhsnjowtg6wCykv3hXX9inerbciiiz+Gy4=
Date: Wed, 24 Apr 2024 14:22:15 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,dan.carpenter@linaro.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-redundant-assignment-to-variable-status.patch added to mm-nonmm-unstable branch
Message-Id: <20240424212216.06651C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove redundant assignment to variable status
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-redundant-assignment-to-variable-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-redundant-assignment-to-variable-status.patch

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

selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix.patch
ocfs2-remove-redundant-assignment-to-variable-status.patch

