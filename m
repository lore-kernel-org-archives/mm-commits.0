From: akpm@linux-foundation.org
Subject: + checkpatch-fix-float-creation-of-match-variables.patch added to -mm tree
Date: Fri, 25 Jan 2013 17:22:44 -0800
Message-ID: <20130126012245.2E0455A42F2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39405 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab3AZBWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 20:22:46 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so99112yen.1
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 17:22:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: Fix $Float creation of match variables
has been added to the -mm tree.  Its filename is
     checkpatch-fix-float-creation-of-match-variables.patch

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
Subject: checkpatch: Fix $Float creation of match variables

commit 74349bccedb ("checkpatch: add support for floating point
constants") added an unnecessary match variable that caused tests that
used a $Constant or $LvalOrFunc to have one too many matches.

This causes problems with usleep_range, min/max and other extended tests.

Avoid using match variables in $Float.
Avoid using match variables in $Assignment too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-float-creation-of-match-variables scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-float-creation-of-match-variables
+++ a/scripts/checkpatch.pl
@@ -230,12 +230,12 @@ our $Inline	= qr{inline|__always_inline|
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Float_hex	= qr{(?i:0x[0-9a-f]+p-?[0-9]+[fl]?)};
-our $Float_dec	= qr{(?i:((?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?))};
-our $Float_int	= qr{(?i:[0-9]+e-?[0-9]+[fl]?)};
+our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
+our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
+our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
-our $Constant	= qr{(?:$Float|(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*))};
-our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
+our $Constant	= qr{$Float|(?i)(?:0x[0-9a-f]+|[0-9]+)[ul]*};
+our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
 			<=|>=|==|!=|
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-fix-float-creation-of-match-variables.patch
linux-next.patch
compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
get_maintainerpl-find-maintainers-for-removed-files.patch
checkpatch-prefer-dev_level-to-dev_printkkern_level.patch
checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch
checkpatch-add-joe-to-maintainers.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch

