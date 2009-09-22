From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-add-maintainers-in-order-listed-in-matched-section.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:16 -0700
Message-ID: <200909222045.n8MKjGoh015365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbZIVUpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:45:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: add maintainers in order listed in matched section
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-add-maintainers-in-order-listed-in-matched-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: add maintainers in order listed in matched section
From: Joe Perches <joe@perches.com>

Previous behavior was "bottom-up" in each section from the pattern "F:"
entry that matched.  Now information is entered into the various lists in
the "as entered" order for each matched section.

This also allows the F: entry to be put anywhere in a section, not just as
the last entries in the section.

And a couple of improvements:

Don't alphabetically sort before outputting the matched scm, status,
subsystem and web sections.

Ignore content after a single email address so these entries are acceptable
M:	name <address> whatever other comment

And a fix:

Make an M: entry without a name again use the name from an immediately
preceding P: line if it exists.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   70 +++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 16 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-maintainers-in-order-listed-in-matched-section scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-maintainers-in-order-listed-in-matched-section
+++ a/scripts/get_maintainer.pl
@@ -313,22 +313,22 @@ if ($email || $email_list) {
 }
 
 if ($scm) {
-    @scm = sort_and_uniq(@scm);
+    @scm = uniq(@scm);
     output(@scm);
 }
 
 if ($status) {
-    @status = sort_and_uniq(@status);
+    @status = uniq(@status);
     output(@status);
 }
 
 if ($subsystem) {
-    @subsystem = sort_and_uniq(@subsystem);
+    @subsystem = uniq(@subsystem);
     output(@subsystem);
 }
 
 if ($web) {
-    @web = sort_and_uniq(@web);
+    @web = uniq(@web);
     output(@web);
 }
 
@@ -442,7 +442,7 @@ sub parse_email {
 	$address = $2;
     } elsif ($formatted_email =~ /^\s*<(.+\@\S*)>.*$/) {
 	$address = $1;
-    } elsif ($formatted_email =~ /^(.+\@\S*)$/) {
+    } elsif ($formatted_email =~ /^(.+\@\S*).*$/) {
 	$address = $1;
     }
 
@@ -485,12 +485,46 @@ sub format_email {
     return $formatted_email;
 }
 
-sub add_categories {
+sub find_starting_index {
+
+    my ($index) = @_;
+
+    while ($index > 0) {
+	my $tv = $typevalue[$index];
+	if (!($tv =~ m/^(\C):\s*(.*)/)) {
+	    last;
+	}
+	$index--;
+    }
+
+    return $index;
+}
+
+sub find_ending_index {
     my ($index) = @_;
 
-    $index = $index - 1;
-    while ($index >= 0) {
+    while ($index < @typevalue) {
 	my $tv = $typevalue[$index];
+	if (!($tv =~ m/^(\C):\s*(.*)/)) {
+	    last;
+	}
+	$index++;
+    }
+
+    return $index;
+}
+
+sub add_categories {
+    my ($index) = @_;
+
+    my $i;
+    my $start = find_starting_index($index);
+    my $end = find_ending_index($index);
+
+    push(@subsystem, $typevalue[$start]);
+
+    for ($i = $start + 1; $i < $end; $i++) {
+	my $tv = $typevalue[$i];
 	if ($tv =~ m/^(\C):\s*(.*)/) {
 	    my $ptype = $1;
 	    my $pvalue = $2;
@@ -513,11 +547,12 @@ sub add_categories {
 	    } elsif ($ptype eq "M") {
 		my ($name, $address) = parse_email($pvalue);
 		if ($name eq "") {
-		    if ($index >= 0) {
-			my $tv = $typevalue[$index - 1];
+		    if ($i > 0) {
+			my $tv = $typevalue[$i - 1];
 			if ($tv =~ m/^(\C):\s*(.*)/) {
 			    if ($1 eq "P") {
 				$name = $2;
+				$pvalue = format_email($name, $address);
 			    }
 			}
 		    }
@@ -532,11 +567,6 @@ sub add_categories {
 	    } elsif ($ptype eq "S") {
 		push(@status, $pvalue);
 	    }
-
-	    $index--;
-	} else {
-	    push(@subsystem,$tv);
-	    $index = -1;
 	}
     }
 }
@@ -559,6 +589,10 @@ sub push_email_address {
 
     my ($name, $address) = parse_email($line);
 
+    if ($address eq "") {
+	return 0;
+    }
+
     if (!$email_remove_duplicates) {
 	push(@email_to, format_email($name, $address));
     } elsif (!email_inuse($name, $address)) {
@@ -566,6 +600,8 @@ sub push_email_address {
 	$email_hash_name{$name}++;
 	$email_hash_address{$address}++;
     }
+
+    return 1;
 }
 
 sub push_email_addresses {
@@ -581,7 +617,9 @@ sub push_email_addresses {
 	    push_email_address($entry);
 	}
     } else {
-	warn("Invalid MAINTAINERS address: '" . $address . "'\n");
+	if (!push_email_address($address)) {
+	    warn("Invalid MAINTAINERS address: '" . $address . "'\n");
+	}
     }
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
ncpfs-remove-dead-url-from-documentation.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

