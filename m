From: akpm@linux-foundation.org
Subject: + checkpatch-allow-control-over-line-length-warning-default-remains-80.patch added to -mm tree
Date: Tue, 20 Nov 2012 13:28:31 -0800
Message-ID: <20121120212832.1236B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:33920 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2KTV2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 16:28:34 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so427613wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 13:28:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, const@makelinux.com


The patch titled
     Subject: checkpatch: allow control over line length warning, default remains 80
has been added to the -mm tree.  Its filename is
     checkpatch-allow-control-over-line-length-warning-default-remains-80.patch

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
Subject: checkpatch: allow control over line length warning, default remains 80

Some projects might want a longer line length so allow a command line
--max-line-length=n control over the long line warnings.  The default line
length is 80.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Constantine Shulyupin <const@makelinux.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-control-over-line-length-warning-default-remains-80 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-control-over-line-length-warning-default-remains-80
+++ a/scripts/checkpatch.pl
@@ -33,6 +33,7 @@ my %ignore_type = ();
 my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
+my $max_line_length = 80;
 
 sub help {
 	my ($exitcode) = @_;
@@ -51,6 +52,7 @@ Options:
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
+  --max-line-length=n        set the maximum line length, if exceeded, warn
   --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
@@ -107,6 +109,7 @@ GetOptions(
 	'strict!'	=> \$check,
 	'ignore=s'	=> \@ignore,
 	'show-types!'	=> \$show_types,
+	'max-line-length=i' => \$max_line_length,
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
@@ -1760,15 +1763,15 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
+#line length limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
 		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
-		    $length > 80)
+		    $length > $max_line_length)
 		{
 			WARN("LONG_LINE",
-			     "line over 80 characters\n" . $herecurr);
+			     "line over $max_line_length characters\n" . $herecurr);
 		}
 
 # Check for user-visible strings broken across lines, which breaks the ability
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-boot_delay-should-only-affect-output.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
checkpatch-warn-about-using-config_experimental.patch
checkpatch-remove-reference-to-feature-removal-scheduletxt.patch
checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch
checkpatch-allow-control-over-line-length-warning-default-remains-80.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

