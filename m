Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3009D2E821
	for <mm-commits@vger.kernel.org>; Fri, 22 Dec 2023 20:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JN/WG4ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74746C433C8;
	Fri, 22 Dec 2023 20:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703275368;
	bh=8DWPzwdp/p4NAY+f+RqAuhp/fmMpWPw0nGY4i/XWZH0=;
	h=Date:To:From:Subject:From;
	b=JN/WG4eeE/9fP7kOHCZi7pcekqueZ/RKZBEe7EOpdvL1icuGxBlyyU0CDRFbx3B+d
	 8k3l09ijjv8MVHAv3VrsmFJwi0H3m2StC3CFKpwdkFCIrF4ql5KmyX43P1OITSNp4a
	 STYSZlsSrLhliQ0ecP1DfVoQouXFekWmqtYT5Cp4=
Date: Fri, 22 Dec 2023 12:02:47 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,sj@kernel.org,tanzirh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-changed-asm-generic-mman-commonh-to-linux-mmanh.patch added to mm-unstable branch
Message-Id: <20231222200248.74746C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: change asm-generic/mman-common.h to linux/mman.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-changed-asm-generic-mman-commonh-to-linux-mmanh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-changed-asm-generic-mman-commonh-to-linux-mmanh.patch

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
From: Tanzir Hasan <tanzirh@google.com>
Subject: mm/damon/vaddr: change asm-generic/mman-common.h to linux/mman.h
Date: Thu, 21 Dec 2023 23:11:01 +0000

asm-generic/mman-common.h can be replaced by linux/mman.h and the file
will still build correctly.  It is an asm-generic file which should be
avoided if possible.

Link: https://lkml.kernel.org/r/20231221-asmgenericvaddr-v1-1-742b170c914e@google.com
Fixes: 6dea8add4d28 ("mm/damon/vaddr: support DAMON-based Operation Schemes")
Signed-off-by: Tanzir Hasan <tanzirh@google.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-changed-asm-generic-mman-commonh-to-linux-mmanh
+++ a/mm/damon/vaddr.c
@@ -7,9 +7,9 @@
 
 #define pr_fmt(fmt) "damon-va: " fmt
 
-#include <asm-generic/mman-common.h>
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
+#include <linux/mman.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
 #include <linux/pagewalk.h>
_

Patches currently in -mm which might be from tanzirh@google.com are

mm-damon-vaddr-changed-asm-generic-mman-commonh-to-linux-mmanh.patch
lib-replaced-asm-generic-io-with-linux-io.patch

