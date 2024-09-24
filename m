Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48A42A8F
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 22:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727215641; cv=none; b=VBq5HwIOrA/oxVNq8ZlICI1F2HtbWEjMzzsMhFIcloUtu25El726wFLmxcU2YnQzJNYPiMu1CTbsfrdr3qrGpdq250m+BNnwv7ZB9W3uX3HOl4yRYLl6HEYJWM3O9cH4uQYgYfvChJLr9yxi8mXujJI9tmTbdl5mbIP4blfz2Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727215641; c=relaxed/simple;
	bh=yNhOFsizQUtKB1vpWJ44er4bSkOwXWie7jkrsjrkfl0=;
	h=Date:To:From:Subject:Message-Id; b=qdBtnuqEBPPnR8Od5EC+Fxk6/0o3plZgmJV0NsbMKDdnaggBlNMl6cvuEcc5Ar1+1jI9+/YrOvEO1j7GGR7hJXY6CfyMbvr+CLP8dCV4MjZBcrSDbOUvA6KQKQssSMizv0t2huOUM0BoZf7jfQuvO0EQNPz9GhTZURf2kw4hiPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3MApt3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3MApt3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D1C4CEC4;
	Tue, 24 Sep 2024 22:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727215641;
	bh=yNhOFsizQUtKB1vpWJ44er4bSkOwXWie7jkrsjrkfl0=;
	h=Date:To:From:Subject:From;
	b=C3MApt3f/qvd38Ur+Ya2QhO9uE3E0zlzjCC7uOuzjGeHgFDra0RDvvZno5q2frNxN
	 aW9NbTek7wjdJ32eApZ9skmnMaqrfL9Dgp/9xvXpj/LXXSpmVQZYAmMbdDHd3+U/qJ
	 JMOFIP4bjSPxrjcgmdvdr6cWFg/1qZWiq0BOI5KM=
Date: Tue, 24 Sep 2024 15:07:20 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,ghe@suse.com,gechangwei@live.cn,zhangzekun11@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-unused-declartion-in-header-file.patch added to mm-nonmm-unstable branch
Message-Id: <20240924220721.573D1C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove unused declartion in header file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-unused-declartion-in-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-unused-declartion-in-header-file.patch

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
From: Zhang Zekun <zhangzekun11@huawei.com>
Subject: ocfs2: remove unused declartion in header file
Date: Fri, 6 Sep 2024 13:57:42 +0800

The definition of ocfs2_global_read_dquot() has been removed since commit
fb8dd8d78014 ("ocfs2: Fix quota locking").  Let's remove the empty
declartion

Link: https://lkml.kernel.org/r/20240906055742.105024-1-zhangzekun11@huawei.com
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/quota.h~ocfs2-remove-unused-declartion-in-header-file
+++ a/fs/ocfs2/quota.h
@@ -97,7 +97,6 @@ ssize_t ocfs2_quota_write(struct super_b
 			  const char *data, size_t len, loff_t off);
 int ocfs2_global_read_info(struct super_block *sb, int type);
 int ocfs2_global_write_info(struct super_block *sb, int type);
-int ocfs2_global_read_dquot(struct dquot *dquot);
 int __ocfs2_sync_dquot(struct dquot *dquot, int freeing);
 static inline int ocfs2_sync_dquot(struct dquot *dquot)
 {
_

Patches currently in -mm which might be from zhangzekun11@huawei.com are

ocfs2-remove-unused-declartion-in-header-file.patch

