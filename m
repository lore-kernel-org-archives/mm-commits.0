Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8CF23F431
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597092; cv=none; b=nMt35FQ3iC7mLdlzkuy4A+EQ0HyzP09xx53iKBlOdFlg+d7aU0dk1cb3kj9AxknolOGzf/m7ZCpM4cvVCUMS9QLVwx00JsE7hqfFDo7oOeUj3UIr8eA5K8F4qNn81LAEiTvDoBjh1OvzbLw4BcK68sVlhRy02oxgGLLQ6cYXed4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597092; c=relaxed/simple;
	bh=jJESpoygv/ODzj5/+61WO94LofJlSV4jrC3+6asbNec=;
	h=Date:To:From:Subject:Message-Id; b=nRzhL7fsEyYN/F0bOkuo6/wVm7frYDxLPZ8dS07cgy4QY42gkSK9GvprrAs7R9qFdI8N+xyg6Au6CvdzxT4nffoXRsjfDLgKfPm4rTH3Fmvgws1wom5BUNyQLCSrE2rSqAOgfpkR15LT6NTKUBW286zwUT10Vo9AhfEjsDW/jaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iJj1W25F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iJj1W25F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D78C116B1;
	Tue, 23 Sep 2025 03:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597092;
	bh=jJESpoygv/ODzj5/+61WO94LofJlSV4jrC3+6asbNec=;
	h=Date:To:From:Subject:From;
	b=iJj1W25Flv4iLruNR9kYBs4Dh1ZLUmUeY8MC+ggOQ7Uu41GKLAkkBW682/zqiHxqq
	 1csgBLDotOiLff5I8PRi+fgYwor3lVxj98ACCJUdhsyPVFiJcs1SO/alcVijPAYoz7
	 7jZzP+TCCL7SmK/6F2Dnw9itKP9kOKkkrLR0CAxw=
Date: Mon, 22 Sep 2025 20:11:31 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name.patch removed from -mm tree
Message-Id: <20250923031132.47D78C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: avoid extra calls to strlen() after ocfs2_sprintf_system_inode_name()
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: avoid extra calls to strlen() after ocfs2_sprintf_system_inode_name()
Date: Wed, 17 Sep 2025 09:02:29 +0300

Since 'ocfs2_sprintf_system_inode_name()' uses 'snprintf()' and returns
the number of characters emitted, callers of the former are better to use
that return value instead of an explicit calls to 'strlen()'.

Link: https://lkml.kernel.org/r/20250917060229.1854335-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c        |   18 +++++++-----------
 fs/ocfs2/move_extents.c |    8 ++++----
 fs/ocfs2/sysfile.c      |   12 ++++++------
 3 files changed, 17 insertions(+), 21 deletions(-)

--- a/fs/ocfs2/ioctl.c~ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name
+++ a/fs/ocfs2/ioctl.c
@@ -358,13 +358,11 @@ static int ocfs2_info_handle_freeinode(s
 				goto bail;
 			}
 		} else {
-			ocfs2_sprintf_system_inode_name(namebuf,
-							sizeof(namebuf),
-							type, i);
+			int len = ocfs2_sprintf_system_inode_name(namebuf,
+								  sizeof(namebuf),
+								  type, i);
 			status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
-							    namebuf,
-							    strlen(namebuf),
-							    &blkno);
+							    namebuf, len, &blkno);
 			if (status < 0) {
 				status = -ENOENT;
 				goto bail;
@@ -651,12 +649,10 @@ static int ocfs2_info_handle_freefrag(st
 			goto bail;
 		}
 	} else {
-		ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type,
-						OCFS2_INVALID_SLOT);
+		int len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf),
+							  type, OCFS2_INVALID_SLOT);
 		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
-						    namebuf,
-						    strlen(namebuf),
-						    &blkno);
+						    namebuf, len, &blkno);
 		if (status < 0) {
 			status = -ENOENT;
 			goto bail;
--- a/fs/ocfs2/move_extents.c~ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name
+++ a/fs/ocfs2/move_extents.c
@@ -364,7 +364,7 @@ static int ocfs2_find_victim_alloc_group
 					 int *vict_bit,
 					 struct buffer_head **ret_bh)
 {
-	int ret, i, bits_per_unit = 0;
+	int ret, i, len, bits_per_unit = 0;
 	u64 blkno;
 	char namebuf[40];
 
@@ -375,9 +375,9 @@ static int ocfs2_find_victim_alloc_group
 	struct ocfs2_dinode *ac_dinode;
 	struct ocfs2_group_desc *bg;
 
-	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
-	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
-					 strlen(namebuf), &blkno);
+	len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
+	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf, len, &blkno);
+
 	if (ret) {
 		ret = -ENOENT;
 		goto out;
--- a/fs/ocfs2/sysfile.c~ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name
+++ a/fs/ocfs2/sysfile.c
@@ -127,14 +127,14 @@ static struct inode * _ocfs2_get_system_
 	char namebuf[40];
 	struct inode *inode = NULL;
 	u64 blkno;
-	int status = 0;
+	int len, status = 0;
 
-	ocfs2_sprintf_system_inode_name(namebuf,
-					sizeof(namebuf),
-					type, slot);
+	len = ocfs2_sprintf_system_inode_name(namebuf,
+					      sizeof(namebuf),
+					      type, slot);
 
-	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
-					    strlen(namebuf), &blkno);
+	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
+					    namebuf, len, &blkno);
 	if (status < 0) {
 		goto bail;
 	}
_

Patches currently in -mm which might be from dmantipov@yandex.ru are


