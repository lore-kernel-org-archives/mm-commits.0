From: akpm@linux-foundation.org
Subject: - m32r-build-fix-for-removing-fsh-from-mmh.patch removed from -mm tree
Date: Mon, 30 Jul 2007 22:01:03 -0700
Message-ID: <200707310501.l6V513x9016518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968903AbXGaFBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 01:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takata@linux-m32r.org, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     m32r: build fix for removing fs.h from mm.h
has been removed from the -mm tree.  Its filename was
     m32r-build-fix-for-removing-fsh-from-mmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m32r: build fix for removing fs.h from mm.h
From: Hirokazu Takata <takata@linux-m32r.org>

This patch is required against the commit:
  Remove fs.h from mm.h
  4e950f6f0189f65f8bf069cf2272649ef418f5e4

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/ptrace.c   |    1 +
 arch/m32r/kernel/smpboot.c  |    1 +
 arch/m32r/kernel/sys_m32r.c |    1 +
 3 files changed, 3 insertions(+)

diff -puN arch/m32r/kernel/ptrace.c~m32r-build-fix-for-removing-fsh-from-mmh arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~m32r-build-fix-for-removing-fsh-from-mmh
+++ a/arch/m32r/kernel/ptrace.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
diff -puN arch/m32r/kernel/smpboot.c~m32r-build-fix-for-removing-fsh-from-mmh arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~m32r-build-fix-for-removing-fsh-from-mmh
+++ a/arch/m32r/kernel/smpboot.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/delay.h>
diff -puN arch/m32r/kernel/sys_m32r.c~m32r-build-fix-for-removing-fsh-from-mmh arch/m32r/kernel/sys_m32r.c
--- a/arch/m32r/kernel/sys_m32r.c~m32r-build-fix-for-removing-fsh-from-mmh
+++ a/arch/m32r/kernel/sys_m32r.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
_

Patches currently in -mm which might be from takata@linux-m32r.org are

origin.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
