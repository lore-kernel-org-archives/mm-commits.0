From: akpm@linux-foundation.org
Subject: + checkpatch-add-support-for-floating-point-constants.patch added to -mm tree
Date: Mon, 17 Dec 2012 13:51:13 -0800
Message-ID: <20121217215114.A4C8C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:64639 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2LQVvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 16:51:17 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so350147lag.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 13:51:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: add support for floating point constants
has been added to the -mm tree.  Its filename is
     checkpatch-add-support-for-floating-point-constants.patch

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
Subject: checkpatch: add support for floating point constants

Even though the kernel doesn't support using floating point constants,
add a regex for them.

Support forms like: 0x123p1, 123e-1, 1.23, 1.5e23f

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-support-for-floating-point-constants scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-support-for-floating-point-constants
+++ a/scripts/checkpatch.pl
@@ -230,7 +230,11 @@ our $Inline	= qr{inline|__always_inline|
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*)};
+our $Float_hex	= qr{(?i:0x[0-9a-f]+p-?[0-9]+[fl]?)};
+our $Float_dec	= qr{(?i:((?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?))};
+our $Float_int	= qr{(?i:[0-9]+e-?[0-9]+[fl]?)};
+our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
+our $Constant	= qr{(?:$Float|(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*))};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
printk-boot_delay-should-only-affect-output.patch
maintainers-chinese-maintainers-mailing-list-is-subscribers-only.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
checkpatch-warn-about-using-config_experimental.patch
checkpatch-remove-reference-to-feature-removal-scheduletxt.patch
checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch
checkpatch-allow-control-over-line-length-warning-default-remains-80.patch
checkpatch-extend-line-continuation-test.patch
checkpatch-add-strict-messages-for-blank-lines-around-braces.patch
checkpatch-warn-when-declaring-struct-spinlock-foo.patch
checkpatch-add-strict-test-for-switch-default-missing-break.patch
checkpatch-find-hex-constants-as-a-single-ident.patch
checkpatch-add-support-for-floating-point-constants.patch
checkpatch-warn-on-camelcase-variable-names.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

