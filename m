From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-octal-permissions-tests.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:03 -0800
Message-ID: <54e2503f.ZRGYm6otLsHkmlgR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbBPURj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve octal permissions tests
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-octal-permissions-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve octal permissions tests

Add world writable permissions tests for the various functions like
debugfs etc...

Add $String type for $FuncArg so that string constants are matched.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-octal-permissions-tests scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-octal-permissions-tests
+++ a/scripts/checkpatch.pl
@@ -298,6 +298,7 @@ our $Binary	= qr{(?i)0b[01]+$Int_type?};
 our $Hex	= qr{(?i)0x[0-9a-f]+$Int_type?};
 our $Int	= qr{[0-9]+$Int_type?};
 our $Octal	= qr{0[0-7]+$Int_type?};
+our $String	= qr{"[X\t]*"};
 our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
 our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
 our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
@@ -517,7 +518,7 @@ our $Typecast	= qr{\s*(\(\s*$NonptrType\
 
 our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
 our $LvalOrFunc	= qr{((?:[\&\*]\s*)?$Lval)\s*($balanced_parens{0,1})\s*};
-our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
+our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant|$String)};
 
 our $declaration_macros = qr{(?x:
 	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,2}\s*\(|
@@ -5261,6 +5262,9 @@ sub process {
 					     length($val) ne 4)) {
 						ERROR("NON_OCTAL_PERMISSIONS",
 						      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
+					} elsif ($val =~ /^$Octal$/ && (oct($val) & 02)) {
+						ERROR("EXPORTED_WORLD_WRITABLE",
+						      "Exporting writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 					}
 				}
 			}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

