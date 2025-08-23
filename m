Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E371D3D994
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 02:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755914439; cv=none; b=qfjnAHQekNNA4mdR8D1OlWrfe2efosM6K9FQ1JhmM0Xkd/I5fz1MeNzm8WAC+i8lr2fI4Bn6zvN+L3hywhEZdtz0wS1ZMLRlIFOObc5LBFsIqrPrhVabckHP9Qq26mhY6nXov8TN0420N+1uXSm5STXNjmSGyB/Jy48FqqlYEsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755914439; c=relaxed/simple;
	bh=0DmFiKZvNbajInfwxTc0nhCo7V3CU4esI2rb1AreTls=;
	h=Date:To:From:Subject:Message-Id; b=jhQNNsO2x1SdbsOMncYjiDeXjZh0ITOuWYbl7m9t0RR3EoSLam4EY2l454JC/1G5dPj1WH4/DdToNHsM7AniVQPgK1AF3yt59PFuFkw3wdIR/Dzg284aiirihMc7Mfpl0YEOjDJ4YfMUMQxruCfBdLNasVMtOn14t36CBN47hQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fwh7sdqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fwh7sdqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A1AC4CEED;
	Sat, 23 Aug 2025 02:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755914438;
	bh=0DmFiKZvNbajInfwxTc0nhCo7V3CU4esI2rb1AreTls=;
	h=Date:To:From:Subject:From;
	b=fwh7sdqtUtYpTHXiTi4X5F4EnoJwtoij8olIK4xgaXtkh0d1quzklC35Kwx69h/Dl
	 Z9g4GNSJvEZs2ae26GGh9WlyYOVcYfn14Gx+dJRrZtmX1d7nGY7whqnTGW2VI492ZO
	 IZml9Klic/QTzFmL8ORyC06YDI0hw26aVb/heWa4=
Date: Fri, 22 Aug 2025 19:00:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vgupta@kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,liuye@kylinos.cn,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch added to mm-unstable branch
Message-Id: <20250823020038.92A1AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch

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
Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
Date: Fri Aug 22 02:54:15 PM PDT 2025

remove arc's private PAGES_TO_MB, remove its unused PAGES_TO_KB

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lkml.kernel.org/r/202508230539.pnO97SIj-lkp@intel.com
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/arcregs.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arc/include/asm/arcregs.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
+++ a/arch/arc/include/asm/arcregs.h
@@ -146,14 +146,13 @@
 
 #ifndef __ASSEMBLER__
 
+#include <linux/mm.h>
+
 #include <soc/arc/arc_aux.h>
 
 /* Helpers */
 #define TO_KB(bytes)		((bytes) >> 10)
 #define TO_MB(bytes)		(TO_KB(bytes) >> 10)
-#define PAGES_TO_KB(n_pages)	((n_pages) << (PAGE_SHIFT - 10))
-#define PAGES_TO_MB(n_pages)	(PAGES_TO_KB(n_pages) >> 10)
-
 
 /*
  ***************************************************************
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix.patch
lib-sys_info-handle-sys_info_mask==0-case-fix.patch

