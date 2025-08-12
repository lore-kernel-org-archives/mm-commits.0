Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726951A9FBE
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 23:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755040918; cv=none; b=T4V9Ooq4D0WjCgFFBCiLj6yQmlm4pDBtpEbxDH84cKPvDe0M1ENNkREKQGTzRb8i6hyXxvbwF9d6MN1nEdr2qb0ZMpzbq/VBaW8g1+TukU+7Oqfy2MUaJyNyT/TES419Bc4qVcgTQyYDdiljzxnq6LXK8WRTD5SBmoJEUbk4E5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755040918; c=relaxed/simple;
	bh=a2wuRTpL82NZIB5zobhHwNdpqSA5et0JGw6BAdVQBOs=;
	h=Date:To:From:Subject:Message-Id; b=Bxbmfj9tocTIM/x+jXc1ymaUGWkFK1TuSFWFj7kxV84ymZoqWL02+5FMJy5LNsTF1eCUt2Ho3SeJY0z7+RQwaObB7X4C+aS04y88ZPCEJWTrn6U5o5bwMPnwZVsrc/bZplAUvp+73KhQHwLB6zUGRpaxCFB0owutGThwuBu6KGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O5hYMnxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O5hYMnxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBC8C4CEF0;
	Tue, 12 Aug 2025 23:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755040917;
	bh=a2wuRTpL82NZIB5zobhHwNdpqSA5et0JGw6BAdVQBOs=;
	h=Date:To:From:Subject:From;
	b=O5hYMnxKNF9W5mcdNKFZ6Y1Mj/TXgPMrmOm6YzlPVHYrZM4fz8JBJhdtxHA8E8ERX
	 3mZZ197wj1au1EWd65K0RQsL2Q9ylTgJ8q77iESQeDdeQ/C2U/9X3jt8yPPLC9rQXF
	 PfUZq20gs4vpm9VNPg6TuyOT6su0UUzxhWFCx4KM=
Date: Tue, 12 Aug 2025 16:21:57 -0700
To: mm-commits@vger.kernel.org,zhao.xichao@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-use-ptr_err_or_zero-to-simplify-code.patch added to mm-nonmm-unstable branch
Message-Id: <20250812232157.CDBC8C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/fault-inject-usercopy.c: use PTR_ERR_OR_ZERO() to simplify code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-use-ptr_err_or_zero-to-simplify-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-use-ptr_err_or_zero-to-simplify-code.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Xichao Zhao <zhao.xichao@vivo.com>
Subject: lib/fault-inject-usercopy.c: use PTR_ERR_OR_ZERO() to simplify code
Date: Tue, 12 Aug 2025 16:40:45 +0800

Use the standard error pointer macro to shorten the code and simplify.

Link: https://lkml.kernel.org/r/20250812084045.64218-1-zhao.xichao@vivo.com
Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject-usercopy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/fault-inject-usercopy.c~lib-use-ptr_err_or_zero-to-simplify-code
+++ a/lib/fault-inject-usercopy.c
@@ -22,10 +22,8 @@ static int __init fail_usercopy_debugfs(
 
 	dir = fault_create_debugfs_attr("fail_usercopy", NULL,
 					&fail_usercopy.attr);
-	if (IS_ERR(dir))
-		return PTR_ERR(dir);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(dir);
 }
 
 late_initcall(fail_usercopy_debugfs);
_

Patches currently in -mm which might be from zhao.xichao@vivo.com are

mm-remove-unnecessary-pointer-variables.patch
lib-use-ptr_err_or_zero-to-simplify-code.patch

