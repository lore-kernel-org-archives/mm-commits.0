From: akpm@linux-foundation.org
Subject: + immediate-values-kprobe-header-fix.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:21:59 -0700
Message-ID: <200707052021.l65KLxVh017112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758951AbXGEUWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:22:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Immediate Values: kprobe header fix
has been added to the -mm tree.  Its filename is
     immediate-values-kprobe-header-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Immediate Values: kprobe header fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Since the immediate values depend on the same int3 handler as kprobes
implements for i386, we have to get architecture specific defines available
for the kprobes trap handler (especially restore_interrupts()) wven when
CONFIG_KPROBES is not selected.

That kind of ifdef around a whole header does not make sense in the first place
anyway.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kprobes.h~immediate-values-kprobe-header-fix include/linux/kprobes.h
--- a/include/linux/kprobes.h~immediate-values-kprobe-header-fix
+++ a/include/linux/kprobes.h
@@ -37,9 +37,9 @@
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
 
-#ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
 
+#ifdef CONFIG_KPROBES
 /* kprobe_status settings */
 #define KPROBE_HIT_ACTIVE	0x00000001
 #define KPROBE_HIT_SS		0x00000002
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
