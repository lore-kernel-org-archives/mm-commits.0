From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-roles-and-rolestats.patch added to -mm tree
Date: Tue, 27 Oct 2009 12:30:33 -0700
Message-ID: <200910271930.n9RJUXkU000492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756654AbZJ0Tbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 15:31:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, ak@suse.de, akpm@linux-foundation.org, ben@decadent.org.uk, corentincj@iksaif.net, greg@kroah.com, hpa@zytor.com, jeremy.fitzhardinge@citrix.com, len.brown@intel.com, mingo@redhat.com, pavel@ucw.cz, rjw@sisk.pl, sziwan@users.sourceforge.net, tglx@linutronix.de, yhlu.kernel@gmail.com


The patch titled
     scripts/get_maintainer.pl: add --roles and --rolestats
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-roles-and-rolestats.patch

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
Subject: scripts/get_maintainer.pl: add --roles and --rolestats
=46rom: Joe Perches <joe@perches.com>

--roles shows the role of each email address, i.e. why it was selected.
--rolestats selects --roles and adds git log/blame signers #'s and %

Multiple roles are possible (supporter, maintainer, git-signer...)

--roles or --rolestats is meant to help identify appropriate maintainer=
s
to notify and should not be used with "git send-email --cc-cmd"

Example output:

Existing:

$ ./scripts/get_maintainer.pl -f arch/x86/kernel/acpi/boot.c
Corentin Chary <corentincj@iksaif.net>
Karol Kozimor <sziwan@users.sourceforge.net>
Len Brown <len.brown@intel.com>
Pavel Machek <pavel@ucw.cz>
Rafael J. Wysocki <rjw@sisk.pl>
Thomas Gleixner <tglx@linutronix.de>
Ingo Molnar <mingo@redhat.com>
H. Peter Anvin <hpa@zytor.com>
x86@kernel.org
Yinghai Lu <yhlu.kernel@gmail.com>
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
acpi4asus-user@lists.sourceforge.net
linux-pm@lists.linux-foundation.org
linux-kernel@vger.kernel.org

With --roles

$ ./scripts/get_maintainer.pl --roles -f arch/x86/kernel/acpi/boot.c
Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS ACPI EXTRAS...)
Karol Kozimor <sziwan@users.sourceforge.net> (maintainer:ASUS ACPI EXTR=
AS...)
Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM,git-signer)
Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM)
Rafael J. Wysocki <rjw@sisk.pl> (supporter:SUSPEND TO RAM)
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE...)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...,git-sign=
er)
H. Peter Anvin <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...)
x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Yinghai Lu <yhlu.kernel@gmail.com> (git-signer)
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> (git-signer)
acpi4asus-user@lists.sourceforge.net (open list:ASUS ACPI EXTRAS...)
linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)
linux-kernel@vger.kernel.org (open list)

With --rolestats

$ ./scripts/get_maintainer.pl --rolestats -f arch/x86/kernel/acpi/boot.=
c
Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS ACPI EXTRAS...)
Karol Kozimor <sziwan@users.sourceforge.net> (maintainer:ASUS ACPI EXTR=
AS...)
Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM,git-signer:16=
/79=3D20%)
Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM)
Rafael J. Wysocki <rjw@sisk.pl> (supporter:SUSPEND TO RAM)
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE...)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...,git-sign=
er:29/79=3D37%)
H. Peter Anvin <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...)
x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Yinghai Lu <yhlu.kernel@gmail.com> (git-signer:12/79=3D15%)
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> (git-signer:6/79=3D=
8%)
acpi4asus-user@lists.sourceforge.net (open list:ASUS ACPI EXTRAS...)
linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)
linux-kernel@vger.kernel.org (open list)

With --rolestats and --git-blame

$ ./scripts/get_maintainer.pl --rolestats --git-blame -f arch/x86/kerne=
l/acpi/boot.c
Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS ACPI EXTRAS...)
Karol Kozimor <sziwan@users.sourceforge.net> (maintainer:ASUS ACPI EXTR=
AS...)
Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM,git-signer:16=
/79=3D20%,commits:22/154=3D14%)
Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM)
Rafael J. Wysocki <rjw@sisk.pl> (supporter:SUSPEND TO RAM)
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE...)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...,git-sign=
er:29/79=3D37%,commits:36/154=3D23%)
H. Peter Anvin <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...)
x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Yinghai Lu <yhlu.kernel@gmail.com> (git-signer:12/79=3D15%,commits:9/15=
4=3D6%)
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> (git-signer:6/79=3D=
8%)
Andi Kleen <ak@suse.de> (commits:11/154=3D7%)
Andrew Morton <akpm@osdl.org> (commits:10/154=3D6%)
acpi4asus-user@lists.sourceforge.net (open list:ASUS ACPI EXTRAS...)
linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)
linux-kernel@vger.kernel.org (open list)

Other changes:

=46ormat git-signers email addresses a bit to reduce bad signatures
Command line bad arguments emitted a verbose usage(), just show --help
Version number bumped to .22

Ben Hutchings had the idea and created a good deal of this implementati=
on.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-roles-=
and-rolestats scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-roles-and-=
rolestats
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
=20
 my $P =3D $0;
-my $V =3D '0.21';
+my $V =3D '0.22';
=20
 use Getopt::Long qw(:config no_auto_abbrev);
=20
@@ -33,6 +33,8 @@ my $email_git_blame =3D 0;
 my $email_remove_duplicates =3D 1;
 my $output_multiline =3D 1;
 my $output_separator =3D ", ";
+my $output_roles =3D 0;
+my $output_rolestats =3D 0;
 my $scm =3D 0;
 my $web =3D 0;
 my $subsystem =3D 0;
@@ -79,6 +81,8 @@ if (!GetOptions(
 		'l!' =3D> \$email_list,
 		's!' =3D> \$email_subscriber_list,
 		'multiline!' =3D> \$output_multiline,
+		'roles!' =3D> \$output_roles,
+		'rolestats!' =3D> \$output_rolestats,
 		'separator=3Ds' =3D> \$output_separator,
 		'subsystem!' =3D> \$subsystem,
 		'status!' =3D> \$status,
@@ -90,8 +94,7 @@ if (!GetOptions(
 		'v|version' =3D> \$version,
 		'h|help' =3D> \$help,
 		)) {
-    usage();
-    die "$P: invalid argument\n";
+    die "$P: invalid argument - use --help if necessary\n";
 }
=20
 if ($help !=3D 0) {
@@ -113,6 +116,10 @@ if ($output_separator ne ", ") {
     $output_multiline =3D 0;
 }
=20
+if ($output_rolestats) {
+    $output_roles =3D 1;
+}
+
 my $selections =3D $email + $scm + $status + $subsystem + $web;
 if ($selections =3D=3D 0) {
     usage();
@@ -326,9 +333,9 @@ if ($email) {
=20
 	    $email_address =3D format_email($1, $2);
 	    if ($email_git_penguin_chiefs) {
-		push(@email_to, $email_address);
+		push(@email_to, [$email_address, 'chief penguin']);
 	    } else {
-		@email_to =3D grep(!/${email_address}/, @email_to);
+		@email_to =3D grep($_->[0] !~ /${email_address}/, @email_to);
 	    }
 	}
     }
@@ -342,7 +349,7 @@ if ($email || $email_list) {
     if ($email_list) {
 	@to =3D (@to, @list_to);
     }
-    output(uniq(@to));
+    output(merge_email(@to));
 }
=20
 if ($scm) {
@@ -405,6 +412,8 @@ MAINTAINER field selection options:
     --l =3D> include list(s) if any
     --s =3D> include subscriber only list(s) if any
     --remove-duplicates =3D> minimize duplicate email names/addresses
+    --roles =3D> show roles (status:subsystem, git-signer, list, etc..=
=2E)
+    --rolestats =3D> show roles and statistics (commits/total_commits,=
 %)
   --scm =3D> print SCM tree(s) if any
   --status =3D> print status if any
   --subsystem =3D> print subsystem name if any
@@ -435,6 +444,13 @@ Notes:
       Used with "--git-blame", does not iterate all files in directory
   Using "--git-blame" is slow and may add old committers and authors
       that are no longer active maintainers to the output.
+  Using "--roles" or "--rolestats" with git send-email --cc-cmd or any
+      other automated tools that expect only ["name"] <email address>
+      may not work because of additional output after <email address>.
+  Using "--rolestats" and "--git-blame" shows the #/total=3D% commits,
+      not the percentage of the entire file authored.  # of commits is
+      not a good measure of amount of code authored.  1 major commit m=
ay
+      contain a thousand lines, 5 trivial commits may modify a single =
line.
 EOT
 }
=20
@@ -547,6 +563,71 @@ sub find_ending_index {
     return $index;
 }
=20
+sub get_maintainer_role {
+    my ($index) =3D @_;
+
+    my $i;
+    my $start =3D find_starting_index($index);
+    my $end =3D find_ending_index($index);
+
+    my $role;
+    my $subsystem =3D $typevalue[$start];
+    if (length($subsystem) > 20) {
+	$subsystem =3D substr($subsystem, 0, 17);
+	$subsystem =3D~ s/\s*$//;
+	$subsystem =3D $subsystem . "...";
+    }
+
+    for ($i =3D $start + 1; $i < $end; $i++) {
+	my $tv =3D $typevalue[$i];
+	if ($tv =3D~ m/^(\C):\s*(.*)/) {
+	    my $ptype =3D $1;
+	    my $pvalue =3D $2;
+	    if ($ptype eq "S") {
+		$role =3D $pvalue;
+	    }
+	}
+    }
+
+    $role =3D lc($role);
+    if      ($role eq "supported") {
+	$role =3D "supporter";
+    } elsif ($role eq "maintained") {
+	$role =3D "maintainer";
+    } elsif ($role eq "odd fixes") {
+	$role =3D "odd fixer";
+    } elsif ($role eq "orphan") {
+	$role =3D "orphan minder";
+    } elsif ($role eq "obsolete") {
+	$role =3D "obsolete minder";
+    } elsif ($role eq "buried alive in reporters") {
+	$role =3D "chief penguin";
+    }
+
+    return $role . ":" . $subsystem;
+}
+
+sub get_list_role {
+    my ($index) =3D @_;
+
+    my $i;
+    my $start =3D find_starting_index($index);
+    my $end =3D find_ending_index($index);
+
+    my $subsystem =3D $typevalue[$start];
+    if (length($subsystem) > 20) {
+	$subsystem =3D substr($subsystem, 0, 17);
+	$subsystem =3D~ s/\s*$//;
+	$subsystem =3D $subsystem . "...";
+    }
+
+    if ($subsystem eq "THE REST") {
+	$subsystem =3D "";
+    }
+
+    return $subsystem;
+}
+
 sub add_categories {
     my ($index) =3D @_;
=20
@@ -564,17 +645,22 @@ sub add_categories {
 	    if ($ptype eq "L") {
 		my $list_address =3D $pvalue;
 		my $list_additional =3D "";
+		my $list_role =3D get_list_role($i);
+
+		if ($list_role ne "") {
+		    $list_role =3D ":" . $list_role;
+		}
 		if ($list_address =3D~ m/([^\s]+)\s+(.*)$/) {
 		    $list_address =3D $1;
 		    $list_additional =3D $2;
 		}
 		if ($list_additional =3D~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
-			push(@list_to, $list_address);
+			push(@list_to, [$list_address, "subscriber list${list_role}"]);
 		    }
 		} else {
 		    if ($email_list) {
-			push(@list_to, $list_address);
+			push(@list_to, [$list_address, "open list${list_role}"]);
 		    }
 		}
 	    } elsif ($ptype eq "M") {
@@ -591,7 +677,8 @@ sub add_categories {
 		    }
 		}
 		if ($email_maintainer) {
-		    push_email_addresses($pvalue);
+		    my $role =3D get_maintainer_role($i);
+		    push_email_addresses($pvalue, $role);
 		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
@@ -618,7 +705,7 @@ sub email_inuse {
 }
=20
 sub push_email_address {
-    my ($line) =3D @_;
+    my ($line, $role) =3D @_;
=20
     my ($name, $address) =3D parse_email($line);
=20
@@ -627,9 +714,9 @@ sub push_email_address {
     }
=20
     if (!$email_remove_duplicates) {
-	push(@email_to, format_email($name, $address));
+	push(@email_to, [format_email($name, $address), $role]);
     } elsif (!email_inuse($name, $address)) {
-	push(@email_to, format_email($name, $address));
+	push(@email_to, [format_email($name, $address), $role]);
 	$email_hash_name{$name}++;
 	$email_hash_address{$address}++;
     }
@@ -638,24 +725,52 @@ sub push_email_address {
 }
=20
 sub push_email_addresses {
-    my ($address) =3D @_;
+    my ($address, $role) =3D @_;
=20
     my @address_list =3D ();
=20
     if (rfc822_valid($address)) {
-	push_email_address($address);
+	push_email_address($address, $role);
     } elsif (@address_list =3D rfc822_validlist($address)) {
 	my $array_count =3D shift(@address_list);
 	while (my $entry =3D shift(@address_list)) {
-	    push_email_address($entry);
+	    push_email_address($entry, $role);
 	}
     } else {
-	if (!push_email_address($address)) {
+	if (!push_email_address($address, $role)) {
 	    warn("Invalid MAINTAINERS address: '" . $address . "'\n");
 	}
     }
 }
=20
+sub add_role {
+    my ($line, $role) =3D @_;
+
+    my ($name, $address) =3D parse_email($line);
+    my $email =3D format_email($name, $address);
+
+    foreach my $entry (@email_to) {
+	if ($email_remove_duplicates) {
+	    my ($entry_name, $entry_address) =3D parse_email($entry->[0]);
+	    if ($name eq $entry_name || $address eq $entry_address) {
+		if ($entry->[1] eq "") {
+		    $entry->[1] =3D "$role";
+		} else {
+		    $entry->[1] =3D "$entry->[1],$role";
+		}
+	    }
+	} else {
+	    if ($email eq $entry->[0]) {
+		if ($entry->[1] eq "") {
+		    $entry->[1] =3D "$role";
+		} else {
+		    $entry->[1] =3D "$entry->[1],$role";
+		}
+	    }
+	}
+    }
+}
+
 sub which {
     my ($bin) =3D @_;
=20
@@ -730,6 +845,10 @@ sub recent_git_signoffs {
     s/.*:\s*(.+)\s*/$1/ for (@lines);
=20
     $total_sign_offs =3D @lines;
+    foreach my $line (@lines) {
+	my ($name, $address) =3D parse_email($line);
+	$line =3D format_email($name, $address);
+    }
=20
     if ($email_remove_duplicates) {
 	@lines =3D mailmap(@lines);
@@ -743,11 +862,19 @@ sub recent_git_signoffs {
     # sort -rn
     foreach my $line (sort {$hash{$b} <=3D> $hash{$a}} keys %hash) {
 	my $sign_offs =3D $hash{$line};
+	my $role;
+
 	$count++;
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
 		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
-	push_email_address($line);
+	push_email_address($line, '');
+	$role =3D "git-signer";
+	if ($output_rolestats) {
+	    my $percent =3D sprintf("%.0f", $sign_offs * 100 / $total_sign_of=
fs);
+	    $role =3D "$role:$sign_offs/$total_sign_offs=3D$percent%";
+	}
+	add_role($line, $role);
     }
 }
=20
@@ -824,11 +951,23 @@ sub git_assign_blame {
     $count =3D 0;
     foreach my $line (sort {$hash{$b} <=3D> $hash{$a}} keys %hash) {
 	my $sign_offs =3D $hash{$line};
+	my $role;
+
 	$count++;
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
 		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
-	push_email_address($line);
+	push_email_address($line, '');
+	if ($from_filename) {
+	    $role =3D "commits";
+	} else {
+	    $role =3D "modified commits";
+	}
+	if ($output_rolestats) {
+	    my $percent =3D sprintf("%.0f", $sign_offs * 100 / $total_sign_of=
fs);
+	    $role =3D "$role:$sign_offs/$total_sign_offs=3D$percent%";
+	}
+	add_role($line, $role);
     }
 }
=20
@@ -849,6 +988,25 @@ sub sort_and_uniq {
     return @parms;
 }
=20
+sub merge_email {
+    my @lines;
+    my %saw;
+
+    for (@_) {
+	my ($address, $role) =3D @$_;
+	if (!$saw{$address}) {
+	    if ($output_roles) {
+		push @lines, "$address ($role)";
+	    } else {
+		push @lines, $address;
+	    }
+	    $saw{$address} =3D 1;
+	}
+    }
+
+    return @lines;
+}
+
 sub output {
     my @parms =3D @_;
=20
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
linux-next.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.=
patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
kernelh-remove-initialization-of-bool-in-printk_once.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
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
