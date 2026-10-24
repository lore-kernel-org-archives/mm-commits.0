Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792882427;
	b=vh+KgC3IQd4deFXC9fJdLbUopPA/y0509hhYOo+WkdDSys5YSpwgtMYftr8x2RhspcKF
	 m21vJ9FEI5bN5FoQXxurkXBYOeQOX2+eEqs+dJe179C5tofPHv0tm0rWGbOdV7W2BT0tp
	 5dbJIkksYuMj56YyD6GCN2SsdYhGdYt+pRHWi0NZM8/ZKOYYc3uSjzjezTxkboiA9U2wQ
	 l2ZIZH57iodDLJvaBaa9Z1yQICr9dAXgMzIy9r3l8GMGBPA94zHV83hQX2k41Ie0PCFCq
	 i4g8+iW/7hDqb1zn+BAQCTIILCVs61iNpbyFcuABVS1gxWgNqyLQfV5kfDh1Vxv8zbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792882427;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DrXX5UGlG/aw+C3BcqxBNkFws/GSGFJdLgC+zXKCLDQ=;
	b=sLIokGQlB1i7+Pj39II8eb/Wo/0DZusEdk6rclwnB3/MLA+3su3imt6DAMOZbS2XCjVY
	 2umD2VWoh4Rrv4C9EXhJdOlXJAQEQZzSXb+8TUlfekYxG94pMtdFSgU5BzfmAzPKaHCFV
	 iK2mb5XCAX+hakVC2t1JBqM0zsFrwuP9qykS+mbNfnKq+WIJ1L2enNCZptHzkBBjGA4fi
	 i0Dp5gml4BGmubthbM2yKd4Wnyr+nsh42nRQFwAVV3uRcqi6sZlAu3aAo4xsJf6tTq4tq
	 UK+DJVNqLajhZn7hWd/6tuoIKI/RkL6DaKgdYYbvUqXpmv2VAjBZ6xO605908fRtXuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jBsjwcUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C85606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 22:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jBsjwcUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE12A1F01825;
	Sat, 24 Oct 2026 22:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792882426;
	bh=DrXX5UGlG/aw+C3BcqxBNkFws/GSGFJdLgC+zXKCLDQ=;
	h=Date:To:From:Subject;
	b=jBsjwcUekf1PnkyFPAqEQWH5HsVnvE1qIorP2uDJ5SezyHrJlO+dQ8Y3JWK7vYCxn
	 rDjt/dWrc/v/W+ePG87JFQh4K+KsgD/Njzwm7YhC1/B6dXQ5KByJU3/tG8Twk/gbYX
	 y4AXz2Evb5EASid8tge3ehCs53HVqKeKajp/bYZw=
Date: Sat, 24 Oct 2026 15:53:46 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,hirofumi@mail.parknet.co.jp,
	matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-hold-truncate_lock-in-fat_write_failed.patch added to mm-nonmm-unstable branch
Message-Id: <20261024225346.BE12A1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fat: hold truncate_lock in fat_write_failed()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-hold-truncate_lock-in-fat_write_failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-hold-truncate_lock-in-fat_write_failed.patch

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
From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Subject: fat: hold truncate_lock in fat_write_failed()
Date: Wed, 21 Oct 2026 13:21:04 -0300

The current fat_write_failed() implementation calls into
fat_truncate_blocks() without holding truncate_lock.

fat_write_failed() can race with the users of fat_aops.bmap().  bmap()
eventually reaches fat_get_cluster(), which assumes the file's cluster
chain will not be truncated concurrently.  fat_write_failed() currently
truncates without holding truncate_lock.

For comparison, fat_setattr() correctly holds truncate_lock during
truncation:

down_write(&MSDOS_I(inode)->truncate_lock);
truncate_setsize(inode, attr->ia_size);
fat_truncate_blocks(inode, attr->ia_size);
up_write(&MSDOS_I(inode)->truncate_lock);

Make it so ->truncate_lock is held exclusive while truncating.

Link: https://lore.kernel.org/20261021162105.62525-1-matheus.aalmeida@inf.ufrgs.br
Fixes: 459f6ed3b8c7 ("fat: convert to use the new truncate convention.")
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Pedro Falcato <pfalcato@suse.de>
---

 fs/fat/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/fat/inode.c~fat-hold-truncate_lock-in-fat_write_failed
+++ a/fs/fat/inode.c
@@ -217,7 +217,9 @@ static void fat_write_failed(struct addr
 
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, inode->i_size);
+		down_write(&MSDOS_I(inode)->truncate_lock);
 		fat_truncate_blocks(inode, inode->i_size);
+		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 }
 
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are

fat-preallocate-space-before-expanding-in-fat_cont_expand.patch
fat-hold-truncate_lock-in-fat_write_failed.patch

