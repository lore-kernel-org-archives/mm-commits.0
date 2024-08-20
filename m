Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7F014A4F0
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724197203; cv=none; b=O4Im7VxCWXIOEKqUK7y6xVSlS7p6EWqvH6CzHNXkCBfWdwCtMirz3d46NeCVPMY/Ht30vB+wxMDtPb4nS2u0ZXByJ10Udh4Vz9c3kFwHPo3vbOW4GuAlFe4niBdTfru/DfcQdRNB3CrmFBG/RIw8x5+pk2dpjgSD3u1WX+CkcfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724197203; c=relaxed/simple;
	bh=bINrpLg3P/UxWB7mQfOz24xzKiLv+l2xLjBgksSJehM=;
	h=Date:To:From:Subject:Message-Id; b=j+IZnZjJz+2zeqy4xiGcflxk4OQEBmziv2jfKMybft1A8HFx0lr8kEuUZTLEoayjU7kkCdQeKWdUaok0xKIzTWFmQJOuN+C/FW2ZHp/G2Jpl2FbgA0uAlKDfZFxJ/CcPt1VUANJMBDj3Q7iH7ZTFaqjODBA2YUGPOX6fTS6OaoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2f2IhOyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2f2IhOyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DB2C4AF1D;
	Tue, 20 Aug 2024 23:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724197202;
	bh=bINrpLg3P/UxWB7mQfOz24xzKiLv+l2xLjBgksSJehM=;
	h=Date:To:From:Subject:From;
	b=2f2IhOyW4zqcLCi0OtnTc4Uoq+TPaEivVQqBHrUJxMkd5hV4TWvJDYwKRZTfftMTx
	 0KsXNWJncxQG9fvXmbhwyDJp/G9PJw/VYAP3ZXPpf1fnO21gm/EM0D//PxqNAGQJve
	 OM12UBicnSu/14C2+3H8qe2X3WRt1SEKQ0N004qg=
Date: Tue, 20 Aug 2024 16:40:01 -0700
To: mm-commits@vger.kernel.org,syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,qasdev00@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-shift-out-of-bounds-ubsan-bug-in-ocfs2_verify_volume.patch added to mm-nonmm-unstable branch
Message-Id: <20240820234002.66DB2C4AF1D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix shift-out-of-bounds UBSAN bug in ocfs2_verify_volume()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-shift-out-of-bounds-ubsan-bug-in-ocfs2_verify_volume.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-shift-out-of-bounds-ubsan-bug-in-ocfs2_verify_volume.patch

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

ocfs2-fix-shift-out-of-bounds-ubsan-bug-in-ocfs2_verify_volume.patch

