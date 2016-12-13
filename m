From: akpm@linux-foundation.org
Subject: [patch 119/123] checkpatch: avoid multiple line dereferences
Date: Mon, 12 Dec 2016 16:46:31 -0800
Message-ID: <584f44e7.u8ZyjhUvC/AinFSK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932578AbcLMAqc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

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
