From: akpm@linux-foundation.org
Subject: [merged] checkpatch-allow-control-over-line-length-warning-default-remains-80.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:54 -0800
Message-ID: <20121218200654.AC00B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:49144 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab2LRUGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:55 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so124791yhl.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, const@makelinux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow control over line length warning, default remains 80
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-control-over-line-length-warning-default-remains-80.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

