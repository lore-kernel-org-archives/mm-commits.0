Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D2523C4F4;
	Tue,  9 Dec 2025 19:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308804; cv=none; b=W8OKdGb7bC1udv+m7lMLb72Jl9mXWeEHwwGWWukcsIeb6gPdmLHniFk8GX6w0bzHbibI/aDD1+TxqjS/LUXKUDPoizhDXQElaL2ktZYwBST09Z2eT+mKuJIvywzVf7bawlkaJSmDeG76IHXVf8DDojaIr1W846/BkZy2HNbfpnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308804; c=relaxed/simple;
	bh=J5za1roF7tlbskCGifOB9gAQpNKkiQHYhDZjtzWSnxc=;
	h=Date:To:From:Subject:Message-Id; b=rTa/koGYtepmi8e5/UwjwfZwblJ/traQGBrlLpo95PLrf/R5EnX8/NWkjBTVMg8N6UDPWL0Uf43sOtVDsHXddEtx53R9jRmwVI37SMv5acji2N2BzV/zEz+wjzPBEmHcqI4kqT3/COBIF851EAIg4p/pjQxY8skRzOEBN9w7w60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lsPFhK6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lsPFhK6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F91C4CEF5;
	Tue,  9 Dec 2025 19:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308803;
	bh=J5za1roF7tlbskCGifOB9gAQpNKkiQHYhDZjtzWSnxc=;
	h=Date:To:From:Subject:From;
	b=lsPFhK6lXA7O2utxKYDIDnZRrLSgiJ6jZ+aE62+t30sa9knI6YUT8WR/a2d+ZLsdr
	 w1VPIqLtChXJrQkY4HK1HPfo4FoVRRf+ot0fjkDTKh1YRd7j4UbQ24ngwGKFi24NG8
	 mVCR7b9gwoWSIpWGdHk0wH7ITHP0VenpBhtP2T3o=
Date: Tue, 09 Dec 2025 11:33:23 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,activprithvi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-kernel-bug-in-ocfs2_find_victim_chain.patch removed from -mm tree
Message-Id: <20251209193323.87F91C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-kernel-bug-in-ocfs2_find_victim_chain.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


