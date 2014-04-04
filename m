From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:30 -0700
Message-ID: <533f0946.MmLHVrapTOMJb8uM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaDDTea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:30 -0700


The patch titled
     Subject: checkpatch: expand parenthesis alignment test to declarations, functions and assignments
has been removed from the -mm tree.  Its filename was
     checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: expand parenthesis alignment test to declarations, functions and assignments

Currently the parenthesis alignment test works only on
misalignments of if statements like

	if (foo(bar,
			baz)

Expand the test to find misalignments like:

static inline int foo(int bar,
			int baz)

and

	foo(bar,
			baz);

and

	foo = bar(baz,
			qux);

Expand the $Inline keyword for __inline and __inline__ too.
Add $Inline to $Declare so it also matches "static inline <foo>".

These checks are only performed with --strict.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments
+++ a/scripts/checkpatch.pl
@@ -281,7 +281,7 @@ our $Attribute	= qr{
 			__weak
 		  }x;
 our $Modifier;
-our $Inline	= qr{inline|__always_inline|noinline};
+our $Inline	= qr{inline|__always_inline|noinline|__inline|__inline__};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
@@ -304,6 +304,8 @@ our $Operators	= qr{
 			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
 		  }x;
 
+our $c90_Keywords = qr{do|for|while|if|else|return|goto|continue|switch|default|case|break}x;
+
 our $NonptrType;
 our $NonptrTypeWithAttr;
 our $Type;
@@ -429,7 +431,7 @@ sub build_types {
 			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
-	$Declare	= qr{(?:$Storage\s+)?$Type};
+	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};
 }
 build_types();
 
@@ -1607,7 +1609,7 @@ sub pos_last_openparen {
 		}
 	}
 
-	return $last_openparen + 1;
+	return length(expand_tabs(substr($line, 0, $last_openparen))) + 1;
 }
 
 sub process {
@@ -2200,7 +2202,7 @@ sub process {
 
 # check multi-line statement indentation matches previous line
 		if ($^V && $^V ge 5.10.0 &&
-		    $prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
+		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|$Ident\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
 			$prevline =~ /^\+(\t*)(.*)$/;
 			my $oldindent = $1;
 			my $rest = $2;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

