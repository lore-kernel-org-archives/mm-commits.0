From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-strict-messages-for-blank-lines-around-braces.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:13 -0800
Message-ID: <20121218201013.AF83E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:32941 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:14 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so126216vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Add --strict messages for blank lines around braces
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-messages-for-blank-lines-around-braces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

