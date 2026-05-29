Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1375B371867;
	Fri, 29 May 2026 04:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028738; cv=none; b=ZdPav+lOZqeriE29zwN7krXMcI/8IuOeVojFC48uDefpHnJzHXx/s07M685naFnc0xZczxjrnNhPr9/nbG9ewwFsWOxx69gyAyandyuYFzgua8xLTzJLQ5y7IvTLRF3YWR3DTb66HCVBL1tjlfubkmizuQYnpGlxHscaKC4RSm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028738; c=relaxed/simple;
	bh=a7A14q662gKoNiOfsiQYVXyXvcY9D0v0VMzU/yRQPDg=;
	h=Date:To:From:Subject:Message-Id; b=YdAYkkMRfyjaAWSm4M8ny4dTVUDDaMc19etltJ0FBmsM5FaOpKiGFg26tPtG/U5Hx2z5GFBpnp37deMWUDRSSE4ro8Au83QqeksEE6qX3Ei+kUmHPUXW8sckmtAKFDoDyG+2P0vwp/eg/DXlONV9sTJfiEGtLyRjhmUThhby48E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U9wdiVQ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U9wdiVQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5FE1F00893;
	Fri, 29 May 2026 04:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028737;
	bh=Au+mXQcsIiUdriIqK5zL5Bn/0AUl9Cd3ARi/3LRz+Ac=;
	h=Date:To:From:Subject;
	b=U9wdiVQ3jMPNMc2CINVeAaZ/vEC0zZ5vZHTGhxMGqkvwCzkLZDH2egQa1NxGcWuXU
	 MVPl1hJcp4m/+2G2oEnZZrCoTQT8pf0UAQ3t4loLUnodwYg3ve1mN7ViFdhKWIlWcn
	 zbbgHP5OEq1i/q1CShlDGJoSCcXqeujS4AzNcfwA=
Date: Thu, 28 May 2026 21:25:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,tristan@talencesecurity.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-kzalloc-for-quota-recovery-bitmap-allocation.patch removed from -mm tree
Message-Id: <20260529042536.DE5FE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use kzalloc for quota recovery bitmap allocation
has been removed from the -mm tree.  Its filename was
     ocfs2-use-kzalloc-for-quota-recovery-bitmap-allocation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tristan Madani <tristan@talencesecurity.com>
Subject: ocfs2: use kzalloc for quota recovery bitmap allocation
Date: Sat, 18 Apr 2026 13:10:48 +0000

ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does not
fully initialize it.  This can lead to use of uninitialized bits during
quota recovery from a corrupted filesystem image.

Use kzalloc instead to ensure the bitmap is zero-initialized.

Link: https://lore.kernel.org/20260418131048.1052507-1-tristmd@gmail.com
Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_local.c~ocfs2-use-kzalloc-for-quota-recovery-bitmap-allocation
+++ a/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(stru
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;
_

Patches currently in -mm which might be from tristan@talencesecurity.com are


