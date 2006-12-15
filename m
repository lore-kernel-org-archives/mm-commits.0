From: akpm@osdl.org
Subject: + fix-vm_events_fold_cpu-build-breakage.patch added to -mm tree
Date: Thu, 14 Dec 2006 21:31:59 -0800
Message-ID: <200612150532.kBF5VxDc007867@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33841 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbWLOFea (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 00:34:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, clameter@engr.sgi.com, magnus@valinux.co.jp


The patch titled
     fix vm_events_fold_cpu() build breakage
has been added to the -mm tree.  Its filename is
     fix-vm_events_fold_cpu-build-breakage.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix vm_events_fold_cpu() build breakage
From: Magnus Damm <damm@opensource.se>

fix vm_events_fold_cpu() build breakage

2.6.20-rc1 does not build properly if CONFIG_VM_EVENT_COUNTERS is set
and CONFIG_HOTPLUG is unset:

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
mm/built-in.o: In function `page_alloc_cpu_notify':
page_alloc.c:(.text+0x56eb): undefined reference to `vm_events_fold_cpu'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/vmstat.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/vmstat.h~fix-vm_events_fold_cpu-build-breakage include/linux/vmstat.h
--- a/include/linux/vmstat.h~fix-vm_events_fold_cpu-build-breakage
+++ a/include/linux/vmstat.h
@@ -81,7 +81,11 @@ static inline void count_vm_events(enum 
 }
 
 extern void all_vm_events(unsigned long *);
+#ifdef CONFIG_HOTPLUG
 extern void vm_events_fold_cpu(int cpu);
+#else
+#define vm_events_fold_cpu(x)	do { } while (0)
+#endif
 
 #else
 
_

Patches currently in -mm which might be from damm@opensource.se are

fix-vm_events_fold_cpu-build-breakage.patch

