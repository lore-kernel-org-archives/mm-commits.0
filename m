From: akpm@linux-foundation.org
Subject: - checkpatch-dissallow-spaces-between-stars-in-pointer-types.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:43 -0800
Message-ID: <200901072216.n07MGhMm016458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761996AbZAGWQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: dissallow spaces between stars in pointer types
has been removed from the -mm tree.  Its filename was
     checkpatch-dissallow-spaces-between-stars-in-pointer-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: dissallow spaces between stars in pointer types
From: Andy Whitcroft <apw@shadowen.org>

Disallow spaces within multiple pointer stars (*) in both casts and
definitions.  Both of these would now be reported:

	(char * *)
	char * *foo;

Also now consistently detects and reports the attributes within these
structures making the error report itself clearer.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   52 ++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dissallow-spaces-between-stars-in-pointer-types scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dissallow-spaces-between-stars-in-pointer-types
+++ a/scripts/checkpatch.pl
@@ -191,7 +191,7 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
+			(?:[\s\*]+\s*const|[\s\*]+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
@@ -1344,7 +1344,7 @@ sub process {
 			}
 
 			# any (foo ... *) is a pointer cast, and foo is a type
-			while ($s =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/sg) {
+			while ($s =~ /\(($Ident)(?:\s+$Sparse)*[\s\*]+\s*\)/sg) {
 				possible($1, "C:" . $s);
 			}
 
@@ -1618,21 +1618,39 @@ sub process {
 		}
 
 # * goes on variable not on type
-		if ($line =~ m{\($NonptrType(\*+)(?:\s+const)?\)}) {
-			ERROR("\"(foo$1)\" should be \"(foo $1)\"\n" .
-				$herecurr);
-
-		} elsif ($line =~ m{\($NonptrType\s+(\*+)(?!\s+const)\s+\)}) {
-			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n" .
-				$herecurr);
-
-		} elsif ($line =~ m{\b$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {
-			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n" .
-				$herecurr);
-
-		} elsif ($line =~ m{\b$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {
-			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n" .
-				$herecurr);
+		# (char*[ const])
+		if ($line =~ m{\($NonptrType(\s*\*[\s\*]*(?:$Modifier\s*)*)\)}) {
+			my ($from, $to) = ($1, $1);
+
+			# Should start with a space.
+			$to =~ s/^(\S)/ $1/;
+			# Should not end with a space.
+			$to =~ s/\s+$//;
+			# '*'s should not have spaces between.
+			while ($to =~ s/(.)\s\*/$1\*/) {
+			}
+
+			#print "from<$from> to<$to>\n";
+			if ($from ne $to) {
+				ERROR("\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
+			}
+		} elsif ($line =~ m{\b$NonptrType(\s*\*[\s\*]*(?:$Modifier\s*)?)($Ident)}) {
+			my ($from, $to, $ident) = ($1, $1, $2);
+
+			# Should start with a space.
+			$to =~ s/^(\S)/ $1/;
+			# Should not end with a space.
+			$to =~ s/\s+$//;
+			# '*'s should not have spaces between.
+			while ($to =~ s/(.)\s\*/$1\*/) {
+			}
+			# Modifiers should have spaces.
+			$to =~ s/(\b$Modifier$)/$1 /;
+
+			#print "from<$from> to<$to>\n";
+			if ($from ne $to) {
+				ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
+			}
 		}
 
 # # no BUG() or BUG_ON()
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch

