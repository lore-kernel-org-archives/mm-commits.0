Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742BB2701BB
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 20:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765918627; cv=none; b=DwNLjai1vp/RCi3dZMqYaTACFCkN1MdpX2UWyLxv6172HIwqKCR3SINlalZZGPZZIA91dOre88mYVKG/JD+cCwyohJm+HMNsvd9NPtJrLNlVN6z8Xd0PtKGNBU0RdoJakMokMphbeH+7xI/osalLOTLqDioGJvzRrHBkbylzJB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765918627; c=relaxed/simple;
	bh=akmNpoM1V4wENZuKfYy7smdrd2OeyJWcOybSwpYriKs=;
	h=Date:To:From:Subject:Message-Id; b=db0OI/uYTSN5BWkWt93u+HTu299n600eLZwTN10IobMVRMH7DE9Tbh2tJSlnjRlbJogdLk6mMk+5cgAwe49Sns2yhupMw2VeMCWKQ+q+m5bhKTkt+HdSJog0gae4Skj7PgczWZHcp3okh3oWY4zM12XcMmy67QglvpHbxEN8oWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TCo1SOaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TCo1SOaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F69C4CEF1;
	Tue, 16 Dec 2025 20:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765918623;
	bh=akmNpoM1V4wENZuKfYy7smdrd2OeyJWcOybSwpYriKs=;
	h=Date:To:From:Subject:From;
	b=TCo1SOafgj7p4sauV21/yb+U4gdFXGcqBGwCq1MnhHokq/335HvHPXV/RZ+4s9Pg3
	 5KmPcDEEiNajYceJeyxHtRrsx6OByhZojBS9lcOL/Fujv0H5Alz7eKoGY5zO/JP1wy
	 HRpRr6H0bv6EKtFKFYMiFj7+Nl82G9su3bSPyJhY=
Date: Tue, 16 Dec 2025 12:57:03 -0800
To: mm-commits@vger.kernel.org,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,rdunlap@infradead.org,petr.pavlu@suse.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,joonas.lahtinen@linux.intel.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,dakr@kernel.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-drop-stack_magic-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20251216205703.B8F69C4CEF1@smtp.kernel.org>
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
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Subject: kernel.h: drop STACK_MAGIC macro
Date: Fri, 5 Dec 2025 12:52:32 -0500

Patch series "Unload linux/kernel.h", v3.

kernel.h contains declarations that can be placed better.


This patch (of 4):

The macro was introduced in 1994, v1.0.4, for stacks protection.  Since
that, people found better ways to protect stacks, and now the macro is
only used by i915 selftests.  Move it to a local header and drop from the
kernel.h.

Link: https://lkml.kernel.org/r/20251205175237.242022-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20251205175237.242022-2-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
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

Patches currently in -mm which might be from yury.norov@gmail.com are

kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

