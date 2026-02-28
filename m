Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F517301460
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 21:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772315161; cv=none; b=Dz2E4fOGC2IkbPaHEwQnRMgpalaD8fwhUBlGW/ci83onaXjanceWSlG7NWalLKq5l0og+AL7/e5PxL5KU9s0k8xcoCwSBtuL3vwRhYfOcQqNDPZl3Nt49VjWIjqZkW2vYbNjGWMkEd00vRkrucdx8ZOF0ELnw0HY5zsEGBR7ryo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772315161; c=relaxed/simple;
	bh=L6YA7LUQnvWkTQ6/liWN+DfE5lxbKHziRS4fyN61JQU=;
	h=Date:To:From:Subject:Message-Id; b=bClxb5Wkvytg7zPEtB0lkS3kY0Dis0wZ8b+LrWo+r9BtVPgNgVj6ANNLedPdCX4DoBYm4Cb0tAAVSkhBgbfSdZTfYC5fCxiiwqAPdl4IxINi3ss1aYbVWINjUYRcO7Gd/JMVxDSZ8fOnnHY3g4mLvEhR+XLWS3C3FQquJN2P8oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZLSUOP9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZLSUOP9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E54C116D0;
	Sat, 28 Feb 2026 21:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772315160;
	bh=L6YA7LUQnvWkTQ6/liWN+DfE5lxbKHziRS4fyN61JQU=;
	h=Date:To:From:Subject:From;
	b=ZLSUOP9qbNiBlW7k+0buacyRMad+fzImF5nWQau/YQDtSAopqccVY3wm6qECOQMy8
	 Ndce7SyWCNDZ28ndBYqJSGMm24AD6JfQ3K3cwCOi6DVdMJbzZTafEYGuzAchRg7Q00
	 FmfOj7bZlIDJu6AyMl9fp98HdHmI1fP7o5LG9ZM8=
Date: Sat, 28 Feb 2026 13:46:00 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-glob-add-missing-spdx-license-identifier.patch added to mm-nonmm-unstable branch
Message-Id: <20260228214600.A3E54C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: glob: add missing SPDX-License-Identifier
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-glob-add-missing-spdx-license-identifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-glob-add-missing-spdx-license-identifier.patch

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
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib: glob: add missing SPDX-License-Identifier
Date: Sat, 28 Feb 2026 19:53:00 +0000

Add the missing dual MIT/GPL license identifier to glob.c.

Link: https://lkml.kernel.org/r/20260228195300.2468310-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/glob.c~lib-glob-add-missing-spdx-license-identifier
+++ a/lib/glob.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
 #include <linux/module.h>
 #include <linux/glob.h>
 
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch

