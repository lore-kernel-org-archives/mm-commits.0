Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDB01DA4E
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 02:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755571703; cv=none; b=IgzmQ3MdySRpWWOzHkZw2ky+8wy4bXYNiYoJeBsS7M+C8oyZi+v/ri+5Xtpoj3o3qcaIN+aUivpDsZ/lcCCsYXCVk3GgiH/MttK0yGtqCDDh+LXg7V0udAZ+o535/+KOEVAw65y8e6IMX7mgrICJb5ERpTeNOT8Wkt7cKax2x6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755571703; c=relaxed/simple;
	bh=ylBQ2ZnAVtpq0UZJtT0dUTxrY3eyzOrHL49SwpTgtKg=;
	h=Date:To:From:Subject:Message-Id; b=i295keWdooZ8tlCqC59+kFAx4R1Kn23xlnoPYiLJP5m3xYqNDJd8wIuxg3DxfzeMQBCjswaPfGIDft0XvL4o7gH9sohUwYq8pdKGA1QXsHNgLKCxAo4eHO2M9KQY6Yk/bDNDPm50MuJePOds3AiM6t28t1/HhS4WM/8oQsjTek4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XDZaZX+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XDZaZX+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAFFC116D0;
	Tue, 19 Aug 2025 02:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755571703;
	bh=ylBQ2ZnAVtpq0UZJtT0dUTxrY3eyzOrHL49SwpTgtKg=;
	h=Date:To:From:Subject:From;
	b=XDZaZX+OHePSLJ2LO6x5g5YkULI/A1XNySbsGQE7hALtS6F7bHI4ug4foYXjEUQBU
	 DAT3tY74Lj19TNxbPRjh1eZGCK6x/0LvGvYkF0mO9pkdSGF3Y1jU18ZrYC6Ppa0CRB
	 b0Ikt9ub8lO/eycsy52JZ44kPiqmMR3UMlRr1ieA=
Date: Mon, 18 Aug 2025 19:48:22 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,josef@toxicpanda.com,hannes@cmpxchg.org,dsterba@suse.com,clm@fb.com,boris@bur.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + btrfs-set-as_uncharged-on-the-btree_inode.patch added to mm-new branch
Message-Id: <20250819024823.3CAFFC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: btrfs: set AS_UNCHARGED on the btree_inode
has been added to the -mm mm-new branch.  Its filename is
     btrfs-set-as_uncharged-on-the-btree_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btrfs-set-as_uncharged-on-the-btree_inode.patch

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
Subject: btrfs: set AS_UNCHARGED on the btree_inode
Date: Mon, 18 Aug 2025 17:36:55 -0700

extent_buffers are global and shared so their pages should not belong to
any particular cgroup (currently whichever cgroups happens to allocate the
extent_buffer).

Btrfs tree operations should not arbitrarily block on cgroup reclaim or
have the shared extent_buffer pages on a cgroup's reclaim lists.

Link: https://lkml.kernel.org/r/cbeb05a98ceac523bce55a0eb12e6d6ad4c98d12.1755562487.git.boris@bur.io
Signed-off-by: Boris Burkov <boris@bur.io>
Acked-by: David Sterba <dsterba@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Cc: Chris Mason <clm@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/disk-io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/disk-io.c~btrfs-set-as_uncharged-on-the-btree_inode
+++ a/fs/btrfs/disk-io.c
@@ -1930,6 +1930,7 @@ static int btrfs_init_btree_inode(struct
 	BTRFS_I(inode)->root = btrfs_grab_root(fs_info->tree_root);
 	set_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags);
 	__insert_inode_hash(inode, hash);
+	set_bit(AS_UNCHARGED, &inode->i_mapping->flags);
 	fs_info->btree_inode = inode;
 
 	return 0;
_

Patches currently in -mm which might be from boris@bur.io are

mm-filemap-add-as_uncharged.patch
mm-add-vmstat-for-cgroup-uncharged-pages.patch
btrfs-set-as_uncharged-on-the-btree_inode.patch

