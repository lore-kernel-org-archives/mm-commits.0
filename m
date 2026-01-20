Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5454134D4CA
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 19:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768938542; cv=none; b=YfXw7p2J6O1dHtGaK6H1MxGaoQJQlgLyIXxI9rbQEnSeSLozJSMSfNdj1npc3TNUI+HSADoCVfG3SbocFtRP9j2t/P7/oHuQMmeOK0qk6Hqd40DeWajy7pzWo0fsVCHvL7/1URkOLHyxONwcIykCKuTYUAXPW2o/rEAjOumtIrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768938542; c=relaxed/simple;
	bh=OqMRz6mwSPIwdji+L6CaJ3oSAanXQAkGbSOOKRItbCk=;
	h=Date:To:From:Subject:Message-Id; b=jCYe2GUMAquY0TqDPPVDGaXvHxBW5ELLuVoBs8lrcvD20UflrHZICVyUHydPqNvqZ/uFVTn151L3cRI+GW1UILrnh6srkPe2PCwXyWxG0zhk4dLXmFM31pkYF21XNbC73FHi2RLzhJiCTLcWMO/ZJpFtDHwQcDrUXaK6vEyDIj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GIDAmfSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GIDAmfSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4F8C16AAE;
	Tue, 20 Jan 2026 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768938539;
	bh=OqMRz6mwSPIwdji+L6CaJ3oSAanXQAkGbSOOKRItbCk=;
	h=Date:To:From:Subject:From;
	b=GIDAmfSHTRuA5HSGrJl94A4XGyBWfDUr6apgJFLJ9jMIULl7IRSr/2994dqAqGJ8R
	 kgc9Q3M3HsZ4S4iwwOOpWcsTuIJw/3b7Wusqun+NeBLRiHqhhRS8CRg4jfkKBBaKK1
	 OQrQugIkOm+TmcYbFegc2JxTbQGgUlwNbXsZ0eOQ=
Date: Tue, 20 Jan 2026 11:48:59 -0800
To: mm-commits@vger.kernel.org,tglx@kernel.org,rusty@rustcorp.com.au,peterz@infradead.org,kernelxing@tencent.com,karim.yaghmour@opersys.com,gregkh@linuxfoundation.org,tim.bird@sony.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kernel-add-spdx-license-identifier-lines.patch removed from -mm tree
Message-Id: <20260120194859.BF4F8C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel: add SPDX-License-Identifier lines
has been removed from the -mm tree.  Its filename was
     kernel-add-spdx-license-identifier-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


