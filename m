From: akpm@linux-foundation.org
Subject: + bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:56:02 -0800
Message-ID: <20120113225603.A5D3B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:53146 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2AMW4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:56:07 -0500
Received: by wgbdt14 with SMTP id dt14so109041wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:56:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de


The patch titled
     Subject: bitops: rename for_each_set_bit_cont() in favor of analogous list.h function
has been added to the -mm tree.  Its filename is
     bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -577,14 +577,14 @@ static bool __perf_sched_find_counter(st
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
Subject: Subject: bitops: rename for_each_set_bit_cont() in favor of analogous list.h function

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch

