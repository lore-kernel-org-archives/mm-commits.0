From: akpm@linux-foundation.org
Subject: + checkpatch-whine-about-access_once.patch added to -mm tree
Date: Fri, 22 Apr 2016 13:14:08 -0700
Message-ID: <571a8610.KCuoyTOFDKgk8gxj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbcDVUOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: whine about ACCESS_ONCE
has been added to the -mm tree.  Its filename is
     checkpatch-whine-about-access_once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-whine-about-access_once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-whine-about-access_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-add-prefer_is_enabled-test.patch
checkpatch-improve-constant_comparison-test-for-structure-members.patch
checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch
checkpatch-whine-about-access_once.patch

