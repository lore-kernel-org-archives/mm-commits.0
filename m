From: akpm@linux-foundation.org
Subject: + checkpatch-fix-a-number-of-complex_macro-false-positives.patch
 added to -mm tree
Date: Wed, 11 Nov 2015 13:59:23 -0800
Message-ID: <5643ba3b.FH2BUzh3/daKC5B2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbKKV7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 16:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vz@mleia.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix a number of COMPLEX_MACRO false positives
has been added to the -mm tree.  Its filename is
     checkpatch-fix-a-number-of-complex_macro-false-positives.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-a-number-of-complex_macro-false-positives.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-a-number-of-complex_macro-false-positives.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-fix-a-number-of-complex_macro-false-positives.patch

