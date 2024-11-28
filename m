Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE37D12B73;
	Thu, 28 Nov 2024 01:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732758709; cv=none; b=t3hhNiSG77La0oMDJYCxh8hb2hLnN5GZK2JSRewG97GbVCdvVouJR1+KASi19Efagp1CrJVXYW7te041gwsT2pP846qTANCrfAj8T1NlV2H0BS3G0UMDbcaS5hDYQmkWtHWDvfqLHXDHlW0h2YNsOp7nZdimPBUkqsq2bX0uWJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732758709; c=relaxed/simple;
	bh=TBD6Sh/QPyySgfLrxsV0I1iVz3k1RFf5Iw6Ky0D9kcQ=;
	h=Date:To:From:Subject:Message-Id; b=NRuqbcFnzjzDFLcNisyRr8OzE5KjUhUkPryotN9Fo8XkR44nlqg3EhDc3CFExYQMmhuAUKAWsdNyunMIovi/4ZiBF288uMpKOmX0vKgnbQdGwBccfZ+NBrEOzz+4JpjCokeQqE44orypqh7YuqRfiFfe5KulNMFAa6sa49Y8APs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rkh0PkrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rkh0PkrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529E4C4CECC;
	Thu, 28 Nov 2024 01:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732758708;
	bh=TBD6Sh/QPyySgfLrxsV0I1iVz3k1RFf5Iw6Ky0D9kcQ=;
	h=Date:To:From:Subject:From;
	b=Rkh0PkrMVj0BLKE9D8hbQdHYrIsqs8HyZvgszqYhNJwHMJxcBp6RoFGrGKFZZdglE
	 drGexNDuyp3n1Fy3CrkalFSgnjNvB7FbCnL1wYSYeOXdmd720SZ7Ymfxzzeemplwd7
	 XpbO8DBMxsCUNngC35q3Dbk3ZRJsySCvAm1gUly0=
Date: Wed, 27 Nov 2024 17:51:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,wen.gang.wang@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-update-seq_file-index-in-ocfs2_dlm_seq_next-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128015148.529E4C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: update seq_file index in ocfs2_dlm_seq_next
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-update-seq_file-index-in-ocfs2_dlm_seq_next-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-update-seq_file-index-in-ocfs2_dlm_seq_next-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: update seq_file index in ocfs2_dlm_seq_next
Date: Tue, 19 Nov 2024 09:45:00 -0800

The following INFO level message was seen:

seq_file: buggy .next function ocfs2_dlm_seq_next [ocfs2] did not
update position index

Fix:
Update *pos (so m->index) to make seq_read_iter happy though the index its
self makes no sense to ocfs2_dlm_seq_next.

Link: https://lkml.kernel.org/r/20241119174500.9198-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/dlmglue.c~ocfs2-update-seq_file-index-in-ocfs2_dlm_seq_next-v2
+++ a/fs/ocfs2/dlmglue.c
@@ -3110,6 +3110,7 @@ static void *ocfs2_dlm_seq_next(struct s
 	struct ocfs2_lock_res *iter = v;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
+	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
 	iter = ocfs2_dlm_next_res(iter, priv);
 	list_del_init(&dummy->l_debug_list);
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are

ocfs2-update-seq_file-index-in-ocfs2_dlm_seq_next-v2.patch

