Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1D61D9663
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 05:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785995340; cv=none; b=k7J1mET0AOAN9pFwNeWB/xV5moIwKSYm+izrcqsaTkVC21zgmtaz6DHynIN1KqKF5/BEZ8jo9MiLfRG/ye07sZCBwxus+7SMJcvcBkkZBhS/BIRmBQZfC+IgwqUFkzjpUsN4qceMQKlJOs+PBqa33Ry5DabODXiGxGJ7F6xxWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785995340; c=relaxed/simple;
	bh=NHgcLvE2BxYmP6ysewRVrNNNABJRMFda36VLy3MNqUY=;
	h=Date:To:From:Subject:Message-Id; b=SDZ0MWGURsbFzjVCxZfvRDq6Oh+Ws7YCKjW4ukD56DVVyv/DxdQIYXCt7eJrEcd+o6tS6i7+BqvapamU9HrANr/byxpAeNPshrO/128P4AHv9rcvJFVLCswRHtwD64RFTB0dxwSxYuyiZPanBbrPEdcQbj6nO1m0YkguWfU8C4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vTcR8Kxb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vTcR8Kxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405D91F000E9;
	Thu,  6 Aug 2026 05:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785995338;
	bh=qDavjFc8ZhLTAuxwG1VleSmSyQBiU0p53D988GVhZxA=;
	h=Date:To:From:Subject;
	b=vTcR8KxbWUCjPC+LbSlCItMAapy0M23k8eiSYY8Y9AIFqDmdyfKt1+nTlaeHqzw+g
	 owBd9IzJhca/oA59cnqngav0Z0eIAU4G/UwyxkVZ3ILLuHSacXMODo0sEhUPLllMU3
	 GYKa9SUDXgeov6PCZ1FZpRXPTu+UDkZXoC64/+VA=
Date: Wed, 05 Aug 2026 22:48:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jhubbard@nvidia.com,hannes@cmpxchg.org,akpm@linux-foundation.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_page_alloc-fix-null-buf-in-debug_guardpage_minorder_setup.patch added to mm-new branch
Message-Id: <20260806054858.405D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: debug_page_alloc: fix NULL buf in debug_guardpage_minorder_setup
has been added to the -mm mm-new branch.  Its filename is
     mm-debug_page_alloc-fix-null-buf-in-debug_guardpage_minorder_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_page_alloc-fix-null-buf-in-debug_guardpage_minorder_setup.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm: debug_page_alloc: fix NULL buf in debug_guardpage_minorder_setup
Date: Thu, 6 Aug 2026 08:45:55 +0800

If the kernel command line includes "debug_guardpage_minorder" without an
equals sign (i.e., no value is provided), the early parameter parser
passes a NULL buf pointer to the setup function.

kstrtouint() does not perform a NULL check on its input and calls directly
into kstrtoull() which dereferences s[0] unconditionally, leading to a
NULL pointer dereference and early boot crash.

Additionally, the error path's pr_err("%s", buf) would also crash with a
NULL format argument.

Link: https://lore.kernel.org/20260806004556.2633049-1-ye.liu@linux.dev
Fixes: c0a32fc5a2e4 ("mm: more intensive memory corruption debugging")
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug_page_alloc.c~mm-debug_page_alloc-fix-null-buf-in-debug_guardpage_minorder_setup
+++ a/mm/debug_page_alloc.c
@@ -22,8 +22,8 @@ static int __init debug_guardpage_minord
 {
 	unsigned int res;
 
-	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
-		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
+	if (!buf || kstrtouint(buf, 10, &res) < 0 || res > MAX_PAGE_ORDER / 2) {
+		pr_err("Bad debug_guardpage_minorder value: %s\n", buf ?: "(missing)");
 		return 0;
 	}
 	_debug_guardpage_minorder = res;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder.patch
mm-show_mem-fix-format-string-inconsistencies-and-type-mismatches.patch
mm-debug_page_alloc-fix-null-buf-in-debug_guardpage_minorder_setup.patch

