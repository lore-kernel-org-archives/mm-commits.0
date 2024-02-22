Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72B217C79
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645172; cv=none; b=Gl7r74AcsxN4HbH9TJTO444nfFSaGBtht3BESyNL3fjviFzH6bn6xXiX0bn4e/zgxxspPsfAzBXDLDL2LXdZYVOyTY96GpBHpejcr+sQBWugYdLUPfit01bb8KdjjkfW2Ho2T85Wsdh3WHlqvqNTHRudxUuzG9EaJ0Zp4rRbNWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645172; c=relaxed/simple;
	bh=xQTeBqKMnEPGcIUTG8NLJW8HUWqNwzI/WcYZhzoWZx4=;
	h=Date:To:From:Subject:Message-Id; b=ut30+MgHcjUSoU0e8vrl52HXk6UNMEcRG+UXZvxnoqvxU8tlpjav1Pjdt2FbGJApzR1zMlE9h9CtzJJ/92ZXln/+p5wtVN8SJVG++rNIvV8ABkh2C7t2utuHQnUqptxGhUC5Ntr6y9/jM2NAjQxT5T8OhN4nWoVIesQxdo+U5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tejpgGlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tejpgGlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E1EC433C7;
	Thu, 22 Feb 2024 23:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645172;
	bh=xQTeBqKMnEPGcIUTG8NLJW8HUWqNwzI/WcYZhzoWZx4=;
	h=Date:To:From:Subject:From;
	b=tejpgGlU5M19NHPF9X5QdkDcKR/mT72SxEZbVsi5JJmZvQTQs9+pFlHIYi90+eLCF
	 qIwQePG/U9W4TplDQcNOvUvHtE0vYe6ORjcLQhVNaBHeUoh1O9TWKXb+j7Mz/B4XDL
	 Cz/cZsXuxqO5OMmBeosqETbmohCeuc9C11VD03fo=
Date: Thu, 22 Feb 2024 15:39:31 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,zhangyongzhen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-spelling-fix.patch removed from -mm tree
Message-Id: <20240222233932.78E1EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: spelling fix
has been removed from the -mm tree.  Its filename was
     ocfs2-spelling-fix.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yongzhen Zhang <zhangyongzhen@kylinos.cn>
Subject: ocfs2: spelling fix
Date: Mon, 8 Jan 2024 09:56:04 +0800

Modify reques to request in the comment.

Link: https://lkml.kernel.org/r/20240108015604.38377-1-zhangyongzhen@kylinos.cn
Signed-off-by: Yongzhen Zhang <zhangyongzhen@kylinos.cn>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-spelling-fix
+++ a/fs/ocfs2/dlmglue.c
@@ -1615,7 +1615,7 @@ update_holders:
 unlock:
 	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
 
-	/* ocfs2_unblock_lock reques on seeing OCFS2_LOCK_UPCONVERT_FINISHING */
+	/* ocfs2_unblock_lock request on seeing OCFS2_LOCK_UPCONVERT_FINISHING */
 	kick_dc = (lockres->l_flags & OCFS2_LOCK_BLOCKED);
 
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
_

Patches currently in -mm which might be from zhangyongzhen@kylinos.cn are


