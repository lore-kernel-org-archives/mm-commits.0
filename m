Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7C413CF9E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291553; cv=none; b=OleVyIoCtnkXYe+MNjFed1Pu+G620VAqyWgNJmYV8DD5N2CT9b3s6mfCqkD6FN3ncNWaTtwKWES1dbSYmYPYV4pmex1EtF9/BEd+5M+NCUgzI83M/35BYjBE4dcZQQ1UEgkLmc10vASPTCdqu3tFTT888dxlRWwflU0s0XVLbzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291553; c=relaxed/simple;
	bh=r/jxMQMyF9s05ROiQ33UtZzaCg0HOFHmaSnJwZ1/Ens=;
	h=Date:To:From:Subject:Message-Id; b=P4nQ5boilrNMrfAfqFMgDoVE8yguFksgXGBsoZKz8HIdccXBHZLC4Ezwng6H57BsTGmsgzVzF7t0HAfJvvb8HU97keKdqeqX9ZeVCHmgSO6GXjlpEWtktFc9Q1YLZtW7n2onKv6XrkYfXhKo49WzQOm/mR4TtaEu3KFLux25JqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gGOVOu3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gGOVOu3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A34CC4AF09;
	Tue, 25 Jun 2024 04:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291552;
	bh=r/jxMQMyF9s05ROiQ33UtZzaCg0HOFHmaSnJwZ1/Ens=;
	h=Date:To:From:Subject:From;
	b=gGOVOu3WG44FSix/alTzdUx5GSacXz9dbwLod3cSWizgAOWYGvAVmfWJq+AwoOp31
	 /hIkFYg48ZGs4KmY1HMu3gZOv3eq9k5qBVIfphUfnrZ7lqMgekwQZCuCi4fj3wQQGz
	 YD5d13BQKgRQ9w2ZCFE6qW6kg+t+wpd5QcAyyJxk=
Date: Mon, 24 Jun 2024 21:59:12 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] afs-drop-usage-of-folio_file_pos.patch removed from -mm tree
Message-Id: <20240625045912.9A34CC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: afs: drop usage of folio_file_pos
has been removed from the -mm tree.  Its filename was
     afs-drop-usage-of-folio_file_pos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: afs: drop usage of folio_file_pos
Date: Wed, 22 May 2024 01:58:47 +0800

folio_file_pos is only needed for mixed usage of page cache and swap
cache, for pure page cache usage, the caller can just use folio_pos
instead.

It can't be a swap cache page here.  Swap mapping may only call into fs
through swap_rw and that is not supported for afs.  So just drop it and
use folio_pos instead.

Link: https://lkml.kernel.org/r/20240521175854.96038-6-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/dir.c      |    6 +++---
 fs/afs/dir_edit.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/afs/dir.c~afs-drop-usage-of-folio_file_pos
+++ a/fs/afs/dir.c
@@ -533,14 +533,14 @@ static int afs_dir_iterate(struct inode
 			break;
 		}
 
-		offset = round_down(ctx->pos, sizeof(*dblock)) - folio_file_pos(folio);
+		offset = round_down(ctx->pos, sizeof(*dblock)) - folio_pos(folio);
 		size = min_t(loff_t, folio_size(folio),
-			     req->actual_len - folio_file_pos(folio));
+			     req->actual_len - folio_pos(folio));
 
 		do {
 			dblock = kmap_local_folio(folio, offset);
 			ret = afs_dir_iterate_block(dvnode, ctx, dblock,
-						    folio_file_pos(folio) + offset);
+						    folio_pos(folio) + offset);
 			kunmap_local(dblock);
 			if (ret != 1)
 				goto out;
--- a/fs/afs/dir_edit.c~afs-drop-usage-of-folio_file_pos
+++ a/fs/afs/dir_edit.c
@@ -256,7 +256,7 @@ void afs_edit_dir_add(struct afs_vnode *
 			folio = folio0;
 		}
 
-		block = kmap_local_folio(folio, b * AFS_DIR_BLOCK_SIZE - folio_file_pos(folio));
+		block = kmap_local_folio(folio, b * AFS_DIR_BLOCK_SIZE - folio_pos(folio));
 
 		/* Abandon the edit if we got a callback break. */
 		if (!test_bit(AFS_VNODE_DIR_VALID, &vnode->flags))
@@ -417,7 +417,7 @@ void afs_edit_dir_remove(struct afs_vnod
 			folio = folio0;
 		}
 
-		block = kmap_local_folio(folio, b * AFS_DIR_BLOCK_SIZE - folio_file_pos(folio));
+		block = kmap_local_folio(folio, b * AFS_DIR_BLOCK_SIZE - folio_pos(folio));
 
 		/* Abandon the edit if we got a callback break. */
 		if (!test_bit(AFS_VNODE_DIR_VALID, &vnode->flags))
_

Patches currently in -mm which might be from kasong@tencent.com are


