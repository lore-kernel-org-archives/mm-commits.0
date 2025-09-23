Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32D621C9F4
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758661469; cv=none; b=ZlrSOf8RrveWL0gm3JwZslx8AXXLhk0CRM1DNo/VVeyRqDh1A5YLWqGgC2kB6oOEHqUVAeLq0o2qdpzAzulA9oWYPGeZk5FR+wSg9Pinku9nA8xn1bZreBFxgpOP5a6Gb5smFrd0I9uf9Ni/bCCWUskh7ZeSZjLTsaIq7f0wG8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758661469; c=relaxed/simple;
	bh=K72x+Kp6xzMNWDnmpo9cHwqQRILTaCOLnpADu6t7Thc=;
	h=Date:To:From:Subject:Message-Id; b=mFyDLJldCOW3z3E69oE2HpdIBrdNQ3FfLi0jF3m+X4jBg3BxFadVD1inZw3qsRuJNxAWCkgYBZ5PoroW64SfSFYgLKm3JM6mn+Aa/bsgXk7P7bI88N4sL181E5mopCsEAEvDlVwnnOcjHwBHS4+U4xk9Xg1VL0oqZQqXB4H3P4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rqIucd/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rqIucd/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E10AC4CEF5;
	Tue, 23 Sep 2025 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758661468;
	bh=K72x+Kp6xzMNWDnmpo9cHwqQRILTaCOLnpADu6t7Thc=;
	h=Date:To:From:Subject:From;
	b=rqIucd/lGkxop711Ap19/trvLJSpcjVA0rEmNah2Xua6H5rdvzUM6Ln+u8DjvzhWq
	 1EtN5TOdSd5rv7Q4ullVsPFQfODuRB1dmF0UAqIOgZVMGxoKKWRnVubulHXOG0xlqB
	 1IfTmn9cB2XbNM3m1Qb+mDZu9mUb9ZL4ea7mq43g=
Date: Tue, 23 Sep 2025 14:04:27 -0700
To: mm-commits@vger.kernel.org,zhang.run@zte.com.cn,nao.horiguchi@gmail.com,mawupeng1@huawei.com,linmiaohe@huawei.com,hu.shengming@zte.com.cn,david@redhat.com,shengminghu512@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-ensure-collect_procs-is-retried-when-unmap-fails.patch added to mm-new branch
Message-Id: <20250923210428.6E10AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: ensure collect_procs is retried when unmap fails
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-ensure-collect_procs-is-retried-when-unmap-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-ensure-collect_procs-is-retried-when-unmap-fails.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Shengming Hu <shengminghu512@qq.com>
Subject: mm/memory-failure: ensure collect_procs is retried when unmap fails
Date: Tue, 23 Sep 2025 22:57:09 +0800

In the memory_failure process, if collect_procs is not executed with the
flag set, the to_kill list may be empty.  Even if there are pages that
fail to be unmapped, SIGKILL or SIGBUS cannot be sent to the process via
collect_procs.

This patch fixes the issue by re-executing collect_procs when the to_kill
list is empty and unmap fails.  This collects processes with unmap
failures into the to_kill list, allowing SIGBUS or SIGKILL to terminate
them in subsequent code.

Link: https://lkml.kernel.org/r/tencent_EDEED996FC685E61AADA14A23BCE9CCDAF09@qq.com
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zhang Run <zhang.run@zte.com.cn>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-ensure-collect_procs-is-retried-when-unmap-fails
+++ a/mm/memory-failure.c
@@ -1600,9 +1600,12 @@ static bool hwpoison_user_mappings(struc
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
 	unmap_success = !unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
-	if (!unmap_success)
+	if (!unmap_success) {
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
 		       pfn, folio_mapcount(folio));
+		if (list_empty(&tokill))
+			collect_procs(folio, p, &tokill, 1);
+	}
 
 	/*
 	 * try_to_unmap() might put mlocked page in lru cache, so call
_

Patches currently in -mm which might be from shengminghu512@qq.com are

mm-memory-failure-ensure-collect_procs-is-retried-when-unmap-fails.patch

