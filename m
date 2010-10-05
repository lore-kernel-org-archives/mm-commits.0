From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:09:55 -0700
Message-ID: <201010052109.o95L9tiI020215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717Ab0JEVKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:10:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, florian@mickler.org


The patch titled
     scripts/get_maintainer.pl: use mailmap in name deduplication and other updates
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates.patch

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
Subject: scripts/get_maintainer.pl: use mailmap in name deduplication and other updates
From: Joe Perches <joe@perches.com>

Use Florian Mickler's mailmap routine to reduce name duplication.

o Add subroutine deduplicate_email to centralize code
o Add hashes for deduplicate_(name|address)_hash
o Remove now unused @interactive_to
o Whitespace neatening
o Add command line --help text
o Add --mailmap command line option control
o Interactive changes:
   - Add toggles for maintainer, git and list selections
   - Default selection is all
   - Add mailmap control

Update to 0.26-beta5

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  234 ++++++++++++++++++++++--------------
 1 file changed, 149 insertions(+), 85 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.26-beta4';
+my $V = '0.26-beta5';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -36,6 +36,7 @@ my $email_git_since = "1-year-ago";
 my $email_hg_since = "-365";
 my $interactive = 0;
 my $email_remove_duplicates = 1;
+my $email_use_mailmap = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $output_roles = 0;
@@ -192,6 +193,7 @@ if (!GetOptions(
 		'hg-since=s' => \$email_hg_since,
 		'i|interactive!' => \$interactive,
 		'remove-duplicates!' => \$email_remove_duplicates,
+		'mailmap!' => \$email_use_mailmap,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
@@ -300,17 +302,17 @@ close($maint);
 # Read mail address map
 #
 
-my $mailmap = read_mailmap();
+my $mailmap;
+
+read_mailmap();
 
 sub read_mailmap {
-    my $mailmap = {
+    $mailmap = {
 	names => {},
 	addresses => {}
     };
 
-    if (!$email_remove_duplicates) {
-	return $mailmap;
-    }
+    return if (!$email_use_mailmap || !(-f "${lk_path}.mailmap"));
 
     open(my $mailmap_file, '<', "${lk_path}.mailmap")
 	or warn "$P: Can't open .mailmap: $!\n";
@@ -331,6 +333,7 @@ sub read_mailmap {
 	    my $address = $2;
 
 	    $real_name =~ s/\s+$//;
+	    ($real_name, $address) = parse_email("$real_name <$address>");
 	    $mailmap->{names}->{$address} = $real_name;
 
 	} elsif (/^<([^\s]+)>\s*<([^\s]+)>$/) {
@@ -340,12 +343,13 @@ sub read_mailmap {
 	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
 	} elsif (/^(.+)<([^\s]+)>\s*<([^\s]+)>$/) {
-	    my $real_name= $1;
+	    my $real_name = $1;
 	    my $real_address = $2;
 	    my $wrong_address = $3;
 
 	    $real_name =~ s/\s+$//;
-
+	    ($real_name, $real_address) =
+		parse_email("$real_name <$real_address>");
 	    $mailmap->{names}->{$wrong_address} = $real_name;
 	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
@@ -356,15 +360,19 @@ sub read_mailmap {
 	    my $wrong_address = $4;
 
 	    $real_name =~ s/\s+$//;
+	    ($real_name, $real_address) =
+		parse_email("$real_name <$real_address>");
+
 	    $wrong_name =~ s/\s+$//;
+	    ($wrong_name, $wrong_address) =
+		parse_email("$wrong_name <$wrong_address>");
 
-	    $mailmap->{names}->{format_email($wrong_name,$wrong_address,1)} = $real_name;
-	    $mailmap->{addresses}->{format_email($wrong_name,$wrong_address,1)} = $real_address;
+	    my $wrong_email = format_email($wrong_name, $wrong_address, 1);
+	    $mailmap->{names}->{$wrong_email} = $real_name;
+	    $mailmap->{addresses}->{$wrong_email} = $real_address;
 	}
     }
     close($mailmap_file);
-
-    return $mailmap;
 }
 
 ## use the filenames on the command line or find the filenames in the patchfiles
@@ -453,7 +461,8 @@ my @scm = ();
 my @web = ();
 my @subsystem = ();
 my @status = ();
-my @interactive_to = ();
+my %deduplicate_name_hash = ();
+my %deduplicate_address_hash = ();
 my $signature_pattern;
 
 my @maintainers = get_maintainers();
@@ -497,7 +506,8 @@ sub get_maintainers {
     @web = ();
     @subsystem = ();
     @status = ();
-    @interactive_to = ();
+    %deduplicate_name_hash = ();
+    %deduplicate_address_hash = ();
     if ($email_git_all_signature_types) {
 	$signature_pattern = "(.+?)[Bb][Yy]:";
     } else {
@@ -506,7 +516,7 @@ sub get_maintainers {
 
     # Find responsible parties
 
-    my %exact_pattern_match_hash;
+    my %exact_pattern_match_hash = ();
 
     foreach my $file (@files) {
 
@@ -590,7 +600,9 @@ sub get_maintainers {
 	}
     }
 
-    @interactive_to = (@email_to, @list_to);
+    foreach my $email (@email_to, @list_to) {
+	$email->[0] = deduplicate_email($email->[0]);
+    }
 
     foreach my $file (@files) {
 	if ($email &&
@@ -637,8 +649,7 @@ sub get_maintainers {
     }
 
     if ($interactive) {
-	@interactive_to = @to;
-	@to = interactive_get_maintainers(\@interactive_to);
+	@to = interactive_get_maintainers(\@to);
     }
 
     return @to;
@@ -702,8 +713,9 @@ Output type options:
 
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
-  --keywords => scan patch for keywords (default: 1 (on))
-  --sections => print the entire subsystem sections with pattern matches
+  --keywords => scan patch for keywords (default: $keywords)
+  --sections => print all of the subsystem sections with pattern matches
+  --mailmap => use .mailmap file (default: $email_use_mailmap)
   --version => show version
   --help => show this help information
 
@@ -1107,7 +1119,7 @@ sub which_conf {
 }
 
 sub mailmap_email {
-    my $line = shift;
+    my ($line) = @_;
 
     my ($name, $address) = parse_email($line);
     my $email = format_email($name, $address, 1);
@@ -1136,26 +1148,25 @@ sub mailmap_email {
 sub mailmap {
     my (@addresses) = @_;
 
-    my @ret = ();
+    my @mapped_emails = ();
     foreach my $line (@addresses) {
-	push(@ret, mailmap_email($line), 1);
+	push(@mapped_emails, mailmap_email($line));
     }
-
-    merge_by_realname(@ret) if $email_remove_duplicates;
-
-    return @ret;
+    merge_by_realname(@mapped_emails) if ($email_use_mailmap);
+    return @mapped_emails;
 }
 
 sub merge_by_realname {
     my %address_map;
     my (@emails) = @_;
+
     foreach my $email (@emails) {
 	my ($name, $address) = parse_email($email);
-	if (!exists $address_map{$name}) {
-	    $address_map{$name} = $address;
-	} else {
+	if (exists $address_map{$name}) {
 	    $address = $address_map{$name};
-	    $email = format_email($name,$address,1);
+	    $email = format_email($name, $address, 1);
+	} else {
+	    $address_map{$name} = $address;
 	}
     }
 }
@@ -1194,8 +1205,7 @@ sub extract_formatted_signatures {
 ## Reformat email addresses (with names) to avoid badly written signatures
 
     foreach my $signer (@signature_lines) {
-	my ($name, $address) = parse_email($signer);
-	$signer = format_email($name, $address, 1);
+	$signer = deduplicate_email($signer);
     }
 
     return (\@type, \@signature_lines);
@@ -1339,6 +1349,7 @@ sub vcs_exists {
 }
 
 sub vcs_is_git {
+    vcs_exists();
     return $vcs_used == 1;
 }
 
@@ -1357,11 +1368,9 @@ sub interactive_get_maintainers {
     my %signed;
     my $count = 0;
     my $maintained = 0;
-    #select maintainers by default
     foreach my $entry (@list) {
-	my $role = $entry->[1];
-	$selected{$count} = ($role =~ /^(maintainer|supporter|open list)/i);
-	$maintained = 1 if ($role =~ /^(maintainer|supporter)/i);
+	$maintained = 1 if ($entry->[1] =~ /^(maintainer|supporter)/i);
+	$selected{$count} = 1;
 	$authored{$count} = 0;
 	$signed{$count} = 0;
 	$count++;
@@ -1418,24 +1427,34 @@ sub interactive_get_maintainers {
 	if ($print_options) {
 	    $print_options = 0;
 	    if (vcs_exists()) {
-		print STDERR
-"\nVersion Control options:\n" .
-"g  use git history      [$email_git]\n" .
-"gf use git-fallback     [$email_git_fallback]\n" .
-"b  use git blame        [$email_git_blame]\n" .
-"bs use blame signatures [$email_git_blame_signatures]\n" .
-"c# minimum commits      [$email_git_min_signatures]\n" .
-"%# min percent          [$email_git_min_percent]\n" .
-"d# history to use       [$$date_ref]\n" .
-"x# max maintainers      [$email_git_max_maintainers]\n" .
-"t  all signature types  [$email_git_all_signature_types]\n";
-	    }
-	    print STDERR "\nAdditional options:\n" .
-"0  toggle all\n" .
-"f  emails in file       [$file_emails]\n" .
-"k  keywords in file     [$keywords]\n" .
-"r  remove duplicates    [$email_remove_duplicates]\n" .
-"p# pattern match depth  [$pattern_depth]\n";
+		print STDERR <<EOT
+
+Version Control options:
+g  use git history      [$email_git]
+gf use git-fallback     [$email_git_fallback]
+b  use git blame        [$email_git_blame]
+bs use blame signatures [$email_git_blame_signatures]
+c# minimum commits      [$email_git_min_signatures]
+%# min percent          [$email_git_min_percent]
+d# history to use       [$$date_ref]
+x# max maintainers      [$email_git_max_maintainers]
+t  all signature types  [$email_git_all_signature_types]
+m  use .mailmap         [$email_use_mailmap]
+EOT
+	    }
+	    print STDERR <<EOT
+
+Additional options:
+0  toggle all
+tm toggle maintainers
+tg toggle git entries
+tl toggle open list entries
+ts toggle subscriber list entries
+f  emails in file       [$file_emails]
+k  keywords in file     [$keywords]
+r  remove duplicates    [$email_remove_duplicates]
+p# pattern match depth  [$pattern_depth]
+EOT
 	}
 	print STDERR
 "\n#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): ";
@@ -1471,6 +1490,28 @@ sub interactive_get_maintainers {
 		for (my $i = 0; $i < $count; $i++) {
 		    $selected{$i} = !$selected{$i};
 		}
+	    } elsif ($sel eq "t") {
+		if (lc($str) eq "m") {
+		    for (my $i = 0; $i < $count; $i++) {
+			$selected{$i} = !$selected{$i}
+			    if ($list[$i]->[1] =~ /^(maintainer|supporter)/i);
+		    }
+		} elsif (lc($str) eq "g") {
+		    for (my $i = 0; $i < $count; $i++) {
+			$selected{$i} = !$selected{$i}
+			    if ($list[$i]->[1] =~ /^(author|commit|signer)/i);
+		    }
+		} elsif (lc($str) eq "l") {
+		    for (my $i = 0; $i < $count; $i++) {
+			$selected{$i} = !$selected{$i}
+			    if ($list[$i]->[1] =~ /^(open list)/i);
+		    }
+		} elsif (lc($str) eq "s") {
+		    for (my $i = 0; $i < $count; $i++) {
+			$selected{$i} = !$selected{$i}
+			    if ($list[$i]->[1] =~ /^(subscriber list)/i);
+		    }
+		}
 	    } elsif ($sel eq "a") {
 		if ($val > 0 && $val <= $count) {
 		    $authored{$val - 1} = !$authored{$val - 1};
@@ -1539,6 +1580,10 @@ sub interactive_get_maintainers {
 	    } elsif ($sel eq "r") {
 		bool_invert(\$email_remove_duplicates);
 		$rerun = 1;
+	    } elsif ($sel eq "m") {
+		bool_invert(\$email_use_mailmap);
+		read_mailmap();
+		$rerun = 1;
 	    } elsif ($sel eq "k") {
 		bool_invert(\$keywords);
 		$rerun = 1;
@@ -1602,6 +1647,36 @@ sub bool_invert {
     }
 }
 
+sub deduplicate_email {
+    my ($email) = @_;
+
+    my $matched = 0;
+    my ($name, $address) = parse_email($email);
+    $email = format_email($name, $address, 1);
+    $email = mailmap_email($email);
+
+    return $email if (!$email_remove_duplicates);
+
+    ($name, $address) = parse_email($email);
+
+    if ($deduplicate_name_hash{lc($name)}) {
+	$name = $deduplicate_name_hash{lc($name)}->[0];
+	$address = $deduplicate_name_hash{lc($name)}->[1];
+	$matched = 1;
+    } elsif ($deduplicate_address_hash{lc($address)}) {
+	$name = $deduplicate_address_hash{lc($address)}->[0];
+	$address = $deduplicate_address_hash{lc($address)}->[1];
+	$matched = 1;
+    }
+    if (!$matched) {
+	$deduplicate_name_hash{lc($name)} = [ $name, $address ];
+	$deduplicate_address_hash{lc($address)} = [ $name, $address ];
+    }
+    $email = format_email($name, $address, 1);
+    $email = mailmap_email($email);
+    return $email;
+}
+
 sub save_commits_by_author {
     my (@lines) = @_;
 
@@ -1611,20 +1686,8 @@ sub save_commits_by_author {
 
     foreach my $line (@lines) {
 	if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
-	    my $matched = 0;
 	    my $author = $1;
-	    my ($name, $address) = parse_email($author);
-	    foreach my $to (@interactive_to) {
-		my ($to_name, $to_address) = parse_email($to->[0]);
-		if ($email_remove_duplicates &&
-		    ((lc($name) eq lc($to_name)) ||
-		     (lc($address) eq lc($to_address)))) {
-		    $author = $to->[0];
-		    $matched = 1;
-		    last;
-		}
-	    }
-	    $author = format_email($name, $address, 1) if (!$matched);
+	    $author = deduplicate_email($author);
 	    push(@authors, $author);
 	}
 	push(@commits, $1) if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
@@ -1665,19 +1728,7 @@ sub save_commits_by_signer {
 	    my $type = $types[0];
 	    my $signer = $signers[0];
 
-	    my $matched = 0;
-	    my ($name, $address) = parse_email($signer);
-	    foreach my $to (@interactive_to) {
-		my ($to_name, $to_address) = parse_email($to->[0]);
-		if ($email_remove_duplicates &&
-		    ((lc($name) eq lc($to_name)) ||
-		     (lc($address) eq lc($to_address)))) {
-		    $signer = $to->[0];
-		    $matched = 1;
-		    last;
-		}
-		$signer = format_email($name, $address, 1) if (!$matched);
-	    }
+	    $signer = deduplicate_email($signer);
 
 	    my $exists = 0;
 	    foreach my $ref(@{$commit_signer_hash{$signer}}) {
@@ -1751,6 +1802,11 @@ sub vcs_file_signoffs {
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
 
     ($commits, @signers) = vcs_find_signers($cmd);
+
+    foreach my $signer (@signers) {
+	$signer = deduplicate_email($signer);
+    }
+
     vcs_assign("commit_signer", $commits, @signers);
 }
 
@@ -1828,9 +1884,8 @@ sub vcs_file_blame {
 		foreach my $line (@lines) {
 		    if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
 			my $author = $1;
-			my ($name, $address) = parse_email($author);
-			$author = format_email($name, $address, 1);
-			push(@authors, $1);
+			$author = deduplicate_email($author);
+			push(@authors, $author);
 		    }
 		}
 
@@ -1846,9 +1901,12 @@ sub vcs_file_blame {
 		    $cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
 		    my @author = vcs_find_author($cmd);
 		    next if !@author;
+
+		    my $formatted_author = deduplicate_email($author[0]);
+
 		    my $count = grep(/$commit/, @all_commits);
 		    for ($i = 0; $i < $count ; $i++) {
-			push(@blame_signers, $author[0]);
+			push(@blame_signers, $formatted_author);
 		    }
 		}
 	    }
@@ -1856,8 +1914,14 @@ sub vcs_file_blame {
 		vcs_assign("authored lines", $total_lines, @blame_signers);
 	    }
 	}
+	foreach my $signer (@signers) {
+	    $signer = deduplicate_email($signer);
+	}
 	vcs_assign("commits", $total_commits, @signers);
     } else {
+	foreach my $signer (@signers) {
+	    $signer = deduplicate_email($signer);
+	}
 	vcs_assign("modified commits", $total_commits, @signers);
     }
 }
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
vsprintfc-use-default-pointer-field-size-for-null-strings.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
lib-fix-scnprintf-if-size-is-==-0.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
scripts-get_maintainerpl-add-interactive-mode.patch
scripts-get_maintainerpl-improve-interactive-ui.patch
scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime.patch
scripts-get_maintainerpl-use-case-insensitive-name-de-duplication.patch
scripts-get_maintainerpl-fix-mailmap-handling.patch
scripts-get_maintainerpl-correct-indentation-in-a-few-places.patch
scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates.patch
scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists.patch
maintainers-fix-colibri-pxa270-file-pattern.patch
maintainers-merge-imote2-and-stargate.patch
maintainers-merge-s3c-244x-sections.patch
maintainers-merge-s3c6400-and-6410-to-64xx.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch
maintainers-use-t-git-and-whitespace-trivia.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

