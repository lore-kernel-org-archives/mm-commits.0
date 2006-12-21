From: akpm@osdl.org
Subject: - fix-vm_events_fold_cpu-build-breakage-fix.patch removed from -mm tree
Date: Thu, 21 Dec 2006 14:22:36 -0800
Message-ID: <200612212222.kBLMMapk006886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46961 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423125AbWLUWWr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 17:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, clameter@engr.sgi.com, magnus@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     fix-vm_events_fold_cpu-build-breakage-fix
has been removed from the -mm tree.  Its filename was
     fix-vm_events_fold_cpu-build-breakage-fix.patch

This patch was dropped because it was folded into fix-vm_events_fold_cpu-build-breakage.patch

------------------------------------------------------
Subject: fix-vm_events_fold_cpu-build-breakage-fix
From: Andrew Morton <akpm@osdl.org>

Let's program in C.

Cc: Magnus Damm <magnus@valinux.co.jp>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/vmstat.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/vmstat.h~fix-vm_events_fold_cpu-build-breakage-fix include/linux/vmstat.h
--- a/include/linux/vmstat.h~fix-vm_events_fold_cpu-build-breakage-fix
+++ a/include/linux/vmstat.h
@@ -84,7 +84,9 @@ extern void all_vm_events(unsigned long 
 #ifdef CONFIG_HOTPLUG
 extern void vm_events_fold_cpu(int cpu);
 #else
-#define vm_events_fold_cpu(x)	do { } while (0)
+static inline void vm_events_fold_cpu(int cpu)
+{
+}
 #endif
 
 #else
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
truncate-clear-page-dirtiness-before-running-try_to_free_buffers.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
schedule_timeout-improve-warning-message.patch
relay-remove-inlining.patch
increase-cardbus_mem_size.patch

