Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D1F332EC1
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967311; cv=none; b=GtnllyagG1eCD8v3jRNeZL+D0eH1WfJG72gctATQiF0p97bzRO1rfRiv22rLYx2WaPyRLe1amVYvIck5rbfO3XKkWudmIrRiu25htRpS7YaOigNO/qFQyZgq9JA/BwpIZ+hwboZcfGtX5ShI4xN9C6XSNw8fH+2GI+KBhXDSUp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967311; c=relaxed/simple;
	bh=zaznvMDTGmUP9JuCuzkisEuREDROUdT4KNlfuMpHcf0=;
	h=Date:To:From:Subject:Message-Id; b=kLb56YyIBt+xvETsmgCSe57KUwb7sKL3iVHvpck0ihgVERfDSCCNLO3Q+t+pUZ86WsuAgmiJ9/QgXcP1KMG/mtVDsuxZBajwCC8qxW7IfrRmwp8MxlgWLk1j8OqwhCGOooFcxmDWUM8NoaOELJPZiEydZikuhRVdk/zOuYoIByM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=acXlGnmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="acXlGnmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B711C19425;
	Wed, 21 Jan 2026 03:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967309;
	bh=zaznvMDTGmUP9JuCuzkisEuREDROUdT4KNlfuMpHcf0=;
	h=Date:To:From:Subject:From;
	b=acXlGnmwGKLKlXojsPWKxpONWQyJXvOUn4eUKwlN5dybqtgW6As2fsQ8UXhy75bay
	 AE76VnCOXIDSBQ/f7+ZT3CWLgoBl9uACV98Y3Tu2HrRRC7200BECAgXXmvU3AS9/iz
	 cNwVXgegtvgF+0yWJ6IQfIcHlQpzSzvLH9lw+jmc=
Date: Tue, 20 Jan 2026 19:48:29 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch removed from -mm tree
Message-Id: <20260121034829.8B711C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate i_refcount_loc when refcount flag is set
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: ocfs2: validate i_refcount_loc when refcount flag is set
Date: Fri, 12 Dec 2025 11:28:26 +0530

Add validation in ocfs2_validate_inode_block() to check that if an inode
has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid i_refcount_loc. 
A corrupted filesystem image can have this inconsistent state, which later
triggers a BUG_ON in ocfs2_remove_refcount_tree() when the inode is being
wiped during unlink.

Catch this corruption early during inode validation to fail gracefully
instead of crashing the kernel.

Link: https://lkml.kernel.org/r/20251212055826.20929-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251208084407.3021466-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20251212045646.9988-1-kartikey406@gmail.com/T/ [v2]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set
+++ a/fs/ocfs2/inode.c
@@ -1529,6 +1529,13 @@ int ocfs2_validate_inode_block(struct su
 		}
 	}
 
+	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
+	    !di->i_refcount_loc) {
+		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
+				(unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
_

Patches currently in -mm which might be from kartikey406@gmail.com are

mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch
mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node.patch

