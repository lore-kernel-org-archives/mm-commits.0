Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6FB2F30
	for <mm-commits@vger.kernel.org>; Tue, 24 Dec 2024 01:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735003601; cv=none; b=YMBSDnNfe5TCsnngsf9p7xXHeQwSZuDM9mZdAC9dW6u0yUr2KtcSM9O6zIS88hzy/0+G7FbKhVzVGliaVaW6AQ6Lf5PUpi99Qs1+2dvjrACMtQVBQmFYykNbeuezV5l7Lc/YNGBRP/BDUbRj30pdjgop1GD0nIxanai7NbUDdLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735003601; c=relaxed/simple;
	bh=xaujRNadKJn4CE+cMZyl+Ouhwn07ffq1mgurqmU/4AM=;
	h=Date:To:From:Subject:Message-Id; b=KUqu2Dz1RTMDYk0X3v7ts4dsZfe/TTrR+uEIC32JTGYpd/DqP9yB9XQoHmkVjsjTtPal6kWZ3ur5teJDuibSTcrtCPvb1NKegxu8/E58fKfOWUMIQoGu6sXBw6clmFF5A8DAigGNHEuaq+4+vlK/qw5ysM9EIyPrCrPr5FpkThM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t9zkeJ+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t9zkeJ+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB11C4CED3;
	Tue, 24 Dec 2024 01:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735003601;
	bh=xaujRNadKJn4CE+cMZyl+Ouhwn07ffq1mgurqmU/4AM=;
	h=Date:To:From:Subject:From;
	b=t9zkeJ+19nxBN7IhoMPDmgA8WgSzP3s955EYfF2iPPW7bkPWrgcOubFx1Eoz9Bsu+
	 Rv8NCyMEEnOe6QL3WIK+BEarvXa2Qm41ny16T/g3tj2MTD2HJ9epJitAflw4pDZ1UC
	 DSmuvQTNeGUoiPWOLYXooCveBYRVyU2RFPvrUvnQ=
Date: Mon, 23 Dec 2024 17:26:40 -0800
To: mm-commits@vger.kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-make-memdup_user_nul-similar-to-memdup_user.patch added to mm-hotfixes-unstable branch
Message-Id: <20241224012641.1FB11C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/util: make memdup_user_nul() similar to memdup_user()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-util-make-memdup_user_nul-similar-to-memdup_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-make-memdup_user_nul-similar-to-memdup_user.patch

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
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm/util: make memdup_user_nul() similar to memdup_user()
Date: Sat, 21 Dec 2024 16:47:29 +0900

Since the string data to copy from userspace is likely less than PAGE_SIZE
bytes, replace GFP_KERNEL with GFP_USER like commit 6c2c97a24f09
("memdup_user(): switch to GFP_USER") does and add __GFP_NOWARN like
commit 6c8fcc096be9 ("mm: don't let userspace spam allocations warnings")
does.  Also, use dedicated slab buckets like commit d73778e4b867
("mm/util: Use dedicated slab buckets for memdup_user()") does.

Link: https://lkml.kernel.org/r/014cd694-cc27-4a07-a34a-2ae95d744515@I-love.SAKURA.ne.jp
Reported-by: syzbot+7e12e97b36154c54414b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7e12e97b36154c54414b
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/util.c~mm-util-make-memdup_user_nul-similar-to-memdup_user
+++ a/mm/util.c
@@ -297,12 +297,7 @@ void *memdup_user_nul(const void __user
 {
 	char *p;
 
-	/*
-	 * Always use GFP_KERNEL, since copy_from_user() can sleep and
-	 * cause pagefault, which makes it pointless to use GFP_NOFS
-	 * or GFP_ATOMIC.
-	 */
-	p = kmalloc_track_caller(len + 1, GFP_KERNEL);
+	p = kmem_buckets_alloc_track_caller(user_buckets, len + 1, GFP_USER | __GFP_NOWARN);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-util-make-memdup_user_nul-similar-to-memdup_user.patch

