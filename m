Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793999758;
	b=HVLgDdrylVax5gEU7MyB9h0QAptix3wvdkn0mArB0a79x0K3p2lleZ4LGFozzpiHxFu5
	 ttgqE7aOpTlZCFNitJaK4KveTJIPvz9+LfuqCP641ZjbdfHest2wOhrO7oivGVjrGbJzD
	 DshnRRDnm4Tjx2wtJWlUfkTq4b0NPaPLw8aPQbOXfdq8PO8jO1W4VRMkOxEYBZT//MhPm
	 2g8RejXi1Pp5luxdkgePbmPdJDgwl64jOCSxj0l6S4PydlK1cXggrDQXyNLvk7KTm9q9o
	 FonHkG4OV6C8mMzQLObWJWQembCvl0Wc4rI23e1RwbTVDNEBMTvD/UOr86sU/2bW1tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793999758;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=OvLAo/H5kT6MahZiDkx5vk1iX5DjECO8Qk2LI/uJU+Y=;
	b=LsJ8xcqyVfryO1+i2xK/IHo3BpRm6TGLce1h7ggHCpaLIiUz6ZZtTZhwqTnsIxAWFl3W
	 WoEdRA5xsc/2rGX19Mvp9LKK+Y3gJxt8i1pmpBJEhQ1YxhnY15BCSQ2e50y7y5N7GFU4+
	 ffUHZHoBoSbFgAp8aa027xrvd+YPtalCAPA2rQLiigtb+L1TVCbCWdoHEaHZFIB7abTkq
	 ONOpyypFPctTjirOgEmpEhAGVqzTuOgwoRhH/quQiNxgkPUo+SVrxI1bdhXjOslGqy/qL
	 rjzM2dHA9/+s1sJDdh8IoopjaQSkvwBLcfrlck1srs7T5F2lDG0FC6C+octdlYTeM1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oEcdu+aF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD9B606A326;
	Fri,  6 Nov 2026 21:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oEcdu+aF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6CC1F008BE;
	Fri,  6 Nov 2026 21:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793999758;
	bh=OvLAo/H5kT6MahZiDkx5vk1iX5DjECO8Qk2LI/uJU+Y=;
	h=Date:To:From:Subject;
	b=oEcdu+aFkO6Pbwda6MHoTFtNFRl9XxHC5qUv5n4W1pSPsd6OlGzHwRGlBFEAyRSPO
	 8Q/lEoPqGPhtY4sEdseAPt68M/vnj3dKsmqyucpT6TS0A5rYFjEInaPCr+c1C0kvN0
	 sgtCrzV2jzdf5ljqCOikTaBoPXoolfNxD2ig7qXI=
Date: Fri, 06 Nov 2026 13:15:57 -0800
To: mm-commits@vger.kernel.org,
	syzbot+65b1e2d8f2d618a93e96@syzkaller.appspotmail.com,stable@vger.kernel.org,
	ngocthang2710.1999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails.patch added to mm-nonmm-unstable branch
Message-Id: <20261106211557.EB6CC1F008BE@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: squashfs: fix leaked page locks when page actor allocation fails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails.patch

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
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Subject: squashfs: fix leaked page locks when page actor allocation fails
Date: Sun, 27 Sep 2026 12:40:12 +0700

squashfs_readpage_block() grabs and locks the sibling pages of the target
block before it allocates the page actor.  If that allocation fails it
jumps to "out", which only frees the page array, so the locked pages are
never unlocked or released.

A later truncate_inode_pages_range() on the inode, e.g.  from evict() at
umount, then waits forever on the leaked folio lock and the task hangs.

Go through mark_errored instead, which unlocks and puts every page
except the target, which the caller handles.

Link: https://lore.kernel.org/20260927060541.45780-1-ngocthang2710.1999@gmail.com
Fixes: f268eedddf35 ("squashfs: extend "page actor" to handle missing pages")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+65b1e2d8f2d618a93e96@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=65b1e2d8f2d618a93e96
Reviewed-by: Phillip Lougher <squashfs.org.uk>
Cc: <stable@vger.kernel.org>
---

 fs/squashfs/file_direct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/file_direct.c~squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails
+++ a/fs/squashfs/file_direct.c
@@ -70,7 +70,7 @@ int squashfs_readpage_block(struct folio
 	actor = squashfs_page_actor_init_special(msblk, page, pages, expected,
 						start_index << PAGE_SHIFT);
 	if (actor == NULL)
-		goto out;
+		goto mark_errored;
 
 	/* Decompress directly into the page cache buffers */
 	res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
_

Patches currently in -mm which might be from ngocthang2710.1999@gmail.com are

squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails.patch

