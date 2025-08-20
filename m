Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0CB2E1757;
	Wed, 20 Aug 2025 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755734194; cv=none; b=FJ8UiL4Aycv0iq9oMbfvQA2Aebh6uf2nfOg6xNOyDJKMNs4j9ZMaZW/f09hfrymlenvSkP3PSo0Ovs7iKH9uNjWAFXsn9nfIDM/hm0enLznXYrYCvenaerRZEi1pdBoQgqGHuFT3dGhqrIRCO2CVJvLcPR29vAszLrPBOvQAZdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755734194; c=relaxed/simple;
	bh=Re1ylybfgsDuS5/NjVqPru6UuJzLyL3bNN6SP6G1UW4=;
	h=Date:To:From:Subject:Message-Id; b=cbO9npcUYQc26eioA6OvYKck6XZMb3RuAWlQQvc9RiwghFNHgObLI5gr20zX4XZhT9D56CoOCzx3KrCkyTUDFMTFnQjFSOmU4bA0drDXtU8aFzn9+ZxmdeyvFe3XoYhojHlmaFIqOTs5dP8t1ZlS4V4RlS0f9YmGpBrz2v+vQgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wA/FUVW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wA/FUVW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477CFC4CEE7;
	Wed, 20 Aug 2025 23:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755734193;
	bh=Re1ylybfgsDuS5/NjVqPru6UuJzLyL3bNN6SP6G1UW4=;
	h=Date:To:From:Subject:From;
	b=wA/FUVW3kbUFxxFDVFkgWHioqKFqY3qWkJdexBp/hl4LwvfgiDdQ++ATcPsSucGy8
	 IWWnYy4qNKoMR/0tiE12HCn9ptb235gEuYUk/hL9IZpSEEw6DQbCWGFfdqJzKJgkEX
	 /WcjhnVrj9ZgavrcNWV63ZDxwKWFsBLgrWk37YEo=
Date: Wed, 20 Aug 2025 16:56:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-prevent-release-journal-inode-after-journal-shutdown.patch added to mm-hotfixes-unstable branch
Message-Id: <20250820235633.477CFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: prevent release journal inode after journal shutdown
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-prevent-release-journal-inode-after-journal-shutdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-prevent-release-journal-inode-after-journal-shutdown.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

ocfs2-prevent-release-journal-inode-after-journal-shutdown.patch

