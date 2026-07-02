Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C7334844C
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 23:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783033342; cv=none; b=kimYpKIWcbC+St6pe5k5CYC0VXWc3uPHSiwoyxZPjXp9f02sFRmvU+BmCREbY0mJcbxrKjuNlldVU/YskJIy6N1gojziDchCezSq0TBVPi395IyKI8VDvnTerAwDveZPypkbrP0fZRhtd627OrfRTiG56X9axD2fgtWpIjwteA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783033342; c=relaxed/simple;
	bh=u6IL7Jc3YfXmL3igZLj9kmyqTGKn3ifQKnLNqhsrP0M=;
	h=Date:To:From:Subject:Message-Id; b=J/uLYaYL9katEXOITQeQ/s2HiamK9XqcLSzNuJ6tHsG1G/NS/HI04V0Bq22AFEsrU7J4oDV8+5R/3yxXrh3MrLRgeLA8s84z7rPcGNr7otIGVS+5p4GXYBYLjliTP5FGm1MYCRSmKRUQkmpKFimlv7URKx7Wsg02nqqOjUYEIHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4hudTSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4hudTSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E76C1F000E9;
	Thu,  2 Jul 2026 23:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783033340;
	bh=XYskRYT8J9sme90n7DkzyBC7+rFdtw4f52vQYeKjwa4=;
	h=Date:To:From:Subject;
	b=V4hudTSplZEaxxUB2Z+2imxEysGAHLEewP11nn+eVdjIDLe2ht92fEqvi6io6Ibkv
	 uF2y8yEsqDnpMKNoe7IZ5x0r+q5UDDk4wmiaFqBBdcZqCwL+qdrmF+SP7x1dzPS7Fp
	 6ZJaYorhcSSmvWZshu+BUJym9nsri2bIMWg/gAxo=
Date: Thu, 02 Jul 2026 16:02:20 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,corbet@lwn.net,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + delaytop-sort-by-max-delay-to-highlight-top-latency-processes.patch added to mm-nonmm-unstable branch
Message-Id: <20260702230220.7E76C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: delaytop: sort by max delay to highlight top latency processes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delaytop-sort-by-max-delay-to-highlight-top-latency-processes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delaytop-sort-by-max-delay-to-highlight-top-latency-processes.patch

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
Subject: delaytop: sort by max delay to highlight top latency processes
Date: Thu, 2 Jul 2026 21:00:00 +0800 (CST)

When using -t/--type option, sort tasks by the maximum delay value of the
selected type in descending order (largest delay first).

This enables quickly identifying the top N processes with the highest
delay spikes, which is essential for diagnosing latency problems by
pinpointing which processes contributed most to system delays.

Link: https://lore.kernel.org/20260702210000676TkC9mShguDS_34k8M6AtP@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |   43 +++++++++
 tools/accounting/delaytop.c                   |   71 +++++++++++++---
 tools/accounting/getdelays.c                  |    5 +
 3 files changed, 108 insertions(+), 11 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~delaytop-sort-by-max-delay-to-highlight-top-latency-processes
+++ a/Documentation/accounting/delay-accounting.rst
@@ -212,3 +212,46 @@ Advanced usage examples::
 
 	# ./delaytop -d secs
 	Specify refresh interval as secs
+
+	# ./delaytop -t type
+	Display only specified delay type with avg/max/timestamp
+    (rows sorted by MAX for that type, largest first)
+
+
+
+delaytop add delay_max fields to track the maximum delay value for each delay type
+(cpu, blkio, irq, swapin, freepages, thrashing, compact, wpcopy) per task.
+
+	bash# ./delaytop -t cpu
+	System Pressure Information: (avg10/avg60/avg300/total)
+	CPU some:       0.4%/   0.2%/   0.1%/     220(ms)
+	CPU full:       0.0%/   0.0%/   0.0%/       0(ms)
+	Memory full:    0.0%/   0.0%/   0.0%/       0(ms)
+	Memory some:    0.0%/   0.0%/   0.0%/       0(ms)
+	IO full:        0.0%/   0.0%/   0.0%/      12(ms)
+	IO some:        0.0%/   0.0%/   0.0%/      13(ms)
+	IRQ full:       0.0%/   0.0%/   0.0%/       0(ms)
+	[q]quit
+	Top 20 processes (sorted by cpu MAX delay, largest first):
+	     PID      TGID  COMMAND          AVG(ms)  MAX(ms)   MAX_TIMESTAMP
+	------------------------------------------------------------------------
+	       9         9  kworker/0:0-eve   0.59   16.87  2026-05-27T13:32:39
+	      30        30  kworker/2:0H-kb   2.87   11.36  2026-05-27T13:32:36
+	      27        27  migration/2       1.05    9.51  2026-05-27T13:32:37
+	      50        50  kworker/2:1-eve   0.50    9.13  2026-05-27T13:32:37
+	      15        15  rcu_preempt       0.11    8.98  2026-05-27T13:32:37
+	       1         1  init              0.17    7.12  2026-05-27T13:32:38
+	      67        67  scsi_eh_0         1.20    4.23  2026-05-27T13:32:37
+	      23        23  ksoftirqd/1       1.12    3.77  2026-05-27T13:32:36
+	       3         3  pool_workqueue_   0.72    3.55  2026-05-27T13:32:38
+	      62        62  kworker/u20:2-a   0.49    3.03  2026-05-27T13:32:37
+	       2         2  kthreadd          0.18    2.82  2026-05-27T13:32:37
+	      11        11  kworker/0:1       1.42    2.76  2026-05-27T13:32:36
+	      39        39  kworker/u20:0-a   0.10    2.71  2026-05-27T13:32:38
+	      17        17  rcu_exp_gp_kthr   0.25    2.65  2026-05-27T13:32:37
+	      66        66  kworker/u20:3-e   0.38    2.55  2026-05-27T13:32:37
+	      20        20  cpuhp/0           0.53    2.51  2026-05-27T13:32:37
+	      28        28  ksoftirqd/2       0.59    2.48  2026-05-27T13:32:37
+	      55        55  kworker/u19:1     0.88    2.42  2026-05-27T13:32:37
+	      13        13  kworker/R-mm_pe   1.18    2.35  2026-05-27T13:32:36
+	      54        54  kworker/3:1-eve   0.14    2.20  2026-05-27T13:32:38
--- a/tools/accounting/delaytop.c~delaytop-sort-by-max-delay-to-highlight-top-latency-processes
+++ a/tools/accounting/delaytop.c
@@ -295,6 +295,7 @@ static void usage(void)
 	"  -C, --container=PATH     Monitor the container at specified cgroup path\n"
 	"  -s, --sort=FIELD         Sort by delay field (default: cpu)\n"
 	"  -t, --type=FIELD         Display only specified delay type with avg/max/timestamp\n"
+	"                           (rows sorted by MAX for that type, largest first)\n"
 	"  -M, --memverbose         Display memory detailed information\n");
 	exit(0);
 }
@@ -838,6 +839,15 @@ static void get_task_delays(void)
 	closedir(dir);
 }
 
+static void field_delay_max_and_ts(const struct task_info *task,
+				     const struct field_desc *field,
+				     unsigned long long *max_ns,
+				     struct __kernel_timespec *max_ts);
+static void get_field_delay_values(const struct task_info *task,
+				   const struct field_desc *field,
+				   double *avg_ms, double *max_ms,
+				   struct __kernel_timespec *max_ts);
+
 /* Calculate average delay in milliseconds */
 static double average_ms(unsigned long long total, unsigned long long count)
 {
@@ -850,7 +860,7 @@ static double average_ms(unsigned long l
  * Format __kernel_timespec to human readable string (YYYY-MM-DDTHH:MM:SS)
  * Returns formatted string or "N/A" if timestamp is zero
  */
-static const char *format_timespec64(struct __kernel_timespec *ts)
+static const char *format_kernel_timespec(struct __kernel_timespec *ts)
 {
 	static char buffer[32];
 	time_t time_sec;
@@ -891,6 +901,16 @@ static int compare_tasks(const void *a,
 	unsigned long long count1;
 	unsigned long long count2;
 	double avg1, avg2;
+	unsigned long long max1, max2;
+
+	/* -t/--type: default sort by MAX column for the selected type (descending) */
+	if (cfg.display_mode == MODE_TYPE && cfg.type_field) {
+		field_delay_max_and_ts(t1, cfg.type_field, &max1, NULL);
+		field_delay_max_and_ts(t2, cfg.type_field, &max2, NULL);
+		if (max1 != max2)
+			return max2 > max1 ? 1 : -1;
+		return 0;
+	}
 
 	total1 = *(unsigned long long *)((char *)t1 + cfg.sort_field->total_offset);
 	total2 = *(unsigned long long *)((char *)t2 + cfg.sort_field->total_offset);
@@ -905,6 +925,28 @@ static int compare_tasks(const void *a,
 	return 0;
 }
 
+/* Max delay (ns) and timestamp for field (shared by display and sort) */
+static void field_delay_max_and_ts(const struct task_info *task, const struct field_desc *field,
+				     unsigned long long *max_ns, struct __kernel_timespec *max_ts)
+{
+	if (!field || !field->max_offset) {
+		*max_ns = 0;
+		if (max_ts)
+			memset(max_ts, 0, sizeof(*max_ts));
+		return;
+	}
+
+	*max_ns = *(unsigned long long *)((char *)task + field->max_offset);
+
+	if (max_ts) {
+		if (field->max_ts_offset)
+			*max_ts = *(struct __kernel_timespec *)((char *)task +
+							       field->max_ts_offset);
+		else
+			memset(max_ts, 0, sizeof(*max_ts));
+	}
+}
+
 /* Get delay values for a specific field */
 static void get_field_delay_values(const struct task_info *task, const struct field_desc *field,
 				   double *avg_ms, double *max_ms,
@@ -923,13 +965,8 @@ static void get_field_delay_values(const
 	count = *(unsigned long long *)((char *)task + field->count_offset);
 	*avg_ms = average_ms(total, count);
 
-	max = *(unsigned long long *)((char *)task + field->max_offset);
+	field_delay_max_and_ts(task, field, &max, max_ts);
 	*max_ms = (double)max / 1000000.0;  /* Convert nanoseconds to milliseconds */
-
-	if (field->max_ts_offset)
-		*max_ts = *(struct __kernel_timespec *)((char *)task + field->max_ts_offset);
-	else
-		memset(max_ts, 0, sizeof(*max_ts));
 }
 
 /* Sort tasks by selected field */
@@ -1079,7 +1116,10 @@ static void display_results(int psi_ret)
 	}
 
 	/* Interacive command */
-	suc &= BOOL_FPRINT(out, "[o]sort [M]memverbose [q]quit\n");
+	if (cfg.display_mode == MODE_TYPE && cfg.type_field)
+		suc &= BOOL_FPRINT(out, "[q]quit\n");
+	else
+		suc &= BOOL_FPRINT(out, "[o]sort [M]memverbose [q]quit\n");
 	if (sort_selected) {
 		if (cfg.display_mode == MODE_MEMVERBOSE)
 			suc &= BOOL_FPRINT(out,
@@ -1090,8 +1130,13 @@ static void display_results(int psi_ret)
 	}
 
 	/* Task delay output */
-	suc &= BOOL_FPRINT(out, "Top %d processes (sorted by %s delay):\n",
-			cfg.max_processes, get_name_by_field(cfg.sort_field));
+	if (cfg.display_mode == MODE_TYPE && cfg.type_field)
+		suc &= BOOL_FPRINT(out,
+			"Top %d processes (sorted by %s MAX delay, largest first):\n",
+			cfg.max_processes, get_name_by_field(cfg.type_field));
+	else
+		suc &= BOOL_FPRINT(out, "Top %d processes (sorted by %s delay):\n",
+				cfg.max_processes, get_name_by_field(cfg.sort_field));
 
 	if (cfg.display_mode == MODE_TYPE && cfg.type_field) {
 		/* Display mode for -t option: show only specified type with avg/max/timestamp */
@@ -1132,7 +1177,7 @@ static void display_results(int psi_ret)
 					&max_ms, &max_ts);
 
 			suc &= BOOL_FPRINT(out, "%12.2f %12.2f %20s\n",
-				avg_ms, max_ms, format_timespec64(&max_ts));
+				avg_ms, max_ms, format_kernel_timespec(&max_ts));
 		} else if (cfg.display_mode == MODE_MEMVERBOSE) {
 			suc &= BOOL_FPRINT(out, DELAY_FMT_MEMVERBOSE,
 				TASK_AVG(tasks[i], mem),
@@ -1201,9 +1246,13 @@ static void handle_keypress(char ch, int
 	} else {
 		switch (ch) {
 		case 'o':
+			if (cfg.display_mode == MODE_TYPE)
+				break;
 			sort_selected = 1;
 			break;
 		case 'M':
+			if (cfg.display_mode == MODE_TYPE)
+				break;
 			toggle_display_mode();
 			for (field = sort_fields; field->name != NULL; field++) {
 				if (field->supported_modes & cfg.display_mode) {
--- a/tools/accounting/getdelays.c~delaytop-sort-by-max-delay-to-highlight-top-latency-processes
+++ a/tools/accounting/getdelays.c
@@ -235,6 +235,11 @@ static const char *format_timespec(struc
 	if (ts->tv_sec == 0 && ts->tv_nsec == 0)
 		return "N/A";
 
+	/* Avoid Y2038 truncation on 32-bit platforms */
+	if (sizeof(time_sec) < sizeof(ts->tv_sec) &&
+	    ts->tv_sec > (__u64)((1ULL << (sizeof(time_sec) * 8 - 1)) - 1))
+		return "N/A";
+
 	time_sec = ts->tv_sec;
 
 	/* Use thread-safe localtime_r */
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

delaytop-add-delay-max-for-delaytop.patch
delaytop-add-timestamp-of-delay-max.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes.patch

