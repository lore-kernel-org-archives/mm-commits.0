From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-types-for-other-os-typedefs.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:21 -0800
Message-ID: <54e25051.HagmtYIBScsnRYbt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbbBPUR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add types for other OS typedefs
has been removed from the -mm tree.  Its filename was
     checkpatch-add-types-for-other-os-typedefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add types for other OS typedefs

bsd and sysv use different typedefs for unsigned types.

These are in types.h but not in checkpatch, so add them to checkpatch's
ability to know types.

This can avoid false positives for code like:

void foo(void)
{
	int x;
	uint y;

	[...];
}

where checkpatch incorrectly emits a warning for "missing a blank line
after declarations".

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-types-for-other-os-typedefs scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-types-for-other-os-typedefs
+++ a/scripts/checkpatch.pl
@@ -339,6 +339,11 @@ our $UTF8	= qr{
 	| $NON_ASCII_UTF8
 }x;
 
+our $typeOtherOSTypedefs = qr{(?x:
+	u_(?:char|short|int|long) |          # bsd
+	u(?:nchar|short|int|long)            # sysv
+)};
+
 our $typeTypedefs = qr{(?x:
 	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
@@ -475,6 +480,7 @@ sub build_types {
 			(?:$Modifier\s+|const\s+)*
 			(?:
 				(?:typeof|__typeof__)\s*\([^\)]*\)|
+				(?:$typeOtherOSTypedefs\b)|
 				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
@@ -492,6 +498,7 @@ sub build_types {
 			(?:
 				(?:typeof|__typeof__)\s*\([^\)]*\)|
 				(?:$typeTypedefs\b)|
+				(?:$typeOtherOSTypedefs\b)|
 				(?:${allWithAttr}\b)
 			)
 			(?:\s+$Modifier|\s+const)*
@@ -3159,6 +3166,7 @@ sub process {
 		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b$typeTypedefs\b/ &&
+		    $line !~ /\b$typeOtherOSTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("NEW_TYPEDEFS",
 			     "do not add new typedefs\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

