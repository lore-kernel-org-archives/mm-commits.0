Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314431420DD;
	Tue, 24 Sep 2024 22:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727215932; cv=none; b=Ur8V84GmM7y9j63SoJwBxMpbOCoNMwgYCrnnUAqa5FTREWgQ/TnFMxowWE6VlXgdcjw2v+PkFB65896sKeTIH59TPutiFD1hyUV6GKnUYFc6BAdhnkzPye/LxOzVO6bcbbSLJV8Es3TEYWsHPllqIKb3SYIeW2p0e106gxvFK2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727215932; c=relaxed/simple;
	bh=+SXg79KZWq3GG+l4ZevXGYUCke9tJeFiXNUYmKa0zQQ=;
	h=Date:To:From:Subject:Message-Id; b=Gsm+kW5BdCl9TWRwbtGE7leH5fEAwe3bH5+FtNHJd9AA36KeQIDEUAXra6DYSkRzj2oNFLpShx+ytNE36t7Ths9Kz49JkRG36mqgnG9Z00tRxm0k0vL15KPR1IrP/ytXnPC7CSZkQR4KUJ0cZwXOGNG9TOiTy64Kmpe0oFL9zaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ekBfAM6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ekBfAM6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B45C4CEC4;
	Tue, 24 Sep 2024 22:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727215931;
	bh=+SXg79KZWq3GG+l4ZevXGYUCke9tJeFiXNUYmKa0zQQ=;
	h=Date:To:From:Subject:From;
	b=ekBfAM6AmhHBe5iniJ3JvT/i5pfSK4ERi8OxIpj6yy+gdBwuAjVvPP/IDDhBoJ1CY
	 Wd/DPnJM1HAhXAdMKJjfIJqLAxZX20o6fwNiTCzvWogsbtzFK3QiPfeZVE9xBJPJPx
	 VQLKpOeo1pke1z0PF4nTNagwTjJamaDidBNtqBZc=
Date: Tue, 24 Sep 2024 15:12:11 -0700
To: mm-commits@vger.kernel.org,syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,pvmohammedanees2003@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-deadlock-in-ocfs2_get_system_file_inode.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924221211.A5B45C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix deadlock in ocfs2_get_system_file_inode
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-deadlock-in-ocfs2_get_system_file_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-deadlock-in-ocfs2_get_system_file_inode.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

ocfs2-fix-deadlock-in-ocfs2_get_system_file_inode.patch
ocfs2-fix-typo-in-comment.patch

