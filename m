Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BBD3770B
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 12:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776946720; cv=none; b=rJGl6mI5DqzA2F4L3IpnK10H73QykpZ4qr0hGBUEW4oeFggwbnqEgCoRKNp6lOGq73m/soiEWK3YwJ+8LuX9BL2ol59PuD0+h+iG+/KmE0InEF34J7OK9qa82eGUQ8l+uM/vinQm5zdW8zdtlGbyxWE2nvXTBGgorDYMvvtWqPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776946720; c=relaxed/simple;
	bh=23Csja55zpf0hraeripnVNeW5YY0gidAQFzVEodmyok=;
	h=Date:To:From:Subject:Message-Id; b=e1NoburYaXTk1xl0u67mdZx15tXNWNluglq3Vw1ql4FZMmaHebwah6cy4Y2H0RZdUaiy4KV2EEElY74s0aPDQf/nZEASNQGo0CCAmW6Gyox25QV28LFud13PXSeV1WL9SdryeB5vR4PayYGmaCXhe8FP1/cp7/Eg/KmSw9PZfts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t9p59O5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t9p59O5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1A4C2BCAF;
	Thu, 23 Apr 2026 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776946720;
	bh=23Csja55zpf0hraeripnVNeW5YY0gidAQFzVEodmyok=;
	h=Date:To:From:Subject:From;
	b=t9p59O5UI9+VpgOp90f8/bfFRGnkGUo8LWEMzL9xGyrt+WlpsIFVIDjxddHZde813
	 EOuvkBxKNa8Vn23T/fegEYmKpSnea/fgy0E2qVUpoENAov5+MwXPi64jWZ3PEmBIdb
	 +RXqFHRcuZmbrzGOvJCvxWwpbcD66MJPNepKjPqY=
Date: Thu, 23 Apr 2026 05:18:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,ljs@kernel.org,lance.yang@linux.dev,hughd@google.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-tmpfs-dont-enable-large-folios-if-not-supported.patch added to mm-new branch
Message-Id: <20260423121840.2C1A4C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "tmpfs: don't enable large folios if not supported"
has been added to the -mm mm-new branch.  Its filename is
     revert-tmpfs-dont-enable-large-folios-if-not-supported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-tmpfs-dont-enable-large-folios-if-not-supported.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Revert "tmpfs: don't enable large folios if not supported"
Date: Thu, 23 Apr 2026 09:41:42 +0800

This reverts commit 5a90c155defa684f3a21f68c3f8e40c056e6114c.

Currently, when shmem mounts are initialized, they only use 'sbinfo->huge'
to determine whether the shmem mount supports large folios.  However, for
anonymous shmem, whether it supports large folios can be dynamically
configured via sysfs interfaces, so setting or not setting
mapping_set_large_folios() during initialization cannot accurately reflect
whether anonymous shmem actually supports large folios, which has already
caused some confusion[1].

Moreover, for tmpfs mounts, relying on 'sbinfo->huge' cannot keep the
mapping_set_large_folios() setting consistent across all mappings in the
entire tmpfs mount.  In other words, under the same tmpfs mount, after
remount, we might end up with some mappings supporting large folios
(calling mapping_set_large_folios()) while others don't.

After some investigation, I found that the write performance regression
addressed by commit 5a90c155defa has already been fixed by the following
commit 665575cff098b ("filemap: move prefaulting out of hot write path"). 
See the following test data:

Base:
dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)

Base + revert 5a90c155defa:
dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)

The data is basically consistent with minor fluctuation noise. So we can now
safely revert commit 5a90c155defa to set mapping_set_large_folios() for all
shmem mounts unconditionally.

Link: https://lore.kernel.org/b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/ [1]
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/shmem.c~revert-tmpfs-dont-enable-large-folios-if-not-supported
+++ a/mm/shmem.c
@@ -3101,10 +3101,7 @@ static struct inode *__shmem_get_inode(s
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
-
-	/* Don't consider 'deny' for emergencies and 'force' for testing */
-	if (sbinfo->huge)
-		mapping_set_large_folios(inode->i_mapping);
+	mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
 	default:
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

revert-tmpfs-dont-enable-large-folios-if-not-supported.patch

