Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49A32045AD
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908607; cv=none; b=ZADt/jx3PuO/PidSuQcwiB+3kxsDka2lo1XqdSZj1Tu9hSOS19o/YfZwpXnImotXO0yUgoq4YeSsb0R7VEGf/waIjebB7CVbornFoIKnyF1F0kDd03rPWPSM9SoQ4sYuWvbaP57vx8HB7WVdTfAA3nPQ6yvcVacN+s2jx6/wsIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908607; c=relaxed/simple;
	bh=n5bFrN12G9bTDbWWE6div3YCTcYHmEguRiNbLrNJxEM=;
	h=Date:To:From:Subject:Message-Id; b=tcsiRyV+nYU4bVPbOTGnXKFV9p+IcW2PSauTvmTIiftW6D2udcmf6yg5+b6ruKtqSfj6ElFKCZ9hWooLJpWQNTGDAL/wQCr6rydFYVs2UxdhTPJK2fiGGLmNC5ijo3shcvJhxuuhmzPJmsAoDXVPS3e3gPn6F0Yiye7IagMqETI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yD1CuHbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yD1CuHbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794C3C4CEFB;
	Wed, 12 Nov 2025 00:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908604;
	bh=n5bFrN12G9bTDbWWE6div3YCTcYHmEguRiNbLrNJxEM=;
	h=Date:To:From:Subject:From;
	b=yD1CuHbYnoOqFuxYHwHZcYj6ilc5GZCcyFt0Sx2xoWniLqttlc59sLnmOndBGcitH
	 EgrTPvG2Jr4ne6RRlJcvfjutYYEz7+PExaP0a72D+Qb2XXdoXkFjsNGuFN3zD4RtZ7
	 mZC7ZQdJFDGsgEzdh+WlkYyIhc7uCDRGyid9ffqg=
Date: Tue, 11 Nov 2025 16:50:03 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block.patch removed from -mm tree
Message-Id: <20251112005004.794C3C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert to host endian in ocfs2_validate_inode_block
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: convert to host endian in ocfs2_validate_inode_block
Date: Sat, 25 Oct 2025 20:32:18 +0800

Convert to host endian when checking OCFS2_VALID_FL to keep consistent
with other checks.

Link: https://lkml.kernel.org/r/20251025123218.3997866-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c~ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block
+++ a/fs/ocfs2/inode.c
@@ -1481,7 +1481,7 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+	if (!(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL)) {
 		rc = ocfs2_error(sb,
 				 "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
 				 (unsigned long long)bh->b_blocknr);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


