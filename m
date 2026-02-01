Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134933EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905007; cv=none; b=UV9cV9yGqNblLpL/ho+ljyvZ0JxFTYBKVFTQLvl2+fju6/0aAfLkSddZ3ZUYmGWRBRgd0OtSf7/SP6EnDMdPWSRNJ59PryZDifowltOwFp60/5xR/j3/MstXdUQGWd3SEwYAAqsUStAu3pTgkoTc0gPi1Q88cH6phqXNgOeyJzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905007; c=relaxed/simple;
	bh=6x+/buLZ824GhkfCB1BxKRhvABo4nkX4mcMwCBvsdSU=;
	h=Date:To:From:Subject:Message-Id; b=komstn2EKYhp+MiVc0Fu1e1ikkdMdzWE4BQuiHjwVVfhmIahMzzPlLiXlBTXW7O9RrX5suRAWrDs2zhEJzALANzMhu/7Y6J8aQ1Ker8bkYNGryuNiialDKwwqzFa+Z64exz1bJ0PZl1/p/Zng7CWkz3ZfJsXtqLtPL8UQ3DWGVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pF0stfkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pF0stfkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC611C4CEF1;
	Sun,  1 Feb 2026 00:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905006;
	bh=6x+/buLZ824GhkfCB1BxKRhvABo4nkX4mcMwCBvsdSU=;
	h=Date:To:From:Subject:From;
	b=pF0stfkxqmVHByDTHMw7xHGXWSxs1E/0feYbEaobAnRXe16aO7hl+qpi5nhxsSkn/
	 F2GLrGdsLp2KtJTl9tzPBtSXhLpMbzuAqw97d0wcRI2x/3v3goxfeJRlUns32tyC2y
	 UmC6hNjTSRaCxk/BhbC+gr0A3fZecslC0cY4EJWs=
Date: Sat, 31 Jan 2026 16:16:46 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernelh-drop-stack_magic-macro.patch removed from -mm tree
Message-Id: <20260201001646.DC611C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel.h: drop STACK_MAGIC macro
has been removed from the -mm tree.  Its filename was
     kernelh-drop-stack_magic-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: kernel.h: drop STACK_MAGIC macro
Date: Thu, 15 Jan 2026 23:25:04 -0500

Patch series "Unload linux/kernel.h", v5.

kernel.h hosts declarations that can be placed better.  This series
decouples kernel.h with some explicit and implicit dependencies; also,
moves tracing functionality to a new independent header.


This patch (of 6):

The macro was introduced in 1994, v1.0.4, for stacks protection.  Since
that, people found better ways to protect stacks, and now the macro is
only used by i915 selftests.  Move it to a local header and drop from the
kernel.h.

Link: https://lkml.kernel.org/r/20260116042510.241009-1-ynorov@nvidia.com
Link: https://lkml.kernel.org/r/20260116042510.241009-2-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gt/selftest_ring_submission.c |    1 +
 drivers/gpu/drm/i915/i915_selftest.h               |    2 ++
 include/linux/kernel.h                             |    2 --
 3 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/selftest_ring_submission.c~kernelh-drop-stack_magic-macro
+++ a/drivers/gpu/drm/i915/gt/selftest_ring_submission.c
@@ -3,6 +3,7 @@
  * Copyright © 2020 Intel Corporation
  */
 
+#include "i915_selftest.h"
 #include "intel_engine_pm.h"
 #include "selftests/igt_flush_test.h"
 
--- a/drivers/gpu/drm/i915/i915_selftest.h~kernelh-drop-stack_magic-macro
+++ a/drivers/gpu/drm/i915/i915_selftest.h
@@ -26,6 +26,8 @@
 
 #include <linux/types.h>
 
+#define STACK_MAGIC	0xdeadbeef
+
 struct pci_dev;
 struct drm_i915_private;
 
--- a/include/linux/kernel.h~kernelh-drop-stack_magic-macro
+++ a/include/linux/kernel.h
@@ -39,8 +39,6 @@
 
 #include <uapi/linux/kernel.h>
 
-#define STACK_MAGIC	0xdeadbeef
-
 struct completion;
 struct user;
 
_

Patches currently in -mm which might be from ynorov@nvidia.com are


