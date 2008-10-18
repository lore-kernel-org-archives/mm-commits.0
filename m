From: akpm@linux-foundation.org
Subject: - checkpatch-pull-out-known-acceptable-typedefs.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:06 -0700
Message-ID: <200810182314.m9INE6Lr028339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbYJRXOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: pull out known acceptable typedefs
has been removed from the -mm tree.  Its filename was
     checkpatch-pull-out-known-acceptable-typedefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: pull out known acceptable typedefs
From: Andy Whitcroft <apw@shadowen.org>

Within the type checker we have a number of common kernel types which must
be implemented as typedefs.  Pull those out so that we can use the same
expressions to trigger exclusions.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-pull-out-known-acceptable-typedefs scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-pull-out-known-acceptable-typedefs
+++ a/scripts/checkpatch.pl
@@ -146,6 +146,11 @@ our $UTF8	= qr {
 	|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
 }x;
 
+our $typeTypedefs = qr{(?x:
+	(?:__)?(?:u|s|be|le)(?:\d|\d\d)|
+	atomic_t
+)};
+
 our @typeList = (
 	qr{void},
 	qr{(?:unsigned\s+)?char},
@@ -159,7 +164,6 @@ our @typeList = (
 	qr{float},
 	qr{double},
 	qr{bool},
-	qr{(?:__)?(?:u|s|be|le)(?:\d|\d\d)},
 	qr{struct\s+$Ident},
 	qr{union\s+$Ident},
 	qr{enum\s+$Ident},
@@ -179,6 +183,7 @@ sub build_types {
 			(?:$Modifier\s+|const\s+)*
 			(?:
 				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
+				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
 			(?:\s+$Modifier|\s+const)*
@@ -1589,6 +1594,7 @@ sub process {
 		if ($line =~ /\btypedef\s/ &&
 		    $line !~ /\btypedef\s+$Type\s+\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
+		    $line !~ /\b$typeTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("do not add new typedefs\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

