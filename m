Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965961A7048
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 19:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725996571; cv=none; b=UrO0l/ea0ma3DZXpeBXFZ9Bqj6hS4w5Tv2rgpvATtMq69CtsOYKGuHuiEeay880cnfwfYmwWUEjWZd5bsvXRN8S4VPa6wBbEW89dFpNUN8EYAFV6COmiVyiQ5aJqv0b1ZgtmKHI4n7fuGnGnbx5/Bigz3Ule1z53uiO7pvfrLwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725996571; c=relaxed/simple;
	bh=0RvzEKI+ovYpKWkrAg8PCbsKbTd8Jyzvj0Og7VkK7n4=;
	h=Date:To:From:Subject:Message-Id; b=IKgibf0ExcUPUMYnzxe3uhzMTj+ZhdNhKJ12Dg6k19kh89OuvQYuz5UiZ08RNYlxGg66KMm7KXEkg7vA1RKFxXJ3O+MkbKOgD64/ycV3fGxDZhGaRaP1guHz1sZTY2pNJfhyAE2pEnfti3Jv3KEWM9QeXIWw3Hjg/qjLhfDCnlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IIwGS9DG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IIwGS9DG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C72C4CEC3;
	Tue, 10 Sep 2024 19:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725996571;
	bh=0RvzEKI+ovYpKWkrAg8PCbsKbTd8Jyzvj0Og7VkK7n4=;
	h=Date:To:From:Subject:From;
	b=IIwGS9DGdd+/awfVmVid+qDsiUjw6Qx+Xgekw7YG8IpsrUgeqJjsW3J3SMh1Vbn0d
	 JGuY5cl0lLle3tXN9qWIeHUQGYyq0FCWDTBnKnehbMwdWfrDspgM4cwQasY7Vfzpht
	 X/NkkNAs9rxVE+i2ZtDcwNGLdWtIsULwpvJ4NasY=
Date: Tue, 10 Sep 2024 12:29:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tytso@mit.edu,serge@hallyn.com,paul@paul-moore.com,laoar.shao@gmail.com,kent.overstreet@linux.dev,jmorris@namei.org,jack@suse.cz,hch@lst.de,dchinner@redhat.com,brauner@kernel.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch added to mm-unstable branch
Message-Id: <20240910192931.11C72C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcachefs-do-not-use-pf_memalloc_noreclaim-fix
has been added to the -mm mm-unstable branch.  Its filename is
     bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Michal Hocko <mhocko@suse.com>
Subject: bcachefs-do-not-use-pf_memalloc_noreclaim-fix
Date: Tue, 10 Sep 2024 09:24:51 +0200

fix kerneldoc issues

Link: https://lkml.kernel.org/r/Zt_05Dqf3bBZL-H2@tiehlicka
Link: https://lkml.kernel.org/r/202409051713.LFVMScXi-lkp@intel.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/inode.c~bcachefs-do-not-use-pf_memalloc_noreclaim-fix
+++ a/fs/inode.c
@@ -149,9 +149,11 @@ static int no_open(struct inode *inode,
  * inode_init_always - perform inode structure initialisation
  * @sb: superblock inode belongs to
  * @inode: inode to initialise
+ * @gfp: allocation flags
  *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
+ * If there are additional allocations required @gfp is used.
  */
 int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp)
 {
_

Patches currently in -mm which might be from mhocko@suse.com are

bcachefs-do-not-use-pf_memalloc_noreclaim.patch
bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch
revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn.patch

