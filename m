From: akpm@linux-foundation.org
Subject: + checkpatch-warn-when-using-gccs-binary-constant-extension.patch added to -mm tree
Date: Wed, 22 May 2013 15:27:44 -0700
Message-ID: <519d4660.t5zGk/3qb1n3jHEt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3EVW1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 18:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, apw@canonical.com, akpm@linux-foundation.org, joe@perches.com

Subject: + checkpatch-warn-when-using-gccs-binary-constant-extension.patch added to -mm tree
To: joe@perches.com,akpm@linux-foundation.org,apw@canonical.com
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 15:27:44 -0700


The patch titled
     Subject: checkpatch: warn when using gcc's binary constant ("0b") extension
has been added to the -mm tree.  Its filename is
     checkpatch-warn-when-using-gccs-binary-constant-extension.patch

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
Subject: checkpatch: warn when using gcc's binary constant ("0b") extension

The gcc extension for binary constants that start with 0b is only
supported with gcc version 4.3 or higher.

The kernel can still be compiled with earlier versions of gcc, so have
checkpatch emit a warning for these constants.

Restructure checkpatch's constant finding code a bit to support finding
these binary constants.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-warn-when-using-gccs-binary-constant-extension scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-when-using-gccs-binary-constant-extension
+++ a/scripts/checkpatch.pl
@@ -230,11 +230,15 @@ our $Inline	= qr{inline|__always_inline|
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
+our $Int_type	= qr{(?i)llu|ull|ll|lu|ul|l|u};
+our $Binary	= qr{(?i)0b[01]+$Int_type?};
+our $Hex	= qr{(?i)0x[0-9a-f]+$Int_type?};
+our $Int	= qr{[0-9]+$Int_type?};
 our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
 our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
 our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
-our $Constant	= qr{$Float|(?i)(?:0x[0-9a-f]+|[0-9]+)[ul]*};
+our $Constant	= qr{$Float|$Binary|$Hex|$Int};
 our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
@@ -2934,9 +2938,17 @@ sub process {
 			}
 		}
 
-#CamelCase
+#Specific variable tests
 		while ($line =~ m{($Constant|$Lval)}g) {
 			my $var = $1;
+
+#gcc binary extension
+			if ($var =~ /^$Binary$/) {
+				WARN("GCC_BINARY_CONSTANT",
+				     "Avoid gcc v4.3+ binary constant extension: <$var>\n" . $herecurr);
+			}
+
+#CamelCase
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
 			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
lib-bitmapc-speed-up-bitmap_find_free_region.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch

