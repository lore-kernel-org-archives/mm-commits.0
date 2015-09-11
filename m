From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-constant-comparison-on-left-side-test.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:35 -0700
Message-ID: <55f31993.xdlOhnF+Gy/dBdD+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbIKSMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, nmorey@kalray.eu, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add constant comparison on left side test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-constant-comparison-on-left-side-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add constant comparison on left side test

"CONST <comparison> variable" checks like:

        if (NULL != foo)
and
        while (0 < bar(...))

where a constant (or what appears to be a constant like an upper case
identifier) is on the left of a comparison are generally preferred to be
written using the constant on the right side like:

        if (foo != NULL)
and
        while (bar(...) > 0)

Add a test for this.

Add a --fix option too, but only do it when the code is immediately
surrounded by parentheses to avoid misfixing things like "(0 < bar() +
constant)"

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Nicolas Morey Chaisemartin <nmorey@kalray.eu>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-constant-comparison-on-left-side-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-constant-comparison-on-left-side-test
+++ a/scripts/checkpatch.pl
@@ -4231,6 +4231,35 @@ sub process {
 			}
 		}
 
+# comparisons with a constant or upper case identifier on the left
+#	avoid cases like "foo + BAR < baz"
+#	only fix matches surrounded by parentheses to avoid incorrect
+#	conversions like "FOO < baz() + 5" being "misfixed" to "baz() > FOO + 5"
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /^\+(.*)\b($Constant|[A-Z_][A-Z0-9_]*)\s*($Compare)\s*($LvalOrFunc)/) {
+			my $lead = $1;
+			my $const = $2;
+			my $comp = $3;
+			my $to = $4;
+			my $newcomp = $comp;
+			if ($lead !~ /$Operators\s*$/ &&
+			    $to !~ /^(?:Constant|[A-Z_][A-Z0-9_]*)$/ &&
+			    WARN("CONSTANT_COMPARISON",
+				 "Comparisons should place the constant on the right side of the test\n" . $herecurr) &&
+			    $fix) {
+				if ($comp eq "<") {
+					$newcomp = ">";
+				} elsif ($comp eq "<=") {
+					$newcomp = ">=";
+				} elsif ($comp eq ">") {
+					$newcomp = "<";
+				} elsif ($comp eq ">=") {
+					$newcomp = "<=";
+				}
+				$fixed[$fixlinenr] =~ s/\(\s*\Q$const\E\s*$Compare\s*\Q$to\E\s*\)/($to $newcomp $const)/;
+			}
+		}
+
 # Return of what appears to be an errno should normally be negative
 		if ($sline =~ /\breturn(?:\s*\(+\s*|\s+)(E[A-Z]+)(?:\s*\)+\s*|\s*)[;:,]/) {
 			my $name = $1;
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

