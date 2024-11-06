Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93711156243
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854783; cv=none; b=RSiHiGxCeaLDdOWFKYa7G9aJnOvr43Sq1P17rpMxDzYW3JjqQ1m3E0h0GUPsFXLefiEPbOSseKnugnYg548gtgnbHiLipva3+AixwTu+vm6MB/hRYpc+ezdYCKHaQF3zylciSpnT4rrZ2rmWYpH1yacAIexnUCxOKuTI8Xqb5v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854783; c=relaxed/simple;
	bh=HgGdBtetzxJVFah38Rg9aRL+5eIcJx/WGNgR6RvWrww=;
	h=Date:To:From:Subject:Message-Id; b=RBsJpFkbvTdUN4hy3O4VW8M3mPdaJgZbNMJAlh1EUjkfLHqfdOnoFGSug1oJA4a+BIve/JoocxDdLpBXfYb+4eec77uEs+7EVNkNSXQFZLKKoKSUrKUJYXGxyAK2pMCsEhPXSYEn2Qh+XcUWe2IgyW4E4njPGp88r+dr6/CbIVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0BJi1HEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0BJi1HEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688C3C4CECF;
	Wed,  6 Nov 2024 00:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854783;
	bh=HgGdBtetzxJVFah38Rg9aRL+5eIcJx/WGNgR6RvWrww=;
	h=Date:To:From:Subject:From;
	b=0BJi1HEHmVtHhomlByduzzCxSyAJmvtf7vhk8lu2pCn72sN2XGg1N/qP9fCjPmdeE
	 zZqkHqwPmdhge1xwL6HsPbBRAPmwFrYPf465za7NfwTIwShAyH3200CfKxALwHFOPz
	 xt23HYrWjBrCFiwISYYANJRSI/2gs1kD9Nyu/yMs=
Date: Tue, 05 Nov 2024 16:59:42 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,peterx@redhat.com,gregkh@linuxfoundation.org,aha310510@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memoryc-remove-stray-newline-at-top-of-file.patch removed from -mm tree
Message-Id: <20241106005943.688C3C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory.c: remove stray newline at top of file
has been removed from the -mm tree.  Its filename was
     mm-memoryc-remove-stray-newline-at-top-of-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memory.c: remove stray newline at top of file
Date: Mon Oct  7 06:20:09 PM PDT 2024

Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
Reported-by: Jeongjun Park <aha310510@gmail.com>
Closes: https://lkml.kernel.org/r/20241007065307.4158-1-aha310510@gmail.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-remove-stray-newline-at-top-of-file
+++ a/mm/memory.c
@@ -1,4 +1,3 @@
-
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  *  linux/mm/memory.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

