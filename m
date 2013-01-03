From: akpm@linux-foundation.org
Subject: + checkpatch-prefer-dev_level-to-dev_printkkern_level.patch added to -mm tree
Date: Thu, 03 Jan 2013 12:48:05 -0800
Message-ID: <20130103204806.5C7DC200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:38198 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3ACUsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 15:48:09 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so979417eek.0
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 12:48:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: prefer dev_<level>( to dev_printk(KERN_<LEVEL>
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-dev_level-to-dev_printkkern_level.patch

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
Subject: checkpatch: prefer dev_<level>( to dev_printk(KERN_<LEVEL>

Add YA check to printk style.

dev_<level> uses are functions and generate smaller
object code than dev_printk(KERN_<LEVEL>.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-dev_level-to-dev_printkkern_level scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-dev_level-to-dev_printkkern_level
+++ a/scripts/checkpatch.pl
@@ -2430,6 +2430,15 @@ sub process {
 			     "Prefer pr_warn(... to pr_warning(...\n" . $herecurr);
 		}
 
+		if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
+			my $orig = $1;
+			my $level = lc($orig);
+			$level = "warn" if ($level eq "warning");
+			$level = "dbg" if ($level eq "debug");
+			WARN("PREFER_DEV_LEVEL",
+			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
_

Patches currently in -mm which might be from joe@perches.com are

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
printk-fix-incorrect-length-from-print_time-when-seconds-99999.patch
get_maintainerpl-find-maintainers-for-removed-files.patch
checkpatch-prefer-dev_level-to-dev_printkkern_level.patch

