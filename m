From: akpm@linux-foundation.org
Subject: [merged] checkpatch-avoid-multiple-line-dereferences.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:27:54 -0800
Message-ID: <58519d3a.rW1nYP7qoQcCthJr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756372AbcLNT3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid multiple line dereferences
has been removed from the -mm tree.  Its filename was
     checkpatch-avoid-multiple-line-dereferences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


