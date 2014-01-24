From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-check-for-ifs-with-unnecessary-parentheses.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:01:55 -0800
Message-ID: <52e2b8a3.4xJA4oFuT+dAI6rP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaAXTB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, josh@joshtriplett.org, apw@canonical.com, joe@perches.com

Subject: [merged] checkpatch-check-for-ifs-with-unnecessary-parentheses.patch removed from -mm tree
To: joe@perches.com,apw@canonical.com,josh@joshtriplett.org,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:55 -0800


The patch titled
     Subject: checkpatch: check for if's with unnecessary parentheses
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-ifs-with-unnecessary-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: check for if's with unnecessary parentheses

If statements don't need multiple parentheses around tested comparisons
like "if ((foo == bar))".

An == comparison maybe a sign of an intended assignment, so emit a
slightly different message if so.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-ifs-with-unnecessary-parentheses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-ifs-with-unnecessary-parentheses
+++ a/scripts/checkpatch.pl
@@ -3254,6 +3254,20 @@ sub process {
 			}
 		}
 
+# if statements using unnecessary parentheses - ie: if ((foo == bar))
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\bif\s*((?:\(\s*){2,})/) {
+			my $openparens = $1;
+			my $count = $openparens =~ tr@\(@\(@;
+			my $msg = "";
+			if ($line =~ /\bif\s*(?:\(\s*){$count,$count}$LvalOrFunc\s*($Compare)\s*$LvalOrFunc(?:\s*\)){$count,$count}/) {
+				my $comp = $4;	#Not $1 because of $LvalOrFunc
+				$msg = " - maybe == should be = ?" if ($comp eq "==");
+				WARN("UNNECESSARY_PARENTHESES",
+				     "Unnecessary parentheses$msg\n" . $herecurr);
+			}
+		}
+
 # Return of what appears to be an errno should normally be -'ve
 		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
 			my $name = $1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

