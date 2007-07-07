From: akpm@linux-foundation.org
Subject: - immediate-values-kprobe-header-fix.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:28:45 -0700
Message-ID: <200707070032.l670WuDH029808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbXGGAdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Immediate Values: kprobe header fix
has been removed from the -mm tree.  Its filename was
     immediate-values-kprobe-header-fix.patch

This patch was dropped because it had testing failures

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
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
