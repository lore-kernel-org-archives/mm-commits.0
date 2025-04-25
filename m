Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6FC35958
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 00:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745542392; cv=none; b=apli4/85iAXeJ1MHqWLuuzXWLiT8O/y4iKugdFq1eG4xroVOZ8+/TJmtS9nLeXm+SIjkEv4fF+y0ILDejKwcDK6dMefXRDTBCqIpg6on6NyB2O8rpx6eskaCRCrbMHGilIbMpr8ELYdPaClud3VwydvCEWMmwLfvXTdab0GKABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745542392; c=relaxed/simple;
	bh=wcCoNr0UEBB1BOKDQfaJF7/q0hHzY8+BdwJ/i38qZNY=;
	h=Date:To:From:Subject:Message-Id; b=mOL2cLxcnnCorg/w5jFdJ/joIxVNyayfMv9EWqL0XycR431g5M84xWkFjSUWLngrAtyyBjm7acb54ambIjae8KdCmXeOowDvBcuTSbwfYZDWVM5n3nvK1M1Eh6Je10KurnpBCjq5yDHvjokyhE2EwVBFfr/vA72wXYOF9KaDwxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L/4AKZ0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L/4AKZ0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D25C4CEE3;
	Fri, 25 Apr 2025 00:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745542391;
	bh=wcCoNr0UEBB1BOKDQfaJF7/q0hHzY8+BdwJ/i38qZNY=;
	h=Date:To:From:Subject:From;
	b=L/4AKZ0yAXgTaAVPYWrECAmu3yrfWpsvi7tWyWfbCZpMPVDXJ2QWE0wMt0mUqLaa4
	 wKfik1ZHW0CCZvIGLQRiY9PcpZiTgcPBtEZ+99B4PLHkG9/LjjXAQzPQd/qdy+AUgH
	 igsUyZTU9GoFwNY2jKXc6ix5OKsxIeMjx9i6owv8=
Date: Thu, 24 Apr 2025 17:53:11 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table.patch added to mm-nonmm-unstable branch
Message-Id: <20250425005311.B2D25C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove unnecessary NULL check before unregister_sysctl_table()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table.patch

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
From: Chen Ni <nichen@iscas.ac.cn>
Subject: ocfs2: remove unnecessary NULL check before unregister_sysctl_table()
Date: Tue, 22 Apr 2025 15:30:51 +0800

unregister_sysctl_table() checks for NULL pointers internally.  Remove
unneeded NULL check here.

Link: https://lkml.kernel.org/r/20250422073051.1334310-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/stackglue.c~ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table
+++ a/fs/ocfs2/stackglue.c
@@ -691,8 +691,7 @@ static void __exit ocfs2_stack_glue_exit
 	memset(&locking_max_version, 0,
 	       sizeof(struct ocfs2_protocol_version));
 	ocfs2_sysfs_exit();
-	if (ocfs2_table_header)
-		unregister_sysctl_table(ocfs2_table_header);
+	unregister_sysctl_table(ocfs2_table_header);
 }
 
 MODULE_AUTHOR("Oracle");
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are

mm-memcontrol-remove-unnecessary-null-check-before-free_percpu.patch
ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table.patch

