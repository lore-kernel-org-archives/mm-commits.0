Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2B642AA6
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745868641; cv=none; b=t9g0X4kJYWuIKoJEEgglVCvEILp2qOPCMesiegQNdVD1S33K4ldlWgF/cou7A7R23wsOtOcshzExR+br/VKXa+VEph47C8d3f9r9WjVc9urQaLTcmBDAxtOuBCpi1Ru97EhBsfSCOXisUcPiBILPbCeXb3u/w0xs376aKB+jzpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745868641; c=relaxed/simple;
	bh=RG2KVMIMKCWHoipyMonYKDNuOmdoslhM4r14kR2lGZA=;
	h=Date:To:From:Subject:Message-Id; b=bwMsgJxsuzhq1OwgQPYOSmHj0tJeeRck2vRfLj0ieVmVBySpE0fpx2vYhWxRaEOewoLlfIVlvSKB27oPo+S0h9XlrCpefMdPO4AkGngL35G18ORFxYw4ulTRND7oCniqGHnuV/idDvNlqSSPg9iIUoPxDfCChCCuX2oqqHoXxK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uktmxiRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uktmxiRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43967C4CEE4;
	Mon, 28 Apr 2025 19:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745868640;
	bh=RG2KVMIMKCWHoipyMonYKDNuOmdoslhM4r14kR2lGZA=;
	h=Date:To:From:Subject:From;
	b=uktmxiRoXr86GDZUy5w7S5a6lReC5ajFQ64tCZgKws7LIEZpjzUmNg7F4afGMSFqy
	 zggx9Pgna48rpgL0rkshSaZy57uHlwngy0vch4DvVEiuiDSBbJ7kEv/c42zxn5YMhJ
	 AEswgN+hkyfVfmp7GOJek58jSw5WFY1MP2Ik37Y8=
Date: Mon, 28 Apr 2025 12:30:39 -0700
To: mm-commits@vger.kernel.org,vulab@iscas.ac.cn,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate.patch added to mm-nonmm-unstable branch
Message-Id: <20250428193040.43967C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate.patch

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
Subject: nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()
Date: Tue, 29 Apr 2025 02:37:08 +0900

In preparation for writing logs, in nilfs_btree_propagate(), which makes
parent and ancestor node blocks dirty starting from a modified data block
or b-tree node block, if the starting block does not belong to the b-tree,
i.e.  is isolated, nilfs_btree_do_lookup() called within the function
fails with -ENOENT.

In this case, even though -ENOENT is an internal code, it is propagated to
the log writer via nilfs_bmap_propagate() and may be erroneously returned
to system calls such as fsync().

Fix this issue by changing the error code to -EINVAL in this case, and
having the bmap layer detect metadata corruption and convert the error
code appropriately.

Link: https://lkml.kernel.org/r/20250428173808.6452-3-konishi.ryusuke@gmail.com
Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/btree.c~nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate
+++ a/fs/nilfs2/btree.c
@@ -2102,11 +2102,13 @@ static int nilfs_btree_propagate(struct
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
-		if (unlikely(ret == -ENOENT))
+		if (unlikely(ret == -ENOENT)) {
 			nilfs_crit(btree->b_inode->i_sb,
 				   "writing node/leaf block does not appear in b-tree (ino=%lu) at key=%llu, level=%d",
 				   btree->b_inode->i_ino,
 				   (unsigned long long)key, level);
+			ret = -EINVAL;
+		}
 		goto out;
 	}
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate.patch

