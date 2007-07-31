From: akpm@linux-foundation.org
Subject: + m32r-build-fix-for-removing-fsh-from-mmh.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:26:55 -0700
Message-ID: <200707310126.l6V1Qtl0008327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbXGaB1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:27:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takata@linux-m32r.org, adobriyan@gmail.com


The patch titled
     m32r: build fix for removing fs.h from mm.h
has been added to the -mm tree.  Its filename is
     m32r-build-fix-for-removing-fsh-from-mmh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
m32r-build-fix-for-removing-fsh-from-mmh.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
