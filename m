Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6C438DD6
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 20:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712607576; cv=none; b=s3IDs0dCuQ5cPMNKrTpJOMcLjesGteppvL/gIx7ihGbpAdGjZImwdqZx7dZLFfRdKIv6lc5fAkYUOj5kwvcJvga151USmPixSJiB5BJQe5/cFHA/pVr2M8F/HBhUbjmnqIC/G5LDtfIOaHsQAM1ZH467Vi484jJPM2A6yxIfkCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712607576; c=relaxed/simple;
	bh=FiSd7cCcXOEjVAV/LzWRdUAJdl0wLf+ZU6Y0eEYLl2w=;
	h=Date:To:From:Subject:Message-Id; b=A6/esyuunUEpQS3GztTNy7Yx0Ttjp55AC+myH1SGRkFn2v9nTMlFU1P5k5diPlxKRi0CCw8+ceK+14L53ZekmDckx8YtkcPRtW2watoCGQq8QRa/OfvLEh8zPldiVZWbu+eAgDTaqkpasfDH6bC8+wLSGvlHlrQR9ijSrH9qU/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RUr6xNtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RUr6xNtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAD1C433F1;
	Mon,  8 Apr 2024 20:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712607576;
	bh=FiSd7cCcXOEjVAV/LzWRdUAJdl0wLf+ZU6Y0eEYLl2w=;
	h=Date:To:From:Subject:From;
	b=RUr6xNtvXzc2d8oPWqUBR2m6vri5uKSkFfa44ylF0PW6YJRfFnxM68ZBcyyguax09
	 6soxMRcfS0V1NXFlLIuBbM7YpS2x9YU6TMkqpfNXkLYC9kEUy+sJ9YeGtAO/qYX5tN
	 KP/SxMqctZc/cIEnVx/dYVWNcVASwfRuo1aPikVQ=
Date: Mon, 08 Apr 2024 13:19:35 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch added to mm-nonmm-unstable branch
Message-Id: <20240408201936.0FAD1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: return real error code in ocfs2_dio_wr_get_block
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch

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

ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch
ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch
ocfs2-fix-races-between-hole-punching-and-aiodio.patch
ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch
ocfs2-use-coarse-time-for-new-created-files.patch

