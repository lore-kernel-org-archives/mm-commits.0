From: akpm@linux-foundation.org
Subject: + memory-controller-resource-counters-v7-fix.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:27:03 -0700
Message-ID: <200708311827.l7VIR8nk020732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932834AbXHaS1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     memory-controller-resource-counters-v7 fix
has been added to the -mm tree.  Its filename is
     memory-controller-resource-counters-v7-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory-controller-resource-counters-v7 fix
From: David Rientjes <rientjes@google.com>

There's a gotcha in res_counter_charge_locked() because of C99 6.3.1.8(1)
since both counter->limit and 'val' are of unsigned long type, the result
of the subtraction will be the same; no promotion is required.  So if
'val' is greater than counter->limit, it will always be larger than
counter->usage and the conditional will fail.  Simply casting this to
signed doesn't work since counter->usage is also unsigned and thus the
result of the subtraction will be promoted to unsigned since the ranks are
the same.

Even though the only (current) use of res_counter_charge() is with a 'val'
actual of 1, this still fails if you set counter->limit to 0.  No chance
of overflow unless you're running on a machine with 4KB pages and 16TB of
memory.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/res_counter.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/res_counter.c~memory-controller-resource-counters-v7-fix kernel/res_counter.c
--- a/kernel/res_counter.c~memory-controller-resource-counters-v7-fix
+++ a/kernel/res_counter.c
@@ -21,7 +21,7 @@ void res_counter_init(struct res_counter
 
 int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
 {
-	if (counter->usage > (counter->limit - val)) {
+	if (counter->usage + val > counter->limit) {
 		counter->failcnt++;
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
