From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-strict-check-for-ifs-with-unnecessary-parentheses.patch
 removed from -mm tree
Date: Wed, 13 Sep 2017 15:43:36 -0700
Message-ID: <59b9b498.+FQ7XGcV792SEqtI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMWni (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 18:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict check for ifs with unnecessary parentheses
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-check-for-ifs-with-unnecessary-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict check for ifs with unnecessary parentheses

An if statement test like
	if ((foo == bar) && (baz != qux))
can arguably be better written without the parentheses as
	if (foo == bar && baz != qux)

Add a test to find these cases.

Link: http://lkml.kernel.org/r/dcd0561ddd0fa43c51a420d53b550d738bf42001.1502734458.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-check-for-ifs-with-unnecessary-parentheses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-check-for-ifs-with-unnecessary-parentheses
+++ a/scripts/checkpatch.pl
@@ -4521,6 +4521,30 @@ sub process {
 			}
 		}
 
+# check for unnecessary parentheses around comparisons in if uses
+		if ($^V && $^V ge 5.10.0 && defined($stat) &&
+		    $stat =~ /(^.\s*if\s*($balanced_parens))/) {
+			my $if_stat = $1;
+			my $test = substr($2, 1, -1);
+			my $herectx;
+			while ($test =~ /(?:^|[^\w\&\!\~])+\s*\(\s*([\&\!\~]?\s*$Lval\s*(?:$Compare\s*$FuncArg)?)\s*\)/g) {
+				my $match = $1;
+				# avoid parentheses around potential macro args
+				next if ($match =~ /^\s*\w+\s*$/);
+				if (!defined($herectx)) {
+					$herectx = $here . "\n";
+					my $cnt = statement_rawlines($if_stat);
+					for (my $n = 0; $n < $cnt; $n++) {
+						my $rl = raw_line($linenr, $n);
+						$herectx .=  $rl . "\n";
+						last if $rl =~ /^[ \+].*\{/;
+					}
+				}
+				CHK("UNNECESSARY_PARENTHESES",
+				    "Unnecessary parentheses around '$match'\n" . $herectx);
+			}
+		}
+
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
_

Patches currently in -mm which might be from joe@perches.com are

parse-maintainers-add-ability-to-specify-filenames.patch

