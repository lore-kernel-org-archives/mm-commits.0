Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A01139CFC
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 19:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725477305; cv=none; b=OEKRjQ/TAqY8qeKDPu9UGh709njsTfGiQe65qx86DdcuWPuwGNrljsLAvEM1eKmpo/XyNji7RfHCL8tuiw8bxx1dEM6R9o12e67R/QFQ5i8OIGFwKpaNYRH1Jr1ELeJandut+0J71kYWxbA3lfAugD1o9tE/cdS1SChfI8L2QPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725477305; c=relaxed/simple;
	bh=V5n/XjEtSgIyDaFB2HCuZpZhBR1mRhjaTHHvWQ9EgRA=;
	h=Date:To:From:Subject:Message-Id; b=EncYfn7YtioqDTHChbgp4z6EOQItLBNMDFhLqIPpTmyStTWF6eMavTGl3d3qhbJ3U97jMmr0s0zRJ3cDUYI5SwemBaUoxgOVe7lQNInJOyoaTfa2V7hpTWshqqDBB4a0VsItO51CPFVwIc5jihfHS5IQHCGF1KulVzjLCeWjXws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FO3kSO5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FO3kSO5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE8DC4CEC2;
	Wed,  4 Sep 2024 19:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725477305;
	bh=V5n/XjEtSgIyDaFB2HCuZpZhBR1mRhjaTHHvWQ9EgRA=;
	h=Date:To:From:Subject:From;
	b=FO3kSO5Y5IJNgmkc3tgNLUkZhRggMAb0go1QKTXxVx3svklY47EkkRMfixGlNHAOV
	 fER2pqQz3IllT9/KiJonyA6KzQVKaeNjdwo8fiPC1dRlLExhe0VdmoSL/ABOD2XORC
	 Ipt4DWee2Ya9r0mv4CIq1ToYWkVmgEhbEBpyceNI=
Date: Wed, 04 Sep 2024 12:15:04 -0700
To: mm-commits@vger.kernel.org,lizhi.xu@windriver.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-determine-empty-node-blocks-as-corrupted.patch added to mm-nonmm-unstable branch
Message-Id: <20240904191505.5DE8DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: determine empty node blocks as corrupted
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-determine-empty-node-blocks-as-corrupted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-determine-empty-node-blocks-as-corrupted.patch

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
Subject: nilfs2: determine empty node blocks as corrupted
Date: Wed, 4 Sep 2024 17:13:08 +0900

Due to the nature of b-trees, nilfs2 itself and admin tools such as
mkfs.nilfs2 will never create an intermediate b-tree node block with 0
child nodes, nor will they delete (key, pointer)-entries that would result
in such a state.  However, it is possible that a b-tree node block is
corrupted on the backing device and is read with 0 child nodes.

Because operation is not guaranteed if the number of child nodes is 0 for
intermediate node blocks other than the root node, modify
nilfs_btree_node_broken(), which performs sanity checks when reading a
b-tree node block, so that such cases will be judged as metadata
corruption.

Link: https://lkml.kernel.org/r/20240904081401.16682-3-konishi.ryusuke@gmail.com
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/btree.c~nilfs2-determine-empty-node-blocks-as-corrupted
+++ a/fs/nilfs2/btree.c
@@ -350,7 +350,7 @@ static int nilfs_btree_node_broken(const
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
 		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     (flags & NILFS_BTREE_NODE_ROOT) ||
-		     nchildren < 0 ||
+		     nchildren <= 0 ||
 		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
 		nilfs_crit(inode->i_sb,
 			   "bad btree node (ino=%lu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-null-ptr-deref-in-nilfs_btree_insert.patch
nilfs2-determine-empty-node-blocks-as-corrupted.patch
nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete.patch

