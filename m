From: akpm@linux-foundation.org
Subject: +
 get_maintainer-add-email-addresses-from-yaml-files.patch added to -mm tree
Date: Mon, 27 Apr 2020 15:28:34 -0700
Message-ID: <20200427222834.qq_ZLuqdk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgD0W2f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 18:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, sam@ravnborg.org


The patch titled
     Subject: get_maintainer: add email addresses from .yaml files
has been added to the -mm tree.  Its filename is
     get_maintainer-add-email-addresses-from-yaml-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-add-email-addre=
sses-from-yaml-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-add-email-addre=
sses-from-yaml-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Joe Perches <joe@perches.com>
Subject: get_maintainer: add email addresses from .yaml files

.yaml files can contain maintainer/author addresses and it seems unlikely
or unnecessary that individual MAINTAINER file section entries for each
.yaml file will be created.

So add the email addresses found in .yaml files to the default
get_maintainer output.

The email addresses are marked with "(in file)" when using the "--roles"
or "--rolestats" options.

Miscellanea:

o Change $file_emails to $email_file_emails to avoid visual
  naming conflicts with @file_emails

Link: http://lkml.kernel.org/r/e85006456d9dbae55286c67ac5263668a72f5b58.158=
8022228.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   44 +++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 15 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-add-email-addresses-from-yam=
l-files
+++ a/scripts/get_maintainer.pl
@@ -57,7 +57,7 @@ my $status =3D 0;
 my $letters =3D "";
 my $keywords =3D 1;
 my $sections =3D 0;
-my $file_emails =3D 0;
+my $email_file_emails =3D 0;
 my $from_filename =3D 0;
 my $pattern_depth =3D 0;
 my $self_test =3D undef;
@@ -69,6 +69,12 @@ my $vcs_used =3D 0;
=20
 my $exit =3D 0;
=20
+my @files =3D ();
+my @fixes =3D ();			# If a patch description includes Fixes: lines
+my @range =3D ();
+my @keyword_tvi =3D ();
+my @file_emails =3D ();
+
 my %commit_author_hash;
 my %commit_signer_hash;
=20
@@ -266,7 +272,7 @@ if (!GetOptions(
 		'pattern-depth=3Di' =3D> \$pattern_depth,
 		'k|keywords!' =3D> \$keywords,
 		'sections!' =3D> \$sections,
-		'fe|file-emails!' =3D> \$file_emails,
+		'fe|file-emails!' =3D> \$email_file_emails,
 		'f|file' =3D> \$from_filename,
 		'find-maintainer-files' =3D> \$find_maintainer_files,
 		'mpath|maintainer-path=3Ds' =3D> \$maintainer_path,
@@ -424,6 +430,22 @@ sub read_all_maintainer_files {
     }
 }
=20
+sub maintainers_in_file {
+    my ($file) =3D @_;
+
+    return if ($file =3D~ m@\bMAINTAINERS$@);
+
+    if (-f $file && ($email_file_emails || $file =3D~ /\.yaml$/)) {
+	open(my $f, '<', $file)
+	    or die "$P: Can't open $file: $!\n";
+	my $text =3D do { local($/) ; <$f> };
+	close($f);
+
+	my @poss_addr =3D $text =3D~ m$[A-Za-z=C3=80-=C3=BF\"\' \,\.\+-]*\s*[\,]*=
\s*[\(\<\{]{0,1}[A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+\.[A-Za-z0-9]+[\)\>\}]{0=
,1}$g;
+	push(@file_emails, clean_file_emails(@poss_addr));
+    }
+}
+
 #
 # Read mail address map
 #
@@ -504,12 +526,6 @@ sub read_mailmap {
=20
 ## use the filenames on the command line or find the filenames in the patc=
hfiles
=20
-my @files =3D ();
-my @fixes =3D ();			# If a patch description includes Fixes: lines
-my @range =3D ();
-my @keyword_tvi =3D ();
-my @file_emails =3D ();
-
 if (!@ARGV) {
     push(@ARGV, "&STDIN");
 }
@@ -527,7 +543,7 @@ foreach my $file (@ARGV) {
 	$file =3D~ s/^\Q${cur_path}\E//;	#strip any absolute path
 	$file =3D~ s/^\Q${lk_path}\E//;	#or the path to the lk tree
 	push(@files, $file);
-	if ($file ne "MAINTAINERS" && -f $file && ($keywords || $file_emails)) {
+	if ($file ne "MAINTAINERS" && -f $file && $keywords) {
 	    open(my $f, '<', $file)
 		or die "$P: Can't open $file: $!\n";
 	    my $text =3D do { local($/) ; <$f> };
@@ -539,10 +555,6 @@ foreach my $file (@ARGV) {
 		    }
 		}
 	    }
-	    if ($file_emails) {
-		my @poss_addr =3D $text =3D~ m$[A-Za-z=C3=80-=C3=BF\"\' \,\.\+-]*\s*[\,]=
*\s*[\(\<\{]{0,1}[A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+\.[A-Za-z0-9]+[\)\>\}]{=
0,1}$g;
-		push(@file_emails, clean_file_emails(@poss_addr));
-	    }
 	}
     } else {
 	my $file_cnt =3D @files;
@@ -923,6 +935,8 @@ sub get_maintainers {
 		print("\n");
 	    }
 	}
+
+	maintainers_in_file($file);
     }
=20
     if ($keywords) {
@@ -1835,7 +1849,7 @@ tm toggle maintainers
 tg toggle git entries
 tl toggle open list entries
 ts toggle subscriber list entries
-f  emails in file       [$file_emails]
+f  emails in file       [$email_file_emails]
 k  keywords in file     [$keywords]
 r  remove duplicates    [$email_remove_duplicates]
 p# pattern match depth  [$pattern_depth]
@@ -1960,7 +1974,7 @@ EOT
 		bool_invert(\$email_git_all_signature_types);
 		$rerun =3D 1;
 	    } elsif ($sel eq "f") {
-		bool_invert(\$file_emails);
+		bool_invert(\$email_file_emails);
 		$rerun =3D 1;
 	    } elsif ($sel eq "r") {
 		bool_invert(\$email_remove_duplicates);
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
get_maintainer-add-email-addresses-from-yaml-files.patch
checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
