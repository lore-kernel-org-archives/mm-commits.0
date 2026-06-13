Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E630A35DA43
	for <mm-commits@vger.kernel.org>; Sat, 13 Jun 2026 02:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781316732; cv=none; b=s0UzvnvAO3SJc2+hHHAWdCegUphqyhafIlVusntrkYOtAutIJtfFfOVNE9UqE4hvWC2Lh9Mh22YyxIP1t9XjnaXjp3sewN9pyGPHBF/reQfBX68IcXiPjYU2hW4ZLb+/9Id8/I5qQOXVB/ruu9GXnoFP8TaP7w+u/h0y7ZuNM3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781316732; c=relaxed/simple;
	bh=1r8wJ7i7g6hAm4Rdobzz/QTR0ni7xyNIXzR3STsFINU=;
	h=Date:To:From:Subject:Message-Id; b=B2YjvlYiJbO77sc+MWkMlP513QNA3YcSWy7p+LD1uZux907K4XcMXEEmZa5UBTLe5X6+EPyEdsKcgTxzhRbMI/6CcEoHeyEPjr1jvaRKctj9kJYEQG2fEcQk7ZUp0wMGDlMCwspx1xX7pGHx72u2tprtVHSC5aUjt26isEnaS6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zfkTh7rb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zfkTh7rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9D81F000E9;
	Sat, 13 Jun 2026 02:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781316731;
	bh=1CF+jq+hWluFTG01eKiloffjOpMMgxvq/KnWzrJXzL0=;
	h=Date:To:From:Subject;
	b=zfkTh7rbdbbUEsmUYYkTJXcpFN+8gl1rcFkMXsuvSemd/LLfQhASaZhvRn8M1lmyZ
	 UtnLIK6cYUGEetcWusTiS2UbWfdfH2ZPveP88AgaTJXO3Gm/OL3q/2VuKPujZJ9VmE
	 8+w2oL4R5xUpURXU57NQsjfS7iJVZnXwSVA/6WAI=
Date: Fri, 12 Jun 2026 19:12:11 -0700
To: mm-commits@vger.kernel.org,sam.moelius@trailofbits.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-interval_tree_test-validate-benchmark-parameters-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260613021211.8F9D81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-interval_tree_test-validate-benchmark-parameters-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-interval_tree_test-validate-benchmark-parameters-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-interval_tree_test-validate-benchmark-parameters-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-interval_tree_test-validate-benchmark-parameters-fix
Date: Fri Jun 12 07:09:37 PM PDT 2026

include printk.h for pr_warn()

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202606122249.neYsYssG-lkp@intel.com/
Cc: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/interval_tree_test.c~lib-interval_tree_test-validate-benchmark-parameters-fix
+++ a/lib/interval_tree_test.c
@@ -4,6 +4,7 @@
 #include <linux/interval_tree.h>
 #include <linux/prandom.h>
 #include <linux/slab.h>
+#include <linux/printk.h>
 #include <asm/timex.h>
 #include <linux/bitmap.h>
 #include <linux/maple_tree.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-interval_tree_test-validate-benchmark-parameters-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
sparc-add-_mcount-prototype.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

