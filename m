From: akpm@linux-foundation.org
Subject: [folded] scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:22:15 -0800
Message-ID: <201003052122.o25LMGMP028369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab0CEVWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     scripts-get_maintainerpl-add-file-emails-find-embedded-email-addre=
sses-v2
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-add-file-emails-find-embedded-email-addre=
sses-v2.patch

This patch was dropped because it was folded into scripts-get_maintaine=
rpl-add-file-emails-find-embedded-email-addresses.patch

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
-
 sub merge_email {
     my @lines;
     my %saw;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.=
patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-=
v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.pa=
tch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-=
maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
get_maintainer-fix-perlcritic-warnings.patch
get_maintainer-quote-email-address-with-period.patch
scripts-get_maintainerpl-fix-possible-infinite-loop.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
maintainers-document-and-add-q-patchwork-queue-entries.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.=
patch
checkpatch-warn-on-unnecessary-spaces-before-quoted-newlines.patch
drivers-hwmon-vt8231c-fix-continuation-line-formats.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
