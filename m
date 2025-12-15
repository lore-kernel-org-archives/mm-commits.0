Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2C82FD68F
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 00:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759327; cv=none; b=GzYNs124sHo9cA5Q8VgsVhYMZCmIaa1Z1GEkPgweSmvvKznOo77rOgpRdMrPTNb10lUqI/KwfktDfaOd0CKUxcC9c0EPZ6VNbtwBxYmz3PqytsIJwXSQ6zIDh6wnLDfWIuZmfSG+B5dsdZz0TaX3oj45tHYPw19XFT+1LoQEnuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759327; c=relaxed/simple;
	bh=IVfVaqO8lsk2PPxJqjmqTVY3KlfH5OYTREMrsEnUD+c=;
	h=Date:To:From:Subject:Message-Id; b=Y8NZraEuaLoeiljZGHR8SpQiw7dZmVNSIxR5fVLsiuuBJIAqCVgxCFZD2cs4PE/F1hkZexMOA1DYYpvGTVy7vVET56Ubibnuk0uR3HcXG8GN+42hihM82k0vCFPWH06t+3dSO/47Qf1fZuqtcRKYYmznWFU5yzEFmyeM5V0IasA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TyNQM4c3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TyNQM4c3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A083C4CEF1;
	Mon, 15 Dec 2025 00:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765759327;
	bh=IVfVaqO8lsk2PPxJqjmqTVY3KlfH5OYTREMrsEnUD+c=;
	h=Date:To:From:Subject:From;
	b=TyNQM4c3mSPDCCdZ+qWRt09hwbuyis6QGz7O0FAUc9pxNIiGVP/dYO20NX7UCcpvT
	 7+RWRQ9u+3+x8Fhf8OfZ0i8ZppEk6t25WRFlZ1yxz5c/8yUiigDj6VtlSslAkEzmkd
	 oDvncyXlPu7UmiM7LfLcIMY5O1XFBU1JK9YAPWA0=
Date: Sun, 14 Dec 2025 16:42:06 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch added to mm-nonmm-unstable branch
Message-Id: <20251215004207.3A083C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate i_refcount_loc when refcount flag is set
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch

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

mm-vmscan-always-allow-writeback-during-memcg-reclaim.patch
ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch

