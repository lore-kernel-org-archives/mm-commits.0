Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BB71BF24
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 03:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734320114; cv=none; b=HvPcGzoK5SCGdKVw/IGRLAc/BiwNDwS1/ZZBjBPP31qEM0v5hBUW/76ejr+yLAqw28vB0TvwgTf/kR+A57oPXX3kmQUY6Kc5Nu4CJpKLhEeDByaZUhYpuB/sPkJqpgs74c8FQzwp/rWBrkTHH9emQCWKy/2fpiy/fx+R5MxWOLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734320114; c=relaxed/simple;
	bh=0ZMOg8zSvoTftxBqoTXNGBFEqKGl0zz7onp/lkrlnDM=;
	h=Date:To:From:Subject:Message-Id; b=jF0k8YvSQJzIR7yWxglbgzVa7OL0Ehag1iiMTgwLczAz0O0Lb5gnZg6ommpTHkuCoIgBewmMLlymenpCDYf1EkSxBgQYVgI1u5JAlzFL+6aiVaRqaFy1vWrrAGEKkq3RFxiEWDB4E4L9csIkfJ+zrJpBC+vf5b6fk8MrdOqLjK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s+i6JmNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s+i6JmNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBA0C4CED0;
	Mon, 16 Dec 2024 03:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734320114;
	bh=0ZMOg8zSvoTftxBqoTXNGBFEqKGl0zz7onp/lkrlnDM=;
	h=Date:To:From:Subject:From;
	b=s+i6JmNo7z9rD+WIWAozSzaze2Mf4uVyru20AuJZ+nm4gMFrCb3RK1hEggceIBSv+
	 GKpAelUxA4hRNuiRbdygErrei52HB/m7jzb5iRA8nfz4qVf4TQNoCAuDdArP3bT9e1
	 7AH16AmltxIGLjVMkVq2trLI0SDhP7RqwXmN3WVI=
Date: Sun, 15 Dec 2024 19:35:13 -0800
To: mm-commits@vger.kernel.org,wangfangpeng1@huawei.com,phillip@squashfs.org.uk,pangliyuan1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-dont-allocate-fragment-caches-more-than-fragments.patch added to mm-nonmm-unstable branch
Message-Id: <20241216033514.0CBA0C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: Dont allocate fragment caches more than fragments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-dont-allocate-fragment-caches-more-than-fragments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-dont-allocate-fragment-caches-more-than-fragments.patch

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
From: pangliyuan <pangliyuan1@huawei.com>
Subject: Squashfs: Dont allocate fragment caches more than fragments
Date: Tue, 10 Dec 2024 17:08:42 +0800

Sometimes the actual number of fragments in image is between
0 and SQUASHFS_CACHED_FRAGMENTS, which cause additional
fragment caches to be allocated.

Sets the number of fragment caches to the minimum of fragments
and SQUASHFS_CACHED_FRAGMENTS.

Link: https://lkml.kernel.org/r/20241210090842.160853-1-pangliyuan1@huawei.com
Signed-off-by: pangliyuan <pangliyuan1@huawei.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <wangfangpeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/super.c~squashfs-dont-allocate-fragment-caches-more-than-fragments
+++ a/fs/squashfs/super.c
@@ -405,7 +405,7 @@ handle_fragments:
 		goto check_directory_table;
 
 	msblk->fragment_cache = squashfs_cache_init("fragment",
-		SQUASHFS_CACHED_FRAGMENTS, msblk->block_size);
+		min(SQUASHFS_CACHED_FRAGMENTS, fragments), msblk->block_size);
 	if (msblk->fragment_cache == NULL) {
 		err = -ENOMEM;
 		goto failed_mount;
_

Patches currently in -mm which might be from pangliyuan1@huawei.com are

squashfs-dont-allocate-fragment-caches-more-than-fragments.patch

