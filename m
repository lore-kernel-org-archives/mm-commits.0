From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch added to -mm tree
Date: Wed, 13 Jan 2010 17:19:45 -0800
Message-ID: <201001140119.o0E1JjIJ007782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713Ab0ANBTu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 20:19:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mpm@selenic.com


The patch titled
     scripts-get_maintainerpl-add-file-emails-find-embedded-email-addre=
sses-v2
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-file-emails-find-embedded-email-addre=
sses-v2.patch

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
Subject: scripts-get_maintainerpl-add-file-emails-find-embedded-email-a=
ddresses-v2
=46rom: Joe Perches <joe@perches.com>

nfi what changed

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   39 +++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-file-e=
mails-find-embedded-email-addresses-v2 scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-file-email=
s-find-embedded-email-addresses-v2
+++ a/scripts/get_maintainer.pl
@@ -257,7 +257,7 @@ foreach my $file (@ARGV) {
 		}
 	    }
 	    if ($file_emails) {
-		my @poss_addr =3D $text =3D~ m$[A-Za-z=C3=80-=C3=BF\"\' \,\.\+-]*\s*=
[\(\<][A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+[\)\>]$g;
+		my @poss_addr =3D $text =3D~ m$[A-Za-z=C3=80-=C3=BF\"\' \,\.\+-]*\s*=
[\,]*\s*[\(\<\{]{0,1}[A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+\.[A-Za-z0-9]+[=
\)\>\}]{0,1}$g;
 		push(@file_emails, clean_file_emails(@poss_addr));
 	    }
 	}
@@ -1128,25 +1128,46 @@ sub clean_file_emails {
     my @fmt_emails =3D ();
=20
     foreach my $email (@file_emails) {
-	$email =3D~ s/\(/\</g;
-	$email =3D~ s/\)/\>/g;
+	$email =3D~ s/[\(\<\{]{0,1}([A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+)[\)\>=
\}]{0,1}/\<$1\>/g;
 	my ($name, $address) =3D parse_email($email);
-	my @nw =3D split(/[^A-Za-z=C3=80-=C3=BF\"\'\,\.\+-]/, $name);
+	if ($name eq '"[,\.]"') {
+	    $name =3D "";
+	}
+
+	my @nw =3D split(/[^A-Za-z=C3=80-=C3=BF\'\,\.\+-]/, $name);
 	if (@nw > 2) {
-	    if ((length($nw[@nw - 2]) =3D=3D 2) &&
-		 substr($nw[@nw - 2], 1) eq ".") {
-		$name =3D "$nw[@nw - 3] $nw[@nw - 2] $nw[@nw - 1]";
+	    my $first =3D $nw[@nw - 3];
+	    my $middle =3D $nw[@nw - 2];
+	    my $last =3D $nw[@nw - 1];
+
+	    if (((length($first) =3D=3D 1 && $first =3D~ m/[A-Za-z]/) ||
+		 (length($first) =3D=3D 2 && substr($first, -1) eq ".")) ||
+		(length($middle) =3D=3D 1 ||
+		 (length($middle) =3D=3D 2 && substr($middle, -1) eq "."))) {
+		$name =3D "$first $middle $last";
 	    } else {
-		$name =3D "$nw[@nw - 2] $nw[@nw - 1]";
+		$name =3D "$middle $last";
 	    }
 	}
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
 	my $fmt_email =3D format_email($name, $address, $email_usename);
 	push(@fmt_emails, $fmt_email);
     }
     return @fmt_emails;
 }
=20
