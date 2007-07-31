From: akpm@linux-foundation.org
Subject: - idr_remove_all-kill-unused-variable.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:35 -0700
Message-ID: <200707312358.l6VNwZ3h029562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758967AbXHAAPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     idr_remove_all: kill unused variable
has been removed from the -mm tree.  Its filename was
     idr_remove_all-kill-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: idr_remove_all: kill unused variable
From: Oleg Nesterov <oleg@tv-sign.ru>

"error" is always equal to 0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~idr_remove_all-kill-unused-variable lib/idr.c
--- a/lib/idr.c~idr_remove_all-kill-unused-variable
+++ a/lib/idr.c
@@ -405,7 +405,7 @@ EXPORT_SYMBOL(idr_remove);
  */
 void idr_remove_all(struct idr *idp)
 {
-	int n, id, max, error = 0;
+	int n, id, max;
 	struct idr_layer *p;
 	struct idr_layer *pa[MAX_LEVEL];
 	struct idr_layer **paa = &pa[0];
@@ -415,7 +415,7 @@ void idr_remove_all(struct idr *idp)
 	max = 1 << n;
 
 	id = 0;
-	while (id < max && !error) {
+	while (id < max) {
 		while (n > IDR_BITS && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
fix-theoretical-ccids_readwrite_lock-race.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
