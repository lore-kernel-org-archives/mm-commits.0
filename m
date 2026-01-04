Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7D02DF12F
	for <mm-commits@vger.kernel.org>; Sun,  4 Jan 2026 19:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767553382; cv=none; b=Je3QLmwznzmqVsypprOFM1h2pUijpSctMg9DfyonLsOLemG4LPU1e3QDemqpgd3ArQ4RiBVpkTeuD5I0k3MLSwDDVefbduGHrt7rw2yT7LTrlx546evABw3AVBrqtooEWCuAYP42lgikR5CYZHM1AD0XTIST1gVp2mq4Z5Ossxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767553382; c=relaxed/simple;
	bh=eGhSdV/+QY5eg0D8zi4yzVac5LcHJmD3m1c1iUmf90c=;
	h=Date:To:From:Subject:Message-Id; b=GX7C399ISwvT8DcwnUFCq7uTHdtCjrnodxgg4jH7IqLxlw7ZXjIbdHwD2wdfBikW5+2ckKTzmTQxdsO5Eysnu3A8MtkWODQMcnSvhjCEv5pCC8ovgQEBSi2p7ZwssW6+/O/aqW69jaWzWGpC7+PxMe9b+KCYdTOX9aycTHhprUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IQtCgOj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IQtCgOj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C320CC4CEF7;
	Sun,  4 Jan 2026 19:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767553381;
	bh=eGhSdV/+QY5eg0D8zi4yzVac5LcHJmD3m1c1iUmf90c=;
	h=Date:To:From:Subject:From;
	b=IQtCgOj5D4IarNbKb+z/5MYq3sZwM+XuPIIP3vTq3Zx14wtw/5NabOmPoTPPu0aSd
	 IxQrhy/oqM6QQBwbnike0SzvX9y/v6rQB3jc7JXKiNIa746xVEZMniMwYpu1lfgJrd
	 vBA+oUd7VtyOtJInhA5i611a7Qjo+7v+YDljdZ48=
Date: Sun, 04 Jan 2026 11:03:01 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,Julia.Lawall@inria.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-adjust-function-name-reference.patch added to mm-nonmm-unstable branch
Message-Id: <20260104190301.C320CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: adjust function name reference
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-adjust-function-name-reference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-adjust-function-name-reference.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@inria.fr>
Subject: ocfs2: adjust function name reference
Date: Tue, 30 Dec 2025 15:25:13 +0100

There is no function dlm_mast_regions().  However, dlm_match_regions() is
passed the buffer "local", which it uses internally, so it seems like
dlm_match_regions() was intended.

Link: https://lkml.kernel.org/r/20251230142513.95467-1-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-adjust-function-name-reference
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1105,7 +1105,7 @@ static int dlm_query_region_handler(stru
 	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
 	     qr->qr_domain);
 
-	/* buffer used in dlm_mast_regions() */
+	/* buffer used in dlm_match_regions() */
 	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
 	if (!local)
 		return -ENOMEM;
_

Patches currently in -mm which might be from Julia.Lawall@inria.fr are

ocfs2-adjust-function-name-reference.patch

