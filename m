Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6CC3BE645;
	Fri, 24 Apr 2026 11:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777030989; cv=none; b=IJO5vADu1NoHnYILxEJJCqXQCd0WlGoxG0D4CYhTkRno6exQVxvrAhZ1+akBDpEnGOK1Nn5dfrDSvMpfwB6pQzTkNpl3NMATihB4t3eI2JXrEC8t7Sh6xlZ9AWolK1Ew9j9ssXAjAHaYICsUi4AjsBMWLOM/srkauF56ZJtGbWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777030989; c=relaxed/simple;
	bh=LcR73gTJiiSLRSf1qU0i/mJyF0H/6GpJyGY1baW7ECg=;
	h=Date:To:From:Subject:Message-Id; b=ZHpLCo6spEWuZnd2v0sKoFGy4QKfF5fmhXHaHVemZV/tyJoU5TaeD4WLrDM5yZF/3l0LsvGh+80mwIFL3REigJnJhIWvHXGwDvc0AHfP+TgISXdNd06zXTlpPZN7dB/RBGIYhrfz6jdqIC2kwXcRHVNXDeQ8yq15grql7RDMgP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yYzwHNkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yYzwHNkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA1EC19425;
	Fri, 24 Apr 2026 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777030989;
	bh=LcR73gTJiiSLRSf1qU0i/mJyF0H/6GpJyGY1baW7ECg=;
	h=Date:To:From:Subject:From;
	b=yYzwHNkJrPd/AbrfVHN8cvA/mmwWDVP4N+YV0kV5dqbOAdlWBG+21prpb65EbH6LO
	 fd7ISd/w4gmmYHT17h/BdORtmE+QbJbOpItYrkkJVUVxFtrOU/R7Q0pmDpSShNc1fA
	 skmLrYrxkz7HD/K5Uda4rLBpKVH6EnyPv/AOnRio=
Date: Fri, 24 Apr 2026 04:43:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,tristan@talencesecurity.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-kzalloc-for-quota-recovery-bitmap-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20260424114309.2CA1EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use kzalloc for quota recovery bitmap allocation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-kzalloc-for-quota-recovery-bitmap-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-kzalloc-for-quota-recovery-bitmap-allocation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Tristan Madani <tristan@talencesecurity.com>
Subject: ocfs2: use kzalloc for quota recovery bitmap allocation
Date: Sat, 18 Apr 2026 13:10:48 +0000

ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does not
fully initialize it.  This can lead to use of uninitialized bits during
quota recovery from a corrupted filesystem image.

Use kzalloc instead to ensure the bitmap is zero-initialized.

Link: https://lore.kernel.org/20260418131048.1052507-1-tristmd@gmail.com
Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_local.c~ocfs2-use-kzalloc-for-quota-recovery-bitmap-allocation
+++ a/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(stru
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;
_

Patches currently in -mm which might be from tristan@talencesecurity.com are

ocfs2-use-kzalloc-for-quota-recovery-bitmap-allocation.patch

