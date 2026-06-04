Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55A43BBFA6
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609816; cv=none; b=E4sS0qZxw8t5SZCz+E/DoBfVAy7Uwv5V8UwXok5AkGWo9ZGXa02BL+zlgK2vsjracqPE1q6HBS/M0tnvlX/YorGze2Dbv/+FiBUuoqk/VCnV5ONDEB+JLHCOE7E7lef7UECaQkpkPtgbjM0RfZJ3eDMeTA2VLEbwZWSqnQsrj2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609816; c=relaxed/simple;
	bh=fvOn4YmocvWLCcrjTJKKJ2Ha4Wbu7//4A6v+u9gycLE=;
	h=Date:To:From:Subject:Message-Id; b=Vv+lPEvzHKggjVjnzfVMjDxB2vpmusFnVlVd0TNFuysUMGfwu3bVls91UAzJ2ln0XQH0SKkrE7fVyqB8uHjXy9dcWznWR+TBcQaVU1ghi24Gq+t3U3vsFhwAj/ujLthiXPEO69/L3uQi83p7dPTzPG30x6eyEaE56mI/Iy2fKnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z7tWFwjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z7tWFwjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991DE1F00893;
	Thu,  4 Jun 2026 21:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609815;
	bh=0pzhzL1rMz+jyFVgLdWctmkz2C9bLbsAO1qCFOPBZ7M=;
	h=Date:To:From:Subject;
	b=z7tWFwjCtwRrXQfMEs6o+g4x0xdfg9uwGJVZvHjqzs7nJmytIQvvFYfYy43I68K6s
	 gBwSwlyFqbTcE5Nb+YUKY043NH1MbIJu/sLcLAqrwklZeEbCrJMKkdDXQw6x+cv2J9
	 nU4xQGLyo1emiWktmzil+z04MNOFzFIEs9yn93gA=
Date: Thu, 04 Jun 2026 14:50:15 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ginger.jzllee@gmail.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-race-between-ocfs2_control_install_private-and-ocfs2_control_release.patch removed from -mm tree
Message-Id: <20260604215015.991DE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix race between ocfs2_control_install_private() and ocfs2_control_release()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-race-between-ocfs2_control_install_private-and-ocfs2_control_release.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix race between ocfs2_control_install_private() and ocfs2_control_release()
Date: Mon, 1 Jun 2026 20:16:18 +0800

Move atomic_inc(&ocfs2_control_opened) and the handshake state update
inside ocfs2_control_lock to close a race window where
ocfs2_control_release() can observe ocfs2_control_opened dropping to zero
(resetting ocfs2_control_this_node and running_proto) while
ocfs2_control_install_private() is about to bump the counter and mark the
connection valid.

Link: https://lore.kernel.org/20260601121618.1263346-1-joseph.qi@linux.alibaba.com
Fixes: 3cfd4ab6b6b4 ("ocfs2: Add the local node id to the handshake.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Ginger <ginger.jzllee@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/stack_user.c~ocfs2-fix-race-between-ocfs2_control_install_private-and-ocfs2_control_release
+++ a/fs/ocfs2/stack_user.c
@@ -327,18 +327,14 @@ static int ocfs2_control_install_private
 		ocfs2_control_this_node = p->op_this_node;
 		running_proto.pv_major = p->op_proto.pv_major;
 		running_proto.pv_minor = p->op_proto.pv_minor;
-	}
-
-out_unlock:
-	mutex_unlock(&ocfs2_control_lock);
-
-	if (!rc && set_p) {
-		/* We set the global values successfully */
 		atomic_inc(&ocfs2_control_opened);
 		ocfs2_control_set_handshake_state(file,
 					OCFS2_CONTROL_HANDSHAKE_VALID);
 	}
 
+out_unlock:
+	mutex_unlock(&ocfs2_control_lock);
+
 	return rc;
 }
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


