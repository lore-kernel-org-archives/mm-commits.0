From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:08:18 -0800
Message-ID: <200703060208.l2628JVL008922@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965730AbXCFCIY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:08:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics: fix buffer overflow in histogram with linear scale
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear.patch

This patch was dropped because it was folded into statistics-infrastructure.patch

------------------------------------------------------
Subject: statistics: fix buffer overflow in histogram with linear scale
From: Martin Peschke <mp3@de.ibm.com>

Values outside the range covered by a histogram with linear scale resulted
in invalid indices pointing to non-existing 'buckets'.  Index is adjusted
to array boundaries, if required.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/statistic.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN lib/statistic.c~statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear
+++ a/lib/statistic.c
@@ -1028,9 +1028,12 @@ static s64 statistic_histogram_calc_valu
 
 static int statistic_histogram_calc_index_lin(struct statistic *stat, s64 value)
 {
-	unsigned long long i = value - stat->u.histogram.range_min;
+	unsigned long long i;
+	if (value <= stat->u.histogram.range_min)
+		return 0;
+	i = value - stat->u.histogram.range_min;
 	do_div(i, stat->u.histogram.base_interval);
-	return i;
+	return min(i, (unsigned long long)(stat->u.histogram.last_index));
 }
 
 static int statistic_histogram_calc_index_log2(struct statistic *stat,
_

Patches currently in -mm which might be from mp3@de.ibm.com are

statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
statistics-infrastructure-adapt-output-format-of-utilisation-indicator.patch
statistics-use-the-enhanced-percpu-interface.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
statistics-infrastructure-exploitation-zfcp.patch
zfcp-gather-hba-specific-latencies-in-statistics.patch
