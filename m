From: akpm@linux-foundation.org
Subject: [merged] bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:10 -0700
Message-ID: <20120326192910.814FEA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55374 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab2CZT3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:12 -0400
Received: by mail-bk0-f74.google.com with SMTP id jm19so288130bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: rename for_each_set_bit_cont() in favor of analogous list.h function
has been removed from the -mm tree.  Its filename was
     bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: bitops: rename for_each_set_bit_cont() in favor of analogous list.h function

This renames for_each_set_bit_cont() to for_each_set_bit_from() because it
is analogous to list_for_each_entry_from() in list.h rather than
list_for_each_entry_continue().

This doesn't remove for_each_set_bit_cont() for now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event.c       |    4 ++--
 include/linux/bitops.h                 |    5 ++++-
 tools/perf/util/include/linux/bitops.h |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event.c~bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function arch/x86/kernel/cpu/perf_event.c
--- a/arch/x86/kernel/cpu/perf_event.c~bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function
+++ a/arch/x86/kernel/cpu/perf_event.c
@@ -643,14 +643,14 @@ static bool __perf_sched_find_counter(st
 	/* Prefer fixed purpose counters */
 	if (x86_pmu.num_counters_fixed) {
 		idx = X86_PMC_IDX_FIXED;
-		for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_MAX) {
+		for_each_set_bit_from(idx, c->idxmsk, X86_PMC_IDX_MAX) {
 			if (!__test_and_set_bit(idx, sched->state.used))
 				goto done;
 		}
 	}
 	/* Grab the first unused counter starting with idx */
 	idx = sched->state.counter;
-	for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_FIXED) {
+	for_each_set_bit_from(idx, c->idxmsk, X86_PMC_IDX_FIXED) {
 		if (!__test_and_set_bit(idx, sched->state.used))
 			goto done;
 	}
diff -puN include/linux/bitops.h~bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function
+++ a/include/linux/bitops.h
@@ -27,11 +27,14 @@ extern unsigned long __sw_hweight64(__u6
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
 /* same as for_each_set_bit() but use bit as value to start with */
-#define for_each_set_bit_cont(bit, addr, size) \
+#define for_each_set_bit_from(bit, addr, size) \
 	for ((bit) = find_next_bit((addr), (size), (bit));	\
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
+#define for_each_set_bit_cont(bit, addr, size) \
+	for_each_set_bit_from(bit, addr, size)
+
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
diff -puN tools/perf/util/include/linux/bitops.h~bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function tools/perf/util/include/linux/bitops.h
--- a/tools/perf/util/include/linux/bitops.h~bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function
+++ a/tools/perf/util/include/linux/bitops.h
@@ -15,7 +15,7 @@
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
 /* same as for_each_set_bit() but use bit as value to start with */
-#define for_each_set_bit_cont(bit, addr, size) \
+#define for_each_set_bit_from(bit, addr, size) \
 	for ((bit) = find_next_bit((addr), (size), (bit));	\
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
sysctl-use-bitmap-library-functions.patch

