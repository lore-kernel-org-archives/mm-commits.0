From: akpm@linux-foundation.org
Subject: [merged] checkpatch-whine-about-access_once.patch removed from
 -mm tree
Date: Mon, 23 May 2016 12:51:37 -0700
Message-ID: <57435f49.ehR1SVbO/FD1jw72%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbcEWTvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: whine about ACCESS_ONCE
has been removed from the -mm tree.  Its filename was
     checkpatch-whine-about-access_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: whine about ACCESS_ONCE

Add a test for use of ACCESS_ONCE that could be written using READ_ONCE or
WRITE_ONCE.

--fix it too if desired.

The WRITE_ONCE fixes are less correct than the coccinelle script below as
checkpatch cannot have a completely correct "expression" mechanism because
checkpatch works on patches and not complete files.

$ cat access_once.cocci
@@
expression e1;
expression e2;
@@

-       ACCESS_ONCE(e1) = e2
+       WRITE_ONCE(e1, e2)

@@
expression e1;
@@

-       ACCESS_ONCE(e1)
+       READ_ONCE(e1)

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-whine-about-access_once scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-whine-about-access_once
+++ a/scripts/checkpatch.pl
@@ -5850,6 +5850,28 @@ sub process {
 			}
 		}
 
+# whine about ACCESS_ONCE
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\bACCESS_ONCE\s*$balanced_parens\s*(=(?!=))?\s*($FuncArg)?/) {
+			my $par = $1;
+			my $eq = $2;
+			my $fun = $3;
+			$par =~ s/^\(\s*(.*)\s*\)$/$1/;
+			if (defined($eq)) {
+				if (WARN("PREFER_WRITE_ONCE",
+					 "Prefer WRITE_ONCE(<FOO>, <BAR>) over ACCESS_ONCE(<FOO>) = <BAR>\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\bACCESS_ONCE\s*\(\s*\Q$par\E\s*\)\s*$eq\s*\Q$fun\E/WRITE_ONCE($par, $fun)/;
+				}
+			} else {
+				if (WARN("PREFER_READ_ONCE",
+					 "Prefer READ_ONCE(<FOO>) over ACCESS_ONCE(<FOO>)\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\bACCESS_ONCE\s*\(\s*\Q$par\E\s*\)/READ_ONCE($par)/;
+				}
+			}
+		}
+
 # check for lockdep_set_novalidate_class
 		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
 		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch
checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch
checkpatch-reduce-number-of-git-log-calls-with-git.patch
checkpatch-improve-git-commit-count-shortcut.patch

