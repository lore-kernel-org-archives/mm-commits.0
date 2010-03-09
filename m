From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:45 -0800
Message-ID: <201003091906.o29J6jmP031277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756068Ab0CITWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, funny-addr@somecompany.com, jksmith@domain.org, mingo@redhat.com, mpm@selenic.com, rjd@tld.com, source@mvista.com, srln@foo.bar, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: add --file-emails, find embedded email =
addresses
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-add-file-emails-find-embedded-email-addre=
sses.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: add --file-emails, find embedded em=
ail addresses
=46rom: Joe Perches <joe@perches.com>

Add an imperfect option to search a source file for email addresses.

New option:  --file-emails or --fe

email addresses in files are freeform text and are nearly impossible to
parse.  Still, might as well try to do a somewhat acceptable job of
finding them.  This code should find all addresses that are in the form
addr@domain.tld

The code assumes that up to 3 alphabetic words along with dashes, comma=
s,
and periods that preceed the email address are a name.

If 3 words are found for the name, and one of the first two words are a
single letter and period, or just a single letter then the 3 words are =
use
as name otherwise the last 2 words are used.

Some variants that are shown correctly:
    John Smith <jksmith@domain.org>
    Random J. Developer <rjd@tld.com>
    Random J. Developer (rjd@tld.com)
    J. Random Developer rjd@tld.com

Variants that are shown nominally correctly:
    Written by First Last (funny-addr@somecompany.com)
is shown as:
    First Last <funny-addr@somecompany.com>

Variants that are shown incorrectly:
    Some Really Long Name <srln@foo.bar>
    MontaVista Software, Inc. <source@mvista.com>
are returned as:
    Long Name <srln@foo.bar>
    "Software, Inc" <source@mvista.com>

--roles and --rolestats show "(in file)" for matches.

=46or instance:

Without -file-emails:

$ ./scripts/get_maintainer.pl -f -nogit -roles net/core/netpoll.c
David S. Miller <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)

With -fe:

$ ./scripts/get_maintainer.pl -f -fe -nogit -roles net/core/netpoll.c
David S. Miller <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Matt Mackall <mpm@selenic.com> (in file)
Ingo Molnar <mingo@redhat.com> (in file)
linux-kernel@vger.kernel.org (open list)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])

The number of email addresses in the file in not limited.  Neither is t=
he
number of returned email addresses.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   83 ++++++++++++++++++++++++++++++++----
 1 file changed, 76 insertions(+), 7 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-file-e=
mails-find-embedded-email-addresses scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-file-email=
s-find-embedded-email-addresses
+++ a/scripts/get_maintainer.pl
@@ -41,6 +41,7 @@ my $web =3D 0;
 my $subsystem =3D 0;
 my $status =3D 0;
 my $keywords =3D 1;
+my $file_emails =3D 0;
 my $from_filename =3D 0;
 my $pattern_depth =3D 0;
 my $version =3D 0;
@@ -120,6 +121,7 @@ if (!GetOptions(
 		'web!' =3D> \$web,
 		'pattern-depth=3Di' =3D> \$pattern_depth,
 		'k|keywords!' =3D> \$keywords,
+		'fe|file-emails!' =3D> \$file_emails,
 		'f|file' =3D> \$from_filename,
 		'v|version' =3D> \$version,
 		'h|help' =3D> \$help,
@@ -232,6 +234,7 @@ if ($email_remove_duplicates) {
 my @files =3D ();
 my @range =3D ();
 my @keyword_tvi =3D ();
+my @file_emails =3D ();
=20
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -242,15 +245,21 @@ foreach my $file (@ARGV) {
     }
     if ($from_filename) {
 	push(@files, $file);
-	if (-f $file && $keywords) {
+	if (-f $file && ($keywords || $file_emails)) {
 	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
 	    my $text =3D do { local($/) ; <FILE> };
-	    foreach my $line (keys %keyword_hash) {
-		if ($text =3D~ m/$keyword_hash{$line}/x) {
-		    push(@keyword_tvi, $line);
+	    close(FILE);
+	    if ($keywords) {
+		foreach my $line (keys %keyword_hash) {
+		    if ($text =3D~ m/$keyword_hash{$line}/x) {
+			push(@keyword_tvi, $line);
+		    }
 		}
 	    }
-	    close(FILE);
+	    if ($file_emails) {
+		my @poss_addr =3D $text =3D~ m$[A-Za-z=C3=80-=C3=BF\"\' \,\.\+-]*\s*=
[\,]*\s*[\(\<\{]{0,1}[A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+\.[A-Za-z0-9]+[=
\)\>\}]{0,1}$g;
+		push(@file_emails, clean_file_emails(@poss_addr));
+	    }
 	}
     } else {
 	my $file_cnt =3D @files;
@@ -285,6 +294,8 @@ foreach my $file (@ARGV) {
     }
 }
=20
+@file_emails =3D uniq(@file_emails);
+
 my @email_to =3D ();
 my @list_to =3D ();
 my @scm =3D ();
@@ -377,6 +388,14 @@ if ($email) {
 	    }
 	}
     }
+
+    foreach my $email (@file_emails) {
+	my ($name, $address) =3D parse_email($email);
+
+	my $tmp_email =3D format_email($name, $address, $email_usename);
+	push_email_address($tmp_email, '');
+	add_role($tmp_email, 'in file');
+    }
 }
=20
 if ($email || $email_list) {
@@ -453,6 +472,7 @@ MAINTAINER field selection options:
     --remove-duplicates =3D> minimize duplicate email names/addresses
     --roles =3D> show roles (status:subsystem, git-signer, list, etc..=
=2E)
     --rolestats =3D> show roles and statistics (commits/total_commits,=
 %)
+    --file-emails =3D> add email addresses found in -f file (default: =
0 (off))
   --scm =3D> print SCM tree(s) if any
   --status =3D> print status if any
   --subsystem =3D> print subsystem name if any
@@ -811,7 +831,9 @@ sub add_role {
     foreach my $entry (@email_to) {
 	if ($email_remove_duplicates) {
 	    my ($entry_name, $entry_address) =3D parse_email($entry->[0]);
-	    if ($name eq $entry_name || $address eq $entry_address) {
+	    if (($name eq $entry_name || $address eq $entry_address)
+		&& ($role eq "" || !($entry->[1] =3D~ m/$role/))
+	    ) {
 		if ($entry->[1] eq "") {
 		    $entry->[1] =3D "$role";
 		} else {
@@ -819,7 +841,9 @@ sub add_role {
 		}
 	    }
 	} else {
-	    if ($email eq $entry->[0]) {
+	    if ($email eq $entry->[0]
+		&& ($role eq "" || !($entry->[1] =3D~ m/$role/))
+	    ) {
 		if ($entry->[1] eq "") {
 		    $entry->[1] =3D "$role";
 		} else {
@@ -1099,6 +1123,51 @@ sub sort_and_uniq {
     return @parms;
 }
=20
+sub clean_file_emails {
+    my (@file_emails) =3D @_;
+    my @fmt_emails =3D ();
+
+    foreach my $email (@file_emails) {
+	$email =3D~ s/[\(\<\{]{0,1}([A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+)[\)\>=
\}]{0,1}/\<$1\>/g;
+	my ($name, $address) =3D parse_email($email);
+	if ($name eq '"[,\.]"') {
+	    $name =3D "";
+	}
+
+	my @nw =3D split(/[^A-Za-z=C3=80-=C3=BF\'\,\.\+-]/, $name);
+	if (@nw > 2) {
+	    my $first =3D $nw[@nw - 3];
+	    my $middle =3D $nw[@nw - 2];
+	    my $last =3D $nw[@nw - 1];
+
+	    if (((length($first) =3D=3D 1 && $first =3D~ m/[A-Za-z]/) ||
+		 (length($first) =3D=3D 2 && substr($first, -1) eq ".")) ||
+		(length($middle) =3D=3D 1 ||
+		 (length($middle) =3D=3D 2 && substr($middle, -1) eq "."))) {
+		$name =3D "$first $middle $last";
+	    } else {
+		$name =3D "$middle $last";
+	    }
+	}
+
+	if (substr($name, -1) =3D~ /[,\.]/) {
+	    $name =3D substr($name, 0, length($name) - 1);
+	} elsif (substr($name, -2) =3D~ /[,\.]"/) {
+	    $name =3D substr($name, 0, length($name) - 2) . '"';
+	}
+
+	if (substr($name, 0, 1) =3D~ /[,\.]/) {
+	    $name =3D substr($name, 1, length($name) - 1);
+	} elsif (substr($name, 0, 2) =3D~ /"[,\.]/) {
+	    $name =3D '"' . substr($name, 2, length($name) - 2);
+	}
+
+	my $fmt_email =3D format_email($name, $address, $email_usename);
+	push(@fmt_emails, $fmt_email);
+    }
+    return @fmt_emails;
+}
+
 sub merge_email {
     my @lines;
     my %saw;
_

Patches currently in -mm which might be from joe@perches.com are

fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patc=
h
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeo=
ut.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.=
patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macr=
o.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
drivers-video-via-fix-continuation-line-formats.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
