Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2593F21CC64
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 23:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768864352; cv=none; b=uLH8rjAvEV+FJB6PI4GvJhh03CEXnPnvGPaPhQAMX4+PyCMVVgdq6mv0AJnHXzJsTPEcANpnWRaRWODDp82IxqoFNd4d7Pq+Ryq6+7V58k2eSban+x1ilSH1DG6I9WUA8CM/AL0QrFYdXBbpiRUhhVKjSPqnZuyJbufNYmdsjOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768864352; c=relaxed/simple;
	bh=o2YiEHlAAWLPtTkrKjNGsBgDaoyqXHpJrfYCb4+CgHk=;
	h=Date:To:From:Subject:Message-Id; b=DtuGL6aidHFc7VpLUz8xCezUfJHBXr8QDf0nF0if62T6w7lRda2kS6aVOHhsTUHovZC/bByKkZlp39/X6Ttat7ogobbW0xoquS7Vw3E2+TZfnFz0LSocEcGUm8h2PKZgRtejOsztCys5HyQ4WP8F8ASO7xHKsgRpCwZI+obuj1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jykUu0fU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jykUu0fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2DEC19424;
	Mon, 19 Jan 2026 23:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768864351;
	bh=o2YiEHlAAWLPtTkrKjNGsBgDaoyqXHpJrfYCb4+CgHk=;
	h=Date:To:From:Subject:From;
	b=jykUu0fU5A+L9crPBvCsU5pvalOxdOvTZpKIZbLMxzVIDpO/LPjgWELnpkBt44Xwa
	 5RdZdOWfes7dO1nohUHmMPNRQjgFkrFmKpdj/04xH+VW50vbkYiJ1KT0gNdwGYgNe+
	 /smwgnggBvwbdXsT6+WQEVyh/5plnvuLii55jbXU=
Date: Mon, 19 Jan 2026 15:12:31 -0800
To: mm-commits@vger.kernel.org,tglx@kernel.org,rusty@rustcorp.com.au,peterz@infradead.org,kernelxing@tencent.com,karim.yaghmour@opersys.com,tim.bird@sony.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-add-spdx-license-identifier-lines.patch added to mm-nonmm-unstable branch
Message-Id: <20260119231231.9E2DEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel: add SPDX-License-Identifier lines
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-add-spdx-license-identifier-lines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-add-spdx-license-identifier-lines.patch

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
From: Tim Bird <tim.bird@sony.com>
Subject: kernel: add SPDX-License-Identifier lines
Date: Mon, 19 Jan 2026 15:40:21 -0700

Add SPDX-License-Identifier lines to some old kernel files.

Link: https://lkml.kernel.org/r/20260119224021.793309-1-tim.bird@sony.com
Signed-off-by: Tim Bird <tim.bird@sony.com>
Acked-by: Karim Yaghmour <karim.yaghmour@opersys.com>
Cc: Jason Xing <kernelxing@tencent.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty "Buggy" Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Tim Bird <tim.bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c   |    3 +--
 kernel/relay.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/cpu.c~kernel-add-spdx-license-identifier-lines
+++ a/kernel/cpu.c
@@ -1,7 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /* CPU control.
  * (C) 2001, 2002, 2003, 2004 Rusty Russell
- *
- * This code is licenced under the GPL.
  */
 #include <linux/sched/mm.h>
 #include <linux/proc_fs.h>
--- a/kernel/relay.c~kernel-add-spdx-license-identifier-lines
+++ a/kernel/relay.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Public API and common code for kernel->userspace relay file support.
  *
@@ -9,8 +10,6 @@
  * Moved to kernel/relay.c by Paul Mundt, 2006.
  * November 2006 - CPU hotplug support by Mathieu Desnoyers
  * 	(mathieu.desnoyers@polymtl.ca)
- *
- * This file is released under the GPL.
  */
 #include <linux/errno.h>
 #include <linux/stddef.h>
_

Patches currently in -mm which might be from tim.bird@sony.com are

kernel-add-spdx-license-identifier-lines.patch

