Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53524C6F
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 01:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712195512; cv=none; b=gGmmAutrnug7zcG+fhz9qYjxzqGoxiIjAmT1WqmHUZHbbQ7pA0X0d/iEnXKPIis8VpthG8iMZ4N3hAitoyKlb1LV3QfyQMK8FtIKSyBOavpQcAFw5BEMbys8yG0hJfolMWpYnKK3LvFfVF0hyBhS3rgjN86N3lwFsTUjDo/6rAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712195512; c=relaxed/simple;
	bh=xFZxGBjixBAsYH7V63R3y6j/i5X51cth2I7BwryPFhs=;
	h=Date:To:From:Subject:Message-Id; b=IGPlFeSoL5jlpyPyKzsxH6kpff5nET/3Xe0We1yhaJ1vsqupWC22st6fVGFTgSi7oE9LauQIFAmZl4vAes1BDWY+DCQAYKvW/WMZAKg+sgfwCSO4F/oQD8qxXGWmv4I63AScoQv5TcJQSo6TbmoJuzJq7+oeC5lAnJfeyGQy57c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XRLyrbU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XRLyrbU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F513C433C7;
	Thu,  4 Apr 2024 01:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712195512;
	bh=xFZxGBjixBAsYH7V63R3y6j/i5X51cth2I7BwryPFhs=;
	h=Date:To:From:Subject:From;
	b=XRLyrbU1+iZ6Nuc1H9MvW0u0b0mQ5PVybYkM86sfBmeoZ1N+5v/r9cpXZl4jLzOnQ
	 LopPGNirC1mIRqPFoEcrI2UVvkSt8hORIfJvNfq7bmrZgivI2adNDpkHRIgIKvOJMC
	 8GgovuQZLYWzOm/cH+hcexJa0wn32ExKymR7o+rY=
Date: Wed, 03 Apr 2024 18:51:51 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch added to mm-nonmm-unstable branch
Message-Id: <20240404015152.4F513C433C7@smtp.kernel.org>
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
Date: Tue, 2 Apr 2024 09:46:48 +0800

Patch series "ocfs2 bugs fixes exposed by fstests", v2.

The patchset is to fix some wrong behavior of ocfs2 exposed by fstests.

Patch 1,2 are about AIO+DIO vs hole punching. generic/300

Patch 3 fixes inode link count mismatch after power failure.
tests/generic/040,041,104,107,336

patch 4 fixes wrong atime with mount option realtime. tests/generic/192


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

Link: https://lkml.kernel.org/r/20240402014651.13723-1-glass.su@suse.com
Link: https://lkml.kernel.org/r/20240402014651.13723-2-glass.su@suse.com
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
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

