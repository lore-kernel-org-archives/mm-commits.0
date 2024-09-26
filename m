Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8860B184556;
	Thu, 26 Sep 2024 21:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384659; cv=none; b=JRrrAEzxThUfx99I0Einc+Wa5zoaUzzTCTlieda4VPlZSoQHuLQA+BRVAS5tqO5tV/Va3xRMWXzDgX8vvMyyBQ9qJr8yW0tmRRg1zn7PWT8gytZyW1vuZp+UzmKfj/gLOvPp7D18+IRq9ElhBnCPXJSdR8ZVdyPbYsP+zFxNIgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384659; c=relaxed/simple;
	bh=9Fi9n4pu634gmjGsIHRvNmdNUvgrQ/o/fVpX5AxNvkY=;
	h=Date:To:From:Subject:Message-Id; b=eAf8AasfUj+huzUTLtZSgzrT+Lfh25zYk66MZa4F/dM98HQgUHwthSaQmmqCDVusGXVN5tPHbNUEsX/2V6gwK2iOsKwJRlf5edo9LwVM2Q0w/EuENh5B1JnFzEE29r93NaEb6glAsAkaz6myMbG0S92HM8/hpY4v3Baq4BK//TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MDnhLVFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MDnhLVFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246BFC4CEC5;
	Thu, 26 Sep 2024 21:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384658;
	bh=9Fi9n4pu634gmjGsIHRvNmdNUvgrQ/o/fVpX5AxNvkY=;
	h=Date:To:From:Subject:From;
	b=MDnhLVFbU3iXX66LzV49rsxpocIG6I2oNQ9f34RqjYs5v+lVz96vYW7ftNgoB5AMm
	 DPf+Mf6tlYa6YPg+IwZAqjEdQlrOiDV5od02X1ZGd7I5O2xG21IWj+rsUxaAiGYwTy
	 Z2Cp1wADFMt70bq8Mf5N57bO5IGyNW/w8e0V2R2A=
Date: Thu, 26 Sep 2024 14:04:17 -0700
To: mm-commits@vger.kernel.org,syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,pvmohammedanees2003@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-deadlock-in-ocfs2_get_system_file_inode.patch removed from -mm tree
Message-Id: <20240926210418.246BFC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix deadlock in ocfs2_get_system_file_inode
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-deadlock-in-ocfs2_get_system_file_inode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
Subject: ocfs2: fix deadlock in ocfs2_get_system_file_inode
Date: Tue, 24 Sep 2024 09:32:57 +0000

syzbot has found a possible deadlock in ocfs2_get_system_file_inode [1].

The scenario is depicted here,

	CPU0					CPU1
lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&osb->system_file_mutex);
                               lock(&ocfs2_file_ip_alloc_sem_key);
lock(&osb->system_file_mutex);

The function calls which could lead to this are:

CPU0
ocfs2_mknod - lock(&ocfs2_file_ip_alloc_sem_key);
.
.
.
ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);

CPU1 -
ocfs2_fill_super - lock(&osb->system_file_mutex);
.
.
.
ocfs2_read_virt_blocks - lock(&ocfs2_file_ip_alloc_sem_key);

This issue can be resolved by making the down_read -> down_read_try
in the ocfs2_read_virt_blocks.

[1] https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd

Link: https://lkml.kernel.org/r/20240924093257.7181-1-pvmohammedanees2003@gmail.com
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: <syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
Tested-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/extent_map.c~ocfs2-fix-deadlock-in-ocfs2_get_system_file_inode
+++ a/fs/ocfs2/extent_map.c
@@ -973,7 +973,13 @@ int ocfs2_read_virt_blocks(struct inode
 	}
 
 	while (done < nr) {
-		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
+			rc = -EAGAIN;
+			mlog(ML_ERROR,
+				 "Inode #%llu ip_alloc_sem is temporarily unavailable\n",
+				 (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			break;
+		}
 		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
 						 &p_block, &p_count, NULL);
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);
_

Patches currently in -mm which might be from pvmohammedanees2003@gmail.com are

ocfs2-fix-typo-in-comment.patch

