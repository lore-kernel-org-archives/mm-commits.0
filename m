Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED3BA59
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 00:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768350149; cv=none; b=qlXYkot6zu4Bl4vB7oROTzSC/mRVM8aAuJjtFigWXHrsS19QjlYwJEGHtz94XjNewTSQPbn4XXRLAifjUR/M3A5guChBMyL4MjugnK7YjAtGBSbWK6xqV8a1dU6chcJn11UJWvRYwPEE1rRBsZr4cHupThXbDoy+8119xCoc0zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768350149; c=relaxed/simple;
	bh=OQVPqfDDDoWd909VeVIJtINT9mmz2BxEAwQ3KvOsrNY=;
	h=Date:To:From:Subject:Message-Id; b=GFGXmYKqR0pHuDOsARwUY/oHChoOVrTBqiNGLUvUaaH3eGd0ZJ022hsTiDJcSYX2dgN7z7gdsoAYkktIhZvrPsUk5PRJ4u6b2NVvGTzPT+oI0wbN4JXN4lmvgx+yc/I4TBRyZAfeY3vmK8pTWyPXBfvg3qTtx07Mb3QMhp+f2dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wENs9ZyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wENs9ZyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD73C116C6;
	Wed, 14 Jan 2026 00:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768350149;
	bh=OQVPqfDDDoWd909VeVIJtINT9mmz2BxEAwQ3KvOsrNY=;
	h=Date:To:From:Subject:From;
	b=wENs9ZyUgdBskC0UmEOuY2/zgqJUC4LE5p9lTQjbu08WkHAtsr7Ffdgf/AtJZT+ex
	 XdC8oYi0/wQFyUrxDcTuKRNJ9VwATpYZFwk+ZUDCZwHECTYWkplli1zpX+zDIgJAzj
	 rh16Mk6x/cz8C+lCrKP5GD6X3gL1G+WiTsHEiFq4=
Date: Tue, 13 Jan 2026 16:22:28 -0800
To: mm-commits@vger.kernel.org,tim.bird@sony.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-add-spdx-license-identifier-lines.patch added to mm-nonmm-unstable branch
Message-Id: <20260114002229.1BD73C116C6@smtp.kernel.org>
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
Date: Tue, 13 Jan 2026 16:44:05 -0700

Add SPDX-License-Identifier lines to some old kernel files.

Link: https://lkml.kernel.org/r/20260113234405.539422-1-tim.bird@sony.com
Signed-off-by: Tim Bird <tim.bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c   |    3 +--
 kernel/relay.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/cpu.c~kernel-add-spdx-license-identifier-lines
+++ a/kernel/cpu.c
@@ -1,7 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
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

