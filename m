From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 083/127] checkpatch: additional MAINTAINER section
 entry ordering checks
Date: Thu, 04 Jun 2020 16:50:33 -0700
Message-ID: <20200604235033.TlsBhkPhV%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXuf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:50:35 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andy.shevchenko@gmail.com, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: additional MAINTAINER section entry ordering checks

There is a preferred order for the entries in MAINTAINERS sections.

See:

commit 3b50142d8528 ("MAINTAINERS: sort field names for all entries")
and
commit 6680125ea5a2 ("MAINTAINERS: list the section entries in the preferred order")

Add checkpatch tests to try to keep that ordering.

Link: http://lkml.kernel.org/r/17677130b3ca62d79817e6a22546bad39d7e81b4.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   45 ++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-additional-maintainer-section-entry-ordering-checks
+++ a/scripts/checkpatch.pl
@@ -3062,14 +3062,43 @@ sub process {
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
-# check for MAINTAINERS entries that don't have the right form
-		if ($realfile =~ /^MAINTAINERS$/ &&
-		    $rawline =~ /^\+[A-Z]:/ &&
-		    $rawline !~ /^\+[A-Z]:\t\S/) {
-			if (WARN("MAINTAINERS_STYLE",
-				 "MAINTAINERS entries use one tab after TYPE:\n" . $herecurr) &&
-			    $fix) {
-				$fixed[$fixlinenr] =~ s/^(\+[A-Z]):\s*/$1:\t/;
+# check MAINTAINERS entries
+		if ($realfile =~ /^MAINTAINERS$/) {
+# check MAINTAINERS entries for the right form
+			if ($rawline =~ /^\+[A-Z]:/ &&
+			    $rawline !~ /^\+[A-Z]:\t\S/) {
+				if (WARN("MAINTAINERS_STYLE",
+					 "MAINTAINERS entries use one tab after TYPE:\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/^(\+[A-Z]):\s*/$1:\t/;
+				}
+			}
+# check MAINTAINERS entries for the right ordering too
+			my $preferred_order = 'MRLSWQBCPTFXNK';
+			if ($rawline =~ /^\+[A-Z]:/ &&
+			    $prevrawline =~ /^[\+ ][A-Z]:/) {
+				$rawline =~ /^\+([A-Z]):\s*(.*)/;
+				my $cur = $1;
+				my $curval = $2;
+				$prevrawline =~ /^[\+ ]([A-Z]):\s*(.*)/;
+				my $prev = $1;
+				my $prevval = $2;
+				my $curindex = index($preferred_order, $cur);
+				my $previndex = index($preferred_order, $prev);
+				if ($curindex < 0) {
+					WARN("MAINTAINERS_STYLE",
+					     "Unknown MAINTAINERS entry type: '$cur'\n" . $herecurr);
+				} else {
+					if ($previndex >= 0 && $curindex < $previndex) {
+						WARN("MAINTAINERS_STYLE",
+						     "Misordered MAINTAINERS entry - list '$cur:' before '$prev:'\n" . $hereprev);
+					} elsif ((($prev eq 'F' && $cur eq 'F') ||
+						  ($prev eq 'X' && $cur eq 'X')) &&
+						 ($prevval cmp $curval) > 0) {
+						WARN("MAINTAINERS_STYLE",
+						     "Misordered MAINTAINERS entry - list file patterns in alphabetic order\n" . $hereprev);
+					}
+				}
 			}
 		}
 
_
