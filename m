From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch added to -mm tree
Date: Tue, 27 Oct 2009 12:34:48 -0700
Message-ID: <200910271934.n9RJYm8l010483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715AbZJ0TfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 15:35:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, ben@decadent.org.uk, greg@kroah.com, pavel@ucw.cz, w.sang@pengutronix.de


The patch titled
     scripts/get_maintainer.pl: fix --non with --git-blame and cleanups
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: fix --non with --git-blame and clea=
nups
=46rom: Joe Perches <joe@perches.com>

=46ix email matching without name --n and --git-blame
   Using --non and --git-blame caused maintainer signature
   matching to fail.  Fixed that by adding 3rd argument to
   sub format_email to control show/hide name portion of address
Slurp -f file instead of reading line-by-line for K: pattern matching.
   Suggested by Wolfram Sang as more efficient
Refactor git command execution
   Break into 2 functions, execute/analyze
   Share code between --git and --git-blame
   Don't warn multiple times when git isn't installed
Improve stats reporting
   --git-min-percent and -- rolestats now count the total number of com=
mits
   for either the period of --git-since or if using --git-blame the com=
mits
   used by the current file and calculate commit % as
      # of commits signed / total commits * 100
Code style cleaning
   Use consistent sub foo { my (args...) =3D @_;

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-fix-non-wi=
th-git-blame-and-cleanups scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-fix-non-with-g=
it-blame-and-cleanups
+++ a/scripts/get_maintainer.pl
@@ -182,7 +182,7 @@ if ($email_remove_duplicates) {
 	next if ($line =3D~ m/^\s*$/);
=20
 	my ($name, $address) =3D parse_email($line);
-	$line =3D format_email($name, $address);
+	$line =3D format_email($name, $address, $email_usename);
=20
 	next if ($line =3D~ m/^\s*$/);
=20
@@ -214,12 +214,10 @@ foreach my $file (@ARGV) {
 	push(@files, $file);
 	if (-f $file && $keywords) {
 	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
-	    while (<FILE>) {
-		my $patch_line =3D $_;
-		foreach my $line (keys %keyword_hash) {
-		    if ($patch_line =3D~ m/^.*$keyword_hash{$line}/x) {
-			push(@keyword_tvi, $line);
-		    }
+	    my $text =3D do { local($/) ; <FILE> };
+	    foreach my $line (keys %keyword_hash) {
+		if ($text =3D~ m/$keyword_hash{$line}/x) {
+		    push(@keyword_tvi, $line);
 		}
 	    }
 	    close(FILE);
@@ -311,7 +309,7 @@ foreach my $file (@files) {
     }
=20
     if ($email && $email_git) {
-	recent_git_signoffs($file);
+	git_file_signoffs($file);
     }
=20
     if ($email && $email_git_blame) {
@@ -331,7 +329,7 @@ if ($email) {
 	if ($chief =3D~ m/^(.*):(.*)/) {
 	    my $email_address;
=20
-	    $email_address =3D format_email($1, $2);
+	    $email_address =3D format_email($1, $2, $email_usename);
 	    if ($email_git_penguin_chiefs) {
 		push(@email_to, [$email_address, 'chief penguin']);
 	    } else {
@@ -509,7 +507,7 @@ sub parse_email {
 }
=20
 sub format_email {
-    my ($name, $address) =3D @_;
+    my ($name, $address, $usename) =3D @_;
=20
     my $formatted_email;
=20
@@ -522,11 +520,11 @@ sub format_email {
 	$name =3D "\"$name\"";
     }
=20
-    if ($email_usename) {
+    if ($usename) {
 	if ("$name" eq "") {
 	    $formatted_email =3D "$address";
 	} else {
-	    $formatted_email =3D "$name <${address}>";
+	    $formatted_email =3D "$name <$address>";
 	}
     } else {
 	$formatted_email =3D $address;
@@ -671,7 +669,7 @@ sub add_categories {
 			if ($tv =3D~ m/^(\C):\s*(.*)/) {
 			    if ($1 eq "P") {
 				$name =3D $2;
-				$pvalue =3D format_email($name, $address);
+				$pvalue =3D format_email($name, $address, $email_usename);
 			    }
 			}
 		    }
@@ -714,9 +712,9 @@ sub push_email_address {
     }
=20
     if (!$email_remove_duplicates) {
-	push(@email_to, [format_email($name, $address), $role]);
+	push(@email_to, [format_email($name, $address, $email_usename), $role=
]);
     } elsif (!email_inuse($name, $address)) {
-	push(@email_to, [format_email($name, $address), $role]);
+	push(@email_to, [format_email($name, $address, $email_usename), $role=
]);
 	$email_hash_name{$name}++;
 	$email_hash_address{$address}++;
     }
@@ -747,7 +745,7 @@ sub add_role {
     my ($line, $role) =3D @_;
=20
     my ($name, $address) =3D parse_email($line);
-    my $email =3D format_email($name, $address);
+    my $email =3D format_email($name, $address, $email_usename);
=20
     foreach my $entry (@email_to) {
 	if ($email_remove_duplicates) {
@@ -784,7 +782,7 @@ sub which {
 }
=20
 sub mailmap {
-    my @lines =3D @_;
+    my (@lines) =3D @_;
     my %hash;
=20
     foreach my $line (@lines) {
@@ -793,14 +791,14 @@ sub mailmap {
 	    $hash{$name} =3D $address;
 	} elsif ($address ne $hash{$name}) {
 	    $address =3D $hash{$name};
-	    $line =3D format_email($name, $address);
+	    $line =3D format_email($name, $address, $email_usename);
 	}
 	if (exists($mailmap{$name})) {
 	    my $obj =3D $mailmap{$name};
 	    foreach my $map_address (@$obj) {
 		if (($map_address eq $address) &&
 		    ($map_address ne $hash{$name})) {
-		    $line =3D format_email($name, $hash{$name});
+		    $line =3D format_email($name, $hash{$name}, $email_usename);
 		}
 	    }
 	}
@@ -809,33 +807,44 @@ sub mailmap {
     return @lines;
 }
=20
-sub recent_git_signoffs {
-    my ($file) =3D @_;
-
-    my $sign_offs =3D "";
-    my $cmd =3D "";
-    my $output =3D "";
-    my $count =3D 0;
-    my @lines =3D ();
-    my %hash;
-    my $total_sign_offs;
-
+my $printed_nogit =3D 0;
+my $printed_nogitdir =3D 0;
+sub has_git {
     if (which("git") eq "") {
-	warn("$P: git not found.  Add --nogit to options?\n");
-	return;
+	if (!$printed_nogit) {
+	    warn("$P: git not found.  Add --nogit to options?\n");
+	    $printed_nogit =3D 1;
+	}
+	return 0;
     }
     if (!(-d ".git")) {
-	warn("$P: .git directory not found.  Use a git repository for better =
results.\n");
-	warn("$P: perhaps 'git clone git://git.kernel.org/pub/scm/linux/kerne=
l/git/torvalds/linux-2.6.git'\n");
-	return;
+	if (!$printed_nogitdir) {
+	    warn(".git directory not found.  "
+		 . "Using a git repository produces better results.\n");
+	    warn("Try Linus Torvalds' latest git repository using:\n");
+	    warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/tor=
valds/linux-2.6.git\n");
+	    $printed_nogitdir =3D 1;
+	}
+	return 0;
     }
=20
-    $cmd =3D "git log --since=3D${email_git_since} -- ${file}";
+    return 1;
+}
+
+sub git_find_signers {
+    my ($cmd) =3D @_;
+
+    my $output;
+    my @lines =3D ();
+    my $commits;
+
+    return (0, @lines) if (!has_git());
=20
     $output =3D `${cmd}`;
     $output =3D~ s/^\s*//gm;
=20
     @lines =3D split("\n", $output);
+    $commits =3D grep(/^commit [0-9a-f]{40,40}/, @lines);		# of commit=
s
=20
     @lines =3D grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
     if (!$email_git_penguin_chiefs) {
@@ -844,10 +853,28 @@ sub recent_git_signoffs {
     # cut -f2- -d":"
     s/.*:\s*(.+)\s*/$1/ for (@lines);
=20
-    $total_sign_offs =3D @lines;
+## Reformat email addresses (with names) to avoid badly written signat=
ures
+
     foreach my $line (@lines) {
 	my ($name, $address) =3D parse_email($line);
-	$line =3D format_email($name, $address);
+	$line =3D format_email($name, $address, 1);
+    }
+
+    return ($commits, @lines);
+}
+
+sub git_assign_signers {
+    my ($role, $divisor, @lines) =3D @_;
+
+    my %hash;
+    my $count =3D 0;
+
+    return if (!has_git());
+    return if (@lines <=3D 0);
+
+    if ($divisor <=3D 0) {
+	warn("Bad divisor in git_assign_signers: $divisor\n");
+	$divisor =3D 1;
     }
=20
     if ($email_remove_duplicates) {
@@ -862,27 +889,43 @@ sub recent_git_signoffs {
     # sort -rn
     foreach my $line (sort {$hash{$b} <=3D> $hash{$a}} keys %hash) {
 	my $sign_offs =3D $hash{$line};
-	my $role;
+	my $percent =3D $sign_offs * 100 / $divisor;
=20
+	$percent =3D 100 if ($percent > 100);
 	$count++;
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
-		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
+		 $percent < $email_git_min_percent);
 	push_email_address($line, '');
-	$role =3D "git-signer";
 	if ($output_rolestats) {
-	    my $percent =3D sprintf("%.0f", $sign_offs * 100 / $total_sign_of=
fs);
-	    $role =3D "$role:$sign_offs/$total_sign_offs=3D$percent%";
+	    my $fmt_percent =3D sprintf("%.0f", $percent);
+	    add_role($line, "$role:$sign_offs/$divisor=3D$fmt_percent%");
+	} else {
+	    add_role($line, $role);
 	}
-	add_role($line, $role);
     }
 }
=20
+sub git_file_signoffs {
+    my ($file) =3D @_;
+
+    my @signers =3D ();
+    my $total_signers;
+
+    return if (!has_git());
+
+    ($total_signers, @signers) =3D
+	git_find_signers("git log --since=3D$email_git_since -- $file");
+    git_assign_signers("git_signer", $total_signers, @signers);
+}
+
 sub save_commits {
     my ($cmd, @commits) =3D @_;
     my $output;
     my @lines =3D ();
=20
+    return (@lines) if (!has_git());
+
     $output =3D `${cmd}`;
=20
     @lines =3D split("\n", $output);
@@ -897,13 +940,10 @@ sub save_commits {
 sub git_assign_blame {
     my ($file) =3D @_;
=20
-    my @lines =3D ();
-    my @commits =3D ();
     my $cmd;
-    my $output;
-    my %hash;
-    my $total_sign_offs;
-    my $count;
+    my @commits =3D ();
+    my @signers =3D ();
+    my $total_commits;
=20
     if (@range) {
 	foreach my $file_range_diff (@range) {
@@ -922,57 +962,27 @@ sub git_assign_blame {
 	}
     }
=20
-    $total_sign_offs =3D 0;
     @commits =3D uniq(@commits);
-    foreach my $commit (@commits) {
-	$cmd =3D "git log -1 ${commit}";
-
-	$output =3D `${cmd}`;
-	$output =3D~ s/^\s*//gm;
-	@lines =3D split("\n", $output);
-
-	@lines =3D grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
-	if (!$email_git_penguin_chiefs) {
-	    @lines =3D grep(!/${penguin_chiefs}/i, @lines);
-	}
-
-	# cut -f2- -d":"
-	s/.*:\s*(.+)\s*/$1/ for (@lines);
-
-	$total_sign_offs +=3D @lines;
+    $total_commits =3D @commits;
=20
-	if ($email_remove_duplicates) {
-	    @lines =3D mailmap(@lines);
-	}
+    foreach my $commit (@commits) {
+	my $commit_count;
+	my @commit_signers =3D ();
=20
-	$hash{$_}++ for @lines;
+	($commit_count, @commit_signers) =3D
+	    git_find_signers("git log -1 $commit");
+	@signers =3D (@signers, @commit_signers);
     }
=20
-    $count =3D 0;
-    foreach my $line (sort {$hash{$b} <=3D> $hash{$a}} keys %hash) {
-	my $sign_offs =3D $hash{$line};
-	my $role;
-
-	$count++;
-	last if ($sign_offs < $email_git_min_signatures ||
-		 $count > $email_git_max_maintainers ||
-		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
-	push_email_address($line, '');
-	if ($from_filename) {
-	    $role =3D "commits";
-	} else {
-	    $role =3D "modified commits";
-	}
-	if ($output_rolestats) {
-	    my $percent =3D sprintf("%.0f", $sign_offs * 100 / $total_sign_of=
fs);
-	    $role =3D "$role:$sign_offs/$total_sign_offs=3D$percent%";
-	}
-	add_role($line, $role);
+    if ($from_filename) {
+	git_assign_signers("commits", $total_commits, @signers);
+    } else {
+	git_assign_signers("modified commits", $total_commits, @signers);
     }
 }
=20
 sub uniq {
-    my @parms =3D @_;
+    my (@parms) =3D @_;
=20
     my %saw;
     @parms =3D grep(!$saw{$_}++, @parms);
@@ -980,7 +990,7 @@ sub uniq {
 }
=20
 sub sort_and_uniq {
-    my @parms =3D @_;
+    my (@parms) =3D @_;
=20
     my %saw;
     @parms =3D sort @parms;
@@ -1008,7 +1018,7 @@ sub merge_email {
 }
=20
 sub output {
-    my @parms =3D @_;
+    my (@parms) =3D @_;
=20
     if ($output_multiline) {
 	foreach my $line (@parms) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch
scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch
maintainers-document-new-k-entry-type.patch
maintainers-add-open-firmware-flattened-device-tree-entry.patch
maintainers-asus-acpi-extras-remove-f-arch-x86-kernel-acpi-bootc.patch
maintainers-brocade-bfa-use-single-line-m-and-tabs.patch
maintainers-server-engines-10gbps-iscsi-use-single-line-m.patch
maintainers-vmware-vmxnet3-quote-name-with-comma-and-period-use-tabs.pa=
tch
linux-next.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.=
patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
kernelh-remove-initialization-of-bool-in-printk_once.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
isicomc-use-pr_fmt-and-pr_level.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
