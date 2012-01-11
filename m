From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-memset-and-min-max-with-cast-checking.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:09 -0800
Message-ID: <20120111213109.A112410004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33196 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab2AKVbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:10 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so137318ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve memset and min/max with cast checking
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-memset-and-min-max-with-cast-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve memset and min/max with cast checking

Improve the checking of arguments to memset and min/max tests.

Move the checking of min/max to statement blocks instead of single line. 
Change $Constant to allow any case type 0x initiator and trailing ul
specifier.  Add $FuncArg type as any function argument with or without a
cast.  Print the whole statement when showing memset or min/max messages. 
Improve the memset with 0 as 3rd argument error message.

There are still weaknesses in the $FuncArg and $Constant code as arbitrary
parentheses and negative signs are not generically supported.

[akpm@linux-foundation.org: fix per Andy]
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   69 +++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-memset-and-min-max-with-cast-checking scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-memset-and-min-max-with-cast-checking
+++ a/scripts/checkpatch.pl
@@ -227,7 +227,7 @@ our $Inline	= qr{inline|__always_inline|
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?:[0-9]+|0x[0-9a-fA-F]+)[UL]*};
+our $Constant	= qr{(?i:(?:[0-9]+|0x[0-9a-f]+)[ul]*)};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
@@ -334,6 +334,7 @@ our $match_balanced_parentheses = qr/(\(
 
 our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
 our $LvalOrFunc	= qr{($Lval)\s*($match_balanced_parentheses{0,1})\s*};
+our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 
 sub deparenthesize {
 	my ($string) = @_;
@@ -2609,28 +2610,6 @@ sub process {
 			}
 		}
 
-# typecasts on min/max could be min_t/max_t
-		if ($line =~ /^\+(?:.*?)\b(min|max)\s*\($Typecast{0,1}($LvalOrFunc)\s*,\s*$Typecast{0,1}($LvalOrFunc)\s*\)/) {
-			if (defined $2 || defined $8) {
-				my $call = $1;
-				my $cast1 = deparenthesize($2);
-				my $arg1 = $3;
-				my $cast2 = deparenthesize($8);
-				my $arg2 = $9;
-				my $cast;
-
-				if ($cast1 ne "" && $cast2 ne "") {
-					$cast = "$cast1 or $cast2";
-				} elsif ($cast1 ne "") {
-					$cast = $cast1;
-				} else {
-					$cast = $cast2;
-				}
-				WARN("MINMAX",
-				     "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
-			}
-		}
-
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
 			ERROR("SPACING", "space required before the open parenthesis '('\n" . $herecurr);
@@ -3121,24 +3100,42 @@ sub process {
 		}
 
 # Check for misused memsets
-		if (defined $stat && $stat =~ /\bmemset\s*\((.*)\)/s) {
-			my $args = $1;
+		if (defined $stat &&
+		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/s) {
+
+			my $ms_addr = $2;
+			my $ms_val = $8;
+			my $ms_size = $14;
 
-			# Flatten any parentheses and braces
-			while ($args =~ s/\([^\(\)]*\)/10/s ||
-			       $args =~ s/\{[^\{\}]*\}/10/s ||
-			       $args =~ s/\[[^\[\]]*\]/10/s)
-			{
-			}
-			# Extract the simplified arguments.
-			my ($ms_addr, $ms_val, $ms_size) =
-						split(/\s*,\s*/, $args);
 			if ($ms_size =~ /^(0x|)0$/i) {
 				ERROR("MEMSET",
-				      "memset size is 3rd argument, not the second.\n" . $herecurr);
+				      "memset to 0's uses 0 as the 2nd argument, not the 3rd\n" . "$here\n$stat\n");
 			} elsif ($ms_size =~ /^(0x|)1$/i) {
 				WARN("MEMSET",
-				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
+				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . "$here\n$stat\n");
+			}
+		}
+
+# typecasts on min/max could be min_t/max_t
+		if (defined $stat &&
+		    $stat =~ /^\+(?:.*?)\b(min|max)\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\)/) {
+			if (defined $2 || defined $8) {
+				my $call = $1;
+				my $cast1 = deparenthesize($2);
+				my $arg1 = $3;
+				my $cast2 = deparenthesize($8);
+				my $arg2 = $9;
+				my $cast;
+
+				if ($cast1 ne "" && $cast2 ne "") {
+					$cast = "$cast1 or $cast2";
+				} elsif ($cast1 ne "") {
+					$cast = $cast1;
+				} else {
+					$cast = $cast2;
+				}
+				WARN("MINMAX",
+				     "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . "$here\n$stat\n");
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

