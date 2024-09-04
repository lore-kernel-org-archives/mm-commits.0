Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FB51E5022
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 19:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725477304; cv=none; b=drqb7pQBI8CsAOA3/f2TmnySsl+jfPUy9bzziEtJO9xdSjSPeBuoRHjRpsNNPXO8Lt3zDmPtUzHCLP6VDnmWAfYXQZTE7vIxRknbZSXJZHv7omctbcmhzpdglrlTNb82zASAQ1DBJwzMdWCAtrmEIGny18P2WpFSaEsdKKNLXVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725477304; c=relaxed/simple;
	bh=jEFHqarDCvyImLy2x91lEdOme11Xkr7q9c8Xk5XAqL8=;
	h=Date:To:From:Subject:Message-Id; b=LwDzZXbxJalBPu5BeX1WR9vJNbLhI3HqQ7NrToCgkVPaDlLYuKmJSYn6N4wiulQUgKl86c8r/4tosgzFQPISZshNBesODKMw+Esp5kJw0UAfedySXOssHRUp/DiKpT+DfzHwP+7L7jnUPOwm/4+i5MPiRBOE5Cihbk89FxvUBB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0CXi+2Hw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0CXi+2Hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89E2C4CEC5;
	Wed,  4 Sep 2024 19:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725477303;
	bh=jEFHqarDCvyImLy2x91lEdOme11Xkr7q9c8Xk5XAqL8=;
	h=Date:To:From:Subject:From;
	b=0CXi+2HwfPr/b4ND/wYQNNp5zmoQ/RiyLlHvFjHj0cR0Zy3gSZyXFWlSUsJKuthkj
	 JLuIbLQrPOFhd8uK0oYW0NWop1xQC8NOR2MmcujFXMlSQ4u95j1NjyqXVxZrXaJKcH
	 RIV8B1yippF8xif2oG2rWMwcFNHWZ5lxoKh7k8Bs=
Date: Wed, 04 Sep 2024 12:15:03 -0700
To: mm-commits@vger.kernel.org,lizhi.xu@windriver.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-potential-null-ptr-deref-in-nilfs_btree_insert.patch added to mm-nonmm-unstable branch
Message-Id: <20240904191503.B89E2C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-potential-null-ptr-deref-in-nilfs_btree_insert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-potential-null-ptr-deref-in-nilfs_btree_insert.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
Date: Wed, 4 Sep 2024 17:13:07 +0900

Patch series "nilfs2: fix potential issues with empty b-tree nodes".

This series addresses three potential issues with empty b-tree nodes that
can occur with corrupted filesystem images, including one recently
discovered by syzbot.


This patch (of 3):

If a b-tree is broken on the device, and the b-tree height is greater than
2 (the level of the root node is greater than 1) even if the number of
child nodes of the b-tree root is 0, a NULL pointer dereference occurs in
nilfs_btree_prepare_insert(), which is called from nilfs_btree_insert().

This is because, when the number of child nodes of the b-tree root is 0,
nilfs_btree_do_lookup() does not set the block buffer head in any of
path[x].bp_bh, leaving it as the initial value of NULL, but if the level
of the b-tree root node is greater than 1, nilfs_btree_get_nonroot_node(),
which accesses the buffer memory of path[x].bp_bh, is called.

Fix this issue by adding a check to nilfs_btree_root_broken(), which
performs sanity checks when reading the root node from the device, to
detect this inconsistency.

Thanks to Lizhi Xu for trying to solve the bug and clarifying the cause
early on.

Link: https://lkml.kernel.org/r/20240904081401.16682-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240902084101.138971-1-lizhi.xu@windriver.com
Link: https://lkml.kernel.org/r/20240904081401.16682-2-konishi.ryusuke@gmail.com
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bff4c7b992038a7409f
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/btree.c~nilfs2-fix-potential-null-ptr-deref-in-nilfs_btree_insert
+++ a/fs/nilfs2/btree.c
@@ -381,7 +381,8 @@ static int nilfs_btree_root_broken(const
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
 		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     nchildren < 0 ||
-		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX)) {
+		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX ||
+		     (nchildren == 0 && level > NILFS_BTREE_LEVEL_NODE_MIN))) {
 		nilfs_crit(inode->i_sb,
 			   "bad btree root (ino=%lu): level = %d, flags = 0x%x, nchildren = %d",
 			   inode->i_ino, level, flags, nchildren);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-null-ptr-deref-in-nilfs_btree_insert.patch
nilfs2-determine-empty-node-blocks-as-corrupted.patch
nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete.patch

