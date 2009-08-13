From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:49:13 -0700
Message-ID: <200908132149.n7DLnDDf012834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbZHMV7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: better email routines, use perl not shell where possible
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch

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
Subject: scripts/get_maintainer.pl: better email routines, use perl not shell where possible
From: Joe Perches <joe@perches.com>

Added format_email and parse_email routines to reduce inline use.

Added email_address_inuse to eliminate multiple maintainer entries
for the same email address, the first name encountered is used.

Used internal perl equivalents of shell cmd use of grep|cut|sort|uniq

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  152 ++++++++++++++++++++++--------------
 1 file changed, 96 insertions(+), 56 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.19';
+my $V = '0.20';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -258,11 +258,8 @@ if ($email) {
     foreach my $chief (@penguin_chief) {
 	if ($chief =~ m/^(.*):(.*)/) {
 	    my $email_address;
-	    if ($email_usename) {
-		$email_address = format_email($1, $2);
-	    } else {
-		$email_address = $2;
-	    }
+
+	    $email_address = format_email($1, $2);
 	    if ($email_git_penguin_chiefs) {
 		push(@email_to, $email_address);
 	    } else {
@@ -400,21 +397,57 @@ sub top_of_kernel_tree {
 	return 0;
 }
 
-sub format_email {
-    my ($name, $email) = @_;
+sub parse_email {
+    my ($formatted_email) = @_;
+
+    my $name = "";
+    my $address = "";
+
+    if ($formatted_email =~ /^([^<]+)<(.*\@.*)>$/) {
+	$name = $1;
+	$address = $2;
+    } elsif ($formatted_email =~ /^<(.*\@.*)>$/) {
+	$address = $1;
+    } elsif ($formatted_email =~ /^(.*\@.*)$/) {
+	$address = $1;
+    }
 
     $name =~ s/^\s+|\s+$//g;
     $name =~ s/^\"|\"$//g;
-    $email =~ s/^\s+|\s+$//g;
+    $address =~ s/^\s+|\s+$//g;
 
-    my $formatted_email = "";
+    if ($name =~ /[^a-z0-9 \.\-]/i) {    ##has "must quote" chars
+	$name =~ s/(?<!\\)"/\\"/g;       ##escape quotes
+	$name = "\"$name\"";
+    }
+
+    return ($name, $address);
+}
+
+sub format_email {
+    my ($name, $address) = @_;
+
+    my $formatted_email;
+
+    $name =~ s/^\s+|\s+$//g;
+    $name =~ s/^\"|\"$//g;
+    $address =~ s/^\s+|\s+$//g;
 
     if ($name =~ /[^a-z0-9 \.\-]/i) {    ##has "must quote" chars
 	$name =~ s/(?<!\\)"/\\"/g;       ##escape quotes
-	$formatted_email = "\"${name}\"\ \<${email}\>";
+	$name = "\"$name\"";
+    }
+
+    if ($email_usename) {
+	if ("$name" eq "") {
+	    $formatted_email = "$address";
+	} else {
+	    $formatted_email = "$name <${address}>";
+	}
     } else {
-	$formatted_email = "${name} \<${email}\>";
+	$formatted_email = $address;
     }
+
     return $formatted_email;
 }
 
@@ -444,19 +477,18 @@ sub add_categories {
 		    }
 		}
 	    } elsif ($ptype eq "M") {
-		my $p_used = 0;
-		if ($index >= 0) {
-		    my $tv = $typevalue[$index - 1];
-		    if ($tv =~ m/^(\C):\s*(.*)/) {
-			if ($1 eq "P") {
-			    if ($email_usename) {
-				push_email_address(format_email($2, $pvalue));
-				$p_used = 1;
+		my ($name, $address) = parse_email($pvalue);
+		if ($name eq "") {
+		    if ($index >= 0) {
+			my $tv = $typevalue[$index - 1];
+			if ($tv =~ m/^(\C):\s*(.*)/) {
+			    if ($1 eq "P") {
+				$name = $2;
 			    }
 			}
 		    }
 		}
-		if (!$p_used) {
+		if ($email_maintainer) {
 		    push_email_addresses($pvalue);
 		}
 	    } elsif ($ptype eq "T") {
@@ -475,26 +507,24 @@ sub add_categories {
     }
 }
 
+sub email_address_inuse {
+    my ($test_address) = @_;
+
+    foreach my $line (@email_to) {
+	my ($name, $address) = parse_email($line);
+
+	return 1 if ($address eq $test_address);
+    }
+    return 0;
+}
+
 sub push_email_address {
-    my ($email_address) = @_;
+    my ($line) = @_;
 
-    my $email_name = "";
+    my ($name, $address) = parse_email($line);
 
-    if ($email_maintainer) {
-	if ($email_address =~ m/([^<]+)<(.*\@.*)>$/) {
-	    $email_name = $1;
-	    $email_address = $2;
-	    if ($email_usename) {
-		push(@email_to, format_email($email_name, $email_address));
-	    } else {
-		push(@email_to, $email_address);
-	    }
-	} elsif ($email_address =~ m/<(.+)>/) {
-	    $email_address = $1;
-	    push(@email_to, $email_address);
-	} else {
-	    push(@email_to, $email_address);
-	}
+    if (!email_address_inuse($address)) {
+	push(@email_to, format_email($name, $address));
     }
 }
 
@@ -535,6 +565,7 @@ sub recent_git_signoffs {
     my $output = "";
     my $count = 0;
     my @lines = ();
+    my %hash;
     my $total_sign_offs;
 
     if (which("git") eq "") {
@@ -548,25 +579,31 @@ sub recent_git_signoffs {
     }
 
     $cmd = "git log --since=${email_git_since} -- ${file}";
-    $cmd .= " | grep -Ei \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
-    if (!$email_git_penguin_chiefs) {
-	$cmd .= " | grep -Ev \"${penguin_chiefs}\"";
-    }
-    $cmd .= " | cut -f2- -d\":\"";
-    $cmd .= " | sort | uniq -c | sort -rn";
 
     $output = `${cmd}`;
     $output =~ s/^\s*//gm;
 
     @lines = split("\n", $output);
 
-    $total_sign_offs = 0;
+    @lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
+    if (!$email_git_penguin_chiefs) {
+	@lines = grep(!/${penguin_chiefs}/i, @lines);
+    }
+    # cut -f2- -d":"
+    s/.*:\s*(.+)\s*/$1/ for (@lines);
+
+    @lines = mailmap(@lines);
+
+    $total_sign_offs = @lines;
+    @lines = sort(@lines);
+    # uniq -c
     foreach my $line (@lines) {
-	if ($line =~ m/([0-9]+)\s+(.*)/) {
-	    $total_sign_offs += $1;
-	} else {
-	    die("$P: Unexpected git output: ${line}\n");
-	}
+	$hash{$line}++;
+    }
+    # sort -rn
+    @lines = ();
+    foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	push(@lines,"$hash{$line}	$line");
     }
 
     foreach my $line (@lines) {
@@ -579,8 +616,8 @@ sub recent_git_signoffs {
 		$sign_offs * 100 / $total_sign_offs < $email_git_min_percent) {
 		last;
 	    }
+	    push_email_address($line);
 	}
-	push_email_address($line);
     }
 }
 
@@ -632,15 +669,18 @@ sub git_assign_blame {
     @commits = uniq(@commits);
     foreach my $commit (@commits) {
 	$cmd = "git log -1 ${commit}";
-	$cmd .= " | grep -Ei \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
-	if (!$email_git_penguin_chiefs) {
-	    $cmd .= " | grep -Ev \"${penguin_chiefs}\"";
-	}
-	$cmd .= " | cut -f2- -d\":\"";
 
 	$output = `${cmd}`;
 	$output =~ s/^\s*//gm;
 	@lines = split("\n", $output);
+
+	@lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
+	if (!$email_git_penguin_chiefs) {
+	    @lines = grep(!/${penguin_chiefs}/i, @lines);
+	}
+	# cut -f2- -d":"
+	s/.*:\s*(.+)\s*/$1/ for (@lines);
+
 	$hash{$_}++ for @lines;
 	$total_sign_offs += @lines;
     }
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-osd-library-and-filesystem-pattern-fix.patch
linux-next.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-git-blame.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch
scripts-get_maintainerpl-add-pattern-depth.patch
scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch
scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch
scripts-get_maintainerpl-using-separator-implies-nomultiline.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

