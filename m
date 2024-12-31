Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D5C1EEE6
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 02:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610419; cv=none; b=iXVUQpI8eCeamx18HpcqMwewTVD39Q2tQmKSBCaBj7Q/Ol4en3fCiSjiutxLzn+YIw5wTw0lGi4cZDPYip4ZEjQUw6xQzEnDQOrkx+bN9dwRkEv9apwsZL83i2WanKr97mI3o+TewHgnT2GfOq+EXvlYgaRHy8DdaM/iDfdDBGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610419; c=relaxed/simple;
	bh=FMwQuXNO4ZI4eIVVB13vdVOW8okmK1UVTZ2p0Y6PHcc=;
	h=Date:To:From:Subject:Message-Id; b=dYrcMbzzCZVXyjRFPkXWLwmtmuoPU/sFCxZgwyvNEf2d3FAZszQreMMecbOe7TI/DunRpmb5OK6Umg9j+ln3JfHGeN4h9lZTXTDRPc+/FFOzQIG5awT63eEGXWoSpKfHxZisy9EUBl1RpTEIOOtfD6nsMUur5ToLjT143fLBSrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZXBMgdOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZXBMgdOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF6DC4CED0;
	Tue, 31 Dec 2024 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610419;
	bh=FMwQuXNO4ZI4eIVVB13vdVOW8okmK1UVTZ2p0Y6PHcc=;
	h=Date:To:From:Subject:From;
	b=ZXBMgdOoNERKbwBhxoQJXN2TcJxMjypeRJYIO24ZhvNFzDbcqBv3pZhWnCFn7aXeo
	 Mah15g8tt8ch05ZJHA7EW0olay3Bw1+kpdbgJFCxqAtwZQjHYaUS7YxvtRHFTIt4OR
	 tFe6BrwJzJ9NwaSWRKn/d5pCpNUUym6LxRMxG+d4=
Date: Mon, 30 Dec 2024 18:00:19 -0800
To: mm-commits@vger.kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-util-make-memdup_user_nul-similar-to-memdup_user.patch removed from -mm tree
Message-Id: <20241231020019.AFF6DC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/util: make memdup_user_nul() similar to memdup_user()
has been removed from the -mm tree.  Its filename was
     mm-util-make-memdup_user_nul-similar-to-memdup_user.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


