Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEF226F28A
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764268985; cv=none; b=BsoSs9iVk26xtBaBelyX0636AhANs4Yb8EcgNdffWVCb/eti+76pc7Yxh8ijtjsKfemPOcuSal2Z+WF7LPt1iAg9BHr456VCCeZSD3p85Db4QSQYCj8X7pMuT6al5CMvhhXzYtEKf4D+LYW1wmKY9KZ2OsPAn8gGGgvIFOu53T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764268985; c=relaxed/simple;
	bh=CPVM2pg2+AJldhAiULfeBJ/G4QymnPAOvs1sJ97WkYo=;
	h=Date:To:From:Subject:Message-Id; b=s4t9A0hOL4np/8V8LLVdVFod0V5kF8a20GMMZfR11ga62ZO5T4lAK7ggAAZQaTRgSlb7RaI/Gn/zbzZdNL+1I+KB0gH+ru7WJuv9Afs0M4oXaiPyQGajRG601ZPUivI4lPDKbz1o92IX7yOAt3wvjEO8cabfDsGqMd23EWmecvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZPmLhL9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZPmLhL9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EF8C4CEF8;
	Thu, 27 Nov 2025 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764268984;
	bh=CPVM2pg2+AJldhAiULfeBJ/G4QymnPAOvs1sJ97WkYo=;
	h=Date:To:From:Subject:From;
	b=ZPmLhL9mpZZkCByMQyZBNyWSRRBt74gqHC+UBJ5fzuBlkhCw2IpIr90Z2guUr+9HZ
	 lu/lzj2f+2XzqOLMSM0iQdKrI6qBgV7wEja6lCszHhGnq+R/aQc4Sn/IhkXvXvVz9r
	 os6r4zN47ke+B3WnTBZTmmcVHHAxgsB19qTFgv78=
Date: Thu, 27 Nov 2025 10:43:03 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,alexey.skidanov@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + genalloch-fix-htmldocs-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20251127184304.05EF8C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: genalloc.h: fix htmldocs warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     genalloch-fix-htmldocs-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/genalloch-fix-htmldocs-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: genalloc.h: fix htmldocs warning
Date: Thu Nov 27 10:39:24 AM PST 2025

WARNING: /home/sfr/kernels/next/next/include/linux/genalloc.h:52 function parameter 'start_addr' not described in 'genpool_algo_t'

Fixes: 52fbf1134d47 ("lib/genalloc.c: fix allocation of aligned buffer from non-aligned chunk")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20251127130624.563597e3@canb.auug.org.au
Cc: Alexey Skidanov <alexey.skidanov@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/genalloc.h~genalloch-fix-htmldocs-warning
+++ a/include/linux/genalloc.h
@@ -44,6 +44,7 @@ struct gen_pool;
  * @nr: The number of zeroed bits we're looking for
  * @data: optional additional data used by the callback
  * @pool: the pool being allocated from
+ * @start_addr: start address of memory chunk
  */
 typedef unsigned long (*genpool_algo_t)(unsigned long *map,
 			unsigned long size,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

