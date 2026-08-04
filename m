Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281162F5324
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816342; cv=none; b=Hz2dIWHDa6+z5cgS3b95FLo2yFwNzlblugB6K6Xn9iFo7ztt88HuEcWuHRg3UWzR/QqQzc5HzwlahJ6Q8tW2ynalPwAXQenom0fD7CHeZpHHnon5OgawYWYt7UwOvYMxoYeLxLikRX5+9OsHLrksTYrfRWt8QsVUVA1av2EVQKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816342; c=relaxed/simple;
	bh=AfgkQlbSqrvPRWKbybqjl2ZTOvyNI5ugpigm/3cNbj8=;
	h=Date:To:From:Subject:Message-Id; b=HpjbZebp0UOs7UWZNKb2m6EkLPtLsy/etIx85SU++xltSfyv+08+WufPoMlo53krn2FnNAmIhpMfh2AYbj23mKfLqg7PMItz1IcHzJN8rFKIz/1w7Hkro43eu9opAwOffNS3E162yrbVrz1boxT1P++LoGz+KxH+cmP3MQn6rJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e+4rSzv/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e+4rSzv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22171F00A3A;
	Tue,  4 Aug 2026 04:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816341;
	bh=CEzM82ss7rt1GZOuroe9UpBEJTOt3FDDybEJmpweXhM=;
	h=Date:To:From:Subject;
	b=e+4rSzv/6/CUQEQQPGomJ/7LWMqR9GDY3EO9I14QUhgLKT3PwFQO5VUyhjasY0lxx
	 snm/5cV4qaoD28lgpPSpzFHRFUn+UzFmJTBFpnkj7lSjEAvdaRfcikIgWZrxLFXBwk
	 0j4YWH8XXNiQqsm6xSS4ftM5fcAD7cZn0f0alZGk=
Date: Mon, 03 Aug 2026 21:05:40 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,fan.yu9@zte.com.cn,shivanksharma2376543@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-accounting-fix-macro-typos-in-getdelays.patch removed from -mm tree
Message-Id: <20260804040540.F22171F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/accounting: fix macro typos in getdelays
has been removed from the -mm tree.  Its filename was
     tools-accounting-fix-macro-typos-in-getdelays.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -302,7 +302,7 @@ static const char *format_timespec(struc
 				average_ms((double)(t)->cpu_delay_total, (t)->cpu_count)); \
 		} \
 	} while (0)
-#define PRINT_FILED_DELAY(name, version, t, count, total, max, min) \
+#define PRINT_FIELD_DELAY(name, version, t, count, total, max, min) \
 	do { \
 		if (version >= 16) { \
 			printf("%-10s%15s%15s%15s%15s%15s\n", \
@@ -324,7 +324,7 @@ static const char *format_timespec(struc
 		} \
 	} while (0)
 
-#define PRINT_FILED_DELAY_WITH_TS(name, version, t, count, total, max, min, max_ts) \
+#define PRINT_FIELD_DELAY_WITH_TS(name, version, t, count, total, max, min, max_ts) \
 	do { \
 		if (version >= 17) { \
 			printf("%-10s%15s%15s%15s%15s%15s%25s\n", \
@@ -365,71 +365,71 @@ static void print_delayacct(struct tasks
 
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


