From: akpm@osdl.org
Subject: - fix-vm_events_fold_cpu-build-breakage.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:52 -0800
Message-ID: <200612230753.kBN7rq73010163@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbWLWHy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@opensource.se, clameter@engr.sgi.com, magnus@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     fix vm_events_fold_cpu() build breakage
has been removed from the -mm tree.  Its filename was
     fix-vm_events_fold_cpu-build-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@osdl.org: cleanup]
Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/vmstat.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/vmstat.h~fix-vm_events_fold_cpu-build-breakage include/linux/vmstat.h
--- a/include/linux/vmstat.h~fix-vm_events_fold_cpu-build-breakage
+++ a/include/linux/vmstat.h
@@ -74,7 +74,13 @@ static inline void count_vm_events(enum 
 }
 
 extern void all_vm_events(unsigned long *);
+#ifdef CONFIG_HOTPLUG
 extern void vm_events_fold_cpu(int cpu);
+#else
+static inline void vm_events_fold_cpu(int cpu)
+{
+}
+#endif
 
 #else
 
_

Patches currently in -mm which might be from damm@opensource.se are

origin.patch

