Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6837E8175E
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104478; cv=none; b=IG4511y9j6WnpYBEep38fEzvNbzRe5I81BARvipuJ6Q76fgLSQBsPWs7AHd6kDEhS32g9M5p9Vzr0TTpzMuaISDyHHQjPWNdsiLjkcSJT5Np4r7DOuvVrzYmOe5BJ4uOuttCK6eHcCDQdfoBtJ4BSUzmp8hmgHgm0DT7TgoMm5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104478; c=relaxed/simple;
	bh=haoSvkFFBv3l/XoqVivZY6yS8V3VBvVxXbI0h/tnU6U=;
	h=Date:To:From:Subject:Message-Id; b=UlvhISNwZAeN16uheXJ6jyKQxWBC3yxXcTjpfuk45I5IFPin9a436NggMCH8X7cyAnuqdiO2p8q3tVhhwxtu3FYvGZP5DFxIX70x8MxCcMY0gemZsqTYCTgPuLjzJ3Qd9MpfilQmeBeVmEuwbCVsQ629H6i9JoqqPevI9G7REOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSAA8U9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSAA8U9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8B0C116B1;
	Fri, 26 Apr 2024 04:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104478;
	bh=haoSvkFFBv3l/XoqVivZY6yS8V3VBvVxXbI0h/tnU6U=;
	h=Date:To:From:Subject:From;
	b=FSAA8U9Z2WzA1HZEcp9ceA8nfKC8PvGJu4ZAM3wP+W0jDIT8hcKRNzIClWQP4SI3Y
	 IDj6Ef4RkkpofhD8EYIu3DFGNE4r5FPho9pP43/aXxJUifa2gNsQ1eI4p41CCBqbKa
	 shKSyivuE456SUjWJB6qMzibZjqb1vzXA51PmbSI=
Date: Thu, 25 Apr 2024 21:07:57 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch removed from -mm tree
Message-Id: <20240426040758.3B8B0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: return real error code in ocfs2_dio_wr_get_block
has been removed from the -mm tree.  Its filename was
     ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: return real error code in ocfs2_dio_wr_get_block
Date: Mon, 8 Apr 2024 16:20:38 +0800

Patch series "ocfs2 bugs fixes exposed by fstests", v3.

The patchset is to fix some wrong behavior of ocfs2 exposed by fstests.

Patch 1 makes userspace happy when some error happens when doing direct
io.  Before the patch, DIO always return -EIO in case of error.  After the
patch, it returns real error code such like -ENOSPC, EDQUOT...

Patch 2 fixes an error case when doing AIO+DIO and hole punching at same
file position in parallel.  generic/300

Patch 3 fixes inode link count mismatch after power failure.  Without the
patch, inode link would be wrong even fync was called on the file. 
tests/generic/040,041,104,107,336

patch 4 fixes wrong atime with mount option realtime.  Without the patch,
atime of new created file won't be updated in right time. 
tests/generic/192

For stable kernels, I added fixes to patch 2,3,4.  The patch 1 is not
recommended to be backported since ocfs2_dio_wr_get_block calls too many
functions.  It's diffcult to check every git history of ocfs2 for every
LTS kernel.  


This patch (of 4):

ocfs2_dio_wr_get_block always returns -EIO in case of errors.  However,
some programs expect right exit codes while doing dio.  For example, tools
like fio treat -ENOSPC as expected code while doing stress jobs.  And
quota tools expect -EDQUOT when disk quota exceeds.

-EIO is too strong return code in the dio path.  The caller of
ocfs2_dio_wr_get_block is __blockdev_direct_IO which is widely used and it
handles error codes well.  I have checked functions called by
ocfs2_dio_wr_get_block and their return codes look good and clear.  So I
think it's safe to let ocfs2_dio_wr_get_block return real error code.

Link: https://lkml.kernel.org/r/20240408082041.20925-1-glass.su@suse.com
Link: https://lkml.kernel.org/r/20240408082041.20925-2-glass.su@suse.com
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block
+++ a/fs/ocfs2/aops.c
@@ -2283,8 +2283,6 @@ unlock:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	if (ret < 0)
-		ret = -EIO;
 	return ret;
 }
 
_

Patches currently in -mm which might be from glass.su@suse.com are


