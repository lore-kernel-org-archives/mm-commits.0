Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A5B272E57;
	Thu, 28 Aug 2025 05:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359973; cv=none; b=RGITSbfYpO2sL8ACDdoJRK6aBxKyK08SA0LjzfQvBMGyDFozuyKnEDoFIBjzh+T6pe1cAfZ3vhZbVLQZdWIElb46z7ry2GV3jTS09vq1jIvVeUNWm8myLRpz501FQiJ3CBQDYLjYc6gwHTbXw46v/b+pY7A+yA2MLQ6LLxkgG7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359973; c=relaxed/simple;
	bh=47MVXWOKsm+7Hr8DApuzjOHDfE8FnyBdxQLeog1VZfs=;
	h=Date:To:From:Subject:Message-Id; b=lUu1papABHNsUP/ZqEm9PB3sZZJXWK4JPf6FbpsogYUP1xzSr8uaTTGQJgxPpztXi9g5ElWmadJi1LU78LfiopaAsGlWYK2Wb1ALfZ/pcshhS9kKNqVIS2cIuebl9w724RJJlChDfaoEezt3VsVDyok6wtThnPacG6Nl/1f0iAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hnbN417G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hnbN417G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E42C4CEEB;
	Thu, 28 Aug 2025 05:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359972;
	bh=47MVXWOKsm+7Hr8DApuzjOHDfE8FnyBdxQLeog1VZfs=;
	h=Date:To:From:Subject:From;
	b=hnbN417G7VuJu1RygY5N6d7ZxIlhHu0Lw+dt0/dUlK+NVV6Y9lslL1KQmfckFRiax
	 ndlU5GzFjXUp3LD0kKS3Oj9uP2d4eIgrS+pxjPqC3cMXCiNblqKlfHIZR8V4ltUcSD
	 F9C8VY7mVZwDHLM4SUbAMAiSiAJeQvfl4WBOoJfA=
Date: Wed, 27 Aug 2025 22:46:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-prevent-release-journal-inode-after-journal-shutdown.patch removed from -mm tree
Message-Id: <20250828054612.C0E42C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: prevent release journal inode after journal shutdown
has been removed from the -mm tree.  Its filename was
     ocfs2-prevent-release-journal-inode-after-journal-shutdown.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Adam Davis <eadavis@qq.com>
Subject: ocfs2: prevent release journal inode after journal shutdown
Date: Tue, 19 Aug 2025 21:41:02 +0800

Before calling ocfs2_delete_osb(), ocfs2_journal_shutdown() has already
been executed in ocfs2_dismount_volume(), so osb->journal must be NULL. 
Therefore, the following calltrace will inevitably fail when it reaches
jbd2_journal_release_jbd_inode().

ocfs2_dismount_volume()->
  ocfs2_delete_osb()->
    ocfs2_free_slot_info()->
      __ocfs2_free_slot_info()->
        evict()->
          ocfs2_evict_inode()->
            ocfs2_clear_inode()->
	      jbd2_journal_release_jbd_inode(osb->journal->j_journal,

Adding osb->journal checks will prevent null-ptr-deref during the above
execution path.

Link: https://lkml.kernel.org/r/tencent_357489BEAEE4AED74CBD67D246DBD2C4C606@qq.com
Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reported-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=47d8cb2f2cc1517e515a
Tested-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-prevent-release-journal-inode-after-journal-shutdown
+++ a/fs/ocfs2/inode.c
@@ -1281,6 +1281,9 @@ static void ocfs2_clear_inode(struct ino
 	 * the journal is flushed before journal shutdown. Thus it is safe to
 	 * have inodes get cleaned up after journal shutdown.
 	 */
+	if (!osb->journal)
+		return;
+
 	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
 				       &oi->ip_jinode);
 }
_

Patches currently in -mm which might be from eadavis@qq.com are


