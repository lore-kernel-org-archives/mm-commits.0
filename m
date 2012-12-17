From: akpm@linux-foundation.org
Subject: + checkpatch-find-hex-constants-as-a-single-ident.patch added to -mm tree
Date: Mon, 17 Dec 2012 13:51:09 -0800
Message-ID: <20121217215110.9C08820005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33567 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2LQVvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 16:51:12 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so351445eei.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 13:51:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: find hex constants as a single IDENT
has been added to the -mm tree.  Its filename is
     checkpatch-find-hex-constants-as-a-single-ident.patch

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
Subject: checkpatch: find hex constants as a single IDENT

Hexadecimal values are current found in 2 parts.  A hex constant like
0x123456abcdef is found as 0 and then x123456abcdef and later coalesced.

Instead, reverse the order of the 2 searches in $Constant to find 0x
first, then 0 so that the entire hex constant is found all at once.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-find-hex-constants-as-a-single-ident scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-find-hex-constants-as-a-single-ident
+++ a/scripts/checkpatch.pl
@@ -230,7 +230,7 @@ our $Inline	= qr{inline|__always_inline|
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?i:(?:[0-9]+|0x[0-9a-f]+)[ul]*)};
+our $Constant	= qr{(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*)};
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

