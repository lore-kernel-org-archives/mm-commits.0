Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C8DF9CC
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722664098; cv=none; b=XxIbQLAL902R+wwboYInedGs49cki1Z8yepJt2T+J5/fHcD4cGF7sm32/aglvTHWDDo3SYPcwfg4uVP6vl3ff1hCbzoZBvohJd/37Dy2d8n0xqIQqK6ZOYJdBjlRlXEhej7gcS+a+cB+r5DqIdrshqBokL3ybSPu5Klm86pSe/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722664098; c=relaxed/simple;
	bh=Y7nXo1krbrAq7lHMC3Ds+rbTmuZyHDtWtV5d7jylziE=;
	h=Date:To:From:Subject:Message-Id; b=EPKr3PIVBpH68AE8A/SBvGhHS9NGUUVTWBTa2PYxd0XaT45wmYqypjuJmlogWJV5pW5JKVE2uYJpVxiAY8ChGkzhsnHRJKIzChtFnT0Cy2LKeGJ29nlsuc9Ztr8fYAMnJZKfUEhtUr1tWvU10lXERzvieGX0bKBLVDv9mTr1JUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j9zK2CMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j9zK2CMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEDAC116B1;
	Sat,  3 Aug 2024 05:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722664098;
	bh=Y7nXo1krbrAq7lHMC3Ds+rbTmuZyHDtWtV5d7jylziE=;
	h=Date:To:From:Subject:From;
	b=j9zK2CMAl0781AGgBDA7+pHJv5YmBSihViSabwcmmbQ0rBeeL1bKuj4/pTSMpmKdJ
	 ZiHUYsxtjl14lLx1aOm35AH//biHJeyGG2LmION+DI4b+c7EE7QQmHvpGwZgjNBa3L
	 HBBRQQ8J9mrRs65GwADXkgilyXrJroWgYrkxHIEQ=
Date: Fri, 02 Aug 2024 22:48:17 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,abaci@linux.alibaba.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-duplicated-include-in-vma_internalh.patch added to mm-unstable branch
Message-Id: <20240803054818.5DEDAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove duplicated include in vma_internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-duplicated-include-in-vma_internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-duplicated-include-in-vma_internalh.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm: remove duplicated include in vma_internal.h
Date: Fri, 2 Aug 2024 14:02:16 +0800

The header files linux/bug.h is included twice in vma_internal.h, so one
inclusion of each can be removed.

Link: https://lkml.kernel.org/r/20240802060216.24591-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9636
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma_internal.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vma_internal.h~mm-remove-duplicated-include-in-vma_internalh
+++ a/mm/vma_internal.h
@@ -12,7 +12,6 @@
 #include <linux/backing-dev.h>
 #include <linux/bitops.h>
 #include <linux/bug.h>
-#include <linux/bug.h>
 #include <linux/cacheflush.h>
 #include <linux/err.h>
 #include <linux/file.h>
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-remove-duplicated-include-in-vma_internalh.patch

