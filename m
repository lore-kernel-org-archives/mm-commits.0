Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C3C33A005
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671945; cv=none; b=MjDBK5xM5qlHTDWBSmDneUSvr9pPuBShAh/jM1xla3N2Y2mdA9bTkYzz6qypK1KCi54kVoIPKLmUiI+xvdVrgFXqgCaUAfuWQtcFdn9/5M4tb0XwY53XwHHodX6AmWjOhcPr1NqTJbZdPJp+xurF4CsdrWA5P0PZM9VM4IrSJOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671945; c=relaxed/simple;
	bh=ilvIznlm802J8yMyvl5+3vGVtSSYr7C4YSFDzAfcEjo=;
	h=Date:To:From:Subject:Message-Id; b=Zwq8KSRppciuSGNuiwXiEEt94+lslg6Zgr0dVV277ZXzws19kkuJd3/ystI3+5wOfdwiP7CrSPGtJrwKmShD2/9iN3sbbjDCfbZ8/5Zc8ofbXEniD3PpeB8DdweJeWjp/YIDh2X0CjVv+xmti/Ncnb221Q0svej0/TlAZTCZi3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q52Uvq2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q52Uvq2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B0BC4CEF7;
	Sat, 28 Mar 2026 04:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671945;
	bh=ilvIznlm802J8yMyvl5+3vGVtSSYr7C4YSFDzAfcEjo=;
	h=Date:To:From:Subject:From;
	b=q52Uvq2uNuiqAv9wfXEInrMuLVf6pKivHNihX4WwTeqDifHlFI3WhCd0CBxCQ4Jjz
	 bRJHOjlFvlvNfYdN06v/WlV3XUxb5rGIdwF9tJIKi6Ja7X+Cr6vkAE0j2LES3+IxCY
	 tTsiULH+zaRp3kwQeTDTpGbzYHvWVsUEYkvYbB4M=
Date: Fri, 27 Mar 2026 21:25:44 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,a.velichayshiy@ispras.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-redundant-error-code-assignment.patch removed from -mm tree
Message-Id: <20260328042545.60B0BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove redundant error code assignment
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-error-code-assignment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Subject: ocfs2: remove redundant error code assignment
Date: Sun, 8 Mar 2026 02:47:53 +0300

Remove the error assignment for variable 'ret' during correct code
execution.  In subsequent execution, variable 'ret' is overwritten.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20260307234809.88421-1-a.velichayshiy@ispras.ru
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-redundant-error-code-assignment
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -930,7 +930,6 @@ redo_request:
 	if (blocked)
 		goto wait;
 
-	ret = -EINVAL;
 	dlm_node_iter_init(mle->vote_map, &iter);
 	while ((nodenum = dlm_node_iter_next(&iter)) >= 0) {
 		ret = dlm_do_master_request(res, mle, nodenum);
_

Patches currently in -mm which might be from a.velichayshiy@ispras.ru are


