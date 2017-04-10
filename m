From: akpm@linux-foundation.org
Subject: + trace-make-trace_hwlat-timestamp-y2038-safe.patch added to -mm
 tree
Date: Mon, 10 Apr 2017 15:34:15 -0700
Message-ID: <58ec0867.zrWxWcQuZ5yBJFRu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbdDJWeQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:34:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, mingo@redhat.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: trace: make trace_hwlat timestamp y2038 safe
has been added to the -mm tree.  Its filename is
     trace-make-trace_hwlat-timestamp-y2038-safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/trace-make-trace_hwlat-timestamp-y2038-safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/trace-make-trace_hwlat-timestamp-y2038-safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: trace: make trace_hwlat timestamp y2038 safe

struct timespec is not y2038 safe on 32 bit machines and needs to be
replaced by struct timespec64 in order to represent times beyond year 2038
on such machines.

Fix all the timestamp representation in struct trace_hwlat and all the
corresponding implementations.

Link: http://lkml.kernel.org/r/1491613030-11599-3-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_entries.h |    6 +++---
 kernel/trace/trace_hwlat.c   |   14 +++++++-------
 kernel/trace/trace_output.c  |    9 ++++-----
 3 files changed, 14 insertions(+), 15 deletions(-)

diff -puN kernel/trace/trace_entries.h~trace-make-trace_hwlat-timestamp-y2038-safe kernel/trace/trace_entries.h
--- a/kernel/trace/trace_entries.h~trace-make-trace_hwlat-timestamp-y2038-safe
+++ a/kernel/trace/trace_entries.h
@@ -348,14 +348,14 @@ FTRACE_ENTRY(hwlat, hwlat_entry,
 		__field(	u64,			duration	)
 		__field(	u64,			outer_duration	)
 		__field(	u64,			nmi_total_ts	)
-		__field_struct( struct timespec,	timestamp	)
-		__field_desc(	long,	timestamp,	tv_sec		)
+		__field_struct( struct timespec64,	timestamp	)
+		__field_desc(	s64,	timestamp,	tv_sec		)
 		__field_desc(	long,	timestamp,	tv_nsec		)
 		__field(	unsigned int,		nmi_count	)
 		__field(	unsigned int,		seqnum		)
 	),
 
-	F_printk("cnt:%u\tts:%010lu.%010lu\tinner:%llu\touter:%llunmi-ts:%llu\tnmi-count:%u\n",
+	F_printk("cnt:%u\tts:%010llu.%010lu\tinner:%llu\touter:%llunmi-ts:%llu\tnmi-count:%u\n",
 		 __entry->seqnum,
 		 __entry->tv_sec,
 		 __entry->tv_nsec,
diff -puN kernel/trace/trace_hwlat.c~trace-make-trace_hwlat-timestamp-y2038-safe kernel/trace/trace_hwlat.c
--- a/kernel/trace/trace_hwlat.c~trace-make-trace_hwlat-timestamp-y2038-safe
+++ a/kernel/trace/trace_hwlat.c
@@ -79,12 +79,12 @@ static u64 last_tracing_thresh = DEFAULT
 
 /* Individual latency samples are stored here when detected. */
 struct hwlat_sample {
-	u64		seqnum;		/* unique sequence */
-	u64		duration;	/* delta */
-	u64		outer_duration;	/* delta (outer loop) */
-	u64		nmi_total_ts;	/* Total time spent in NMIs */
-	struct timespec	timestamp;	/* wall time */
-	int		nmi_count;	/* # NMIs during this sample */
+	u64			seqnum;		/* unique sequence */
+	u64			duration;	/* delta */
+	u64			outer_duration;	/* delta (outer loop) */
+	u64			nmi_total_ts;	/* Total time spent in NMIs */
+	struct timespec64	timestamp;	/* wall time */
+	int			nmi_count;	/* # NMIs during this sample */
 };
 
 /* keep the global state somewhere. */
@@ -250,7 +250,7 @@ static int get_sample(void)
 		s.seqnum = hwlat_data.count;
 		s.duration = sample;
 		s.outer_duration = outer_sample;
-		s.timestamp = CURRENT_TIME;
+		ktime_get_real_ts64(&s.timestamp);
 		s.nmi_total_ts = nmi_total_ts;
 		s.nmi_count = nmi_count;
 		trace_hwlat_sample(&s);
diff -puN kernel/trace/trace_output.c~trace-make-trace_hwlat-timestamp-y2038-safe kernel/trace/trace_output.c
--- a/kernel/trace/trace_output.c~trace-make-trace_hwlat-timestamp-y2038-safe
+++ a/kernel/trace/trace_output.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2008 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/ftrace.h>
@@ -1161,11 +1160,11 @@ trace_hwlat_print(struct trace_iterator
 
 	trace_assign_type(field, entry);
 
-	trace_seq_printf(s, "#%-5u inner/outer(us): %4llu/%-5llu ts:%ld.%09ld",
+	trace_seq_printf(s, "#%-5u inner/outer(us): %4llu/%-5llu ts:%lld.%09ld",
 			 field->seqnum,
 			 field->duration,
 			 field->outer_duration,
-			 field->timestamp.tv_sec,
+			 (long long)field->timestamp.tv_sec,
 			 field->timestamp.tv_nsec);
 
 	if (field->nmi_count) {
@@ -1195,10 +1194,10 @@ trace_hwlat_raw(struct trace_iterator *i
 
 	trace_assign_type(field, iter->ent);
 
-	trace_seq_printf(s, "%llu %lld %ld %09ld %u\n",
+	trace_seq_printf(s, "%llu %lld %lld %09ld %u\n",
 			 field->duration,
 			 field->outer_duration,
-			 field->timestamp.tv_sec,
+			 (long long)field->timestamp.tv_sec,
 			 field->timestamp.tv_nsec,
 			 field->seqnum);
 
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch
trace-make-trace_hwlat-timestamp-y2038-safe.patch
fs-cifs-replace-current_time-by-other-appropriate-apis.patch
fs-ceph-current_time-with-ktime_get_real_ts.patch
fs-ufs-use-ktime_get_real_ts64-for-birthtime.patch
audit-use-timespec64-to-represent-audit-timestamps.patch
fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch
fs-ubifs-replace-current_time_sec-with-current_time.patch
lustre-replace-current_time-macro.patch
apparmorfs-replace-current_time-with-current_time.patch
time-delete-current_time_sec-and-current_time.patch
time-delete-current_fs_time-function.patch

