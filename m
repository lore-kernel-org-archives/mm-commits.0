From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-fix-file-exclusion-x-logic.patch added to -mm tree
Date: Wed, 30 Dec 2009 15:21:01 -0800
Message-ID: <200912302321.nBUNL1FD007908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbZL3XVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 18:21:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, error27@gmail.com


The patch titled
     scripts/get_maintainer.pl: fix file exclusion X: logic
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-fix-file-exclusion-x-logic.patch

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
Subject: scripts/get_maintainer.pl: fix file exclusion X: logic
From: Joe Perches <joe@perches.com>

The following command doesn't generate any output.
`./scripts/get_maintainer.pl --no-git -f drivers/net/wireless/wl12xx/wl1271_acx.c`

An excluded "X:" pattern match in any section would cause a file not to
match any other section.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   82 +++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 29 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-fix-file-exclusion-x-logic scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-fix-file-exclusion-x-logic
+++ a/scripts/get_maintainer.pl
@@ -296,46 +296,56 @@ my @status = ();
 
 foreach my $file (@files) {
 
-#Do not match excluded file patterns
+    my %hash;
+    my $tvi = find_first_section();
+    while ($tvi < @typevalue) {
+	my $start = find_starting_index($tvi);
+	my $end = find_ending_index($tvi);
+	my $exclude = 0;
+	my $i;
 
-    my $exclude = 0;
-    foreach my $line (@typevalue) {
-	if ($line =~ m/^(\C):\s*(.*)/) {
-	    my $type = $1;
-	    my $value = $2;
-	    if ($type eq 'X') {
-		if (file_match_pattern($file, $value)) {
-		    $exclude = 1;
-		    last;
-		}
-	    }
-	}
-    }
+	#Do not match excluded file patterns
 
-    if (!$exclude) {
-	my $tvi = 0;
-	my %hash;
-	foreach my $line (@typevalue) {
+	for ($i = $start; $i < $end; $i++) {
+	    my $line = $typevalue[$i];
 	    if ($line =~ m/^(\C):\s*(.*)/) {
 		my $type = $1;
 		my $value = $2;
-		if ($type eq 'F') {
+		if ($type eq 'X') {
 		    if (file_match_pattern($file, $value)) {
-			my $value_pd = ($value =~ tr@/@@);
-			my $file_pd = ($file  =~ tr@/@@);
-			$value_pd++ if (substr($value,-1,1) ne "/");
-			if ($pattern_depth == 0 ||
-			    (($file_pd - $value_pd) < $pattern_depth)) {
-			    $hash{$tvi} = $value_pd;
-			}
+			$exclude = 1;
 		    }
 		}
 	    }
-	    $tvi++;
 	}
-	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-	    add_categories($line);
+
+	if (!$exclude) {
+	    for ($i = $start; $i < $end; $i++) {
+		my $line = $typevalue[$i];
+		if ($line =~ m/^(\C):\s*(.*)/) {
+		    my $type = $1;
+		    my $value = $2;
+		    if ($type eq 'F') {
+			if (file_match_pattern($file, $value)) {
+			    my $value_pd = ($value =~ tr@/@@);
+			    my $file_pd = ($file  =~ tr@/@@);
+			    $value_pd++ if (substr($value,-1,1) ne "/");
+			    if ($pattern_depth == 0 ||
+				(($file_pd - $value_pd) < $pattern_depth)) {
+				$hash{$tvi} = $value_pd;
+			    }
+			}
+		    }
+		}
+	    }
 	}
+
+	$tvi += ($end - $start);
+
+    }
+
+    foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	add_categories($line);
     }
 
     if ($email && $email_git) {
@@ -570,6 +580,20 @@ sub format_email {
     return $formatted_email;
 }
 
+sub find_first_section {
+    my $index = 0;
+
+    while ($index < @typevalue) {
+	my $tv = $typevalue[$index];
+	if (($tv =~ m/^(\C):\s*(.*)/)) {
+	    last;
+	}
+	$index++;
+    }
+
+    return $index;
+}
+
 sub find_starting_index {
     my ($index) = @_;
 
_

Patches currently in -mm which might be from joe@perches.com are

scripts-get_maintainerpl-fix-file-exclusion-x-logic.patch
linux-next.patch
vsnprintf-fix-reference-for-compressed-ipv6-addresses.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

