From: akpm@linux-foundation.org
Subject: +
 checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch added to -mm tree
Date: Mon, 31 Mar 2014 15:20:07 -0700
Message-ID: <5339ea17.UnxefDaPFffb9QWg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaCaWUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 18:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 15:20:07 -0700


The patch titled
     Subject: checkpatch: expand parenthesis alignment test to declarations, functions and assignments
has been added to the -mm tree.  Its filename is
     checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch

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

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
 
@@ -429,7 +429,7 @@ sub build_types {
 			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
-	$Declare	= qr{(?:$Storage\s+)?$Type};
+	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};
 }
 build_types();
 
@@ -1607,7 +1607,7 @@ sub pos_last_openparen {
 		}
 	}
 
-	return $last_openparen + 1;
+	return length(expand_tabs(substr($line, 0, $last_openparen))) + 1;
 }
 
 sub process {
@@ -2200,7 +2200,7 @@ sub process {
 
 # check multi-line statement indentation matches previous line
 		if ($^V && $^V ge 5.10.0 &&
-		    $prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
+		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|$Ident\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
 			$prevline =~ /^\+(\t*)(.*)$/;
 			my $oldindent = $1;
 			my $rest = $2;
_

Patches currently in -mm which might be from joe@perches.com are

ntfs-logging-clean-up.patch
errh-use-bool-for-is_err-and-is_err_or_null.patch
maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch
maintainers-addition-of-dialog-semiconductor-files.patch
maintainers-remove-venkatesh-from-hpet-move-to-credits.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
checkpatchpl-modify-warning-message-for-printk-usage.patch
checkpatch-improve-octal-permissions-test-speed.patch
checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatchpl-add-check-for-change-id.patch
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments-fix.patch
checkpatch-dont-warn-on-bitfield-spaces-around.patch
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
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
linux-next.patch

