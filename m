Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2529ECA4E
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 00:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784247114; cv=none; b=pLzIR9q6CF7M5ra3B3Ai5hjZYqsUXbb/c6tp6eX98b63i2nxD1rLBUYzKrnXzt+XfuRX2sfkILQdLtjfzs/GPhXxK3APlE0/G3Tdzst4VAP3ntr2dmR+MJQ6q1H1k5G4JJkMU++vT7vBybBHRCqZgt3cyRNyquE3mNbEdw2p13Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784247114; c=relaxed/simple;
	bh=S1gw0wgE19mGP/t+yvFM5Mqk91RybH8/3b35EVjImZU=;
	h=Date:To:From:Subject:Message-Id; b=sRNwBx+rR6cpT/9khtlmIup5H4JklLuGZTAvo8VHFrHBtacnjbUt/fo3NJeFVVahTUZ3bj+mpOVxy758VRcT2ffGfBCc9Mrl3KEzlmu8z7RRuK+O9FXbutalA2FLAYmYSmzk0grx4PPsUtjqtqT2ZreqFtCssVAtsgVri9wblbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ao3bEfYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ao3bEfYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFF61F000E9;
	Fri, 17 Jul 2026 00:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784247112;
	bh=czFNhfzeVVHGYFpPEZQ6tdeeVb5brMlpZrNfN92SJMA=;
	h=Date:To:From:Subject;
	b=ao3bEfYmb+TSI0VygUaVDdepP2iHM7HRm7Q6gEYpVQmZOMEFnt+Wza3nUx2LkGDU8
	 a3bp8uCnY+CQ8ng1YffuUriFOrz6hML2IITgBgwQVe7V5PSFRU5cNsMTLcYkkbcjO6
	 uViSGDYEwDvA8yh/YlCtOOrQqreHuS5dzHP1bNBk=
Date: Thu, 16 Jul 2026 17:11:52 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,fan.yu9@zte.com.cn,shivanksharma2376543@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-accounting-fix-macro-typos-in-getdelays.patch added to mm-nonmm-unstable branch
Message-Id: <20260717001152.9AFF61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/accounting: fix macro typos in getdelays
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-accounting-fix-macro-typos-in-getdelays.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-accounting-fix-macro-typos-in-getdelays.patch

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
From: Shivank Sharma <shivanksharma2376543@gmail.com>
Subject: tools/accounting: fix macro typos in getdelays
Date: Thu, 16 Jul 2026 19:45:45 +0530

Correct the spelling of PRINT_FILED_DELAY and PRINT_FILED_DELAY_WITH_TS to
PRINT_FIELD_DELAY and PRINT_FIELD_DELAY_WITH_TS respectively.

This resolves typo naming errors across the macro definitions and their
matching inside print_delayacct().

Link: https://lore.kernel.org/20260716141545.1292951-1-shivanksharma2376543@gmail.com
Signed-off-by: Shivank Sharma <shivanksharma2376543@gmail.com>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/tools/accounting/getdelays.c~tools-accounting-fix-macro-typos-in-getdelays
+++ a/tools/accounting/getdelays.c
@@ -307,7 +307,7 @@ static const char *format_timespec(struc
 				average_ms((double)(t)->cpu_delay_total, (t)->cpu_count)); \
 		} \
 	} while (0)
-#define PRINT_FILED_DELAY(name, version, t, count, total, max, min) \
+#define PRINT_FIELD_DELAY(name, version, t, count, total, max, min) \
 	do { \
 		if (version >= 16) { \
 			printf("%-10s%15s%15s%15s%15s%15s\n", \
@@ -329,7 +329,7 @@ static const char *format_timespec(struc
 		} \
 	} while (0)
 
-#define PRINT_FILED_DELAY_WITH_TS(name, version, t, count, total, max, min, max_ts) \
+#define PRINT_FIELD_DELAY_WITH_TS(name, version, t, count, total, max, min, max_ts) \
 	do { \
 		if (version >= 17) { \
 			printf("%-10s%15s%15s%15s%15s%15s%25s\n", \
@@ -370,71 +370,71 @@ static void print_delayacct(struct tasks
 
 	/* Use new macro with timestamp support for version >= 17 */
 	if (t->version >= 17) {
-		PRINT_FILED_DELAY_WITH_TS("IO", t->version, t,
+		PRINT_FIELD_DELAY_WITH_TS("IO", t->version, t,
 			blkio_count, blkio_delay_total,
 			blkio_delay_max, blkio_delay_min, blkio_delay_max_ts);
 
-		PRINT_FILED_DELAY_WITH_TS("SWAP", t->version, t,
+		PRINT_FIELD_DELAY_WITH_TS("SWAP", t->version, t,
 			swapin_count, swapin_delay_total,
 			swapin_delay_max, swapin_delay_min, swapin_delay_max_ts);
 
-		PRINT_FILED_DELAY_WITH_TS("RECLAIM", t->version, t,
+		PRINT_FIELD_DELAY_WITH_TS("RECLAIM", t->version, t,
 			freepages_count, freepages_delay_total,
 			freepages_delay_max, freepages_delay_min, freepages_delay_max_ts);
 
-		PRINT_FILED_DELAY_WITH_TS("THRASHING", t->version, t,
+		PRINT_FIELD_DELAY_WITH_TS("THRASHING", t->version, t,
 			thrashing_count, thrashing_delay_total,
 			thrashing_delay_max, thrashing_delay_min, thrashing_delay_max_ts);
 
 		if (t->version >= 11) {
-			PRINT_FILED_DELAY_WITH_TS("COMPACT", t->version, t,
+			PRINT_FIELD_DELAY_WITH_TS("COMPACT", t->version, t,
 				compact_count, compact_delay_total,
 				compact_delay_max, compact_delay_min, compact_delay_max_ts);
 		}
 
 		if (t->version >= 13) {
-			PRINT_FILED_DELAY_WITH_TS("WPCOPY", t->version, t,
+			PRINT_FIELD_DELAY_WITH_TS("WPCOPY", t->version, t,
 				wpcopy_count, wpcopy_delay_total,
 				wpcopy_delay_max, wpcopy_delay_min, wpcopy_delay_max_ts);
 		}
 
 		if (t->version >= 14) {
-			PRINT_FILED_DELAY_WITH_TS("IRQ", t->version, t,
+			PRINT_FIELD_DELAY_WITH_TS("IRQ", t->version, t,
 				irq_count, irq_delay_total,
 				irq_delay_max, irq_delay_min, irq_delay_max_ts);
 		}
 	} else {
 		/* Use original macro for older versions */
-		PRINT_FILED_DELAY("IO", t->version, t,
+		PRINT_FIELD_DELAY("IO", t->version, t,
 			blkio_count, blkio_delay_total,
 			blkio_delay_max, blkio_delay_min);
 
-		PRINT_FILED_DELAY("SWAP", t->version, t,
+		PRINT_FIELD_DELAY("SWAP", t->version, t,
 			swapin_count, swapin_delay_total,
 			swapin_delay_max, swapin_delay_min);
 
-		PRINT_FILED_DELAY("RECLAIM", t->version, t,
+		PRINT_FIELD_DELAY("RECLAIM", t->version, t,
 			freepages_count, freepages_delay_total,
 			freepages_delay_max, freepages_delay_min);
 
-		PRINT_FILED_DELAY("THRASHING", t->version, t,
+		PRINT_FIELD_DELAY("THRASHING", t->version, t,
 			thrashing_count, thrashing_delay_total,
 			thrashing_delay_max, thrashing_delay_min);
 
 		if (t->version >= 11) {
-			PRINT_FILED_DELAY("COMPACT", t->version, t,
+			PRINT_FIELD_DELAY("COMPACT", t->version, t,
 				compact_count, compact_delay_total,
 				compact_delay_max, compact_delay_min);
 		}
 
 		if (t->version >= 13) {
-			PRINT_FILED_DELAY("WPCOPY", t->version, t,
+			PRINT_FIELD_DELAY("WPCOPY", t->version, t,
 				wpcopy_count, wpcopy_delay_total,
 				wpcopy_delay_max, wpcopy_delay_min);
 		}
 
 		if (t->version >= 14) {
-			PRINT_FILED_DELAY("IRQ", t->version, t,
+			PRINT_FIELD_DELAY("IRQ", t->version, t,
 				irq_count, irq_delay_total,
 				irq_delay_max, irq_delay_min);
 		}
_

Patches currently in -mm which might be from shivanksharma2376543@gmail.com are

tools-accounting-fix-macro-typos-in-getdelays.patch

