From: akpm@linux-foundation.org
Subject: +
 checkpatch-fix-const_struct-when-const_structscheckpatch-is-missing.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 13:21:50 -0700
Message-ID: <20200624202150.RE7iZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406285AbgFXUVw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 16:21:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, quentin@isovalent.com


The patch titled
     Subject: checkpatch: fix CONST_STRUCT when const_structs.checkpatch is=
 missing
has been added to the -mm tree.  Its filename is
     checkpatch-fix-const_struct-when-const_structscheckpatch-is-missing.pa=
tch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-const_struct-wh=
en-const_structscheckpatch-is-missing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-const_struct-wh=
en-const_structscheckpatch-is-missing.patch

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
From: Quentin Monnet <quentin@isovalent.com>
Subject: checkpatch: fix CONST_STRUCT when const_structs.checkpatch is miss=
ing

Checkpatch reports warnings when some specific structs are not declared as
const in the code.  The list of structs to consider was initially defined
in the checkpatch.pl script itself, but it was later moved to an external
file (scripts/const_structs.checkpatch), in commit bf1fa1dae68e
("checkpatch: externalize the structs that should be const").  This
introduced two minor issues:

- When file scripts/const_structs.checkpatch is not present (for
  example, if checkpatch is run outside of the kernel directory with the
  "--no-tree" option), a warning is printed to stderr to tell the user
  that "No structs that should be const will be found". This is fair,
  but the warning is printed unconditionally, even if the option
  "--ignore CONST_STRUCT" is passed. In the latter case, we explicitly
  ask checkpatch to skip this check, so no warning should be printed.

- When scripts/const_structs.checkpatch is missing, or even when trying
  to silence the warning by adding an empty file, $const_structs is set
  to "", and the regex used for finding structs that should be const,
  "$line =3D~ /=08struct\s+($const_structs)=08(?!\s*\{)/)", matches all
  structs found in the code, thus reporting a number of false positives.

Let's fix the first item by skipping scripts/const_structs.checkpatch
processing if "CONST_STRUCT" checks are ignored, and the second one by
skipping the test if $const_structs is not defined. Since we modify the
read_words() function a little bit, update the checks for
$typedefsfile/$typeOtherTypedefs as well.

Link: http://lkml.kernel.org/r/20200623221822.3727-1-quentin@isovalent.com
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-const_struct-when-const_structsc=
heckpatch-is-missing
+++ a/scripts/checkpatch.pl
@@ -62,7 +62,7 @@ my $spelling_file =3D "$D/spelling.txt";
 my $codespell =3D 0;
 my $codespellfile =3D "/usr/share/codespell/dictionary.txt";
 my $conststructsfile =3D "$D/const_structs.checkpatch";
-my $typedefsfile =3D "";
+my $typedefsfile;
 my $color =3D "auto";
 my $allow_c99_comments =3D 1; # Can be overridden by --ignore C99_COMMENT_=
TOLERANCE
 # git output parsing needs US English output, so first set backtick child =
process LANGUAGE
@@ -770,7 +770,7 @@ sub read_words {
 				next;
 			}
=20
-			$$wordsRef .=3D '|' if ($$wordsRef ne "");
+			$$wordsRef .=3D '|' if (defined $$wordsRef);
 			$$wordsRef .=3D $line;
 		}
 		close($file);
@@ -780,16 +780,18 @@ sub read_words {
 	return 0;
 }
=20
-my $const_structs =3D "";
-read_words(\$const_structs, $conststructsfile)
-    or warn "No structs that should be const will be found - file '$consts=
tructsfile': $!\n";
+my $const_structs;
+if (show_type("CONST_STRUCT")) {
+	read_words(\$const_structs, $conststructsfile)
+	    or warn "No structs that should be const will be found - file '$const=
structsfile': $!\n";
+}
=20
-my $typeOtherTypedefs =3D "";
-if (length($typedefsfile)) {
+if (defined($typedefsfile)) {
+	my $typeOtherTypedefs;
 	read_words(\$typeOtherTypedefs, $typedefsfile)
 	    or warn "No additional types will be considered - file '$typedefsfile=
': $!\n";
+	$typeTypedefs .=3D '|' . $typeOtherTypedefs if (defined $typeOtherTypedef=
s);
 }
-$typeTypedefs .=3D '|' . $typeOtherTypedefs if ($typeOtherTypedefs ne "");
=20
 sub build_types {
 	my $mods =3D "(?x:  \n" . join("|\n  ", (@modifierList, @modifierListFile=
)) . "\n)";
@@ -6688,7 +6690,8 @@ sub process {
=20
 # check for various structs that are normally const (ops, kgdb, device_tre=
e)
 # and avoid what seem like struct definitions 'struct foo {'
-		if ($line !~ /\bconst\b/ &&
+		if (defined($const_structs) &&
+		    $line !~ /\bconst\b/ &&
 		    $line =3D~ /\bstruct\s+($const_structs)\b(?!\s*\{)/) {
 			WARN("CONST_STRUCT",
 			     "struct $1 should normally be const\n" . $herecurr);
_

Patches currently in -mm which might be from quentin@isovalent.com are

checkpatch-fix-const_struct-when-const_structscheckpatch-is-missing.patch
