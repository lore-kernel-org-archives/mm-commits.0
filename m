Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1473714AD0D
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 23:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758150993; cv=none; b=J18ebSRe8DuJZwUIbJ+k1AYuAKaLb2RRhj9Mak1nEpS2uKBO7orrnHmxtG+pGjsVjK+e6Gzr3DFWbyuxvG/id+5IK6VnwpCI8m0yBpZZ1y/KAWp+Hf7mE8dwaJj01SP4BTr9kr/4UPqDUA7k6ax1U1iU0sw3UBMVWw1irrSWYqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758150993; c=relaxed/simple;
	bh=5fTEuBqtPwivL7eGlNj6fCKUP+x34kjtPIG4YTl/hxI=;
	h=Date:To:From:Subject:Message-Id; b=QgBJkWW7MqIwfiaPtQM1D5bW7yUmU+AbFNXoXAYTScey4EPZ/5d6Vqwin8+TtQWF78aFGnQzdpBsAKt+/LiOmziDKJp+xXGpTNWezX7d3ZGe3ECwdJ7DLMKkKXy1J/qZy0kyfpcuok/wqjVLPGADqv9Rk8RxgA/YzbQcQf1ZVA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EgvU8lKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EgvU8lKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79069C4CEE7;
	Wed, 17 Sep 2025 23:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758150992;
	bh=5fTEuBqtPwivL7eGlNj6fCKUP+x34kjtPIG4YTl/hxI=;
	h=Date:To:From:Subject:From;
	b=EgvU8lKy3QgK2nDBT/fiAkqzUFLLZIKOf4UpJx+lJVzbhQEDYiaGE8bH/jOsM9BGt
	 uWZv3JXnr8H1krkAyRzualEl54ZDdvJR0eaAwdvkFCKALDafWQu86/2FRPAdBpL9EQ
	 ZDC1OrhTNv04ilh+KT7rX7Wla8yoJeekamc3CiuQ=
Date: Wed, 17 Sep 2025 16:16:31 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name.patch added to mm-nonmm-unstable branch
Message-Id: <20250917231632.79069C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: avoid extra calls to strlen() after ocfs2_sprintf_system_inode_name()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name.patch

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

ocfs2-avoid-extra-calls-to-strlen-after-ocfs2_sprintf_system_inode_name.patch

