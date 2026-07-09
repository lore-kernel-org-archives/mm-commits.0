Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D50529993D
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 01:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783562039; cv=none; b=d2WCKyoWGu9u9l9pQggwqoYGm1KotKhBO+l9BZ5e+aWZXHupCQNYfrELvhsqgEElkoMWICC9WgNBe72WtGRwmfZCDADGCOsTI0raGofmOMDCKLmB2sJFOnSLo/qlC5hNEDrjkVAUEdvUR3Sx4GWaSV1SVAIoW/srEf54kgW+A/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783562039; c=relaxed/simple;
	bh=vtlHdqvkQV1vz+WzBhe0F5BHrZHuqFUBC70Aq9J/eqY=;
	h=Date:To:From:Subject:Message-Id; b=gssODViWUtTzXw8WU8SJsJsnkUk/m6RelVz4LxnFRpy6jYNpxBmenglxP56atmLQzpwbP4JhO2XI1qmXBP3FfvypkWWqBHW72JpFnePIhO9XNMMhazmNUl8/OUCHe9OnmuTxaD96tJpsYphjENhcKx2/evRg+ROnJWZNCawJLJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EJeKBl5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EJeKBl5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DC21F00A3D;
	Thu,  9 Jul 2026 01:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783562038;
	bh=R287CttAnxPnFaA1Oxoh8UWnCsCpiErjcEBBKdfAu/g=;
	h=Date:To:From:Subject;
	b=EJeKBl5MD1lZLTpBT3ASRgugr9RzZ8JsmRKXX97vM1YgGcLxOYTmnGJprSTR6zWdr
	 RBdRKBRBNZjGWErWuOJP8t0N1Fe6HqKsl/Y/sVOG52h7B+2hyZ7U0P60Eg4MNT82kd
	 ss+Kqs2pvyKg2C3fbV3HNCBuqneLDem524EkGj/U=
Date: Wed, 08 Jul 2026 18:53:57 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,elver@google.com,baolin.wang@linux.alibaba.com,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-annotate-benign-data-race-in-shmem_getattr.patch added to mm-new branch
Message-Id: <20260709015358.19DC21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: annotate benign data-race in shmem_getattr()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-annotate-benign-data-race-in-shmem_getattr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-annotate-benign-data-race-in-shmem_getattr.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -1287,7 +1287,8 @@ static int shmem_getattr(struct mnt_idma
 	struct inode *inode = path->dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
-	if (info->alloced - info->swapped != inode->i_mapping->nrpages)
+	/* Fast-path hint; recalc under info->lock corrects any stale read. */
+	if (data_race(info->alloced - info->swapped != inode->i_mapping->nrpages))
 		shmem_recalc_inode(inode, 0, 0);
 
 	if (info->fsflags & FS_APPEND_FL)
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

mm-shmem-annotate-benign-data-race-in-shmem_getattr.patch

