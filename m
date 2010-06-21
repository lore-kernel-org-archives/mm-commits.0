From: akpm@linux-foundation.org
Subject: + tmpfs-add-accurate-compare-function-to-percpu_counter-library.patch added to -mm tree
Date: Mon, 21 Jun 2010 13:19:57 -0700
Message-ID: <201006212019.o5LKJv3E002595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757848Ab0FUUUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 16:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.c.chen@linux.intel.com, hughd@google.com


The patch titled
     tmpfs: add accurate compare function to percpu_counter library
has been added to the -mm tree.  Its filename is
     tmpfs-add-accurate-compare-function-to-percpu_counter-library.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: add accurate compare function to percpu_counter library
From: Tim Chen <tim.c.chen@linux.intel.com>

Add percpu_counter_compare that allows for a quick but accurate comparison
of percpu_counter with a given value.

A rough count is provided by the count field in percpu_counter structure,
without accounting for the other values stored in individual cpu counters.
 The actual count is a sum of count and the cpu counters.  However, count
field is never different from the actual value by a factor of
batch*num_online_cpu.  We do not need to get actual count for comparison
if count is different from the given value by this factor and allows for
quick comparison without summing up all the per cpu counters.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   11 +++++++++++
 lib/percpu_counter.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff -puN include/linux/percpu_counter.h~tmpfs-add-accurate-compare-function-to-percpu_counter-library include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~tmpfs-add-accurate-compare-function-to-percpu_counter-library
+++ a/include/linux/percpu_counter.h
@@ -40,6 +40,7 @@ void percpu_counter_destroy(struct percp
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
+int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -98,6 +99,16 @@ static inline void percpu_counter_set(st
 	fbc->count = amount;
 }
 
+static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
+{
+	if (fbc->count > rhs)
+		return 1;
+	else if (fbc->count < rhs)
+		return -1;
+	else
+		return 0;
+}
+
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
diff -puN lib/percpu_counter.c~tmpfs-add-accurate-compare-function-to-percpu_counter-library lib/percpu_counter.c
--- a/lib/percpu_counter.c~tmpfs-add-accurate-compare-function-to-percpu_counter-library
+++ a/lib/percpu_counter.c
@@ -138,6 +138,33 @@ static int __cpuinit percpu_counter_hotc
 	return NOTIFY_OK;
 }
 
+/*
+ * Compare counter against given value.
+ * Return 1 if greater, 0 if equal and -1 if less
+ */
+int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
+{
+	s64	count;
+
+	count = percpu_counter_read(fbc);
+	/* Check to see if rough count will be sufficient for comparison */
+	if (abs(count - rhs) > (percpu_counter_batch*num_online_cpus())) {
+		if (count > rhs)
+			return 1;
+		else
+			return -1;
+	}
+	/* Need to use precise count */
+	count = percpu_counter_sum(fbc);
+	if (count > rhs)
+		return 1;
+	else if (count < rhs)
+		return -1;
+	else
+		return 0;
+}
+EXPORT_SYMBOL(percpu_counter_compare);
+
 static int __init percpu_counter_startup(void)
 {
 	compute_batch_value();
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

tmpfs-add-accurate-compare-function-to-percpu_counter-library.patch
tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks.patch

