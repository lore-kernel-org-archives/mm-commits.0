Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8628372692
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028774; cv=none; b=YsNig4Wjup1fyRENSusowKbQTbK8+/8YaTcPgPlzrVz2r/QTi4y3T3ZGujfti1wed1QoUl8u+moRqvF+jon3Nq3bmerkF1zc0k6F+01Yc/bx2XakPpIM9YTaiHdxVupo/OM9XKfZhBXZefSHtHH6LMhziYCSJzsijCw4WXdIhyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028774; c=relaxed/simple;
	bh=d/UaRigE5VhM+mdcb718Ne4RxH6naXIB9o+6y1EtOd4=;
	h=Date:To:From:Subject:Message-Id; b=IBDjcNgBy/1Zqplxa/XcUNc+wn2W/Kkcy+tiraCIVdFTwnIpF2/u0opqd4kMlTeRBztd7wYL3bEp+kGhUo1EwtDxTv0RPqZ2ftADtVOJf0cgHLpHbK50zJjUuLxVjj3UPSqhdZYbwbpqaSlfjH9zkD5EVR2+ym4arlDuGj6Egq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwOh/Ezj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwOh/Ezj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2211F00893;
	Fri, 29 May 2026 04:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028772;
	bh=iK67HxsDHMvoaRxnI9BgtkCAnWgcYB/HI0wtPetbKEA=;
	h=Date:To:From:Subject;
	b=qwOh/EzjuQQchPIa9MZIarX+OabJShrAWEWO1vPVzX1ftuQ5fl1CiYDcsPka62c5l
	 iVeEWg8RRSIYqMPiSDZe2J3DWhsgujBhrEsCJ5MNuaMOkmW10lzsRRD4n8l1QNx+gX
	 84LCtDlAr2rST+uXzrqIDBLkaE5/RykXXSnyXH1Y=
Date: Thu, 28 May 2026 21:26:12 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-inline-xattr-header-before-ibody-remove.patch removed from -mm tree
Message-Id: <20260529042612.8D2211F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate inline xattr header before ibody remove
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-inline-xattr-header-before-ibody-remove.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate inline xattr header before ibody remove
Date: Fri, 8 May 2026 16:59:12 +0800

[BUG]
A corrupt inline xattr header can make ocfs2_xattr_ibody_remove() pass an
unchecked header into ocfs2_remove_value_outside() during inode xattr
teardown.

[CAUSE]
ocfs2_xattr_ibody_remove() still rebuilt the ibody xattr header directly
from di->i_xattr_inline_size and then handed it to code that iterates
xh_count and entry geometry.

[FIX]
Validate the inline xattr header with the shared helper before handing it
to the outside-value removal path, and propagate -EFSCORRUPTED on bad
metadata instead of traversing the unchecked header.

Link: https://lore.kernel.org/20260508085914.61647-4-gality369@gmail.com
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Zixuan Fu <r33s3n6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-inline-xattr-header-before-ibody-remove
+++ a/fs/ocfs2/xattr.c
@@ -2476,9 +2476,9 @@ static int ocfs2_xattr_ibody_remove(stru
 		.vb_access = ocfs2_journal_access_di,
 	};
 
-	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
+	if (ret)
+		return ret;
 
 	ret = ocfs2_remove_value_outside(inode, &vb, header,
 					 ref_ci, ref_root_bh);
_

Patches currently in -mm which might be from gality369@gmail.com are


