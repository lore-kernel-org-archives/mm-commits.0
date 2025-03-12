Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372DC1F09B3
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 22:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741819010; cv=none; b=WkdePp5HyT/DUUxCMgkS1PrFyIYG+NjEto4WqIKtqDj1HpS9hj5r2hein3O3q4CnozM6AT9erstIu8mTKYi1CALxqP4rQjpbhHA2EQic00X8kg+cVkO//eajaDKYKdAD6x86FfPZSlwlg2EwRHUL7h+GSd1ZkIyxognxXe20K/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741819010; c=relaxed/simple;
	bh=eT0SFd7vTUj3py+ADWOaklE27y72wV11Fr/Vvleuxr0=;
	h=Date:To:From:Subject:Message-Id; b=fH6hH66LFtd0T9LZAwBgGMdixGEmlWQVjVWG/6nAkKYMsK2GW7ON5bCWK75X52a4GVtzxGA+6M8MYHdMzwPtqQSFkowJCIeLwzCpUnHUIn3wSa68NvyG9nExACu4eYONTNTSK0gXXGFaYMhsJOc4G7XtExKJhvxpoyR5icXWSYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IpauzedS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IpauzedS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9382AC4CEDD;
	Wed, 12 Mar 2025 22:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741819009;
	bh=eT0SFd7vTUj3py+ADWOaklE27y72wV11Fr/Vvleuxr0=;
	h=Date:To:From:Subject:From;
	b=IpauzedSFKISQHcQHImw8RH5ZCfR3pTsMt30yBcsF/5xNW3v7ZXUg0KJaKzqYD/tx
	 15rCZ8hT34B5AeZtIwb8gGCtktcJHk8d/k0NfwQv5fubrnp8g+QCzG7aG1M00llOoC
	 7iaaIz4Yds4+oPDnumL2/Gq76ZD4CX8XjrQVDlZU=
Date: Wed, 12 Mar 2025 15:36:49 -0700
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-add-line-breaks.patch added to mm-unstable branch
Message-Id: <20250312223649.9382AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug: add line breaks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug-add-line-breaks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-add-line-breaks.patch

This patch will later appear in the mm-unstable branch at
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
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/debug: add line breaks
Date: Wed, 12 Mar 2025 17:37:17 +0800

Missing a newline character at the end of the format string.

Link: https://lkml.kernel.org/r/20250312093717.364031-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-debug-add-line-breaks
+++ a/mm/debug.c
@@ -173,7 +173,7 @@ dump:
 void dump_page(const struct page *page, const char *reason)
 {
 	if (PagePoisoned(page))
-		pr_warn("page:%p is uninitialized and poisoned", page);
+		pr_warn("page:%p is uninitialized and poisoned\n", page);
 	else
 		__dump_page(page);
 	if (reason)
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memfd-fix-spelling-and-grammatical-issues.patch
mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch
mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch
mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch
mm-debug-add-line-breaks.patch

