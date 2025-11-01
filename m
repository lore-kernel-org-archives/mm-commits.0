Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2D522E3E7
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 02:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761964691; cv=none; b=hpfgKWfhKjDLmUBPgmecpHC5c2aFKw9leq87lbiZHHJW2a7vkraa//qykdjJ1eyObQNCO/o+/cgHo18vJsl4Pc46btYSmgwmbsFE1n6jKzBblSyMl2XkIU71JWfMUWMiMmGm+NK+kzgiuzoRboFvmLd4wcqfEQkGvaQCIzPjkEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761964691; c=relaxed/simple;
	bh=/gnzfDxXVzPjcbs/ckqlI9KUN4C+DC1DE+T2gwvSOFA=;
	h=Date:To:From:Subject:Message-Id; b=mIF6OJAClJpmZMdsYZLFobyq6BHduddd+bVZG8sBc7fjGF9xFf0v98LBJFOixQzf6VH6uOuD7YmE5FBnHmqQTdI6nv0gWeXMNODBp3pmoI4DG6uZlbY39GXT2VIKZcxlfy77B/txoEJv9KUwCHUqg58JQID8A5+RH/ZRFzIJ6Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SC/X8ck5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SC/X8ck5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27B4C4CEE7;
	Sat,  1 Nov 2025 02:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761964690;
	bh=/gnzfDxXVzPjcbs/ckqlI9KUN4C+DC1DE+T2gwvSOFA=;
	h=Date:To:From:Subject:From;
	b=SC/X8ck5XGvErr3UPYIvOxfzTZ9RDyTd5mqWUF7qHfxwRbB0HBEDys5JQ9CRWLQiX
	 R3lDJcV59N5XhAPwgccDmGMshTG48XQHIzYWGBRG1b255ZPDh7lFqNbVD3io44jW1W
	 33EtVxxNT0DApPZLVYf81NgA6qJ/qQjGsM69dhM0=
Date: Fri, 31 Oct 2025 19:38:10 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,kartikey406@gmail.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch added to mm-nonmm-unstable branch
Message-Id: <20251101023810.A27B4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add extra consistency checks for chain allocator dinodes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add extra consistency checks for chain allocator dinodes
Date: Thu, 30 Oct 2025 18:30:02 +0300

When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
add an extra checks whether a) the maximum amount of chain records in
'struct ocfs2_chain_list' matches the value calculated based on the
filesystem block size, and b) the next free slot index is within the valid
range.

Link: https://lkml.kernel.org/r/20251030153003.1934585-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes
+++ a/fs/ocfs2/inode.c
@@ -1513,6 +1513,23 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_count));
+			goto bail;
+		}
+		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_next_free_rec));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch
ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch
ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch
ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch
ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

