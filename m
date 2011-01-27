From: akpm@linux-foundation.org
Subject: + get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.patch added to -mm tree
Date: Wed, 26 Jan 2011 16:11:38 -0800
Message-ID: <201101270011.p0R0Bc0x012924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372Ab1A0ALm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 19:11:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, agimenez@sysvalve.es


The patch titled
     get_maintainer.pl: allow "K:" pattern tests to match non-patch tex=
t
has been added to the -mm tree.  Its filename is
     get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.pat=
ch

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
Subject: get_maintainer.pl: allow "K:" pattern tests to match non-patch=
 text
=46rom: Joe Perches <joe@perches.com>

Extend the usage of the K section in the MAINTAINERS file to support
matching regular expressions to any arbitrary text that may precede the
patch itself.  For example, the commit message or mail headers generate=
d
by git-format-patch.

Signed-off-by: Joe Perches <joe@perches.com>
Original-patch-by: L. Alberto Gim=E9nez <agimenez@sysvalve.es>
Acked-by: L. Alberto Gim=E9nez <agimenez@sysvalve.es>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-allow-k-pattern-te=
sts-to-match-non-patch-text scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-allow-k-pattern-tests-=
to-match-non-patch-text
+++ a/scripts/get_maintainer.pl
@@ -420,6 +420,14 @@ foreach my $file (@ARGV) {
=20
 	open(my $patch, "< $file")
 	    or die "$P: Can't open $file: $!\n";
+
+	# We can check arbitrary information before the patch
+	# like the commit message, mail headers, etc...
+	# This allows us to match arbitrary keywords against any part
+	# of a git format-patch generated file (subject tags, etc...)
+
+	my $patch_prefix =3D "";			#Parsing the intro
+
 	while (<$patch>) {
 	    my $patch_line =3D $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
@@ -428,13 +436,14 @@ foreach my $file (@ARGV) {
 		$filename =3D~ s@\n@@;
 		$lastfile =3D $filename;
 		push(@files, $filename);
+		$patch_prefix =3D "^[+-].*";	#Now parsing the actual patch
 	    } elsif (m/^\@\@ -(\d+),(\d+)/) {
 		if ($email_git_blame) {
 		    push(@range, "$lastfile:$1:$2");
 		}
 	    } elsif ($keywords) {
 		foreach my $line (keys %keyword_hash) {
-		    if ($patch_line =3D~ m/^[+-].*$keyword_hash{$line}/x) {
+		    if ($patch_line =3D~ m/${patch_prefix}$keyword_hash{$line}/x) {
 			push(@keyword_tvi, $line);
 		    }
 		}
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch
printk-allow-setting-default_message_level-via-kconfig.patch
get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
