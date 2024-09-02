Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5008014F10F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248834; cv=none; b=TbFF5O30yuzSBwWoM5v0D7wRSdyT5/FZxA/GBWUatZhf9Oj1VUlIDnmIw9LUbfJ6Xug9J7HOFJxGC5efqFfbtYPxJrHG+x0U8QsCt9DPB6QELkASQU7SDdBzZpsx+aTxWu6Std67lI0cUmB4422rPuwalU5e8TSjaIigJ27mnWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248834; c=relaxed/simple;
	bh=nOO5xDx6uWD354eYjsxlrgJDTTpny/8WGpAKjVHcb+g=;
	h=Date:To:From:Subject:Message-Id; b=ePAbMLZlvDw9KqzYt+1HNH5nyBv3uyFm+UQJ1UFnWZeeTF1minIQODi3oi8z3KseDU/+vPrdnVIT/lNDjOig5Jw12Gm3WhxMsQIq8/v0mxmb2H0KZHMBNI7uH1CTe55/dzPw7C0SyiC529miCzcWd12j363EXfJdBTI70pzxFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kfN/D1dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kfN/D1dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED30C4CEC2;
	Mon,  2 Sep 2024 03:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248834;
	bh=nOO5xDx6uWD354eYjsxlrgJDTTpny/8WGpAKjVHcb+g=;
	h=Date:To:From:Subject:From;
	b=kfN/D1drgcWuo467sHlRKAMp36KK6LpaGrVjse4WUhOrOZnPh1smp5hEGprdm14J9
	 TFycvhe5QDLHbs8GE/YsngUxFKU07MD159bY5KD/GYBzRcgi3erc4RYy92El5LQSpx
	 oHqun0Zkr71VtwzNzeWFpQOCZ9JYmgbyJn7C7Q1k=
Date: Sun, 01 Sep 2024 20:47:13 -0700
To: mm-commits@vger.kernel.org,syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,qasdev00@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-shift-out-of-bounds-ubsan-bug-in-ocfs2_verify_volume.patch removed from -mm tree
Message-Id: <20240902034714.1ED30C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix shift-out-of-bounds UBSAN bug in ocfs2_verify_volume()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-shift-out-of-bounds-ubsan-bug-in-ocfs2_verify_volume.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: qasdev <qasdev00@gmail.com>
Subject: ocfs2: fix shift-out-of-bounds UBSAN bug in ocfs2_verify_volume()
Date: Tue, 20 Aug 2024 02:22:09 +0100

This patch addresses a shift-out-of-bounds error in the
ocfs2_verify_volume() function, identified by UBSAN.  The bug was
triggered by an invalid s_clustersize_bits value (e.g., 1548), which
caused the expression "1 <<
le32_to_cpu(di->id2.i_super.s_clustersize_bits)" to exceed the limits of a
32-bit integer, leading to an out-of-bounds shift.

Link: https://lkml.kernel.org/r/ZsPvwQAXd5R/jNY+@hostname
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Reported-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=f3fff775402751ebb471
Tested-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-shift-out-of-bounds-ubsan-bug-in-ocfs2_verify_volume
+++ a/fs/ocfs2/super.c
@@ -2357,8 +2357,8 @@ static int ocfs2_verify_volume(struct oc
 			     (unsigned long long)bh->b_blocknr);
 		} else if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 12 ||
 			    le32_to_cpu(di->id2.i_super.s_clustersize_bits) > 20) {
-			mlog(ML_ERROR, "bad cluster size found: %u\n",
-			     1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
+			mlog(ML_ERROR, "bad cluster size bit found: %u\n",
+			     le32_to_cpu(di->id2.i_super.s_clustersize_bits));
 		} else if (!le64_to_cpu(di->id2.i_super.s_root_blkno)) {
 			mlog(ML_ERROR, "bad root_blkno: 0\n");
 		} else if (!le64_to_cpu(di->id2.i_super.s_system_dir_blkno)) {
_

Patches currently in -mm which might be from qasdev00@gmail.com are


