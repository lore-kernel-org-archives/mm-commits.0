Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793408775;
	b=zL/rok6f8y4l28b8lGWdupti/JHpZA7uMGrz3YrAlP/pKyvCZBY084HrGc368+Jk1LsY
	 Ci0e4GULgcQwwuSrE58Wr9vkhySvTfWvgbqLTk5AJGqafJvo9fXl8xb4P+VEa+n1GsHPR
	 JwS9Ox4enOEoJxB9cNoD7GwKnMxacbDcKAyZdGTjocRxMxmTBwepEyMqaysTUJ08aKwa9
	 2wXoxizkiy5YPPkZKN8ac8xinmbT4vM5dBdJdMKCQoKvTW92kigQIgetrhNWsXnR1LCHW
	 n5INF7vIj3KvC3cqvcT/H+Nl98FxUsbIb5va7AP4DuWhHKCbmj/q7VteqK0k6d212Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793408775;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PedfzPMqkr5refej7pBn+1+2+5frmXxqB+6V0YMckxs=;
	b=eRmoUN8hqPaSAeup0J64PnzxATtRjdz/cj0bUYc4E8CsS/6vhyvm+DneNbtafa5xEWx6
	 25ategQVBrlYZUdBs+6DPK95i/nCnIlzkZucHhCqtfz484mAA8AgtLRPsfgiwfa6NelIu
	 HynLj8DvAMIFFfd4grd6JHlg+HAyiNDeLIE48R7vlHm7zT8MA0wBFvA0KP462v/0gV9Q0
	 E5c5l5opSMA32L13aTCY/gI+qynhS5RdDJ+ndmmoNky+Bw6ji/ud7SNokc/2hSnA28rur
	 Z5JnE9AdIZC0/lSmfJmcSQJbcFNVAntG9EAQH/IcnDgGOcYKE9qVBYbsgqtAp/YbsZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pnN+VX1T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B80606A323
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 01:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pnN+VX1T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FC31F000C1;
	Sat, 31 Oct 2026 01:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793408775;
	bh=PedfzPMqkr5refej7pBn+1+2+5frmXxqB+6V0YMckxs=;
	h=Date:To:From:Subject;
	b=pnN+VX1TAkxAv+CM2hmfbSuCTYBMyIGhTWqWTU8zWWkBSjpHSY8vDCBgg/Fhm5j8V
	 2fETwcbjxpbVB16z/irF6Xs/hygGdfzuU4cddxpQzqJbdyAAIn05t12vHeoChKd+p7
	 aeID19tnTOc6tq7eeZvFg5QVeBCaYxCP/MyvB/AE=
Date: Fri, 30 Oct 2026 18:06:14 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin@linux.dev,
	thomas.weissschuh@linutronix.de,fan.yu9@zte.com.cn,corbet@lwn.net,
	wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + delaytop-add-timestamp-of-delay-max.patch added to mm-nonmm-unstable branch
Message-Id: <20261031010614.E8FC31F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: delaytop: add timestamp of delay max
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delaytop-add-timestamp-of-delay-max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delaytop-add-timestamp-of-delay-max.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: delaytop: add timestamp of delay max
Date: Wed, 23 Sep 2026 21:04:32 +0800

Record the wall-clock timestamp when each maximum delay occurred for
all delay types. The timestamp is displayed in the MAX_TIMESTAMP column
when using -t/--type option.

This enables:
- Identifying the time when a process experienced an abnormal delay spike
- Correlating delay peaks across multiple processes at the same timestamp
- Cross-referencing with system logs, traces, or other metrics at that time
- Pinpointing the root cause of latency issues by finding concurrent events

Link: https://lore.kernel.org/202609232104322217DtZVWdYNJmwhuvwqdJqw@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xu Xin <xu.xin@linux.dev>
---

 tools/accounting/delaytop.c |   87 ++++++++++++++++++++++++++++++----
 1 file changed, 77 insertions(+), 10 deletions(-)

--- a/tools/accounting/delaytop.c~delaytop-add-timestamp-of-delay-max
+++ a/tools/accounting/delaytop.c
@@ -76,14 +76,16 @@
 	offsetof(struct task_info, name##_delay_total), \
 	offsetof(struct task_info, name##_count), \
 	offsetof(struct task_info, name##_delay_max), \
+	offsetof(struct task_info, name##_delay_max_ts), \
 	modes}
 #define SORT_FIELD_NO_MAX(name, cmd, modes) \
 	{#name, #cmd, \
 	offsetof(struct task_info, name##_delay_total), \
 	offsetof(struct task_info, name##_count), \
 	0, \
+	0, \
 	modes}
-#define END_FIELD {NULL, 0, 0, 0, 0, 0}
+#define END_FIELD {NULL, 0, 0, 0, 0, 0, 0}
 
 /* Display mode types */
 #define MODE_TYPE_ALL	(0xFFFFFFFF)
@@ -117,27 +119,35 @@ struct task_info {
 	unsigned long long cpu_count;
 	unsigned long long cpu_delay_total;
 	unsigned long long cpu_delay_max;
+	struct __kernel_timespec cpu_delay_max_ts;
 	unsigned long long blkio_count;
 	unsigned long long blkio_delay_total;
 	unsigned long long blkio_delay_max;
+	struct __kernel_timespec blkio_delay_max_ts;
 	unsigned long long swapin_count;
 	unsigned long long swapin_delay_total;
 	unsigned long long swapin_delay_max;
+	struct __kernel_timespec swapin_delay_max_ts;
 	unsigned long long freepages_count;
 	unsigned long long freepages_delay_total;
 	unsigned long long freepages_delay_max;
+	struct __kernel_timespec freepages_delay_max_ts;
 	unsigned long long thrashing_count;
 	unsigned long long thrashing_delay_total;
 	unsigned long long thrashing_delay_max;
+	struct __kernel_timespec thrashing_delay_max_ts;
 	unsigned long long compact_count;
 	unsigned long long compact_delay_total;
 	unsigned long long compact_delay_max;
+	struct __kernel_timespec compact_delay_max_ts;
 	unsigned long long wpcopy_count;
 	unsigned long long wpcopy_delay_total;
 	unsigned long long wpcopy_delay_max;
+	struct __kernel_timespec wpcopy_delay_max_ts;
 	unsigned long long irq_count;
 	unsigned long long irq_delay_total;
 	unsigned long long irq_delay_max;
+	struct __kernel_timespec irq_delay_max_ts;
 	unsigned long long mem_count;
 	unsigned long long mem_delay_total;
 };
@@ -158,6 +168,7 @@ struct field_desc {
 	unsigned long total_offset; /* Offset of total delay in task_info */
 	unsigned long count_offset; /* Offset of count in task_info */
 	unsigned long max_offset;  /* Offset of max delay in task_info */
+	unsigned long max_ts_offset; /* Offset of max delay timestamp in task_info */
 	size_t supported_modes; /* Supported display modes */
 };
 
@@ -283,7 +294,7 @@ static void usage(void)
 	"  -p, --pid=PID            Monitor only the specified PID\n"
 	"  -C, --container=PATH     Monitor the container at specified cgroup path\n"
 	"  -s, --sort=FIELD         Sort by delay field (default: cpu)\n"
-	"  -t, --type=FIELD         Display only specified delay type with avg/max\n"
+	"  -t, --type=FIELD         Display only specified delay type with avg/max/timestamp\n"
 	"  -M, --memverbose         Display memory detailed information\n");
 	exit(0);
 }
@@ -749,27 +760,35 @@ static void fetch_and_fill_task_info(int
 						SET_TASK_STAT(task_count, cpu_count);
 						SET_TASK_STAT(task_count, cpu_delay_total);
 						SET_TASK_STAT(task_count, cpu_delay_max);
+						SET_TASK_STAT(task_count, cpu_delay_max_ts);
 						SET_TASK_STAT(task_count, blkio_count);
 						SET_TASK_STAT(task_count, blkio_delay_total);
 						SET_TASK_STAT(task_count, blkio_delay_max);
+						SET_TASK_STAT(task_count, blkio_delay_max_ts);
 						SET_TASK_STAT(task_count, swapin_count);
 						SET_TASK_STAT(task_count, swapin_delay_total);
 						SET_TASK_STAT(task_count, swapin_delay_max);
+						SET_TASK_STAT(task_count, swapin_delay_max_ts);
 						SET_TASK_STAT(task_count, freepages_count);
 						SET_TASK_STAT(task_count, freepages_delay_total);
 						SET_TASK_STAT(task_count, freepages_delay_max);
+						SET_TASK_STAT(task_count, freepages_delay_max_ts);
 						SET_TASK_STAT(task_count, thrashing_count);
 						SET_TASK_STAT(task_count, thrashing_delay_total);
 						SET_TASK_STAT(task_count, thrashing_delay_max);
+						SET_TASK_STAT(task_count, thrashing_delay_max_ts);
 						SET_TASK_STAT(task_count, compact_count);
 						SET_TASK_STAT(task_count, compact_delay_total);
 						SET_TASK_STAT(task_count, compact_delay_max);
+						SET_TASK_STAT(task_count, compact_delay_max_ts);
 						SET_TASK_STAT(task_count, wpcopy_count);
 						SET_TASK_STAT(task_count, wpcopy_delay_total);
 						SET_TASK_STAT(task_count, wpcopy_delay_max);
+						SET_TASK_STAT(task_count, wpcopy_delay_max_ts);
 						SET_TASK_STAT(task_count, irq_count);
 						SET_TASK_STAT(task_count, irq_delay_total);
 						SET_TASK_STAT(task_count, irq_delay_max);
+						SET_TASK_STAT(task_count, irq_delay_max_ts);
 						set_mem_count(&tasks[task_count]);
 						set_mem_delay_total(&tasks[task_count]);
 						task_count++;
@@ -827,6 +846,44 @@ static double average_ms(unsigned long l
 	return (double)total / 1000000.0 / count;
 }
 
+/*
+ * Format __kernel_timespec to human readable string (YYYY-MM-DDTHH:MM:SS)
+ * Returns formatted string or "N/A" if timestamp is zero
+ */
+static const char *format_timespec64(struct __kernel_timespec *ts)
+{
+	static char buffer[32];
+	time_t time_sec;
+	struct tm tm_info;
+
+	/* Check if timestamp is zero (not set) */
+	if (ts->tv_sec == 0 && ts->tv_nsec == 0)
+		return "N/A";
+
+	/* Avoid Y2038 truncation: check if timestamp fits in time_t on 32-bit platforms */
+	if (sizeof(time_t) < sizeof(ts->tv_sec)) {
+		__s64 max = (__s64)((1ULL << (sizeof(time_t) * 8 - 1)) - 1);
+
+		if (ts->tv_sec > max || ts->tv_sec < -max - 1)
+			return "N/A";
+	}
+
+	time_sec = (time_t)ts->tv_sec;
+
+	if (localtime_r(&time_sec, &tm_info) == NULL)
+		return "N/A";
+
+	snprintf(buffer, sizeof(buffer), "%04d-%02d-%02dT%02d:%02d:%02d",
+		tm_info.tm_year + 1900,
+		tm_info.tm_mon + 1,
+		tm_info.tm_mday,
+		tm_info.tm_hour,
+		tm_info.tm_min,
+		tm_info.tm_sec);
+
+	return buffer;
+}
+
 /* Comparison function for sorting tasks */
 static int compare_tasks(const void *a, const void *b)
 {
@@ -853,13 +910,15 @@ static int compare_tasks(const void *a,
 
 /* Get delay values for a specific field */
 static void get_field_delay_values(const struct task_info *task, const struct field_desc *field,
-				   double *avg_ms, double *max_ms)
+				   double *avg_ms, double *max_ms,
+				   struct __kernel_timespec *max_ts)
 {
 	unsigned long long total, count, max;
 
 	if (!field || !field->max_offset) {
 		*avg_ms = 0;
 		*max_ms = 0;
+		memset(max_ts, 0, sizeof(*max_ts));
 		return;
 	}
 
@@ -869,6 +928,11 @@ static void get_field_delay_values(const
 
 	max = *(unsigned long long *)((char *)task + field->max_offset);
 	*max_ms = (double)max / 1000000.0;  /* Convert nanoseconds to milliseconds */
+
+	if (field->max_ts_offset)
+		*max_ts = *(struct __kernel_timespec *)((char *)task + field->max_ts_offset);
+	else
+		memset(max_ts, 0, sizeof(*max_ts));
 }
 
 /* Sort tasks by selected field */
@@ -1033,11 +1097,12 @@ static void display_results(int psi_ret)
 			cfg.max_processes, get_name_by_field(cfg.sort_field));
 
 	if (cfg.display_mode == MODE_TYPE && cfg.type_field) {
-		/* Display mode for -t option: show only specified type with avg/max */
-		suc &= BOOL_FPRINT(out, "%8s  %8s  %-17s %12s %12s\n",
+		/* Display mode for -t option: show only specified type with avg/max/timestamp */
+		suc &= BOOL_FPRINT(out, "%8s  %8s  %-17s %12s %12s %20s\n",
 			"PID", "TGID", "COMMAND",
-			"AVG(ms)", "MAX(ms)");
-		suc &= BOOL_FPRINT(out, "----------------------------------------------------\n");
+			"AVG(ms)", "MAX(ms)", "MAX_TIMESTAMP");
+		suc &= BOOL_FPRINT(out, "--------------------------------------------------------");
+		suc &= BOOL_FPRINT(out, "----------------------------------------\n");
 	} else {
 		suc &= BOOL_FPRINT(out, "%8s  %8s  %-17s", "PID", "TGID", "COMMAND");
 		if (cfg.display_mode == MODE_MEMVERBOSE) {
@@ -1064,11 +1129,13 @@ static void display_results(int psi_ret)
 			tasks[i].pid, tasks[i].tgid, tasks[i].command);
 		if (cfg.display_mode == MODE_TYPE && cfg.type_field) {
 			double avg_ms, max_ms;
+			struct __kernel_timespec max_ts;
 
-			get_field_delay_values(&tasks[i], cfg.type_field, &avg_ms, &max_ms);
+			get_field_delay_values(&tasks[i], cfg.type_field, &avg_ms,
+					&max_ms, &max_ts);
 
-			suc &= BOOL_FPRINT(out, " %12.2f %12.2f\n",
-				avg_ms, max_ms);
+			suc &= BOOL_FPRINT(out, " %12.2f %12.2f %20s\n",
+				avg_ms, max_ms, format_timespec64(&max_ts));
 		} else if (cfg.display_mode == MODE_MEMVERBOSE) {
 			suc &= BOOL_FPRINT(out, DELAY_FMT_MEMVERBOSE,
 				TASK_AVG(tasks[i], mem),
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

delaytop-add-delay-max-for-delaytop.patch
delaytop-add-timestamp-of-delay-max.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes.patch

