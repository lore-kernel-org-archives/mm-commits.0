From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-messages-for-blank-lines-around-braces.patch added to -mm tree
Date: Tue, 27 Nov 2012 15:19:51 -0800
Message-ID: <20121127231951.A479882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41459 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab2K0XTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 18:19:52 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so1535923qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 15:19:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: Add --strict messages for blank lines around braces
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-messages-for-blank-lines-around-braces.patch

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
Subject: checkpatch: Add --strict messages for blank lines around braces

Blank lines around braces are not unnecessary.  Emit a message on the use
of these blank lines only when using --strict.

int foo(int bar)
{

	something or other....

}

is generally written in the kernel as:

int foo(int bar)
{
	something or other...
}

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-messages-for-blank-lines-around-braces scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-messages-for-blank-lines-around-braces
+++ a/scripts/checkpatch.pl
@@ -3189,6 +3189,16 @@ sub process {
 			}
 		}
 
+# check for unnecessary blank lines around braces
+		if (($line =~ /^..*}\s*$/ && $prevline =~ /^.\s*$/)) {
+			CHK("BRACES",
+			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
+		}
+		if (($line =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
+			CHK("BRACES",
+			    "Blank lines aren't necessary after an open brace '{'\n" . $hereprev);
+		}
+
 # no volatiles please
 		my $asm_volatile = qr{\b(__asm__|asm)\s+(__volatile__|volatile)\b};
 		if ($line =~ /\bvolatile\b/ && $line !~ /$asm_volatile/) {
_

Patches currently in -mm which might be from joe@perches.com are

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
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

