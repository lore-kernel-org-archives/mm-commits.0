Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3454729AAF8;
	Tue,  2 Dec 2025 16:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693703; cv=none; b=Dva0ABkE1Cw0SW4cT3Ba2xpo2F/SdxQXBCFBTsUypfOgEsyIVfCkn6RJ3+3PMg3kppPqb4gYywjWz/97i5yaKfjBFiqG4hND78xcj3lqadzNPSwGXvVndrDwAMUPxd1ugN1UevIVWVYajK8r9mhYoh6GqzU/44wPJ3PcrA44lOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693703; c=relaxed/simple;
	bh=/tDn2+TvpCsV/V+XMJL21Ga2wSku8tb8NvipnVFm1uA=;
	h=Date:To:From:Subject:Message-Id; b=tinHlXpocFl4OAl0qDTJteJp82fTU9vzFS+VzEN8//MCyXU4kC57nXFD8HisFgWTFOBo480jdTbMDE8Un1amDUqVvN0pss8E+6dzddHhu2dsOKgxmwu67wTOT+biDvivkyb2K6wmd0lMGM75mGr0vEGmMWSO+V4TCs6G3Y0NQlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HenSbte8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HenSbte8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5463C4CEF1;
	Tue,  2 Dec 2025 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764693702;
	bh=/tDn2+TvpCsV/V+XMJL21Ga2wSku8tb8NvipnVFm1uA=;
	h=Date:To:From:Subject:From;
	b=HenSbte8YN5VpwAEolXgokhW34Tf5uFnJJwCEDKfRc0pObSxIDC5hrY9p22NN/vak
	 Ru8nN7b52mtRIh5clF4O/B6MHcDBT7/rl4YgOFQhtLXa5cj9B6WxHl+dJ4kZCcsyFv
	 Q6FxHLSjD51L4zw60vuM93Ez6GfnHQ1DlNqbadNI=
Date: Tue, 02 Dec 2025 08:41:42 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,activprithvi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-kernel-bug-in-ocfs2_find_victim_chain.patch added to mm-nonmm-unstable branch
Message-Id: <20251202164142.A5463C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-kernel-bug-in-ocfs2_find_victim_chain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-kernel-bug-in-ocfs2_find_victim_chain.patch

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
From: Prithvi Tambewagh <activprithvi@gmail.com>
Subject: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Mon, 1 Dec 2025 18:37:11 +0530

syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
`cl_next_free_rec` field of the allocation chain list (next free slot in
the chain list) is 0, triggring the BUG_ON(!cl->cl_next_free_rec)
condition in ocfs2_find_victim_chain() and panicking the kernel.

To fix this, an if condition is introduced in ocfs2_claim_suballoc_bits(),
just before calling ocfs2_find_victim_chain(), the code block in it being
executed when either of the following conditions is true:

1. `cl_next_free_rec` is equal to 0, indicating that there are no free
chains in the allocation chain list
2. `cl_next_free_rec` is greater than `cl_count` (the total number of
chains in the allocation chain list)

Either of them being true is indicative of the fact that there are no
chains left for usage.

This is addressed using ocfs2_error(), which prints
the error log for debugging purposes, rather than panicking the kernel.

Link: https://lkml.kernel.org/r/20251201130711.143900-1-activprithvi@gmail.com
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ocfs2/suballoc.c~ocfs2-fix-kernel-bug-in-ocfs2_find_victim_chain
+++ a/fs/ocfs2/suballoc.c
@@ -1993,6 +1993,16 @@ static int ocfs2_claim_suballoc_bits(str
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	if (!le16_to_cpu(cl->cl_next_free_rec) ||
+	    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has invalid next "
+				     "free chain record %u, but only %u total\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno),
+				     le16_to_cpu(cl->cl_next_free_rec),
+				     le16_to_cpu(cl->cl_count));
+		goto bail;
+	}
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
_

Patches currently in -mm which might be from activprithvi@gmail.com are

ocfs2-fix-kernel-bug-in-ocfs2_find_victim_chain.patch

