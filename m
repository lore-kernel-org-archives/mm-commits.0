Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E47B2F4A15
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 21:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765919265; cv=none; b=ohPeB+V9RurgYWUlcJnjM0DIPKIfQxo4azyn/VL+b6I1izB3gL16rW8NzOmw+emGG0HQgGeN8LV6NrJNaktvk//35FpCMiYF8/GfJQB8z6z4P0ufkfSdHRNh8GBaC3H4YqrDh49dirnpE4Oj8IIqkav5alohvUQ8s/myzf7MoXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765919265; c=relaxed/simple;
	bh=COCcUf51hY6QDU/817PPRb3ZLD74uCNJZOYd/8T3UZg=;
	h=Date:To:From:Subject:Message-Id; b=R2TOs27EG9Lhg8VwjBjD6UzEBobdjsh32PLUvFBP8XwTHJN0LvoYsseyPeU8SwahFJnVLGZrz65ISF4Vd2EmsIMjgIBilMU/h/yr1v5fedWMLx2icV2hMaXY7b5iphYYtMU50INFhu5qLDZna07GFq8ya36HGjMQDz8xczZC6vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aDrTC3EY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aDrTC3EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE66C4CEF1;
	Tue, 16 Dec 2025 21:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765919265;
	bh=COCcUf51hY6QDU/817PPRb3ZLD74uCNJZOYd/8T3UZg=;
	h=Date:To:From:Subject:From;
	b=aDrTC3EYPXvIhaD+dbbCvr9DqfyRrIjpqVMlWjCmLFYJ2tRoQOb9OoGt1DFKYmmPn
	 COqLuDZTb6U5nti1N6eaoKFuLUp6SdpZBjrexMtp2sYSflHQzAKaIzatPUVovIsv+9
	 vS06dU/zXOCP7m/0uXKoIq1qngYFxeL/annzQ7/c=
Date: Tue, 16 Dec 2025 13:07:44 -0800
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,lalitshankarch@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-remove-unused-parameter.patch added to mm-nonmm-unstable branch
Message-Id: <20251216210744.EAE66C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: remove unused parameter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-remove-unused-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-remove-unused-parameter.patch

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
From: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
Subject: fat: remove unused parameter
Date: Tue, 2 Dec 2025 03:14:04 +0530

Remove unused inode parameter from fat_cache_alloc().

Link: https://lkml.kernel.org/r/20251201214403.90604-2-lalitshankarch@gmail.com
Signed-off-by: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fat/cache.c~fat-remove-unused-parameter
+++ a/fs/fat/cache.c
@@ -54,7 +54,7 @@ void fat_cache_destroy(void)
 	kmem_cache_destroy(fat_cache_cachep);
 }
 
-static inline struct fat_cache *fat_cache_alloc(struct inode *inode)
+static inline struct fat_cache *fat_cache_alloc(void)
 {
 	return kmem_cache_alloc(fat_cache_cachep, GFP_NOFS);
 }
@@ -144,7 +144,7 @@ static void fat_cache_add(struct inode *
 			MSDOS_I(inode)->nr_caches++;
 			spin_unlock(&MSDOS_I(inode)->cache_lru_lock);
 
-			tmp = fat_cache_alloc(inode);
+			tmp = fat_cache_alloc();
 			if (!tmp) {
 				spin_lock(&MSDOS_I(inode)->cache_lru_lock);
 				MSDOS_I(inode)->nr_caches--;
_

Patches currently in -mm which might be from lalitshankarch@gmail.com are

fat-remove-unused-parameter.patch

