From: akpm@linux-foundation.org
Subject: + checkpatch-add-types-for-other-os-typedefs.patch added to -mm
 tree
Date: Thu, 22 Jan 2015 11:52:11 -0800
Message-ID: <54c154eb.YTTU+JuV52rJgvl3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbbAVTw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 14:52:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add types for other OS typedefs
has been added to the -mm tree.  Its filename is
     checkpatch-add-types-for-other-os-typedefs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-types-for-other-os-typedefs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-types-for-other-os-typedefs.patch

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
@@ -337,6 +337,11 @@ our $UTF8	= qr{
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
@@ -473,6 +478,7 @@ sub build_types {
 			(?:$Modifier\s+|const\s+)*
 			(?:
 				(?:typeof|__typeof__)\s*\([^\)]*\)|
+				(?:$typeOtherOSTypedefs\b)|
 				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
@@ -490,6 +496,7 @@ sub build_types {
 			(?:
 				(?:typeof|__typeof__)\s*\([^\)]*\)|
 				(?:$typeTypedefs\b)|
+				(?:$typeOtherOSTypedefs\b)|
 				(?:${allWithAttr}\b)
 			)
 			(?:\s+$Modifier|\s+const)*
@@ -3124,6 +3131,7 @@ sub process {
 		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b$typeTypedefs\b/ &&
+		    $line !~ /\b$typeOtherOSTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("NEW_TYPEDEFS",
 			     "do not add new typedefs\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

printk-correct-timeout-comment-neaten-module_parm_desc.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
checkpatch-improve-octal-permissions-tests.patch
checkpatch-ignore-__pure-attribute.patch
checkpatch-fix-unnecessary_kern_level-false-positive.patch
checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
checkpatch-update-git-commit-message.patch
checkpatch-add-likely-unlikely-comparison-misuse-test.patch
checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch
checkpatch-add-types-for-other-os-typedefs.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

