From: akpm@linux-foundation.org
Subject: - i386-account-for-module-percpu-space-separately-from-kernel.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:37 -0700
Message-ID: <200703292339.l2TNdbdh015446@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945953AbXC2Xjq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, ebiederm@xmission.com, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     i386: account for module percpu space separately from kernel percpu
has been removed from the -mm tree.  Its filename was
     i386-account-for-module-percpu-space-separately-from-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: account for module percpu space separately from kernel percpu
From: Jeremy Fitzhardinge <jeremy@goop.org>

Rather than using a single constant PERCPU_ENOUGH_ROOM, compute it as the
sum of kernel_percpu + PERCPU_MODULE_RESERVE.  This is taken directly from
the x86_64 tree.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/percpu.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/asm-i386/percpu.h~i386-account-for-module-percpu-space-separately-from-kernel include/asm-i386/percpu.h
--- a/include/asm-i386/percpu.h~i386-account-for-module-percpu-space-separately-from-kernel
+++ a/include/asm-i386/percpu.h
@@ -5,6 +5,16 @@
 #include <asm-generic/percpu.h>
 #else
 
+#ifdef CONFIG_MODULES
+# define PERCPU_MODULE_RESERVE 8192
+#else
+# define PERCPU_MODULE_RESERVE 0
+#endif
+
+#define PERCPU_ENOUGH_ROOM \
+	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
+	 PERCPU_MODULE_RESERVE)
+
 /*
  * PER_CPU finds an address of a per-cpu variable.
  *
_

Patches currently in -mm which might be from jeremy@goop.org are

fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
