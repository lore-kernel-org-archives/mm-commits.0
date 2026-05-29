Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A643624C2
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027561; cv=none; b=pBOKd3KgeC49d3FB2/NVJNAmdBywYaeyc6/PqOTw83LwZYSPKoQPMMw1vdxFgMIdEAFfYjKUFWYQUXhSFSsRQrH+KtTay9H7Jsy9Z1XNTQqF5n1bfqlrgCxCn+z8gRkecAhkGnqYT6px5JErnoVFUOVsakCzF1B3O9aPGU2BTfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027561; c=relaxed/simple;
	bh=1fsQfHXMOEiw1MiUn3d72Gj1baUggFzAUkxS9U/aWns=;
	h=Date:To:From:Subject:Message-Id; b=MONKV3evIcEYzqMHPumCmoabM83Uk2Sv1uq2w/DLaGcfW5VSBSXWaf/UqtZrZV0ulcQ4L9dwsvCo6MzT3flihjhXeqOaEPfir5rINQsvJg2J38NY5tJtxuVIKW2dZjANMc/hjVA0VR0ur9ct1/66615SsUzXsBFI5HpVI192sEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x9wz8Td/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x9wz8Td/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756611F0089B;
	Fri, 29 May 2026 04:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027559;
	bh=rS8sck0Onw+4GuBtiBQMTUsAgMZFP46s+cLABnxOstQ=;
	h=Date:To:From:Subject;
	b=x9wz8Td/7CmalDdpqKgYRi6xFGCnuB+kRVwZdIogHfcYzQFY/52zXVEgSilMPNmQ6
	 ts46nXRqNLi2FfdKCn0Qv9P9qaTBIDVp0d92n+NtkvPkF/0isTfUau5jkNeseagD0i
	 ntRdVNud3WSASmNKyYfuRuNRq3X1yuSiUukUfgXw=
Date: Thu, 28 May 2026 21:05:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,ljs@kernel.org,lance.yang@linux.dev,hughd@google.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-tmpfs-dont-enable-large-folios-if-not-supported.patch removed from -mm tree
Message-Id: <20260529040559.756611F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "tmpfs: don't enable large folios if not supported"
has been removed from the -mm tree.  Its filename was
     revert-tmpfs-dont-enable-large-folios-if-not-supported.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Link: https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/
Fixes: 5a90c155defa ("tmpfs: don't enable large folios if not supported")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
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

mm-khugepaged-run-khugepaged-for-all-orders.patch

