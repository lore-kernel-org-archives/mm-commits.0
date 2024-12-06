Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471FB193409;
	Fri,  6 Dec 2024 03:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457329; cv=none; b=mOjTOwRNzAQrMqNixnWnjY4cG8b5nIIpBJLOmqg/DUUtZEkindxipiXr+wYmqGwbPHjOGcGiAZFFuJ/e5y6nlTABwUgsd6O4VPN71qWj1bfMkboEDhjYbdTvbuIXwiaXy2EI0uMLjfZus4CcVobaANdkySBv6ulgcvq1dlmz6oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457329; c=relaxed/simple;
	bh=Qxk3jYUeuT9pRsujYeFRJuHeB33yVy/64Gm11Z+XUTk=;
	h=Date:To:From:Subject:Message-Id; b=Of0MskpgkneRCTaR27S+fiYNeJvdW/yD2MLOTA/xuSOSCNOXwdH7QCodo8PMIz4oOZosOAiOrZEER8nqsyaB7jC+II3F6FvPUGM/VQezX3uS0ExYEdFO5zJFQZ2fuJvVcNogSY7ejTuvFt3HgFRI/P04xcDVA1j1Lb5oC/MeNR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VNXNZvbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VNXNZvbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0C1C4CED1;
	Fri,  6 Dec 2024 03:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457328;
	bh=Qxk3jYUeuT9pRsujYeFRJuHeB33yVy/64Gm11Z+XUTk=;
	h=Date:To:From:Subject:From;
	b=VNXNZvbW/FZCny+fIPCS72/VfDQ8jST5q4A+xWODKlg80MqAJmiAb+EkAnwUHH8IF
	 R7eOvwDsyESL/uHXe03g4hfpdCVN4BP9xLmiobi8CIt5rusCy9c9XYwm2sbQ5in3ZA
	 hyCqTb/2/GHBqhYB/z0y1js8SOZ0EO5+s66aLBXk=
Date: Thu, 05 Dec 2024 19:55:28 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,wen.gang.wang@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-update-seq_file-index-in-ocfs2_dlm_seq_next-v2.patch removed from -mm tree
Message-Id: <20241206035528.CB0C1C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: update seq_file index in ocfs2_dlm_seq_next
has been removed from the -mm tree.  Its filename was
     ocfs2-update-seq_file-index-in-ocfs2_dlm_seq_next-v2.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: update seq_file index in ocfs2_dlm_seq_next
Date: Tue, 19 Nov 2024 09:45:00 -0800

The following INFO level message was seen:

seq_file: buggy .next function ocfs2_dlm_seq_next [ocfs2] did not
update position index

Fix:
Update *pos (so m->index) to make seq_read_iter happy though the index its
self makes no sense to ocfs2_dlm_seq_next.

Link: https://lkml.kernel.org/r/20241119174500.9198-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/dlmglue.c~ocfs2-update-seq_file-index-in-ocfs2_dlm_seq_next-v2
+++ a/fs/ocfs2/dlmglue.c
@@ -3110,6 +3110,7 @@ static void *ocfs2_dlm_seq_next(struct s
 	struct ocfs2_lock_res *iter = v;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
+	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
 	iter = ocfs2_dlm_next_res(iter, priv);
 	list_del_init(&dummy->l_debug_list);
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are


