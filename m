Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7A614A91
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 03:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768619063; cv=none; b=Az0ZEBV1dI9qSa6zwWv0c0ZokwMyDqQ2mQtq07bx/1hLVA9az6O294L9iKm3yiceSSh2F1xU1HlpOZNK4myGVku/gqLHPJIUrRohM9m78tLn5tX2ITQZRBIBmAsuTDpEESveoPcG00x9PbEOLtEN98F4X1AU0+azGmurMLj0sRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768619063; c=relaxed/simple;
	bh=h3enUL9wPmnVyCHvERqIoYK6pGhidXzajlyWFa4ZTFs=;
	h=Date:To:From:Subject:Message-Id; b=mdY7HROS7qWohjJ1t+z25ENTDQhZONPE18gxmnhZ1WDnRI6AVBB0Ql5rWlkgt6wFcyiQKO+aIS4B+9J2nNPfpRCC3hIHNdLDzxdH7Wu5h9/72XWHaMedZiSF63hbQr3VGSfsetUzBmRMEiyxUSEYuzEFypL+NZj8Q6WY68Jct8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B+i1+IoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B+i1+IoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965C5C116C6;
	Sat, 17 Jan 2026 03:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768619062;
	bh=h3enUL9wPmnVyCHvERqIoYK6pGhidXzajlyWFa4ZTFs=;
	h=Date:To:From:Subject:From;
	b=B+i1+IoNQuMGYivSN1oVvUBvTMYqicQjlvzQ6i3CjQsJ0gFFrzurTD4PS5KQfLUE4
	 o1UEQzltjev24SrWAuyPVrhdjZqaKOml7A2gH8OV31RzdAoe+jIb2IKGx/TQo1z3zu
	 6E9OQ5Wg9wkb2rH32zMWtmBu/6yBZIFr2Q9Dp6kQ=
Date: Fri, 16 Jan 2026 19:04:22 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-drop-stack_magic-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20260117030422.965C5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel.h: drop STACK_MAGIC macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-drop-stack_magic-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-drop-stack_magic-macro.patch

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

nodemask-propagate-boolean-for-nodes_andnot.patch
mm-use-nodes_and-return-value-to-simplify-client-code.patch
cgroup-use-nodes_and-output-where-appropriate.patch
kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
kernelh-include-linux-instruction_pointerh-explicitly.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

