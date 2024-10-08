Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9771862A
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728350750; cv=none; b=JSN2kTOkJJjhnvLIohWZ6Qsi/Jl4aMhr3W156f4G1klwVCwi49t6nAsQWId4JJ4S3POhTttrCqoNPbXcndz0hVpS1oaIbqPAxamlfj5ux+p0YpYDz3T/0VnewDLs8YDP5ToxEN8098GtM6aBj0qusKbNUMxjE1vQ8sLpcavURHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728350750; c=relaxed/simple;
	bh=UeEgPDBLiMP34ZXls2feDEUMe4lFWKKpw5BBmIXqDkw=;
	h=Date:To:From:Subject:Message-Id; b=b+3tFoMFWEtuoXBHqGzetxc0l2L6c3OKcO+SKb76SMHRvnvkjgIF/RaSz3dqp6nzp1zWpQHAlH5brw0aS5fukwM9gRhGjl9U+Y7E+DiMmm8lGR6qmaiesutYWKDcPwI6XI2nc2WO4Phie6K7TqhpA/kif7Hjq3xvNYRZ6vunw6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Phz4lK4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Phz4lK4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB728C4CED5;
	Tue,  8 Oct 2024 01:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728350749;
	bh=UeEgPDBLiMP34ZXls2feDEUMe4lFWKKpw5BBmIXqDkw=;
	h=Date:To:From:Subject:From;
	b=Phz4lK4lJYpJ/yWkA63EjjbuCRirXjUgttBgrRIVsftcNijhbofdlQAttyMfEjt4e
	 vI01qBJl4tahSqB5XJfRNfETJ1FEPhHir1N+mvqZHDrjPg/aAGnKPyUVNs24dMl5ps
	 lnrcGKPYfEr417u8rE1l8BkEApgkjxaObQOB0XlA=
Date: Mon, 07 Oct 2024 18:25:49 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,peterx@redhat.com,gregkh@linuxfoundation.org,aha310510@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memoryc-remove-stray-newline-at-top-of-file.patch added to mm-unstable branch
Message-Id: <20241008012549.BB728C4CED5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory.c: remove stray newline at top of file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memoryc-remove-stray-newline-at-top-of-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memoryc-remove-stray-newline-at-top-of-file.patch

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

lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch

