Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712861F4191
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333582; cv=none; b=Ipd2dg8qS9UckMvIlxyiHfk8reftU70NOedsN0SLcPNyKceEvPI2urE45Inexe95MXESrbZ6vRuA7ncrm1jQPhMhSxVf88ZPMyx5REII7mOj5nKJJQRn1R0IJW1BBzz+UmdT0j/YQci3V8TdOPumFtRFpcNru8j5J8dmC3QuoQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333582; c=relaxed/simple;
	bh=oZutyS9HAL9NraZjg3zNgvKVk3h6F2839HsNsFQV+AI=;
	h=Date:To:From:Subject:Message-Id; b=UuZks2+Mlrd3NFzuA3sHR5hP70L10AqA/KvUharhesKQLg7FWe9iJ8ug+oFrrCHW8AjTf9P0yK1NkQ0x2OLKB0Ym98HTdiCdzmUoWGOhG19rzzHtqjjWKoQpmpPhthZiSyXaedh6FueLPVQ9OzJ2ld8tkEVFGwy1290pRt85518=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tzovyz5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tzovyz5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C42C4CEF4;
	Wed, 27 Aug 2025 22:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756333582;
	bh=oZutyS9HAL9NraZjg3zNgvKVk3h6F2839HsNsFQV+AI=;
	h=Date:To:From:Subject:From;
	b=Tzovyz5pzjBiSi2VrmfkSe+NjkFy38NWYjdjuLPHfgxxQp5YAUwmL07r8wAralmJE
	 IEA4fj0fz75IWog6aW0JgxQi9u2W7WXPYB3Xhs+pO2HaE1GamodjM/2G/q7p7wcNhN
	 3ot3sXXO8XtuNfhTGGl+7ZKmIlxN2x5HX+7PTVMw=
Date: Wed, 27 Aug 2025 15:26:21 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,boris@bur.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + btrfs-set-as_kernel_file-on-the-btree_inode.patch added to mm-new branch
Message-Id: <20250827222622.07C42C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: btrfs: set AS_KERNEL_FILE on the btree_inode
has been added to the -mm mm-new branch.  Its filename is
     btrfs-set-as_kernel_file-on-the-btree_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btrfs-set-as_kernel_file-on-the-btree_inode.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Boris Burkov <boris@bur.io>
Subject: btrfs: set AS_KERNEL_FILE on the btree_inode
Date: Thu, 21 Aug 2025 14:55:37 -0700

extent_buffers are global and shared so their pages should not belong to
any particular cgroup (currently whichever cgroups happens to allocate the
extent_buffer).

Btrfs tree operations should not arbitrarily block on cgroup reclaim or
have the shared extent_buffer pages on a cgroup's reclaim lists.

Link: https://lkml.kernel.org/r/2ee99832619a3fdfe80bf4dc9760278662d2d746.1755812945.git.boris@bur.io
Signed-off-by: Boris Burkov <boris@bur.io>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/disk-io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/disk-io.c~btrfs-set-as_kernel_file-on-the-btree_inode
+++ a/fs/btrfs/disk-io.c
@@ -1930,6 +1930,7 @@ static int btrfs_init_btree_inode(struct
 	BTRFS_I(inode)->root = btrfs_grab_root(fs_info->tree_root);
 	set_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags);
 	__insert_inode_hash(inode, hash);
+	set_bit(AS_KERNEL_FILE, &inode->i_mapping->flags);
 	fs_info->btree_inode = inode;
 
 	return 0;
_

Patches currently in -mm which might be from boris@bur.io are

mm-filemap-add-as_kernel_file.patch
mm-filemap-add-as_kernel_file-fix.patch
mm-add-vmstat-for-kernel_file-pages.patch
btrfs-set-as_kernel_file-on-the-btree_inode.patch

