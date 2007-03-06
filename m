From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-adapt-output-format-of-utilisation-indicator.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:08:26 -0800
Message-ID: <200703060208.l2628QEU008928@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46932 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965731AbXCFCIc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:08:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics: adapt output format of utilisation indicator
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-adapt-output-format-of-utilisation-indicator.patch

This patch was dropped because it was folded into statistics-infrastructure.patch

------------------------------------------------------
Subject: statistics: adapt output format of utilisation indicator
From: Martin Peschke <mp3@de.ibm.com>

Statistics might be compounds of several results, or buckets (see
histogram).  For any mode of data aggregation, we use one line per bucket
in the output format - with the exception of a "utilisation indicator",
which squeezes a handful of numbers into a single line (number of samples,
minimim, average, maximum, variance).

This patch splits this compound up into separate and appropriately named
output lines, ridding us of a nasty exception, and improving readability.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/statistics.txt |   22 +++++++++++++++++-----
 lib/statistic.c              |   14 +++++++++++---
 2 files changed, 28 insertions(+), 8 deletions(-)

diff -puN Documentation/statistics.txt~statistics-infrastructure-adapt-output-format-of-utilisation-indicator Documentation/statistics.txt
--- a/Documentation/statistics.txt~statistics-infrastructure-adapt-output-format-of-utilisation-indicator
+++ a/Documentation/statistics.txt
@@ -199,7 +199,11 @@ has been implemented:
   size_write 0x14000 12			|
   ...					|
   size_write 0x9000 1			/
-  queue_used_depth 970 1 18.122 32		> num min avg max for a queue
+  queue_used_depth samples 970			\
+  queue_used_depth minimum 1			|
+  queue_used_depth average 18.122		> utilisation of a queue
+  queue_used_depth maximum 32			|
+  queue_used_depth variance 53.324		/
 
 Such output can grow as needed in debugfs files. It is human-readable and
 could be parsed and postprocessed by simple scripts that are aware of what the
@@ -543,18 +547,26 @@ this:
   foo 0x1000 4
   foo 0x2000 1
   foo 0x5000 2
-  bar 961 1 42.000 128
+  bar samples 961
+  bar minimum 1
+  bar average 42.000
+  bar maximum 128
+  bar variance 149.254
 
 
 	Output formats of different statistic types
 
   Statistic Type	Output Format				Number of Lines
 
-  counter_inc		<name> <total of Y>				1
+  counter_inc		<name> <total of Y>			1
 
-  counter_prod		<name> <total of Xi*Yi>				1
+  counter_prod		<name> <total of Xi*Yi>			1
 
-  utilisation		<name> <total of Y> <min X> <avg X> <max X>	1
+  utilisation		<name> "samples" <total of Y>		5
+			<name> "minimum" <minimum X>
+			<name> "average" <average X>
+			<name> "maximum" <maximum X>
+			<name> "variance" <variance of X>
 
   sparse		<name> <Xn> <total of Y for Xn>		<= entries
 			...
diff -puN lib/statistic.c~statistics-infrastructure-adapt-output-format-of-utilisation-indicator lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-adapt-output-format-of-utilisation-indicator
+++ a/lib/statistic.c
@@ -984,14 +984,22 @@ static int statistic_fdata_util(struct s
 	signed long long min = num ? util->min : 0,
 			 max = num ? util->max : 0;
 
-	seg = sgrb_seg_find(&fpriv->read_seg_lh, 128);
+	seg = sgrb_seg_find(&fpriv->read_seg_lh, 512);
 	if (unlikely(!seg))
 		return -ENOMEM;
 	statistic_div(&mean_w, &mean_d, acc, num, 3);
 	statistic_div(&var_w, &var_d, sqr - mean_w * mean_w, num, 3);
 	seg->offset += sprintf(seg->address + seg->offset,
-			       "%s %Lu %Ld %Ld.%03Ld %Ld %Ld.%03Ld\n", name,
-			       num, min, mean_w, mean_d, max, var_w, var_d);
+			       "%s samples %Lu\n"
+			       "%s minimum %Ld\n"
+			       "%s average %Ld.%03Ld\n"
+			       "%s maximum %Ld\n"
+			       "%s variance %Ld.%03Ld\n",
+			       name, num,
+			       name, min,
+			       name, mean_w, mean_d,
+			       name, max,
+			       name, var_w, var_d);
 	return 0;
 }
 
_

Patches currently in -mm which might be from mp3@de.ibm.com are

statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-adapt-output-format-of-utilisation-indicator.patch
statistics-use-the-enhanced-percpu-interface.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
statistics-infrastructure-exploitation-zfcp.patch
zfcp-gather-hba-specific-latencies-in-statistics.patch
