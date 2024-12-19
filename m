Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B7870809;
	Thu, 19 Dec 2024 02:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575256; cv=none; b=ZvqJ6kDULzzyK5FbDZ6XfnDos0AiwkTDv1R+Cbw57drXiC9r1CHgL7fimI0+UYp3iTz0FZGse8l0Lk/m/j78FQ1He7NlZVfxa5QksPwiZFMKViWGw4VREu7PyFmIZ4ceDqOH9x7NIpKYLj7DX8Mzh71KWk0LlZikwfpJy4fM2RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575256; c=relaxed/simple;
	bh=OB6AcvM7XAqC2Z3FFsNNoei0wuA772XqOc/I3kn/XV8=;
	h=Date:To:From:Subject:Message-Id; b=RWvmsBo6UlzIJyq4aEsrCl4Rn1126ATDQa01AlR09b/WBbsnYbZ0CMr+cDwLIWWzt6NvBodmMyWSWzHK6+uPoT5pCXBlTWJPcutoFKah4NaXl6czRsYT5Oo2v2oeSFY/mLKqvsc5gdW/TSOQBK+wFlnqLpTEtJKc6wqDA/BPYaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mzxeQvLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mzxeQvLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E4EC4CECD;
	Thu, 19 Dec 2024 02:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734575254;
	bh=OB6AcvM7XAqC2Z3FFsNNoei0wuA772XqOc/I3kn/XV8=;
	h=Date:To:From:Subject:From;
	b=mzxeQvLK4H7yv1xxvCGl1xGtAvpl3ODagbMFJl/YdHFBYlmHFzwMwOTgvQZ8e40nM
	 kLFX6J2z/znP5yl2FKooI5u1hwPo2bz7U+uJEsZsOCZH6Qdp8DQWKWULZL3HwWJBLY
	 NbbR67M0E+rz7dprYji783Dnu+JFpNaYNc/LI8qA=
Date: Wed, 18 Dec 2024 18:27:33 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dennis.lamerice@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch added to mm-nonmm-unstable branch
Message-Id: <20241219022734.33E4EC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch

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
From: Dennis Lam <dennis.lamerice@gmail.com>
Subject: ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
Date: Tue, 17 Dec 2024 21:39:25 -0500

When mounting ocfs2 and then remounting it as read-only, a
slab-use-after-free occurs after the user uses a syscall to
quota_getnextquota.  Specifically, sb_dqinfo(sb, type)->dqi_priv is the
dangling pointer.

During the remounting process, the pointer dqi_priv is freed but is never
set as null leaving it to to be accessed.  Additionally, the read-only
option for remounting sets the DQUOT_SUSPENDED flag instead of setting the
DQUOT_USAGE_ENABLED flags.  Moreover, later in the process of getting the
next quota, the function ocfs2_get_next_id is called and only checks the
quota usage flags and not the quota suspended flags.

To fix this, I set dqi_priv to null when it is freed after remounting with
read-only and put a check for DQUOT_SUSPENDED in ocfs2_get_next_id.

Link: https://lkml.kernel.org/r/20241218023924.22821-2-dennis.lamerice@gmail.com
Fixes: 8f9e8f5fcc05 ("ocfs2: Fix Q_GETNEXTQUOTA for filesystem without quotas")
Signed-off-by: Dennis Lam <dennis.lamerice@gmail.com>
Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Tested-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6731d26f.050a0220.1fb99c.014b.GAE@google.com/T/
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |    2 +-
 fs/ocfs2/quota_local.c  |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv
+++ a/fs/ocfs2/quota_global.c
@@ -893,7 +893,7 @@ static int ocfs2_get_next_id(struct supe
 	int status = 0;
 
 	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
-	if (!sb_has_quota_loaded(sb, type)) {
+	if (!sb_has_quota_active(sb, type)){
 		status = -ESRCH;
 		goto out;
 	}
--- a/fs/ocfs2/quota_local.c~ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv
+++ a/fs/ocfs2/quota_local.c
@@ -867,6 +867,7 @@ out:
 	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
+	info->dqi_priv = NULL;
 	return status;
 }
 
_

Patches currently in -mm which might be from dennis.lamerice@gmail.com are

ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch

