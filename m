From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-fix-file-exclusion-x-logic.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:15 -0800
Message-ID: <201001112018.o0BKIFw7025475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754132Ab0AKUfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:35:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, error27@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: fix file exclusion X: logic
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-fix-file-exclusion-x-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

