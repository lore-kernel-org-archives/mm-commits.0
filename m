Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1988E20322
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 22:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755900120; cv=none; b=BUyN9tbpTo3PPOh3cWBREdyPdeRRj5r4Q+Tdy6k6wUHzkPiiY1mwllybPJ4n426mnrBD+Dkxg/1Ckx40TPhvnmRJS0s4cEbGExLnU5H/SlDkr3jFfLEli+Zp8+SjwaV9/QObSqvYv8TbJ4n5FhLqe0K1ArMSH10d4Gw3xmbFs+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755900120; c=relaxed/simple;
	bh=p5t+WdoyMGwPjY0as6JlDmA8kMQQyq8dWk7WstvbPlA=;
	h=Date:To:From:Subject:Message-Id; b=IKGUFTwxrp33sWUjO9ib6qv78P1HcDcoxZ6EAHMv7/rWeeOFTzOPsNB7Cr/fYFDmM91Qes7i7j7Lt9UPBljstYb0eryIM8AEMcW9Y803mAmim78j57Ln/JYc6SV1Qwc3ViUHxo7LKJpiiwTHHISC7eghqPNifRxaS2Zn76il/8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+Sr8SFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+Sr8SFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB3BC4CEED;
	Fri, 22 Aug 2025 22:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755900119;
	bh=p5t+WdoyMGwPjY0as6JlDmA8kMQQyq8dWk7WstvbPlA=;
	h=Date:To:From:Subject:From;
	b=h+Sr8SFCA57NZ/jPxNbvlMowAdruXOv+3xzpLF2EXc1Q5t2fyfOtIdMeGp/5uQjzn
	 aq1FyMQEYpcCSrOWVu3DXpJCreISbDN9UejG+yXFauyWgU3GYikIOf7pNayF2iynlb
	 qSvhEza8IcD8iyzLT9jQbP91vbO67P2B4fkIVrVI=
Date: Fri, 22 Aug 2025 15:01:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vgupta@kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,liuye@kylinos.cn,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch added to mm-unstable branch
Message-Id: <20250822220159.7AB3BC4CEED@smtp.kernel.org>
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

add system-wide PAGES_TO_KB/PAGES_FROM_KB to mm.h, remove arc private
versions

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

 arch/arc/include/asm/arcregs.h |    4 ++--
 include/linux/mm.h             |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arc/include/asm/arcregs.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
+++ a/arch/arc/include/asm/arcregs.h
@@ -146,13 +146,13 @@
 
 #ifndef __ASSEMBLER__
 
+#include <linux/mm.h>
+
 #include <soc/arc/arc_aux.h>
 
 /* Helpers */
 #define TO_KB(bytes)		((bytes) >> 10)
 #define TO_MB(bytes)		(TO_KB(bytes) >> 10)
-#define PAGES_TO_KB(n_pages)	((n_pages) << (PAGE_SHIFT - 10))
-#define PAGES_TO_MB(n_pages)	(PAGES_TO_KB(n_pages) >> 10)
 
 
 /*
--- a/include/linux/mm.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
+++ a/include/linux/mm.h
@@ -75,6 +75,8 @@ extern void * high_memory;
  * PAGE_SHIFT is the shift for page size (e.g., 12 for 4KB pages)
  * So (20 - PAGE_SHIFT) converts between pages and MB
  */
+#define PAGES_TO_KB(pages) ((pages) >> (10 - PAGE_SHIFT))
+#define KB_TO_PAGES(kb)    ((kb) << (10 - PAGE_SHIFT))
 #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
 #define MB_TO_PAGES(mb)    ((mb) << (20 - PAGE_SHIFT))
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
lib-sys_info-handle-sys_info_mask==0-case-fix.patch

