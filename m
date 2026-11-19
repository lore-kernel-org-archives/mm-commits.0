Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795111437;
	b=b+d3rprL6L0wQSL2pUqPeyyPmgvr77yTLZQWHndKVvbwJyaWluUA5gmDCZkIxxAoLzr2
	 6wUq/gmZZyWy5aXD8/M4Vu6oAlVi462aCBXaHVSuTXbdnCNzdFk4XkpLx+Wa/fYGyURFD
	 4kjTX+8p33tGM6Nx0SSUUYXdfQZFwQzUuGP7z1cjBXCvNifrueZJMcHKUOjLzpa9OizR2
	 HKj8yvMNGW2NLVD6v11BmWvc/GiZSluFSx8+fyQBeaJMtnsLmiv2Zszg9srQVxvJGD2TB
	 iaIB01rle7IO0JEyucU+GIFX8UAvp1prI/s0F5ziSrx+82PqwTUocyKqbwWLYqW4W6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795111437;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=BXYU7JR5cRWnvJBGhPx3SetX8VEPPkW4VPS6k1ZMa9w=;
	b=l3WKiinef58kWxrODgbXdaOnthTPboMjiI8jwz1gwJwXILih5VW0LUEtmJWiPOgLmX0o
	 VXJHN09mNt8tNW4btvpxho6HlTHJnRI9sxt4KTVC1lh/hxRH8dlrcyM4sPa/akuzPAtLf
	 gLextVGr4WYpSFsMb2trWp1CSGey9LOhHghowfStbPENAo/qyZ73FHI1hGzS2UvvzagRN
	 QFyn7o/QG697Epj6QkN2rhtf9u614yKfNccK5wl+npIygKcGsgC+PUrJen+fAwFQs39lk
	 xhcbBT4FDQhVHv89WEuKI9U9+LMW/hJ5sqrqsFDh5yvzd/B8M/d/JFgoK0sY3Qwo0Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XGu3qUjZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790CC606A325
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 18:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XGu3qUjZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074A61F000C6;
	Thu, 19 Nov 2026 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795111437;
	bh=BXYU7JR5cRWnvJBGhPx3SetX8VEPPkW4VPS6k1ZMa9w=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=XGu3qUjZD5VBskRucxHT++2CO7XdD4dAgK3J6nxuqqtv4Tu6Mtv/4MvgM2GvGcbMj
	 sPmP9CpeoechZRCRsehIsADLJNXRhR8/YHccoYkXBTc/4cvNTjK8H/Ie1MlzEHaoV8
	 r/2C5rf7irdAUbXXT0bDpJkzt1WJfHR4SXUyhzPg=
Date: Thu, 19 Nov 2026 10:03:56 -0800
To: mm-commits@vger.kernel.org,
	syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com,mszeredi@redhat.com,
	hughd@google.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261105082717.c459bb33778fcf27e5675082@linux-foundation.org>
References: <20261105082717.c459bb33778fcf27e5675082@linux-foundation.org>
Subject: [merged] shmem-consume-the-reserved-xattr-space-despite-remount.patch removed from -mm tree
Message-Id: <20261119180357.074A61F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: shmem: consume the reserved xattr space despite remount
has been removed from the -mm tree.  Its filename was
     shmem-consume-the-reserved-xattr-space-despite-remount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem: consume the reserved xattr space despite remount
Date: Thu, 05 Nov 2026 08:08:06 -0800

Creating a tmpfs inode can trigger WARN_ON(ispace) in shmem_initxattrs()
when a concurrent remount sets nr_inodes=0.  With panic_on_warn enabled,
this warning can panic the machine.

shmem_initxattrs() reserves space for the security xattrs while inode
limits are enabled.  It later tests max_inodes again before consuming that
reservation for each installed xattr.  If remount disables the limit
between those steps, successfully installed xattrs leave a nonzero
reservation behind.

Use the remaining reservation, rather than the current mount policy, to
decide whether to subtract the installed xattr's space.  This also leaves
the failure path with only the unconsumed reservation to refund.

An initially unlimited filesystem cannot acquire an inode limit through
remount: shmem_reconfigure() rejects that transition.

Link: https://patch.msgid.link/20261105082717.c459bb33778fcf27e5675082@linux-foundation.org
Fixes: 076e5cef28e2 ("simple_xattr: change interface to pass struct simple_xattrs")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=4324f771847cecb27c54
Tested-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
---
Reproduced the warning before the fix and verified its absence
afterward in a Debian 13 guest with SELinux enabled (permissive).

A temporary hook paused file creation after reserving security-xattr
space. Another process completed a real nr_inodes=0 remount before
creation resumed. The unpatched kernel left 94 bytes unconsumed and
triggered WARN_ON(ispace); the patched kernel consumed the reservation
completely. File contents and the security xattr were verified.

Ordinary creation on limited and unlimited tmpfs mounts also passed
on both kernels. No additional KASAN or lockdep reports occurred.

Tested Linux 7.4.0-rc1 with GCC 13.3, KASAN and lockdep, using KVM:
8 GiB RAM, four vCPUs and one virtual NUMA node, backed by a
Threadripper PRO 3995WX. Both kernels had the same diagnostic hook;
the ordering was forced rather than left to random stress.

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-consume-the-reserved-xattr-space-despite-remount
+++ a/mm/shmem.c
@@ -4491,7 +4491,7 @@ static int shmem_initxattrs(struct inode
 		if (simple_xattr_add(&sbinfo->xa_cache, &info->xattrs, new_xattr))
 			break;
 
-		if (sbinfo->max_inodes)
+		if (ispace)
 			ispace -= simple_xattr_space(new_xattr->name, new_xattr->size);
 		retain_and_null_ptr(new_xattr);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-page_exth-to-memory-management-page-allocator.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

