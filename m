Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BDA17BA1;
	Tue, 31 Dec 2024 02:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610405; cv=none; b=jIEOALvRJH69bfdQYpF4ny2CrMVd3iOpPL9OrxQIfhEa7TY8fur33FkDErkgtwuv5PaOQd9Uf6aER4LfZ1LePnr7PdOjjvWthdJalfyE+Av3ZozoTgJJcdM27HPX9xlc9ijLB8Qsk7QQLHUaqgFjqdILLUb4vfCE1TFM9UiE0sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610405; c=relaxed/simple;
	bh=xH+N1aZyHcKV7iNFXhMlTh6SYVSqPioToTfSNAcgJ50=;
	h=Date:To:From:Subject:Message-Id; b=fjAtwzlDCB6zlN/6mW/6FBIFuEw5wNeGWyNpeq9S85mFCgU6XbN2FggjMvYV6/wCdsk0K/GXAXD/jBVBVc9Gn6V+bzb4AUwkpb2Zgj6FaKkJihVojPV0djTkera7U6Evlm2AuYadWlJCGu63lthsy0Hbb01Vvbsezpb4rDHvBjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0TlYGrWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0TlYGrWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE6CC4CED0;
	Tue, 31 Dec 2024 02:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610405;
	bh=xH+N1aZyHcKV7iNFXhMlTh6SYVSqPioToTfSNAcgJ50=;
	h=Date:To:From:Subject:From;
	b=0TlYGrWNbchbAnSdk9HCGNhiaOS0NUluQKkG9FmyM4k9Sju/QHkITiaTj8oRR28BN
	 wLpXMzQQIXkmXME0uj+711ogBF8++FTX2crv+cGihAAyozxbkSTgF7HCaxVVJPISku
	 XzmIC4UE7/wG2QXGmedFhilGTkmjdoh6cjZ1POYE=
Date: Mon, 30 Dec 2024 18:00:04 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dennis.lamerice@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch removed from -mm tree
Message-Id: <20241231020004.EFE6CC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dennis Lam <dennis.lamerice@gmail.com>
Subject: ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
Date: Tue, 17 Dec 2024 21:39:25 -0500

When mounting ocfs2 and then remounting it as read-only, a
slab-use-after-free occurs after the user uses a syscall to
quota_getnextquota.  Specifically, sb_dqinfo(sb, type)->dqi_priv is the
dangling pointer.

During the remounting process, the pointer dqi_priv is freed but is never
set as null leaving it to be accessed.  Additionally, the read-only option
for remounting sets the DQUOT_SUSPENDED flag instead of setting the
DQUOT_USAGE_ENABLED flags.  Moreover, later in the process of getting the
next quota, the function ocfs2_get_next_id is called and only checks the
quota usage flags and not the quota suspended flags.

To fix this, I set dqi_priv to null when it is freed after remounting with
read-only and put a check for DQUOT_SUSPENDED in ocfs2_get_next_id.

[akpm@linux-foundation.org: coding-style cleanups]
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
+	if (!sb_has_quota_active(sb, type)) {
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


