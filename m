From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-use-correct-indentation.patch added to -mm tree
Date: Thu, 16 Sep 2010 12:53:19 -0700
Message-ID: <201009161953.o8GJrJmF010332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab0IPTxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 15:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: use correct indentation
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-use-correct-indentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: use correct indentation
From: Joe Perches <joe@perches.com>

Fix an overly indented block.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-use-correct-indentation scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-use-correct-indentation
+++ a/scripts/get_maintainer.pl
@@ -420,23 +420,23 @@ foreach my $file (@files) {
 
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	add_categories($line);
-	    if ($sections) {
-		my $i;
-		my $start = find_starting_index($line);
-		my $end = find_ending_index($line);
-		for ($i = $start; $i < $end; $i++) {
-		    my $line = $typevalue[$i];
-		    if ($line =~ /^[FX]:/) {		##Restore file patterns
-			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
-			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
-			$line =~ s/\\\./\./g;       	##Convert \. to .
-			$line =~ s/\.\*/\*/g;       	##Convert .* to *
-		    }
-		    $line =~ s/^([A-Z]):/$1:\t/g;
-		    print("$line\n");
+	if ($sections) {
+	    my $i;
+	    my $start = find_starting_index($line);
+	    my $end = find_ending_index($line);
+	    for ($i = $start; $i < $end; $i++) {
+		my $line = $typevalue[$i];
+		if ($line =~ /^[FX]:/) {		##Restore file patterns
+		    $line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+		    $line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+		    $line =~ s/\\\./\./g;       	##Convert \. to .
+		    $line =~ s/\.\*/\*/g;       	##Convert .* to *
 		}
-		print("\n");
+		$line =~ s/^([A-Z]):/$1:\t/g;
+		print("$line\n");
 	    }
+	    print("\n");
+	}
     }
 
     if ($email && $email_git) {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-irq-subsystem.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

