From: akpm@linux-foundation.org
Subject: + checkpatch-avoid-multiple-line-dereferences.patch added to -mm
 tree
Date: Thu, 03 Nov 2016 15:42:03 -0700
Message-ID: <581bbd3b.ELMViQFqUEZIAGFW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbcKCWmE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2016 18:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid multiple line dereferences
has been added to the -mm tree.  Its filename is
     checkpatch-avoid-multiple-line-dereferences.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-avoid-multiple-line-dereferences.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-avoid-multiple-line-dereferences.patch

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
Subject: checkpatch: avoid multiple line dereferences

Code that puts a single dereferencing identifier on multiple lines like:

     struct_identifier->member[index].
	member = <foo>;

is generally hard to follow.

Prefer that dereferencing identifiers be single line.

Link: http://lkml.kernel.org/r/e9c191ae3f41bedc8ffd5c0fbcc5a1cec1d1d2df.1478120869.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-multiple-line-dereferences scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-multiple-line-dereferences
+++ a/scripts/checkpatch.pl
@@ -3440,6 +3440,18 @@ sub process {
 #ignore lines not being added
 		next if ($line =~ /^[^\+]/);
 
+# check for dereferences that span multiple lines
+		if ($prevline =~ /^\+.*$Lval\s*(?:\.|->)\s*$/ &&
+		    $line =~ /^\+\s*(?!\#\s*(?!define\s+|if))\s*$Lval/) {
+			$prevline =~ /($Lval\s*(?:\.|->))\s*$/;
+			my $ref = $1;
+			$line =~ /^.\s*($Lval)/;
+			$ref .= $1;
+			$ref =~ s/\s//g;
+			WARN("MULTILINE_DEREFERENCE",
+			     "Avoid multiple line dereference - prefer '$ref'\n" . $hereprev);
+		}
+
 # check for declarations of signed or unsigned without int
 		while ($line =~ m{\b($Declare)\s*(?!char\b|short\b|int\b|long\b)\s*($Ident)?\s*[=,;\[\)\(]}g) {
 			my $type = $1;
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-look-for-arbitrary-letter-prefixes-in-sections.patch
checkpatch-dont-check-pl-files-improve-absolute-path-commit-log-test.patch
checkpatch-avoid-multiple-line-dereferences.patch

