Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33D3376A08
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 03:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785813170; cv=none; b=NAiv4l4xRs9JzQZE//xeu7STHRaenTegDmmLJqBCJp0DlNLZXTZVYKcAUatpL2DoTDJA+3/RLM1RTqX04aYDtgrEE9dHIQzkp+QrLlC+jFWPHdULyECUlu54/q5ddPEBrOwe4o9QRwt9rpd6ZN5hbnnsF2Kl5MOYB5SLsPnUl1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785813170; c=relaxed/simple;
	bh=WPFVHJLYuVeg4nPrZSj/n0K+2gC/otXpCEmrIUZplPw=;
	h=Date:To:From:Subject:Message-Id; b=QpPkb2QdOAa50NbI4X1tzLq3+ocY+S3YC92DJ18LBJ6BQo1ZRCgSVQMF4MYvl6bkajT2wgIj21YDSRhkrl5cDDM7UD1no726frj95+pk0KcLnVC4621iNY2SrH8syQpCvrqYmo/NoSu09pGxAi/tQ7dZKGOUC+JN+OWh+kyMu74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IgrP3Mmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgrP3Mmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0C11F000E9;
	Tue,  4 Aug 2026 03:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785813157;
	bh=SliG5lqq4YmI3/O9Jpi1KlDysvK2wi82Fq6W9LBjjj0=;
	h=Date:To:From:Subject;
	b=IgrP3MmyTS69WZ1nOS2/hQs5d06e8bueeojS8oDWXaewj6zYxuR3zcsKcnEbExDk2
	 39x47Ye6bF/kTjBuIB5p6B0F1mAOGV0DgvsFQ2HnOe7E9DpvJZ0KRpEcsYP+fG8xsM
	 C6QzBPkaWvFwDdT90dKLsD4gmiy7s61tOr8tuMNc=
Date: Mon, 03 Aug 2026 20:12:37 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,corbet@lwn.net,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] delaytop-add-delay-max-for-delaytop.patch removed from -mm tree
Message-Id: <20260804031237.6E0C11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: delaytop: add delay max for delaytop
has been removed from the -mm tree.  Its filename was
     delaytop-add-delay-max-for-delaytop.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: delaytop: add delay max for delaytop
Date: Thu, 2 Jul 2026 20:58:15 +0800 (CST)

Patch series "delaytop: add delay max, timestamp and sorting for top
latency analysis".

Previously delaytop only showed average delays. This patch adds:

1. delay_max fields to track the maximum delay value for each delay type
   (cpu, blkio, irq, swapin, freepages, thrashing, compact, wpcopy)
   per task.

2. The -t/--type option displays only the specified delay type with avg/max
   values side by side, allowing focused analysis:
     delaytop -t cpu    # Show only CPU delay with avg/max
     delaytop -t wpcopy # Show Copy-on-Write delay with avg/max

3. Wall-clock timestamp when each maximum delay occurred, displayed in the
   MAX_TIMESTAMP column when using -t/--type option. This enables:
   - Identifying the time when a process experienced an abnormal delay max
   - Correlating delay max across multiple processes at the same timestamp
   - Cross-referencing with logs, traces, or other metrics at that time

4. When using -t/--type option, tasks are sorted by maximum delay value in
   descending order (largest delay first), enabling quick identification of
   top N processes with highest delay spikes.


This patch (of 3):

Previously delaytop only showed average delays.  Add delay_max fields to
track the maximum delay value for each delay type (cpu, blkio, irq,
swapin, freepages, thrashing, compact, wpcopy) per task.

This provides a global view of all tasks' delay spikes, which is essential
for identifying processes that experienced brief but significant latency
events that would be hidden by average-only metrics.

The -t/--type option displays only the specified delay type with avg/max
values side by side, allowing focused analysis:
  delaytop -t cpu    # Show only CPU delay with avg/max
  delaytop -t wpcopy    # Show Copy-on-Write delay with avg/max

Link: https://lore.kernel.org/20260702205704180NZ3cu_QF04KfBIL6vjTHL@zte.com.cn
Link: https://lore.kernel.org/202607022058152607Y25X-YgssuvncpVNHljz@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/delaytop.c |  165 ++++++++++++++++++++++++++--------
 1 file changed, 131 insertions(+), 34 deletions(-)

--- a/tools/accounting/delaytop.c~delaytop-add-delay-max-for-delaytop
+++ a/tools/accounting/delaytop.c
@@ -75,13 +75,21 @@
 	{#name, #cmd, \
 	offsetof(struct task_info, name##_delay_total), \
 	offsetof(struct task_info, name##_count), \
+	offsetof(struct task_info, name##_delay_max), \
 	modes}
-#define END_FIELD {NULL, 0, 0}
+#define SORT_FIELD_NO_MAX(name, cmd, modes) \
+	{#name, #cmd, \
+	offsetof(struct task_info, name##_delay_total), \
+	offsetof(struct task_info, name##_count), \
+	0, \
+	modes}
+#define END_FIELD {NULL, 0, 0, 0, 0, 0}
 
 /* Display mode types */
 #define MODE_TYPE_ALL	(0xFFFFFFFF)
 #define MODE_DEFAULT	(1 << 0)
 #define MODE_MEMVERBOSE	(1 << 1)
+#define MODE_TYPE	(1 << 2)	/* Display specific type with avg/max */
 
 /* PSI statistics structure */
 struct psi_stats {
@@ -108,20 +116,28 @@ struct task_info {
 	char command[TASK_COMM_LEN];
 	unsigned long long cpu_count;
 	unsigned long long cpu_delay_total;
+	unsigned long long cpu_delay_max;
 	unsigned long long blkio_count;
 	unsigned long long blkio_delay_total;
+	unsigned long long blkio_delay_max;
 	unsigned long long swapin_count;
 	unsigned long long swapin_delay_total;
+	unsigned long long swapin_delay_max;
 	unsigned long long freepages_count;
 	unsigned long long freepages_delay_total;
+	unsigned long long freepages_delay_max;
 	unsigned long long thrashing_count;
 	unsigned long long thrashing_delay_total;
+	unsigned long long thrashing_delay_max;
 	unsigned long long compact_count;
 	unsigned long long compact_delay_total;
+	unsigned long long compact_delay_max;
 	unsigned long long wpcopy_count;
 	unsigned long long wpcopy_delay_total;
+	unsigned long long wpcopy_delay_max;
 	unsigned long long irq_count;
 	unsigned long long irq_delay_total;
+	unsigned long long irq_delay_max;
 	unsigned long long mem_count;
 	unsigned long long mem_delay_total;
 };
@@ -141,6 +157,7 @@ struct field_desc {
 	const char *cmd_char;	/* Interactive command */
 	unsigned long total_offset; /* Offset of total delay in task_info */
 	unsigned long count_offset; /* Offset of count in task_info */
+	unsigned long max_offset;  /* Offset of max delay in task_info */
 	size_t supported_modes; /* Supported display modes */
 };
 
@@ -153,6 +170,7 @@ struct config {
 	int monitor_pid;		/* Monitor specific PID */
 	char *container_path;	/* Path to container cgroup */
 	const struct field_desc *sort_field;	/* Current sort field */
+	const struct field_desc *type_field;	/* Type field for -t option */
 	size_t display_mode;	/* Current display mode */
 };
 
@@ -164,15 +182,15 @@ static int task_count;
 static int running = 1;
 static struct container_stats container_stats;
 static const struct field_desc sort_fields[] = {
-	SORT_FIELD(cpu,		c,	MODE_DEFAULT),
-	SORT_FIELD(blkio,	i,	MODE_DEFAULT),
-	SORT_FIELD(irq,		q,	MODE_DEFAULT),
-	SORT_FIELD(mem,		m,	MODE_DEFAULT | MODE_MEMVERBOSE),
-	SORT_FIELD(swapin,	s,	MODE_MEMVERBOSE),
-	SORT_FIELD(freepages,	r,	MODE_MEMVERBOSE),
-	SORT_FIELD(thrashing,	t,	MODE_MEMVERBOSE),
-	SORT_FIELD(compact,	p,	MODE_MEMVERBOSE),
-	SORT_FIELD(wpcopy,	w,	MODE_MEMVERBOSE),
+	SORT_FIELD(cpu,		c,	MODE_DEFAULT | MODE_TYPE),
+	SORT_FIELD(blkio,	i,	MODE_DEFAULT | MODE_TYPE),
+	SORT_FIELD(irq,		q,	MODE_DEFAULT | MODE_TYPE),
+	SORT_FIELD_NO_MAX(mem,	m,	MODE_DEFAULT | MODE_MEMVERBOSE),
+	SORT_FIELD(swapin,	s,	MODE_MEMVERBOSE | MODE_TYPE),
+	SORT_FIELD(freepages,	r,	MODE_MEMVERBOSE | MODE_TYPE),
+	SORT_FIELD(thrashing,	t,	MODE_MEMVERBOSE | MODE_TYPE),
+	SORT_FIELD(compact,	p,	MODE_MEMVERBOSE | MODE_TYPE),
+	SORT_FIELD(wpcopy,	w,	MODE_MEMVERBOSE | MODE_TYPE),
 	END_FIELD
 };
 static int sort_selected;
@@ -265,6 +283,7 @@ static void usage(void)
 	"  -p, --pid=PID            Monitor only the specified PID\n"
 	"  -C, --container=PATH     Monitor the container at specified cgroup path\n"
 	"  -s, --sort=FIELD         Sort by delay field (default: cpu)\n"
+	"  -t, --type=FIELD         Display only specified delay type with avg/max\n"
 	"  -M, --memverbose         Display memory detailed information\n");
 	exit(0);
 }
@@ -283,6 +302,7 @@ static void parse_args(int argc, char **
 		{"processes", required_argument, 0, 'P'},
 		{"sort", required_argument, 0, 's'},
 		{"container", required_argument, 0, 'C'},
+		{"type", required_argument, 0, 't'},
 		{"memverbose", no_argument, 0, 'M'},
 		{0, 0, 0, 0}
 	};
@@ -292,6 +312,7 @@ static void parse_args(int argc, char **
 	cfg.iterations = 0;
 	cfg.max_processes = 20;
 	cfg.sort_field = &sort_fields[0];	/* Default sorted by CPU delay */
+	cfg.type_field = NULL;				/* No type field by default */
 	cfg.output_one_time = 0;
 	cfg.monitor_pid = 0;	/* 0 means monitor all PIDs */
 	cfg.container_path = NULL;
@@ -300,7 +321,7 @@ static void parse_args(int argc, char **
 	while (1) {
 		int option_index = 0;
 
-		c = getopt_long(argc, argv, "hd:n:p:oP:C:s:M", long_options, &option_index);
+		c = getopt_long(argc, argv, "hd:n:p:oP:C:s:t:M", long_options, &option_index);
 		if (c == -1)
 			break;
 
@@ -363,9 +384,32 @@ static void parse_args(int argc, char **
 
 			cfg.sort_field = field;
 			break;
+		case 't':
+			if (strlen(optarg) == 0) {
+				fprintf(stderr, "Error: empty type field\n");
+				exit(1);
+			}
+
+			field = get_field_by_name(optarg);
+			/* Show available fields if invalid option provided */
+			if (!field || !(field->supported_modes & MODE_TYPE)) {
+				fprintf(stderr, "Error: invalid type field '%s'\n", optarg);
+				display_available_fields(MODE_TYPE);
+				exit(1);
+			}
+
+			cfg.type_field = field;
+			cfg.display_mode = MODE_TYPE;
+			break;
 		case 'M':
 			cfg.display_mode = MODE_MEMVERBOSE;
-			cfg.sort_field = get_field_by_name("mem");
+			/* Find first field supporting MODE_MEMVERBOSE for sorting */
+			for (field = sort_fields; field->name != NULL; field++) {
+				if (field->supported_modes & MODE_MEMVERBOSE) {
+					cfg.sort_field = field;
+					break;
+				}
+			}
 			break;
 		default:
 			fprintf(stderr, "Try 'delaytop --help' for more information.\n");
@@ -690,7 +734,12 @@ static void fetch_and_fill_task_info(int
 			nested_len = NLA_PAYLOAD(na->nla_len);
 			while (nested_len > 0) {
 				if (nested->nla_type == TASKSTATS_TYPE_STATS) {
-					memcpy(&stats, NLA_DATA(nested), sizeof(stats));
+					size_t payload_len = NLA_PAYLOAD(nested->nla_len);
+
+					memset(&stats, 0, sizeof(stats));
+					if (payload_len > sizeof(stats))
+						payload_len = sizeof(stats);
+					memcpy(&stats, NLA_DATA(nested), payload_len);
 					if (task_count < MAX_TASKS) {
 						tasks[task_count].pid = pid;
 						tasks[task_count].tgid = pid;
@@ -699,20 +748,28 @@ static void fetch_and_fill_task_info(int
 						tasks[task_count].command[TASK_COMM_LEN - 1] = '\0';
 						SET_TASK_STAT(task_count, cpu_count);
 						SET_TASK_STAT(task_count, cpu_delay_total);
+						SET_TASK_STAT(task_count, cpu_delay_max);
 						SET_TASK_STAT(task_count, blkio_count);
 						SET_TASK_STAT(task_count, blkio_delay_total);
+						SET_TASK_STAT(task_count, blkio_delay_max);
 						SET_TASK_STAT(task_count, swapin_count);
 						SET_TASK_STAT(task_count, swapin_delay_total);
+						SET_TASK_STAT(task_count, swapin_delay_max);
 						SET_TASK_STAT(task_count, freepages_count);
 						SET_TASK_STAT(task_count, freepages_delay_total);
+						SET_TASK_STAT(task_count, freepages_delay_max);
 						SET_TASK_STAT(task_count, thrashing_count);
 						SET_TASK_STAT(task_count, thrashing_delay_total);
+						SET_TASK_STAT(task_count, thrashing_delay_max);
 						SET_TASK_STAT(task_count, compact_count);
 						SET_TASK_STAT(task_count, compact_delay_total);
+						SET_TASK_STAT(task_count, compact_delay_max);
 						SET_TASK_STAT(task_count, wpcopy_count);
 						SET_TASK_STAT(task_count, wpcopy_delay_total);
+						SET_TASK_STAT(task_count, wpcopy_delay_max);
 						SET_TASK_STAT(task_count, irq_count);
 						SET_TASK_STAT(task_count, irq_delay_total);
+						SET_TASK_STAT(task_count, irq_delay_max);
 						set_mem_count(&tasks[task_count]);
 						set_mem_delay_total(&tasks[task_count]);
 						task_count++;
@@ -777,14 +834,14 @@ static int compare_tasks(const void *a,
 	const struct task_info *t2 = (const struct task_info *)b;
 	unsigned long long total1;
 	unsigned long long total2;
-	unsigned long count1;
-	unsigned long count2;
+	unsigned long long count1;
+	unsigned long long count2;
 	double avg1, avg2;
 
 	total1 = *(unsigned long long *)((char *)t1 + cfg.sort_field->total_offset);
 	total2 = *(unsigned long long *)((char *)t2 + cfg.sort_field->total_offset);
-	count1 = *(unsigned long *)((char *)t1 + cfg.sort_field->count_offset);
-	count2 = *(unsigned long *)((char *)t2 + cfg.sort_field->count_offset);
+	count1 = *(unsigned long long *)((char *)t1 + cfg.sort_field->count_offset);
+	count2 = *(unsigned long long *)((char *)t2 + cfg.sort_field->count_offset);
 
 	avg1 = average_ms(total1, count1);
 	avg2 = average_ms(total2, count2);
@@ -794,6 +851,26 @@ static int compare_tasks(const void *a,
 	return 0;
 }
 
+/* Get delay values for a specific field */
+static void get_field_delay_values(const struct task_info *task, const struct field_desc *field,
+				   double *avg_ms, double *max_ms)
+{
+	unsigned long long total, count, max;
+
+	if (!field || !field->max_offset) {
+		*avg_ms = 0;
+		*max_ms = 0;
+		return;
+	}
+
+	total = *(unsigned long long *)((char *)task + field->total_offset);
+	count = *(unsigned long long *)((char *)task + field->count_offset);
+	*avg_ms = average_ms(total, count);
+
+	max = *(unsigned long long *)((char *)task + field->max_offset);
+	*max_ms = (double)max / 1000000.0;  /* Convert nanoseconds to milliseconds */
+}
+
 /* Sort tasks by selected field */
 static void sort_tasks(void)
 {
@@ -847,7 +924,12 @@ static void get_container_stats(void)
 	while (nl_len > 0) {
 		if (na->nla_type == CGROUPSTATS_TYPE_CGROUP_STATS) {
 			/* Get the cgroupstats structure */
-			memcpy(&stats, NLA_DATA(na), sizeof(stats));
+			size_t payload_len = NLA_PAYLOAD(na->nla_len);
+
+			memset(&stats, 0, sizeof(stats));
+			if (payload_len > sizeof(stats))
+				payload_len = sizeof(stats);
+			memcpy(&stats, NLA_DATA(na), payload_len);
 
 			/* Fill container stats */
 			container_stats.nr_sleeping = stats.nr_sleeping;
@@ -950,29 +1032,44 @@ static void display_results(int psi_ret)
 	suc &= BOOL_FPRINT(out, "Top %d processes (sorted by %s delay):\n",
 			cfg.max_processes, get_name_by_field(cfg.sort_field));
 
-	suc &= BOOL_FPRINT(out, "%8s  %8s  %-17s", "PID", "TGID", "COMMAND");
-	if (cfg.display_mode == MODE_MEMVERBOSE) {
-		suc &= BOOL_FPRINT(out, "%8s %8s %8s %8s %8s %8s\n",
-			"MEM(ms)", "SWAP(ms)", "RCL(ms)",
-			"THR(ms)", "CMP(ms)", "WP(ms)");
-		suc &= BOOL_FPRINT(out, "-----------------------");
-		suc &= BOOL_FPRINT(out, "-----------------------");
-		suc &= BOOL_FPRINT(out, "-----------------------");
-		suc &= BOOL_FPRINT(out, "---------------------\n");
+	if (cfg.display_mode == MODE_TYPE && cfg.type_field) {
+		/* Display mode for -t option: show only specified type with avg/max */
+		suc &= BOOL_FPRINT(out, "%8s  %8s  %-17s %12s %12s\n",
+			"PID", "TGID", "COMMAND",
+			"AVG(ms)", "MAX(ms)");
+		suc &= BOOL_FPRINT(out, "----------------------------------------------------\n");
 	} else {
-		suc &= BOOL_FPRINT(out, "%8s %8s %8s %8s\n",
-			"CPU(ms)", "IO(ms)", "IRQ(ms)", "MEM(ms)");
-		suc &= BOOL_FPRINT(out, "-----------------------");
-		suc &= BOOL_FPRINT(out, "-----------------------");
-		suc &= BOOL_FPRINT(out, "--------------------------\n");
+		suc &= BOOL_FPRINT(out, "%8s  %8s  %-17s", "PID", "TGID", "COMMAND");
+		if (cfg.display_mode == MODE_MEMVERBOSE) {
+			suc &= BOOL_FPRINT(out, "%8s %8s %8s %8s %8s %8s\n",
+				"MEM(ms)", "SWAP(ms)", "RCL(ms)",
+				"THR(ms)", "CMP(ms)", "WP(ms)");
+			suc &= BOOL_FPRINT(out, "-----------------------");
+			suc &= BOOL_FPRINT(out, "-----------------------");
+			suc &= BOOL_FPRINT(out, "-----------------------");
+			suc &= BOOL_FPRINT(out, "---------------------\n");
+		} else {
+			suc &= BOOL_FPRINT(out, "%8s %8s %8s %8s\n",
+				"CPU(ms)", "IO(ms)", "IRQ(ms)", "MEM(ms)");
+			suc &= BOOL_FPRINT(out, "-----------------------");
+			suc &= BOOL_FPRINT(out, "-----------------------");
+			suc &= BOOL_FPRINT(out, "--------------------------\n");
+		}
 	}
 
 	count = task_count < cfg.max_processes ? task_count : cfg.max_processes;
 
 	for (i = 0; i < count; i++) {
-		suc &= BOOL_FPRINT(out, "%8d  %8d  %-15s",
+		suc &= BOOL_FPRINT(out, "%8d  %8d  %-17s",
 			tasks[i].pid, tasks[i].tgid, tasks[i].command);
-		if (cfg.display_mode == MODE_MEMVERBOSE) {
+		if (cfg.display_mode == MODE_TYPE && cfg.type_field) {
+			double avg_ms, max_ms;
+
+			get_field_delay_values(&tasks[i], cfg.type_field, &avg_ms, &max_ms);
+
+			suc &= BOOL_FPRINT(out, "%12.2f %12.2f\n",
+				avg_ms, max_ms);
+		} else if (cfg.display_mode == MODE_MEMVERBOSE) {
 			suc &= BOOL_FPRINT(out, DELAY_FMT_MEMVERBOSE,
 				TASK_AVG(tasks[i], mem),
 				TASK_AVG(tasks[i], swapin),
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

delaytop-add-timestamp-of-delay-max.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes.patch

