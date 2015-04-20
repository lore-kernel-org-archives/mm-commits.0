From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-test-for-repeated-const-uses.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:01 -0700
Message-ID: <553550ad.17L3nQjeeSqMraOt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbbDTTKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for repeated const uses
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-repeated-const-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for repeated const uses

Using 'const <type> const *' is generally meant to be written 'const
<type> * const'.

Add a test for the miswritten form.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-repeated-const-uses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-repeated-const-uses
+++ a/scripts/checkpatch.pl
@@ -323,6 +323,7 @@ our $Operators	= qr{
 
 our $c90_Keywords = qr{do|for|while|if|else|return|goto|continue|switch|default|case|break}x;
 
+our $BasicType;
 our $NonptrType;
 our $NonptrTypeMisordered;
 our $NonptrTypeWithAttr;
@@ -514,6 +515,11 @@ sub build_types {
 	my $Misordered = "(?x:  \n" . join("|\n  ", @typeListMisordered) . "\n)";
 	my $allWithAttr = "(?x:  \n" . join("|\n  ", @typeListWithAttr) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
+	$BasicType	= qr{
+				(?:$typeOtherOSTypedefs\b)|
+				(?:$typeTypedefs\b)|
+				(?:${all}\b)
+		}x;
 	$NonptrType	= qr{
 			(?:$Modifier\s+|const\s+)*
 			(?:
@@ -3192,6 +3198,18 @@ sub process {
 				$herecurr);
                }
 
+# check for const <foo> const where <foo> is not a pointer or array type
+		if ($sline =~ /\bconst\s+($BasicType)\s+const\b/) {
+			my $found = $1;
+			if ($sline =~ /\bconst\s+\Q$found\E\s+const\b\s*\*/) {
+				WARN("CONST_CONST",
+				     "'const $found const *' should probably be 'const $found * const'\n" . $herecurr);
+			} elsif ($sline !~ /\bconst\s+\Q$found\E\s+const\s+\w+\s*\[/) {
+				WARN("CONST_CONST",
+				     "'const $found const' should probably be 'const $found'\n" . $herecurr);
+			}
+		}
+
 # check for non-global char *foo[] = {"bar", ...} declarations.
 		if ($line =~ /^.\s+(?:static\s+|const\s+)?char\s+\*\s*\w+\s*\[\s*\]\s*=\s*\{/) {
 			WARN("STATIC_CONST_CHAR_ARRAY",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

