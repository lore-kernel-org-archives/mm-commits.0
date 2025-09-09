Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C14C2D7DED
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 04:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757391116; cv=none; b=qD2IEEu4Omwt0Q88Hp6Qbf8qU2pTi5LkDFTRFlWgZ4hdoxe1HcUcot5bkfN6gWe9oro/5pGjlE8Wh6PU0bHS7ce2iR5yRqZCZaMh53kHIfKNF5Y1YQF0YwIm1DphmJGXzpDfOhKTGAvBdw17/pmxyGPm12VbQFnqjy3rt3VTNAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757391116; c=relaxed/simple;
	bh=ogGFTUri0JOiFMGTnm1/x57SGv3iX7nQGW+r3RW6g8c=;
	h=Date:To:From:Subject:Message-Id; b=lRlgzmIuPJSglKNJ9ZjBL1bRQkeOPLuLLub8DVZ5U8oOMSHWWLabqcqBrPRO85pE/AZcTVZK2mfigDcekmWOh2oaDfG6aWPl7lTAsNawivAjVHyd9G8oUAE9DP1ZhpfKTSy4ArqxTrViyf8IEFGp2Lki7/+jTT4KGYTX17SlRDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zbIvCmEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zbIvCmEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F59C4CEF4;
	Tue,  9 Sep 2025 04:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757391115;
	bh=ogGFTUri0JOiFMGTnm1/x57SGv3iX7nQGW+r3RW6g8c=;
	h=Date:To:From:Subject:From;
	b=zbIvCmEX17N8Vbovm8vFlIwqyh2T1plt5Hqkoikqi2U1z5P+i3AoHpNEijiF/iJp9
	 Pzwl1nIjwi1iTQQaVeeXE2QpMCujUP/k2FuCYm6g1c9Z0gyLg6QC0RRIVHbNCmKyps
	 4vST4XgUzTs2QOAqemaAgeLBODDqGVhuqiioGPUg=
Date: Mon, 08 Sep 2025 21:11:55 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-delaytop-add-memory-verbose-mode-support.patch added to mm-nonmm-unstable branch
Message-Id: <20250909041155.B0F59C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/delaytop: add memory verbose mode support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-delaytop-add-memory-verbose-mode-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-delaytop-add-memory-verbose-mode-support.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Fan Yu <fan.yu9@zte.com.cn>
Subject: tools/delaytop: add memory verbose mode support
Date: Sun, 7 Sep 2025 00:12:52 +0800 (CST)

The original delaytop tool always displayed detailed memory subsystem
breakdown, which could be overwhelming for users who only need high-level
overview.

Add flexible display control allowing users to choose their preferred
information granularity.

The new flexibility provides:
1) For quick monitoring: use normal mode to reduce visual clutter
2) For deep analysis: use verbose mode to see all memory subsystem details

Link: https://lkml.kernel.org/r/202509070012527934u0ySb3teQ4gOYKnocyNO@zte.com.cn
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/delaytop.c |  128 ++++++++++++++++++++++++++--------
 1 file changed, 98 insertions(+), 30 deletions(-)

--- a/tools/accounting/delaytop.c~tools-delaytop-add-memory-verbose-mode-support
+++ a/tools/accounting/delaytop.c
@@ -69,13 +69,22 @@
 	int ret = fprintf(stream, fmt, ##__VA_ARGS__); \
 	ret >= 0; \
 })
+#define TASK_AVG(task, field) average_ms((task).field##_delay_total, (task).field##_count)
 #define PSI_LINE_FORMAT "%-12s %6.1f%%/%6.1f%%/%6.1f%%/%8llu(ms)\n"
-#define SORT_FIELD(name) \
+#define DELAY_FMT_DEFAULT "%8.2f %8.2f %8.2f %8.2f\n"
+#define DELAY_FMT_MEMVERBOSE "%8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n"
+#define SORT_FIELD(name, modes) \
 	{#name, \
 	offsetof(struct task_info, name##_delay_total), \
-	offsetof(struct task_info, name##_count)}
+	offsetof(struct task_info, name##_count), \
+	modes}
 #define END_FIELD {NULL, 0, 0}
 
+/* Display mode types */
+#define MODE_TYPE_ALL	(0xFFFFFFFF)
+#define MODE_DEFAULT	(1 << 0)
+#define MODE_MEMVERBOSE	(1 << 1)
+
 /* PSI statistics structure */
 struct psi_stats {
 	double cpu_some_avg10, cpu_some_avg60, cpu_some_avg300;
@@ -115,6 +124,8 @@ struct task_info {
 	unsigned long long wpcopy_delay_total;
 	unsigned long long irq_count;
 	unsigned long long irq_delay_total;
+	unsigned long long mem_count;
+	unsigned long long mem_delay_total;
 };
 
 /* Container statistics structure */
@@ -131,6 +142,7 @@ struct field_desc {
 	const char *name;	/* Field name for cmdline argument */
 	unsigned long total_offset; /* Offset of total delay in task_info */
 	unsigned long count_offset; /* Offset of count in task_info */
+	size_t supported_modes; /* Supported display modes */
 };
 
 /* Program settings structure */
@@ -142,6 +154,7 @@ struct config {
 	int monitor_pid;		/* Monitor specific PID */
 	char *container_path;	/* Path to container cgroup */
 	const struct field_desc *sort_field;	/* Current sort field */
+	size_t display_mode;	/* Current display mode */
 };
 
 /* Global variables */
@@ -152,14 +165,15 @@ static int task_count;
 static int running = 1;
 static struct container_stats container_stats;
 static const struct field_desc sort_fields[] = {
-	SORT_FIELD(cpu),
-	SORT_FIELD(blkio),
-	SORT_FIELD(irq),
-	SORT_FIELD(swapin),
-	SORT_FIELD(freepages),
-	SORT_FIELD(thrashing),
-	SORT_FIELD(compact),
-	SORT_FIELD(wpcopy),
+	SORT_FIELD(cpu,		MODE_DEFAULT),
+	SORT_FIELD(blkio,	MODE_DEFAULT),
+	SORT_FIELD(irq,		MODE_DEFAULT),
+	SORT_FIELD(mem,		MODE_DEFAULT | MODE_MEMVERBOSE),
+	SORT_FIELD(swapin,	MODE_MEMVERBOSE),
+	SORT_FIELD(freepages,	MODE_MEMVERBOSE),
+	SORT_FIELD(thrashing,	MODE_MEMVERBOSE),
+	SORT_FIELD(compact,	MODE_MEMVERBOSE),
+	SORT_FIELD(wpcopy,	MODE_MEMVERBOSE),
 	END_FIELD
 };
 
@@ -207,7 +221,7 @@ static const char *get_name_by_field(con
 }
 
 /* Generate string of available field names */
-static void display_available_fields(void)
+static void display_available_fields(size_t mode)
 {
 	const struct field_desc *field;
 	char buf[MAX_BUF_LEN];
@@ -215,6 +229,8 @@ static void display_available_fields(voi
 	buf[0] = '\0';
 
 	for (field = sort_fields; field->name != NULL; field++) {
+		if (!(field->supported_modes & mode))
+			continue;
 		strncat(buf, "|", MAX_BUF_LEN - strlen(buf) - 1);
 		strncat(buf, field->name, MAX_BUF_LEN - strlen(buf) - 1);
 		buf[MAX_BUF_LEN - 1] = '\0';
@@ -235,7 +251,8 @@ static void usage(void)
 	"  -o, --once               Display once and exit\n"
 	"  -p, --pid=PID            Monitor only the specified PID\n"
 	"  -C, --container=PATH     Monitor the container at specified cgroup path\n"
-	"  -s, --sort=FIELD         Sort by delay field (default: cpu)\n");
+	"  -s, --sort=FIELD         Sort by delay field (default: cpu)\n"
+	"  -M, --memverbose         Display memory detailed information\n");
 	exit(0);
 }
 
@@ -253,6 +270,7 @@ static void parse_args(int argc, char **
 		{"processes", required_argument, 0, 'P'},
 		{"sort", required_argument, 0, 's'},
 		{"container", required_argument, 0, 'C'},
+		{"memverbose", no_argument, 0, 'M'},
 		{0, 0, 0, 0}
 	};
 
@@ -264,11 +282,12 @@ static void parse_args(int argc, char **
 	cfg.output_one_time = 0;
 	cfg.monitor_pid = 0;	/* 0 means monitor all PIDs */
 	cfg.container_path = NULL;
+	cfg.display_mode = MODE_DEFAULT;
 
 	while (1) {
 		int option_index = 0;
 
-		c = getopt_long(argc, argv, "hd:n:p:oP:C:s:", long_options, &option_index);
+		c = getopt_long(argc, argv, "hd:n:p:oP:C:s:M", long_options, &option_index);
 		if (c == -1)
 			break;
 
@@ -325,12 +344,16 @@ static void parse_args(int argc, char **
 			/* Show available fields if invalid option provided */
 			if (!field) {
 				fprintf(stderr, "Error: invalid sort field '%s'\n", optarg);
-				display_available_fields();
+				display_available_fields(MODE_TYPE_ALL);
 				exit(1);
 			}
 
 			cfg.sort_field = field;
 			break;
+		case 'M':
+			cfg.display_mode = MODE_MEMVERBOSE;
+			cfg.sort_field = get_field_by_name("mem");
+			break;
 		default:
 			fprintf(stderr, "Try 'delaytop --help' for more information.\n");
 			exit(1);
@@ -338,6 +361,25 @@ static void parse_args(int argc, char **
 	}
 }
 
+/* Calculate average delay in milliseconds for overall memory */
+static void set_mem_delay_total(struct task_info *t)
+{
+	t->mem_delay_total = t->swapin_delay_total +
+		t->freepages_delay_total +
+		t->thrashing_delay_total +
+		t->compact_delay_total +
+		t->wpcopy_delay_total;
+}
+
+static void set_mem_count(struct task_info *t)
+{
+	t->mem_count = t->swapin_count +
+		t->freepages_count +
+		t->thrashing_count +
+		t->compact_count +
+		t->wpcopy_count;
+}
+
 /* Create a raw netlink socket and bind */
 static int create_nl_socket(void)
 {
@@ -611,6 +653,8 @@ static void fetch_and_fill_task_info(int
 						SET_TASK_STAT(task_count, wpcopy_delay_total);
 						SET_TASK_STAT(task_count, irq_count);
 						SET_TASK_STAT(task_count, irq_delay_total);
+						set_mem_count(&tasks[task_count]);
+						set_mem_delay_total(&tasks[task_count]);
 						task_count++;
 					}
 					break;
@@ -829,27 +873,44 @@ static void display_results(void)
 	/* Task delay output */
 	suc &= BOOL_FPRINT(out, "Top %d processes (sorted by %s delay):\n",
 			cfg.max_processes, get_name_by_field(cfg.sort_field));
-	suc &= BOOL_FPRINT(out, "%5s  %5s  %-17s", "PID", "TGID", "COMMAND");
-	suc &= BOOL_FPRINT(out, "%7s %7s %7s %7s %7s %7s %7s %7s\n",
-		"CPU(ms)", "IO(ms)", "SWAP(ms)", "RCL(ms)",
-		"THR(ms)", "CMP(ms)", "WP(ms)", "IRQ(ms)");
 
-	suc &= BOOL_FPRINT(out, "-----------------------------------------------");
-	suc &= BOOL_FPRINT(out, "----------------------------------------------\n");
+	suc &= BOOL_FPRINT(out, "%8s  %8s  %-17s", "PID", "TGID", "COMMAND");
+	if (cfg.display_mode == MODE_MEMVERBOSE) {
+		suc &= BOOL_FPRINT(out, "%8s %8s %8s %8s %8s %8s\n",
+			"MEM(ms)", "SWAP(ms)", "RCL(ms)",
+			"THR(ms)", "CMP(ms)", "WP(ms)");
+		suc &= BOOL_FPRINT(out, "-----------------------");
+		suc &= BOOL_FPRINT(out, "-----------------------");
+		suc &= BOOL_FPRINT(out, "-----------------------");
+		suc &= BOOL_FPRINT(out, "---------------------\n");
+	} else {
+		suc &= BOOL_FPRINT(out, "%8s %8s %8s %8s\n",
+			"CPU(ms)", "IO(ms)", "IRQ(ms)", "MEM(ms)");
+		suc &= BOOL_FPRINT(out, "-----------------------");
+		suc &= BOOL_FPRINT(out, "-----------------------");
+		suc &= BOOL_FPRINT(out, "--------------------------\n");
+	}
+
 	count = task_count < cfg.max_processes ? task_count : cfg.max_processes;
 
 	for (i = 0; i < count; i++) {
-		suc &= BOOL_FPRINT(out, "%5d  %5d  %-15s",
+		suc &= BOOL_FPRINT(out, "%8d  %8d  %-15s",
 			tasks[i].pid, tasks[i].tgid, tasks[i].command);
-		suc &= BOOL_FPRINT(out, "%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n",
-			average_ms(tasks[i].cpu_delay_total, tasks[i].cpu_count),
-			average_ms(tasks[i].blkio_delay_total, tasks[i].blkio_count),
-			average_ms(tasks[i].swapin_delay_total, tasks[i].swapin_count),
-			average_ms(tasks[i].freepages_delay_total, tasks[i].freepages_count),
-			average_ms(tasks[i].thrashing_delay_total, tasks[i].thrashing_count),
-			average_ms(tasks[i].compact_delay_total, tasks[i].compact_count),
-			average_ms(tasks[i].wpcopy_delay_total, tasks[i].wpcopy_count),
-			average_ms(tasks[i].irq_delay_total, tasks[i].irq_count));
+		if (cfg.display_mode == MODE_MEMVERBOSE) {
+			suc &= BOOL_FPRINT(out, DELAY_FMT_MEMVERBOSE,
+				TASK_AVG(tasks[i], mem),
+				TASK_AVG(tasks[i], swapin),
+				TASK_AVG(tasks[i], freepages),
+				TASK_AVG(tasks[i], thrashing),
+				TASK_AVG(tasks[i], compact),
+				TASK_AVG(tasks[i], wpcopy));
+		} else {
+			suc &= BOOL_FPRINT(out, DELAY_FMT_DEFAULT,
+				TASK_AVG(tasks[i], cpu),
+				TASK_AVG(tasks[i], blkio),
+				TASK_AVG(tasks[i], irq),
+				TASK_AVG(tasks[i], mem));
+		}
 	}
 
 	suc &= BOOL_FPRINT(out, "\n");
@@ -891,6 +952,13 @@ int main(int argc, char **argv)
 
 	/* Main loop */
 	while (running) {
+		/* Exit when sort field do not match display mode */
+		if (!(cfg.sort_field->supported_modes & cfg.display_mode)) {
+			fprintf(stderr, "Sort field not supported in this mode\n");
+			display_available_fields(cfg.display_mode);
+			break;
+		}
+
 		/* Read PSI statistics */
 		read_psi_stats();
 
_

Patches currently in -mm which might be from fan.yu9@zte.com.cn are

tools-delaytop-add-flexible-sorting-by-delay-field.patch
tools-delaytop-add-memory-verbose-mode-support.patch
tools-delaytop-add-interactive-mode-with-keyboard-controls.patch
tools-delaytop-improve-error-handling-for-missing-psi-support.patch
docs-update-delaytop-documentation-for-new-interactive-features.patch

