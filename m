Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346943BE17B
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896616; cv=none; b=Zr8mBie+4nMS37zDDo1GaJzszXXxIJbPRYLDB2LtFzSVOfYu47WX7wcruC84sf6kh7NAibUx7S4lnXKmwLsDfpHC+5Yxmg9UF6xeMXFyZsSH/B90B1UNPeBKBo3kOf649PJjgnV1lDvD513hkhyiJ/OQEcb5V8W33fuHCPF9zHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896616; c=relaxed/simple;
	bh=Vr+VvRk90Z6pOkX89wx399tVkL+r0yFbC5Nbj07W/Eg=;
	h=Date:To:From:Subject:Message-Id; b=NQZ3lgSPUW7DrRWMF+GKRouSRuytdSaJaiM1x0fBK93HIzz1eqr6kjIdMrVmmtIZCZHKFp6XGekQ8QeysrAgf+9qwEJXuMEwUU3qIU5wNOSXXe/fJsKMLkNhgaC4myxc8diTkSH39//u9BZ+80ba0MTi+sAtTZt6Q5u3vTGMMzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zs7lGUiI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zs7lGUiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F229E1F000E9;
	Wed,  5 Aug 2026 02:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896615;
	bh=cs+P+OlFN8jyY6rbG9U8S49pdqhm+oVw+XRAH6bzedM=;
	h=Date:To:From:Subject;
	b=Zs7lGUiIIZIH6MYFReofXS8aq9DDFr/lJcfoZYjCNNiWBB8L+rnN51O8tldmBVfOe
	 CSka74iRtipZlBGbszF36CQVqZfCkJ4siWucyLdrX37G8dSl7OGyN/TW/9jUyPkuYU
	 QALD2Os/TGII4B8sStfRDJb4++8xAVPSxA5RYyyE=
Date: Tue, 04 Aug 2026 19:23:34 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,elver@google.com,baolin.wang@linux.alibaba.com,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-annotate-benign-data-race-in-shmem_getattr.patch removed from -mm tree
Message-Id: <20260805022334.F229E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: annotate benign data-race in shmem_getattr()
has been removed from the -mm tree.  Its filename was
     mm-shmem-annotate-benign-data-race-in-shmem_getattr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: mm/shmem: annotate benign data-race in shmem_getattr()
Date: Wed, 8 Jul 2026 13:19:41 +0200

shmem_getattr() reads info->alloced, info->swapped and i_mapping->nrpages
without info->lock to decide whether shmem_recalc_inode() should be
called.  shmem_recalc_inode() recomputes these under info->lock, so a
stale read here only affects whether shmem_recalc_inode() runs.

Annotate data_race() to silence KCSAN.

Link: https://lore.kernel.org/20260708111941.35460-1-jaeyeon.lee.dev@gmail.com
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Reported-by: syzbot+dfb578404df369f6599b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dfb578404df369f6599b
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-annotate-benign-data-race-in-shmem_getattr
+++ a/mm/shmem.c
@@ -1297,7 +1297,8 @@ static int shmem_getattr(struct mnt_idma
 	struct inode *inode = path->dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
-	if (info->alloced - info->swapped != inode->i_mapping->nrpages)
+	/* Fast-path hint; recalc under info->lock corrects any stale read. */
+	if (data_race(info->alloced - info->swapped != inode->i_mapping->nrpages))
 		shmem_recalc_inode(inode, 0, 0);
 
 	if (info->fsflags & FS_APPEND_FL)
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are


