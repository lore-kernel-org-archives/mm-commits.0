From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch added to -mm tree
Date: Tue, 12 Jan 2010 15:15:11 -0800
Message-ID: <201001122315.o0CNFBiG001091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab0ALXPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 18:15:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, addr@domain.tld, davem@davemloft.net, funny-addr@somecompany.com, jksmith@domain.org, jrd@domain.tld, mingo@redhat.com, mpm@selenic.com, rjd@tld.com, srln@foo.bar


The patch titled
     scripts/get_maintainer.pl: add --file-emails, find embedded email =
addresses
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-file-emails-find-embedded-email-addre=
sses.patch

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
Subject: scripts/get_maintainer.pl: add --file-emails, find embedded em=
ail addresses
=46rom: Joe Perches <joe@perches.com>

Add an imperfect option to search a source file for email addresses.

New option:  --file-emails or --fe (default is disabled)

email addresses in files are freeform text and are nearly impossible to
parse.  Still, might as well try to do a somewhat acceptable job of
finding them.

This code will find all addresses that are in the form (addr@domain.tld=
)
and <addr@domain.tld>.  Addresses without parentheses or angle brackets
are ignored.

Some variants that are shown correctly:
	John Smith <jksmith@domain.org>
	Random J. Developer <rjd@tld.com>
	Random J. Developer (rjd@tld.com)

A variant that is shown correctly:
	Written by First Last (funny-addr@somecompany.com)
is shown as:
	First Last <funny-addr@somecompany.com>

Variants that are shown incorrectly:
	J. Random Developer <jrd@domain.tld>
	Some Really Long Name <srln@foo.bar>
are returned as:
	Random Developer <jrd@domain.tld>
	Long Name <srln@foo.bar>

Some variants that are ignored:
	Some Really Long Name srrln@foo.bar
	name@domain.tld (Developer Name)

The code assumes that the 2 words preceeding a found
email address are names.  If the 1st of the 2 words is
a single letter and period, then another word is used,
assuming (First, Initial, Last).

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

The number of email addresses in the file in not limited.
Neither is the number of returned email addresses.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   62 +++++++++++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 7 deletions(-)

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
[\(\<][A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+[\)\>]$g;
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
@@ -1099,6 +1123,30 @@ sub sort_and_uniq {
     return @parms;
 }
=20
+sub clean_file_emails {
+    my (@file_emails) =3D @_;
+    my @fmt_emails =3D ();
+
+    foreach my $email (@file_emails) {
+	$email =3D~ s/\(/\</g;
+	$email =3D~ s/\)/\>/g;
+	my ($name, $address) =3D parse_email($email);
+	my @nw =3D split(/[^A-Za-z=C3=80-=C3=BF\"\'\,\.\+-]/, $name);
+	if (@nw > 2) {
+	    if ((length($nw[@nw - 2]) =3D=3D 2) &&
+		 substr($nw[@nw - 2], 1) eq ".") {
+		$name =3D "$nw[@nw - 3] $nw[@nw - 2] $nw[@nw - 1]";
+	    } else {
+		$name =3D "$nw[@nw - 2] $nw[@nw - 1]";
+	    }
+	}
+	my $fmt_email =3D format_email($name, $address, $email_usename);
+	push(@fmt_emails, $fmt_email);
+    }
+    return @fmt_emails;
+}
+
+
 sub merge_email {
     my @lines;
     my %saw;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.=
patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.=
patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
