Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764FF16F0FE
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977379; cv=none; b=NZiYu6bCh9n3n0OWH7qQMy6B1CyHi6g7Xf7fWrOCHv9nPhjfVWQs4mqnlnULhrPtPtI7FjB26hZ3q70RXZ3WtXQLGDud4BoS7U8S3Gt8r9FHoKjj1yZGg7txG5gDTfG4qsK1Fp5v3S7pS7b+qa0LxMHhFMfU50618QJvyg1ty0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977379; c=relaxed/simple;
	bh=ZT4etMN/fppFZ0dWyLk7BIAqh4yX6LWMAUDjfXivxXU=;
	h=Date:To:From:Subject:Message-Id; b=q/MFEuNg571hwhU5nJBmUILvltxIQUHfalya95WYUmyB18SItuEXwedOTx36M/DmRpO6/krdzCNRJVeqDG8rtVySid9p8SNCRMBbPgPAbUmVmDYeiJ02t/hNvaMcH7u8kMbAHX9xl3vRyUzlI6iLbAzUjrIy+wvw1bSd58mCDKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VGyMn5Xw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VGyMn5Xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE6DC4CEE3;
	Sun, 20 Jul 2025 02:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977379;
	bh=ZT4etMN/fppFZ0dWyLk7BIAqh4yX6LWMAUDjfXivxXU=;
	h=Date:To:From:Subject:From;
	b=VGyMn5Xw37M5TgZA8SGqAeehEXEVpAlpO91ttjrgBxiQ8tXbBOexEqJyemptMaT1/
	 LyIvrD4ktdGd+45xSckwouHkFx2K58J4HKdJpBhUjhgIemp7WEi0j/ab/0i4y6BasL
	 b4p1f2dyYAgg/Q225xSWV2ztfQRlI2kKnNS7m+S8=
Date: Sat, 19 Jul 2025 19:09:38 -0700
To: mm-commits@vger.kernel.org,zhang.yunkai@zte.com.cn,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yong12@zte.com.cn,tu.qiang35@zte.com.cn,jiang.kun2@zte.com.cn,he.peilin@zte.com.cn,fan.yu9@zte.com.cn,david@redhat.com,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] delaytop-add-psi-info-to-show-system-delay.patch removed from -mm tree
Message-Id: <20250720020939.4AE6DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: delaytop: add psi info to show system delay
has been removed from the -mm tree.  Its filename was
     delaytop-add-psi-info-to-show-system-delay.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: delaytop: add psi info to show system delay
Date: Thu, 10 Jul 2025 13:54:51 +0800 (CST)

Support showing whole delay of system by reading PSI, just like the first
few lines of information output by the top command.  the output of
delaytop includes both system-wide delay and delay of individual tasks,
providing a more comprehensive reflection of system latency status.

Use case
========
bash# ./delaytop
System Pressure Information: (avg10/avg60/avg300/total)
CPU:    full:    0.0%/   0.0%/   0.0%/0           some:    0.1%/   0.0%/   0.0%/14216596
Memory: full:    0.0%/   0.0%/   0.0%/34010659    some:    0.0%/   0.0%/   0.0%/35406492
IO:     full:    0.1%/   0.0%/   0.0%/51029453    some:    0.1%/   0.0%/   0.0%/55330465
IRQ:    full:    0.0%/   0.0%/   0.0%/0

Top 20 processes (sorted by CPU delay):

  PID   TGID  COMMAND            CPU(ms)  IO(ms)        SWAP(ms) RCL(ms) THR(ms)  CMP(ms)  WP(ms)  IRQ(ms)
---------------------------------------------------------------------------------------------
   32     32  kworker/2:0H-sy   23.65     0.00     0.00     0.00    0.00     0.00     0.00     0.00
  497    497  kworker/R-scsi_    1.20     0.00     0.00     0.00    0.00     0.00     0.00     0.00
  495    495  kworker/R-scsi_    1.13     0.00     0.00     0.00    0.00     0.00     0.00     0.00
  494    494  scsi_eh_0          1.12     0.00     0.00     0.00    0.00     0.00     0.00     0.00
  485    485  kworker/R-ata_s    0.90     0.00     0.00     0.00    0.00     0.00     0.00     0.00
  574    574  kworker/R-kdmfl    0.36     0.00     0.00     0.00    0.00     0.00     0.00     0.00
   34     34  idle_inject/3      0.33     0.00     0.00     0.00    0.00     0.00     0.00     0.00
 1123   1123  nde-netfilter      0.28     0.00     0.00     0.00    0.00     0.00     0.00     0.00
   60     60  ksoftirqd/7        0.25     0.00     0.00     0.00    0.00     0.00     0.00     0.00
  114    114  kworker/0:2-cgr    0.25     0.00     0.00     0.00    0.00     0.00     0.00     0.00
  496    496  scsi_eh_1          0.24     0.00     0.00     0.00    0.00     0.00     0.00     0.00
   51     51  cpuhp/6            0.24     0.00     0.00     0.00    0.00     0.00     0.00     0.00
 1667   1667  atd                0.24     0.00     0.00     0.00    0.00     0.00     0.00     0.00
   45     45  cpuhp/5            0.23     0.00     0.00     0.00    0.00     0.00     0.00     0.00
 1102   1102  nde-backupservi    0.22     0.00     0.00     0.00    0.00     0.00     0.00     0.00
 1098   1098  systemsettings     0.21     0.00     0.00     0.00    0.00     0.00     0.00     0.00
 1100   1100  audit-monitor      0.20     0.00     0.00     0.00    0.00     0.00     0.00     0.00
   53     53  migration/6        0.20     0.00     0.00     0.00    0.00     0.00     0.00     0.00
 1482   1482  sshd               0.19     0.00     0.00     0.00    0.00     0.00     0.00     0.00
   39     39  cpuhp/4            0.19     0.00     0.00     0.00    0.00     0.00     0.00     0.00

Link: https://lkml.kernel.org/r/20250710135451340_5pOgpIFi0M5AE7H44W1D@zte.com.cn
Co-developed-by: Fan Yu <fan.yu9@zte.com.cn>
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peilin He <he.peilin@zte.com.cn>
Cc: Qiang Tu <tu.qiang35@zte.com.cn>
Cc: wangyong <wang.yong12@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/delaytop.c |  163 +++++++++++++++++++++++++++++++---
 1 file changed, 149 insertions(+), 14 deletions(-)

--- a/tools/accounting/delaytop.c~delaytop-add-psi-info-to-show-system-delay
+++ a/tools/accounting/delaytop.c
@@ -10,9 +10,9 @@
  * individual tasks (PIDs).
  *
  * Key features:
- *   - Collects per-task delay accounting statistics via taskstats.
- *   - Supports sorting, filtering.
- *   - Supports both interactive (screen refresh).
+ *	- Collects per-task delay accounting statistics via taskstats.
+ *	- Supports sorting, filtering.
+ *	- Supports both interactive (screen refresh).
  *
  * Copyright (C) Fan Yu, ZTE Corp. 2025
  * Copyright (C) Wang Yaxin, ZTE Corp. 2025
@@ -43,6 +43,14 @@
 #include <linux/cgroupstats.h>
 #include <ncurses.h>
 
+#define PSI_CPU_SOME "/proc/pressure/cpu"
+#define PSI_CPU_FULL	"/proc/pressure/cpu"
+#define PSI_MEMORY_SOME "/proc/pressure/memory"
+#define PSI_MEMORY_FULL "/proc/pressure/memory"
+#define PSI_IO_SOME "/proc/pressure/io"
+#define PSI_IO_FULL "/proc/pressure/io"
+#define PSI_IRQ_FULL	"/proc/pressure/irq"
+
 #define NLA_NEXT(na)			((struct nlattr *)((char *)(na) + NLA_ALIGN((na)->nla_len)))
 #define NLA_DATA(na)			((void *)((char *)(na) + NLA_HDRLEN))
 #define NLA_PAYLOAD(len)		(len - NLA_HDRLEN)
@@ -66,6 +74,24 @@ struct config {
 	char *container_path;	/* Path to container cgroup */
 };
 
+/* PSI statistics structure */
+struct psi_stats {
+	double cpu_some_avg10, cpu_some_avg60, cpu_some_avg300;
+	unsigned long long cpu_some_total;
+	double cpu_full_avg10, cpu_full_avg60, cpu_full_avg300;
+	unsigned long long cpu_full_total;
+	double memory_some_avg10, memory_some_avg60, memory_some_avg300;
+	unsigned long long memory_some_total;
+	double memory_full_avg10, memory_full_avg60, memory_full_avg300;
+	unsigned long long memory_full_total;
+	double io_some_avg10, io_some_avg60, io_some_avg300;
+	unsigned long long io_some_total;
+	double io_full_avg10, io_full_avg60, io_full_avg300;
+	unsigned long long io_full_total;
+	double irq_full_avg10, irq_full_avg60, irq_full_avg300;
+	unsigned long long irq_full_total;
+};
+
 /* Task delay information structure */
 struct task_info {
 	int pid;
@@ -100,6 +126,7 @@ struct container_stats {
 
 /* Global variables */
 static struct config cfg;
+static struct psi_stats psi;
 static struct task_info tasks[MAX_TASKS];
 static int task_count;
 static int running = 1;
@@ -130,13 +157,13 @@ static void usage(void)
 {
 	printf("Usage: delaytop [Options]\n"
 	"Options:\n"
-	"  -h, --help               Show this help message and exit\n"
-	"  -d, --delay=SECONDS      Set refresh interval (default: 2 seconds, min: 1)\n"
-	"  -n, --iterations=COUNT   Set number of updates (default: 0 = infinite)\n"
-	"  -P, --processes=NUMBER   Set maximum number of processes to show (default: 20, max: 1000)\n"
-	"  -o, --once               Display once and exit\n"
-	"  -p, --pid=PID            Monitor only the specified PID\n"
-	"  -C, --container=PATH     Monitor the container at specified cgroup path\n");
+	"  -h, --help				Show this help message and exit\n"
+	"  -d, --delay=SECONDS	  Set refresh interval (default: 2 seconds, min: 1)\n"
+	"  -n, --iterations=COUNT	Set number of updates (default: 0 = infinite)\n"
+	"  -P, --processes=NUMBER	Set maximum number of processes to show (default: 20, max: 1000)\n"
+	"  -o, --once				Display once and exit\n"
+	"  -p, --pid=PID			Monitor only the specified PID\n"
+	"  -C, --container=PATH	 Monitor the container at specified cgroup path\n");
 	exit(0);
 }
 
@@ -276,7 +303,7 @@ static int send_cmd(int sd, __u16 nlmsg_
 	memset(&nladdr, 0, sizeof(nladdr));
 	nladdr.nl_family = AF_NETLINK;
 	while ((r = sendto(sd, buf, buflen, 0, (struct sockaddr *) &nladdr,
-				   sizeof(nladdr))) < buflen) {
+					sizeof(nladdr))) < buflen) {
 		if (r > 0) {
 			buf += r;
 			buflen -= r;
@@ -320,6 +347,89 @@ static int get_family_id(int sd)
 	return id;
 }
 
+static void read_psi_stats(void)
+{
+	FILE *fp;
+	char line[256];
+	int ret = 0;
+	/* Zero all fields */
+	memset(&psi, 0, sizeof(psi));
+	/* CPU pressure */
+	fp = fopen(PSI_CPU_SOME, "r");
+	if (fp) {
+		while (fgets(line, sizeof(line), fp)) {
+			if (strncmp(line, "some", 4) == 0) {
+				ret = sscanf(line, "some avg10=%lf avg60=%lf avg300=%lf total=%llu",
+							&psi.cpu_some_avg10, &psi.cpu_some_avg60,
+							&psi.cpu_some_avg300, &psi.cpu_some_total);
+				if (ret != 4)
+					fprintf(stderr, "Failed to parse CPU some PSI data\n");
+			} else if (strncmp(line, "full", 4) == 0) {
+				ret = sscanf(line, "full avg10=%lf avg60=%lf avg300=%lf total=%llu",
+						&psi.cpu_full_avg10, &psi.cpu_full_avg60,
+						&psi.cpu_full_avg300, &psi.cpu_full_total);
+				if (ret != 4)
+					fprintf(stderr, "Failed to parse CPU full PSI data\n");
+			}
+		}
+		fclose(fp);
+	}
+	/* Memory pressure */
+	fp = fopen(PSI_MEMORY_SOME, "r");
+	if (fp) {
+		while (fgets(line, sizeof(line), fp)) {
+			if (strncmp(line, "some", 4) == 0) {
+				ret = sscanf(line, "some avg10=%lf avg60=%lf avg300=%lf total=%llu",
+						&psi.memory_some_avg10, &psi.memory_some_avg60,
+						&psi.memory_some_avg300, &psi.memory_some_total);
+				if (ret != 4)
+					fprintf(stderr, "Failed to parse Memory some PSI data\n");
+			} else if (strncmp(line, "full", 4) == 0) {
+				ret = sscanf(line, "full avg10=%lf avg60=%lf avg300=%lf total=%llu",
+						&psi.memory_full_avg10, &psi.memory_full_avg60,
+						&psi.memory_full_avg300, &psi.memory_full_total);
+			}
+				if (ret != 4)
+					fprintf(stderr, "Failed to parse Memory full PSI data\n");
+		}
+		fclose(fp);
+	}
+	/* IO pressure */
+	fp = fopen(PSI_IO_SOME, "r");
+	if (fp) {
+		while (fgets(line, sizeof(line), fp)) {
+			if (strncmp(line, "some", 4) == 0) {
+				ret = sscanf(line, "some avg10=%lf avg60=%lf avg300=%lf total=%llu",
+						&psi.io_some_avg10, &psi.io_some_avg60,
+						&psi.io_some_avg300, &psi.io_some_total);
+				if (ret != 4)
+					fprintf(stderr, "Failed to parse IO some PSI data\n");
+			} else if (strncmp(line, "full", 4) == 0) {
+				ret = sscanf(line, "full avg10=%lf avg60=%lf avg300=%lf total=%llu",
+						&psi.io_full_avg10, &psi.io_full_avg60,
+						&psi.io_full_avg300, &psi.io_full_total);
+				if (ret != 4)
+					fprintf(stderr, "Failed to parse IO full PSI data\n");
+			}
+		}
+		fclose(fp);
+	}
+	/* IRQ pressure (only full) */
+	fp = fopen(PSI_IRQ_FULL, "r");
+	if (fp) {
+		while (fgets(line, sizeof(line), fp)) {
+			if (strncmp(line, "full", 4) == 0) {
+				ret = sscanf(line, "full avg10=%lf avg60=%lf avg300=%lf total=%llu",
+						&psi.irq_full_avg10, &psi.irq_full_avg60,
+						&psi.irq_full_avg300, &psi.irq_full_total);
+				if (ret != 4)
+					fprintf(stderr, "Failed to parse IRQ full PSI data\n");
+			}
+		}
+		fclose(fp);
+	}
+}
+
 static int read_comm(int pid, char *comm_buf, size_t buf_size)
 {
 	char path[64];
@@ -549,7 +659,29 @@ static void display_results(void)
 	FILE *out = stdout;
 
 	fprintf(out, "\033[H\033[J");
-
+	/* PSI output (one-line, no cat style) */
+	fprintf(out, "System Pressure Information: ");
+	fprintf(out, "(avg10/avg60/avg300/total)\n");
+	fprintf(out, "CPU:");
+	fprintf(out, "	full: %6.1f%%/%6.1f%%/%6.1f%%/%-10llu", psi.cpu_full_avg10,
+			psi.cpu_full_avg60, psi.cpu_full_avg300, psi.cpu_full_total);
+	fprintf(out, "  some: %6.1f%%/%6.1f%%/%6.1f%%/%-10llu\n", psi.cpu_some_avg10,
+			psi.cpu_some_avg60, psi.cpu_some_avg300, psi.cpu_some_total);
+
+	fprintf(out, "Memory:");
+	fprintf(out, " full: %6.1f%%/%6.1f%%/%6.1f%%/%-10llu", psi.memory_full_avg10,
+			psi.memory_full_avg60, psi.memory_full_avg300, psi.memory_full_total);
+	fprintf(out, "  some: %6.1f%%/%6.1f%%/%6.1f%%/%-10llu\n", psi.memory_some_avg10,
+			psi.memory_some_avg60, psi.memory_some_avg300, psi.memory_some_total);
+
+	fprintf(out, "IO:");
+	fprintf(out, "	full: %6.1f%%/%6.1f%%/%6.1f%%/%-10llu", psi.io_full_avg10,
+			psi.io_full_avg60, psi.io_full_avg300, psi.io_full_total);
+	fprintf(out, "  some: %6.1f%%/%6.1f%%/%6.1f%%/%-10llu\n", psi.io_some_avg10,
+			psi.io_some_avg60, psi.io_some_avg300, psi.io_some_total);
+	fprintf(out, "IRQ:");
+	fprintf(out, "	full: %6.1f%%/%6.1f%%/%6.1f%%/%-10llu\n\n", psi.irq_full_avg10,
+			psi.irq_full_avg60, psi.irq_full_avg300, psi.irq_full_total);
 	if (cfg.container_path) {
 		fprintf(out, "Container Information (%s):\n", cfg.container_path);
 		fprintf(out, "Processes: running=%d, sleeping=%d, ",
@@ -559,8 +691,8 @@ static void display_results(void)
 			container_stats.nr_io_wait);
 	}
 	fprintf(out, "Top %d processes (sorted by CPU delay):\n\n",
-		   cfg.max_processes);
-	fprintf(out, "  PID	TGID  COMMAND		 CPU(ms)  IO(ms)   ");
+			cfg.max_processes);
+	fprintf(out, "  PID	TGID  COMMAND		 CPU(ms)  IO(ms)	");
 	fprintf(out, "SWAP(ms) RCL(ms) THR(ms)  CMP(ms)  WP(ms)  IRQ(ms)\n");
 	fprintf(out, "-----------------------------------------------");
 	fprintf(out, "----------------------------------------------\n");
@@ -616,6 +748,9 @@ int main(int argc, char **argv)
 
 	/* Main loop */
 	while (running) {
+		/* Read PSI statistics */
+		read_psi_stats();
+
 		/* Get container stats if container path provided */
 		if (cfg.container_path)
 			get_container_stats();
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are


