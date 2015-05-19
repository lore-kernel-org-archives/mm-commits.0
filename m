From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
 added to -mm tree
Date: Tue, 19 May 2015 16:03:28 -0700
Message-ID: <555bc140.QI17rGK0EiyN7HCC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbESXD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 19:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict warning for c99 fixed size typedefs : int<size>_t
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch

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
Subject: checkpatch: add --strict warning for c99 fixed size typedefs : int<size>_t

Using declarations like u_int16_t in kernel code is not preferred.

Suggest the kernel sized types instead of the c99 types when not in the
uapi directory.

Add a $typeC99Typedefs variable for the types to check and neaten the
other typedef variables.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t
+++ a/scripts/checkpatch.pl
@@ -347,15 +347,20 @@ our $UTF8	= qr{
 	| $NON_ASCII_UTF8
 }x;
 
+our $typeC99Typedefs = qr{(?:__)?(?:[us]_?)?int_?(?:8|16|32|64)_t};
 our $typeOtherOSTypedefs = qr{(?x:
 	u_(?:char|short|int|long) |          # bsd
 	u(?:nchar|short|int|long)            # sysv
 )};
-
-our $typeTypedefs = qr{(?x:
+our $typeKernelTypedefs = qr{(?x:
 	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
 )};
+our $typeTypedefs = qr{(?x:
+	$typeC99Typedefs\b|
+	$typeOtherOSTypedefs\b|
+	$typeKernelTypedefs\b
+)};
 
 our $logFunctions = qr{(?x:
 	printk(?:_ratelimited|_once|)|
@@ -516,7 +521,6 @@ sub build_types {
 	my $allWithAttr = "(?x:  \n" . join("|\n  ", @typeListWithAttr) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$BasicType	= qr{
-				(?:$typeOtherOSTypedefs\b)|
 				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 		}x;
@@ -524,7 +528,6 @@ sub build_types {
 			(?:$Modifier\s+|const\s+)*
 			(?:
 				(?:typeof|__typeof__)\s*\([^\)]*\)|
-				(?:$typeOtherOSTypedefs\b)|
 				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
@@ -542,7 +545,6 @@ sub build_types {
 			(?:
 				(?:typeof|__typeof__)\s*\([^\)]*\)|
 				(?:$typeTypedefs\b)|
-				(?:$typeOtherOSTypedefs\b)|
 				(?:${allWithAttr}\b)
 			)
 			(?:\s+$Modifier|\s+const)*
@@ -3264,7 +3266,6 @@ sub process {
 		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b$typeTypedefs\b/ &&
-		    $line !~ /\b$typeOtherOSTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("NEW_TYPEDEFS",
 			     "do not add new typedefs\n" . $herecurr);
@@ -4980,6 +4981,24 @@ sub process {
 			      "Using weak declarations can have unintended link defects\n" . $herecurr);
 		}
 
+# check for c99 types like uint8_t used outside of uapi/
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b($Declare)\s*$Ident\s*[=;,\[]/) {
+			my $type = $1;
+			if ($type =~ /\b($typeC99Typedefs)\b/) {
+				$type = $1;
+				my $kernel_type = 'u';
+				$kernel_type = 's' if ($type =~ /^_*[si]/);
+				$type =~ /(\d+)/;
+				$kernel_type .= $1;
+				if (CHK("PREFER_KERNEL_TYPES",
+					"Prefer kernel type '$kernel_type' over '$type'\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\b$type\b/$kernel_type/;
+				}
+			}
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

