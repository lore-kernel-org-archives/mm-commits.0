Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53A347FFE
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 03:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785813176; cv=none; b=mRtRHKW/QGbO887aaz19lOccP/xZDIQnEN7X1M2/uVrgiNh0+ItFS7SoB/oH3ofdA5xMIyb79Cdw7KYV2MP5Ymtpj+Rixxvyqg4UhqtXwRR9nUB9imjwhA+iIiDCHN3eWS29Tdypa0TkToihiySRwPCNxjxIkB67QBCJnOfHHxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785813176; c=relaxed/simple;
	bh=yCocz9ERn8g8d+JxXA4K3mclLQ3iearyVjVB5XBQZy0=;
	h=Date:To:From:Subject:Message-Id; b=RDqfhVDamJGk1DSq3VqCpPXVeY1rhExd0sfKWLns9msz9S54WNIh+ykcmOssSebSKRUaK7okrHZRNo6tVAJAAtnV+kmnYNYSMZSkcweeqznIo04P0s5c4iYXadkXdmHMC7h5QSqu5yc78v+tcmXRyrdmMUvJpucTWdSruF+mjEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IIc0xUa5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IIc0xUa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3E01F00A3A;
	Tue,  4 Aug 2026 03:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785813158;
	bh=JdtWevxaGHgXR/aTfPAfAUHsEQbMSFKtbd/Xe+XgSQk=;
	h=Date:To:From:Subject;
	b=IIc0xUa5CWFTaBjPqWT4kFKdWz2tlZ7mGy3mvQ1sI04CDoxgsnURqV+kEI6pFS0v2
	 OvsMtrp560U0KJEVKnn3etOxaBnopTPOtTATkRnzgNofgE8+uTH9ng+UWUaxDdtVjg
	 YU0dlZaL3EfmLsNy80nUV5k7eiTTd1cE8Dhk6Lwo=
Date: Mon, 03 Aug 2026 20:12:38 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,corbet@lwn.net,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] delaytop-add-timestamp-of-delay-max.patch removed from -mm tree
Message-Id: <20260804031238.8C3E01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: delaytop: add timestamp of delay max
has been removed from the -mm tree.  Its filename was
     delaytop-add-timestamp-of-delay-max.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: delaytop: add timestamp of delay max
Date: Thu, 2 Jul 2026 20:58:54 +0800 (CST)

Record the wall-clock timestamp when each maximum delay occurred for all
delay types.  The timestamp is displayed in the MAX_TIMESTAMP column when
using -t/--type option.

This enables:
- Identifying the time when a process experienced an abnormal delay spike
- Correlating delay peaks across multiple processes at the same timestamp
- Cross-referencing with system logs, traces, or other metrics at that time
- Pinpointing the root cause of latency issues by finding concurrent events

Link: https://lore.kernel.org/20260702205854461V25Py2xQvLesD8HF_2Rh8@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/delaytop.c |   84 +++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 10 deletions(-)

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
@@ -827,6 +846,41 @@ static double average_ms(unsigned long l
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
+	if (sizeof(time_t) < sizeof(ts->tv_sec) &&
+	    ts->tv_sec > (__u64)((1ULL << (sizeof(time_t) * 8 - 1)) - 1))
+		return "N/A";
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
@@ -853,13 +907,15 @@ static int compare_tasks(const void *a,
 
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
 
@@ -869,6 +925,11 @@ static void get_field_delay_values(const
 
 	max = *(unsigned long long *)((char *)task + field->max_offset);
 	*max_ms = (double)max / 1000000.0;  /* Convert nanoseconds to milliseconds */
+
+	if (field->max_ts_offset)
+		*max_ts = *(struct __kernel_timespec *)((char *)task + field->max_ts_offset);
+	else
+		memset(max_ts, 0, sizeof(*max_ts));
 }
 
 /* Sort tasks by selected field */
@@ -1033,11 +1094,12 @@ static void display_results(int psi_ret)
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
@@ -1064,11 +1126,13 @@ static void display_results(int psi_ret)
 			tasks[i].pid, tasks[i].tgid, tasks[i].command);
 		if (cfg.display_mode == MODE_TYPE && cfg.type_field) {
 			double avg_ms, max_ms;
+			struct __kernel_timespec max_ts;
 
-			get_field_delay_values(&tasks[i], cfg.type_field, &avg_ms, &max_ms);
+			get_field_delay_values(&tasks[i], cfg.type_field, &avg_ms,
+					&max_ms, &max_ts);
 
-			suc &= BOOL_FPRINT(out, "%12.2f %12.2f\n",
-				avg_ms, max_ms);
+			suc &= BOOL_FPRINT(out, "%12.2f %12.2f %20s\n",
+				avg_ms, max_ms, format_timespec64(&max_ts));
 		} else if (cfg.display_mode == MODE_MEMVERBOSE) {
 			suc &= BOOL_FPRINT(out, DELAY_FMT_MEMVERBOSE,
 				TASK_AVG(tasks[i], mem),
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

delaytop-sort-by-max-delay-to-highlight-top-latency-processes.patch

