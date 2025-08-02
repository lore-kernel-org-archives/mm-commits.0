Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09E023D291
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161357; cv=none; b=mQ+P6rX6Xb8vdENnsUj3gk9mqjqbxpC2TmjzcRGekh0+577UIomVJmgOAfsII958MA12MyOMxz9ky021uIrHZMrErUn1W0VqLcpQm6aEPKJOqFFHPmgCy10PkingPdj1+wwyH4+nZ1bOu4Ktb+CoWq8oZ+n8qoNwt8rXJeEZRiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161357; c=relaxed/simple;
	bh=xcNhDsAnXSDQRwLYgvFfsct6+7PZPXMaYgu1krMLmos=;
	h=Date:To:From:Subject:Message-Id; b=Il+PwQ9uHX5Wvyc2/o6eWAYXMu8yAzabajLdRMfeWUYGwgq7V9Qdh/QWbNlUP6GjMt4mZvdebI82w1kfzT8p/LItwcihGy3tDSUj0THAVdQn9nyvkKCNrrgDZ6fGiR7/H/JXtni9AeUZVohwWLc9HXYwCD8XCC7Loc9zLaAS9lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mxAPWdDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mxAPWdDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71845C4CEEF;
	Sat,  2 Aug 2025 19:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161356;
	bh=xcNhDsAnXSDQRwLYgvFfsct6+7PZPXMaYgu1krMLmos=;
	h=Date:To:From:Subject:From;
	b=mxAPWdDMC9rta3NHJzfti0yIuTTR3Jzr4sw7yKIvsVbQRhJ5XjoZ41Jx+eTjEGF7X
	 9daUmEQpo0srvURgctQ/z9kSy2F+qCBOZjjF3k45SV4goMl1RdGPFWK1VpUbf7QO+n
	 dc8tEuILdhthSm1dd8ZhrVw16efeOesZPUWMUn6I=
Date: Sat, 02 Aug 2025 12:02:35 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,corbet@lwn.net,fan.yu9@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-getdelays-add-backward-compatibility-for-taskstats-version.patch removed from -mm tree
Message-Id: <20250802190236.71845C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/getdelays: add backward compatibility for taskstats version
has been removed from the -mm tree.  Its filename was
     tools-getdelays-add-backward-compatibility-for-taskstats-version.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fan Yu <fan.yu9@zte.com.cn>
Subject: tools/getdelays: add backward compatibility for taskstats version
Date: Thu, 31 Jul 2025 22:53:26 +0800 (CST)

Add version checks to print_delayacct() to handle differences in struct
taskstats across kernel versions.  Field availability depends on taskstats
version (t->version), corresponding to TASKSTATS_VERSION in kernel headers
(see include/uapi/linux/taskstats.h).

Version feature mapping:
- version >= 11  - supports COMPACT statistics
- version >= 13  - supports WPCOPY statistics
- version >= 14  - supports IRQ statistics
- version >= 16  - supports *_max and *_min delay statistics

This ensures the tool works correctly with both older and newer kernel
versions by conditionally printing fields based on the reported version.

eg.1
bash# grep -r "#define TASKSTATS_VERSION" /usr/include/linux/taskstats.h
"#define TASKSTATS_VERSION       10"
bash# ./getdelays -d -p 1
CPU                 count     real total  virtual total    delay total  delay average
                     7481     3786181709     3807098291       36393725          0.005ms
IO                  count    delay total  delay average
                      369     1116046035          3.025ms
SWAP                count    delay total  delay average
                        0              0          0.000ms
RECLAIM             count    delay total  delay average
                        0              0          0.000ms
THRASHING           count    delay total  delay average
                        0              0          0.000ms

eg.2
bash# grep -r "#define TASKSTATS_VERSION" /usr/include/linux/taskstats.h
"#define TASKSTATS_VERSION       14"
bash# ./getdelays -d -p 1
CPU                 count     real total  virtual total    delay total  delay average
                    68862   163474790046   174584722267    19962496806          0.290ms
IO                  count    delay total  delay average
                        0              0          0.000ms
SWAP                count    delay total  delay average
                        0              0          0.000ms
RECLAIM             count    delay total  delay average
                        0              0          0.000ms
THRASHING           count    delay total  delay average
                        0              0          0.000ms
COMPACT             count    delay total  delay average
                        0              0          0.000ms
WPCOPY              count    delay total  delay average
                        0              0          0.000ms
IRQ                 count    delay total  delay average
                        0              0          0.000ms

Link: https://lkml.kernel.org/r/20250731225326549CttJ7g9NfjTlaqBwl015T@zte.com.cn
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |  167 +++++++++++++++++++--------------
 1 file changed, 100 insertions(+), 67 deletions(-)

--- a/tools/accounting/getdelays.c~tools-getdelays-add-backward-compatibility-for-taskstats-version
+++ a/tools/accounting/getdelays.c
@@ -194,75 +194,108 @@ static int get_family_id(int sd)
 #define average_ms(t, c) (t / 1000000ULL / (c ? c : 1))
 #define delay_ms(t) (t / 1000000ULL)
 
+/*
+ * Version compatibility note:
+ * Field availability depends on taskstats version (t->version),
+ * corresponding to TASKSTATS_VERSION in kernel headers
+ * see include/uapi/linux/taskstats.h
+ *
+ * Version feature mapping:
+ * version >= 11  - supports COMPACT statistics
+ * version >= 13  - supports WPCOPY statistics
+ * version >= 14  - supports IRQ statistics
+ * version >= 16  - supports *_max and *_min delay statistics
+ *
+ * Always verify version before accessing version-dependent fields
+ * to maintain backward compatibility.
+ */
+#define PRINT_CPU_DELAY(version, t) \
+	do { \
+		if (version >= 16) { \
+			printf("%-10s%15s%15s%15s%15s%15s%15s%15s\n", \
+				"CPU", "count", "real total", "virtual total", \
+				"delay total", "delay average", "delay max", "delay min"); \
+			printf("          %15llu%15llu%15llu%15llu%15.3fms%13.6fms%13.6fms\n", \
+				(unsigned long long)(t)->cpu_count, \
+				(unsigned long long)(t)->cpu_run_real_total, \
+				(unsigned long long)(t)->cpu_run_virtual_total, \
+				(unsigned long long)(t)->cpu_delay_total, \
+				average_ms((double)(t)->cpu_delay_total, (t)->cpu_count), \
+				delay_ms((double)(t)->cpu_delay_max), \
+				delay_ms((double)(t)->cpu_delay_min)); \
+		} else { \
+			printf("%-10s%15s%15s%15s%15s%15s\n", \
+				"CPU", "count", "real total", "virtual total", \
+				"delay total", "delay average"); \
+			printf("          %15llu%15llu%15llu%15llu%15.3fms\n", \
+				(unsigned long long)(t)->cpu_count, \
+				(unsigned long long)(t)->cpu_run_real_total, \
+				(unsigned long long)(t)->cpu_run_virtual_total, \
+				(unsigned long long)(t)->cpu_delay_total, \
+				average_ms((double)(t)->cpu_delay_total, (t)->cpu_count)); \
+		} \
+	} while (0)
+#define PRINT_FILED_DELAY(name, version, t, count, total, max, min) \
+	do { \
+		if (version >= 16) { \
+			printf("%-10s%15s%15s%15s%15s%15s\n", \
+				name, "count", "delay total", "delay average", \
+				"delay max", "delay min"); \
+			printf("          %15llu%15llu%15.3fms%13.6fms%13.6fms\n", \
+				(unsigned long long)(t)->count, \
+				(unsigned long long)(t)->total, \
+				average_ms((double)(t)->total, (t)->count), \
+				delay_ms((double)(t)->max), \
+				delay_ms((double)(t)->min)); \
+		} else { \
+			printf("%-10s%15s%15s%15s\n", \
+				name, "count", "delay total", "delay average"); \
+			printf("          %15llu%15llu%15.3fms\n", \
+				(unsigned long long)(t)->count, \
+				(unsigned long long)(t)->total, \
+				average_ms((double)(t)->total, (t)->count)); \
+		} \
+	} while (0)
+
 static void print_delayacct(struct taskstats *t)
 {
-	printf("\n\nCPU   %15s%15s%15s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15llu%15llu%15.3fms%13.6fms%13.6fms\n"
-	       "IO    %15s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
-	       "SWAP  %15s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
-	       "RECLAIM  %12s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
-	       "THRASHING%12s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
-	       "COMPACT  %12s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
-	       "WPCOPY   %12s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
-	       "IRQ   %15s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n",
-	       "count", "real total", "virtual total",
-	       "delay total", "delay average", "delay max", "delay min",
-	       (unsigned long long)t->cpu_count,
-	       (unsigned long long)t->cpu_run_real_total,
-	       (unsigned long long)t->cpu_run_virtual_total,
-	       (unsigned long long)t->cpu_delay_total,
-	       average_ms((double)t->cpu_delay_total, t->cpu_count),
-	       delay_ms((double)t->cpu_delay_max),
-	       delay_ms((double)t->cpu_delay_min),
-	       "count", "delay total", "delay average", "delay max", "delay min",
-	       (unsigned long long)t->blkio_count,
-	       (unsigned long long)t->blkio_delay_total,
-	       average_ms((double)t->blkio_delay_total, t->blkio_count),
-	       delay_ms((double)t->blkio_delay_max),
-	       delay_ms((double)t->blkio_delay_min),
-	       "count", "delay total", "delay average", "delay max", "delay min",
-	       (unsigned long long)t->swapin_count,
-	       (unsigned long long)t->swapin_delay_total,
-	       average_ms((double)t->swapin_delay_total, t->swapin_count),
-	       delay_ms((double)t->swapin_delay_max),
-	       delay_ms((double)t->swapin_delay_min),
-	       "count", "delay total", "delay average", "delay max", "delay min",
-	       (unsigned long long)t->freepages_count,
-	       (unsigned long long)t->freepages_delay_total,
-	       average_ms((double)t->freepages_delay_total, t->freepages_count),
-	       delay_ms((double)t->freepages_delay_max),
-	       delay_ms((double)t->freepages_delay_min),
-	       "count", "delay total", "delay average", "delay max", "delay min",
-	       (unsigned long long)t->thrashing_count,
-	       (unsigned long long)t->thrashing_delay_total,
-	       average_ms((double)t->thrashing_delay_total, t->thrashing_count),
-	       delay_ms((double)t->thrashing_delay_max),
-	       delay_ms((double)t->thrashing_delay_min),
-	       "count", "delay total", "delay average", "delay max", "delay min",
-	       (unsigned long long)t->compact_count,
-	       (unsigned long long)t->compact_delay_total,
-	       average_ms((double)t->compact_delay_total, t->compact_count),
-	       delay_ms((double)t->compact_delay_max),
-	       delay_ms((double)t->compact_delay_min),
-	       "count", "delay total", "delay average", "delay max", "delay min",
-	       (unsigned long long)t->wpcopy_count,
-	       (unsigned long long)t->wpcopy_delay_total,
-	       average_ms((double)t->wpcopy_delay_total, t->wpcopy_count),
-	       delay_ms((double)t->wpcopy_delay_max),
-	       delay_ms((double)t->wpcopy_delay_min),
-	       "count", "delay total", "delay average", "delay max", "delay min",
-	       (unsigned long long)t->irq_count,
-	       (unsigned long long)t->irq_delay_total,
-	       average_ms((double)t->irq_delay_total, t->irq_count),
-	       delay_ms((double)t->irq_delay_max),
-	       delay_ms((double)t->irq_delay_min));
+	printf("\n\n");
+
+	PRINT_CPU_DELAY(t->version, t);
+
+	PRINT_FILED_DELAY("IO", t->version, t,
+		blkio_count, blkio_delay_total,
+		blkio_delay_max, blkio_delay_min);
+
+	PRINT_FILED_DELAY("SWAP", t->version, t,
+		swapin_count, swapin_delay_total,
+		swapin_delay_max, swapin_delay_min);
+
+	PRINT_FILED_DELAY("RECLAIM", t->version, t,
+		freepages_count, freepages_delay_total,
+		freepages_delay_max, freepages_delay_min);
+
+	PRINT_FILED_DELAY("THRASHING", t->version, t,
+		thrashing_count, thrashing_delay_total,
+		thrashing_delay_max, thrashing_delay_min);
+
+	if (t->version >= 11) {
+		PRINT_FILED_DELAY("COMPACT", t->version, t,
+			compact_count, compact_delay_total,
+			compact_delay_max, compact_delay_min);
+	}
+
+	if (t->version >= 13) {
+		PRINT_FILED_DELAY("WPCOPY", t->version, t,
+			wpcopy_count, wpcopy_delay_total,
+			wpcopy_delay_max, wpcopy_delay_min);
+	}
+
+	if (t->version >= 14) {
+		PRINT_FILED_DELAY("IRQ", t->version, t,
+			irq_count, irq_delay_total,
+			irq_delay_max, irq_delay_min);
+	}
 }
 
 static void task_context_switch_counts(struct taskstats *t)
_

Patches currently in -mm which might be from fan.yu9@zte.com.cn are


