Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401D0156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810167; cv=none; b=GDM0eyoughx0JvkFqYBCnXkyHtiNg9K/KhXmW8F2rV4uHDR/Z2/F1aWtjT20Il+p1QPdYCu186WR0n2qnZuabM78KuEMxQmMhy7Rv1lipiyDAleJoKHFqfI0Pq8/8L5lsw/+aBx3DpZfA0o3zcS2oPA6poqLHaKZ/WFjAlEfhT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810167; c=relaxed/simple;
	bh=WRkUEYJCicYDvl8VXuU5uHpNUn1uYLpMZra1pf2ZM/0=;
	h=Date:To:From:Subject:Message-Id; b=chIiDbk8qIS+rT2CpWZ0EIjReYHyz/JCWZPoYVegNLstMk1f3If/o70fg37gRVF4s7FSTQ51o6LhYxpW24W9hAzfTvGEFmrtsZleZeBQyoDjKLR6fxkT0antTvu90Q6uGvuSka5PFLDKfB2cZTLkUFvRRDep6sUHhEw8/MJXVVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KakrfB7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KakrfB7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16494C4CEEB;
	Sun, 14 Sep 2025 00:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810167;
	bh=WRkUEYJCicYDvl8VXuU5uHpNUn1uYLpMZra1pf2ZM/0=;
	h=Date:To:From:Subject:From;
	b=KakrfB7gthoTvWagTCJAIfaATgYf4mu5bYfTO3JN6Fjk727DoO8NFFMM/ZFMWVE7W
	 1zkK+Iu+0W+nfa7m8yDcbuKuVwVpUIWoW5r9b/AWytpC3VQFQdb2VGLbw8zlMrrDER
	 pwsIDrHWqv0yAxpT+Vzk/vCqG6EAziFHUP1tn9Us=
Date: Sat, 13 Sep 2025 17:36:06 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-delaytop-improve-error-handling-for-missing-psi-support.patch removed from -mm tree
Message-Id: <20250914003607.16494C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/delaytop: improve error handling for missing PSI support
has been removed from the -mm tree.  Its filename was
     tools-delaytop-improve-error-handling-for-missing-psi-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fan Yu <fan.yu9@zte.com.cn>
Subject: tools/delaytop: improve error handling for missing PSI support
Date: Sun, 7 Sep 2025 00:14:17 +0800 (CST)

Enhanced display logic to conditionally show PSI information only when
successfully read, with helpful guidance for users to enable PSI support
(psi=1 cmdline parameter).

Link: https://lkml.kernel.org/r/20250907001417537vSx6nUsb3ILqI0iQ-WnGp@zte.com.cn
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/delaytop.c |  182 +++++++++++++++++++++-------------
 1 file changed, 116 insertions(+), 66 deletions(-)

--- a/tools/accounting/delaytop.c~tools-delaytop-improve-error-handling-for-missing-psi-support
+++ a/tools/accounting/delaytop.c
@@ -44,13 +44,11 @@
 #include <linux/cgroupstats.h>
 #include <stddef.h>
 
-#define PSI_CPU_SOME "/proc/pressure/cpu"
-#define PSI_CPU_FULL	"/proc/pressure/cpu"
-#define PSI_MEMORY_SOME "/proc/pressure/memory"
-#define PSI_MEMORY_FULL "/proc/pressure/memory"
-#define PSI_IO_SOME "/proc/pressure/io"
-#define PSI_IO_FULL "/proc/pressure/io"
-#define PSI_IRQ_FULL	"/proc/pressure/irq"
+#define PSI_PATH	"/proc/pressure"
+#define PSI_CPU_PATH	"/proc/pressure/cpu"
+#define PSI_MEMORY_PATH	"/proc/pressure/memory"
+#define PSI_IO_PATH	"/proc/pressure/io"
+#define PSI_IRQ_PATH	"/proc/pressure/irq"
 
 #define NLA_NEXT(na)			((struct nlattr *)((char *)(na) + NLA_ALIGN((na)->nla_len)))
 #define NLA_DATA(na)			((void *)((char *)(na) + NLA_HDRLEN))
@@ -499,87 +497,134 @@ static int get_family_id(int sd)
 	return id;
 }
 
-static void read_psi_stats(void)
+static int read_psi_stats(void)
 {
 	FILE *fp;
 	char line[256];
 	int ret = 0;
+	int error_count = 0;
+
+	/* Check if PSI path exists */
+	if (access(PSI_PATH, F_OK) != 0) {
+		fprintf(stderr, "Error: PSI interface not found at %s\n", PSI_PATH);
+		fprintf(stderr, "Please ensure your kernel supports PSI (Pressure Stall Information)\n");
+		return -1;
+	}
+
 	/* Zero all fields */
 	memset(&psi, 0, sizeof(psi));
+
 	/* CPU pressure */
-	fp = fopen(PSI_CPU_SOME, "r");
+	fp = fopen(PSI_CPU_PATH, "r");
 	if (fp) {
 		while (fgets(line, sizeof(line), fp)) {
 			if (strncmp(line, "some", 4) == 0) {
 				ret = sscanf(line, "some avg10=%lf avg60=%lf avg300=%lf total=%llu",
 							&psi.cpu_some_avg10, &psi.cpu_some_avg60,
 							&psi.cpu_some_avg300, &psi.cpu_some_total);
-				if (ret != 4)
+				if (ret != 4) {
 					fprintf(stderr, "Failed to parse CPU some PSI data\n");
+					error_count++;
+				}
 			} else if (strncmp(line, "full", 4) == 0) {
 				ret = sscanf(line, "full avg10=%lf avg60=%lf avg300=%lf total=%llu",
 						&psi.cpu_full_avg10, &psi.cpu_full_avg60,
 						&psi.cpu_full_avg300, &psi.cpu_full_total);
-				if (ret != 4)
+				if (ret != 4) {
 					fprintf(stderr, "Failed to parse CPU full PSI data\n");
+					error_count++;
+				}
 			}
 		}
 		fclose(fp);
+	} else {
+		fprintf(stderr, "Warning: Failed to open %s\n", PSI_CPU_PATH);
+		error_count++;
 	}
+
 	/* Memory pressure */
-	fp = fopen(PSI_MEMORY_SOME, "r");
+	fp = fopen(PSI_MEMORY_PATH, "r");
 	if (fp) {
 		while (fgets(line, sizeof(line), fp)) {
 			if (strncmp(line, "some", 4) == 0) {
 				ret = sscanf(line, "some avg10=%lf avg60=%lf avg300=%lf total=%llu",
 						&psi.memory_some_avg10, &psi.memory_some_avg60,
 						&psi.memory_some_avg300, &psi.memory_some_total);
-				if (ret != 4)
+				if (ret != 4) {
 					fprintf(stderr, "Failed to parse Memory some PSI data\n");
+					error_count++;
+				}
 			} else if (strncmp(line, "full", 4) == 0) {
 				ret = sscanf(line, "full avg10=%lf avg60=%lf avg300=%lf total=%llu",
 						&psi.memory_full_avg10, &psi.memory_full_avg60,
 						&psi.memory_full_avg300, &psi.memory_full_total);
-			}
-				if (ret != 4)
+				if (ret != 4) {
 					fprintf(stderr, "Failed to parse Memory full PSI data\n");
+					error_count++;
+				}
+			}
 		}
 		fclose(fp);
+	} else {
+		fprintf(stderr, "Warning: Failed to open %s\n", PSI_MEMORY_PATH);
+		error_count++;
 	}
+
 	/* IO pressure */
-	fp = fopen(PSI_IO_SOME, "r");
+	fp = fopen(PSI_IO_PATH, "r");
 	if (fp) {
 		while (fgets(line, sizeof(line), fp)) {
 			if (strncmp(line, "some", 4) == 0) {
 				ret = sscanf(line, "some avg10=%lf avg60=%lf avg300=%lf total=%llu",
 						&psi.io_some_avg10, &psi.io_some_avg60,
 						&psi.io_some_avg300, &psi.io_some_total);
-				if (ret != 4)
+				if (ret != 4) {
 					fprintf(stderr, "Failed to parse IO some PSI data\n");
+					error_count++;
+				}
 			} else if (strncmp(line, "full", 4) == 0) {
 				ret = sscanf(line, "full avg10=%lf avg60=%lf avg300=%lf total=%llu",
 						&psi.io_full_avg10, &psi.io_full_avg60,
 						&psi.io_full_avg300, &psi.io_full_total);
-				if (ret != 4)
+				if (ret != 4) {
 					fprintf(stderr, "Failed to parse IO full PSI data\n");
+					error_count++;
+				}
 			}
 		}
 		fclose(fp);
+	} else {
+		fprintf(stderr, "Warning: Failed to open %s\n", PSI_IO_PATH);
+		error_count++;
 	}
+
 	/* IRQ pressure (only full) */
-	fp = fopen(PSI_IRQ_FULL, "r");
+	fp = fopen(PSI_IRQ_PATH, "r");
 	if (fp) {
 		while (fgets(line, sizeof(line), fp)) {
 			if (strncmp(line, "full", 4) == 0) {
 				ret = sscanf(line, "full avg10=%lf avg60=%lf avg300=%lf total=%llu",
 						&psi.irq_full_avg10, &psi.irq_full_avg60,
 						&psi.irq_full_avg300, &psi.irq_full_total);
-				if (ret != 4)
+				if (ret != 4) {
 					fprintf(stderr, "Failed to parse IRQ full PSI data\n");
+					error_count++;
+				}
 			}
 		}
 		fclose(fp);
+	} else {
+		fprintf(stderr, "Warning: Failed to open %s\n", PSI_IRQ_PATH);
+		error_count++;
 	}
+
+	/* Return error count: 0 means success, >0 means warnings, -1 means fatal error */
+	if (error_count > 0) {
+		fprintf(stderr, "PSI stats reading completed with %d warnings\n", error_count);
+		return error_count;
+	}
+
+	return 0;
 }
 
 static int read_comm(int pid, char *comm_buf, size_t buf_size)
@@ -820,7 +865,7 @@ static void get_container_stats(void)
 }
 
 /* Display results to stdout or log file */
-static void display_results(void)
+static void display_results(int psi_ret)
 {
 	time_t now = time(NULL);
 	struct tm *tm_now = localtime(&now);
@@ -833,49 +878,53 @@ static void display_results(void)
 	suc &= BOOL_FPRINT(out, "\033[H\033[J");
 
 	/* PSI output (one-line, no cat style) */
-	suc &= BOOL_FPRINT(out, "System Pressure Information: (avg10/avg60/avg300/total)\n");
-	suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
-		"CPU some:",
-		psi.cpu_some_avg10,
-		psi.cpu_some_avg60,
-		psi.cpu_some_avg300,
-		psi.cpu_some_total / 1000);
-	suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
-		"CPU full:",
-		psi.cpu_full_avg10,
-		psi.cpu_full_avg60,
-		psi.cpu_full_avg300,
-		psi.cpu_full_total / 1000);
-	suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
-		"Memory full:",
-		psi.memory_full_avg10,
-		psi.memory_full_avg60,
-		psi.memory_full_avg300,
-		psi.memory_full_total / 1000);
-	suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
-		"Memory some:",
-		psi.memory_some_avg10,
-		psi.memory_some_avg60,
-		psi.memory_some_avg300,
-		psi.memory_some_total / 1000);
-	suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
-		"IO full:",
-		psi.io_full_avg10,
-		psi.io_full_avg60,
-		psi.io_full_avg300,
-		psi.io_full_total / 1000);
-	suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
-		"IO some:",
-		psi.io_some_avg10,
-		psi.io_some_avg60,
-		psi.io_some_avg300,
-		psi.io_some_total / 1000);
-	suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
-		"IRQ full:",
-		psi.irq_full_avg10,
-		psi.irq_full_avg60,
-		psi.irq_full_avg300,
-		psi.irq_full_total / 1000);
+	suc &= BOOL_FPRINT(out, "System Pressure Information: (avg10/avg60vg300/total)\n");
+	if (psi_ret) {
+		suc &= BOOL_FPRINT(out, "  PSI not found: check if psi=1 enabled in cmdline\n");
+	} else {
+		suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
+			"CPU some:",
+			psi.cpu_some_avg10,
+			psi.cpu_some_avg60,
+			psi.cpu_some_avg300,
+			psi.cpu_some_total / 1000);
+		suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
+			"CPU full:",
+			psi.cpu_full_avg10,
+			psi.cpu_full_avg60,
+			psi.cpu_full_avg300,
+			psi.cpu_full_total / 1000);
+		suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
+			"Memory full:",
+			psi.memory_full_avg10,
+			psi.memory_full_avg60,
+			psi.memory_full_avg300,
+			psi.memory_full_total / 1000);
+		suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
+			"Memory some:",
+			psi.memory_some_avg10,
+			psi.memory_some_avg60,
+			psi.memory_some_avg300,
+			psi.memory_some_total / 1000);
+		suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
+			"IO full:",
+			psi.io_full_avg10,
+			psi.io_full_avg60,
+			psi.io_full_avg300,
+			psi.io_full_total / 1000);
+		suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
+			"IO some:",
+			psi.io_some_avg10,
+			psi.io_some_avg60,
+			psi.io_some_avg300,
+			psi.io_some_total / 1000);
+		suc &= BOOL_FPRINT(out, PSI_LINE_FORMAT,
+			"IRQ full:",
+			psi.irq_full_avg10,
+			psi.irq_full_avg60,
+			psi.irq_full_avg300,
+			psi.irq_full_total / 1000);
+	}
 
 	if (cfg.container_path) {
 		suc &= BOOL_FPRINT(out, "Container Information (%s):\n", cfg.container_path);
@@ -1017,6 +1066,7 @@ int main(int argc, char **argv)
 {
 	const struct field_desc *field;
 	int iterations = 0;
+	int psi_ret = 0;
 	char keypress;
 
 	/* Parse command line arguments */
@@ -1054,7 +1104,7 @@ int main(int argc, char **argv)
 		}
 
 		/* Read PSI statistics */
-		read_psi_stats();
+		psi_ret = read_psi_stats();
 
 		/* Get container stats if container path provided */
 		if (cfg.container_path)
@@ -1067,7 +1117,7 @@ int main(int argc, char **argv)
 		sort_tasks();
 
 		/* Display results to stdout or log file */
-		display_results();
+		display_results(psi_ret);
 
 		/* Check for iterations */
 		if (cfg.iterations > 0 && ++iterations >= cfg.iterations)
_

Patches currently in -mm which might be from fan.yu9@zte.com.cn are


