From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-fix-a-number-of-complex_macro-false-positives.patch removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:18 -0800
Message-ID: <56a162c6.sSJJAqiws2aLqeHa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbcAUW7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vz@mleia.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix a number of COMPLEX_MACRO false positives
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-a-number-of-complex_macro-false-positives.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Zapolskiy <vz@mleia.com>
Subject: checkpatch: fix a number of COMPLEX_MACRO false positives

A simple search over the kernel souce displays a number of correctly
defined multiline macro, which generally are used as an array element
initializer:

% find ../linux -type f | xargs grep -B1 -H '^[:space]*\[.*\\$'

However checkpatch.pl unexpectedly complains about all these macro
definitions:

% ./scripts/checkpatch.pl --types COMPLEX_MACRO -f include/linux/perf/arm_pmu.h

ERROR: Macros with complex values should be enclosed in parentheses
+#define PERF_MAP_ALL_UNSUPPORTED					\
+	 [0 ... PERF_COUNT_HW_MAX - 1] = HW_OP_UNSUPPORTED

The change intends to fix this type of false positives by flattening
only array members and skipping array element designators.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-a-number-of-complex_macro-false-positives scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-a-number-of-complex_macro-false-positives
+++ a/scripts/checkpatch.pl
@@ -4550,7 +4550,7 @@ sub process {
 			# Flatten any parentheses and braces
 			while ($dstat =~ s/\([^\(\)]*\)/1/ ||
 			       $dstat =~ s/\{[^\{\}]*\}/1/ ||
-			       $dstat =~ s/\[[^\[\]]*\]/1/)
+			       $dstat =~ s/.\[[^\[\]]*\]/1/)
 			{
 			}
 
@@ -4570,7 +4570,8 @@ sub process {
 				union|
 				struct|
 				\.$Ident\s*=\s*|
-				^\"|\"$
+				^\"|\"$|
+				^\[
 			}x;
 			#print "REST<$rest> dstat<$dstat> ctx<$ctx>\n";
 			if ($dstat ne '' &&
_

Patches currently in -mm which might be from vz@mleia.com are


