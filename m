From: akpm@linux-foundation.org
Subject: + checkpatch-whine-about-access_once.patch added to -mm tree
Date: Sat, 16 Apr 2016 13:20:19 -0700
Message-ID: <57129e83.ldMaD9VD6pmZex45%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbcDPUUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 16:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: whine about ACCESS_ONCE
has been added to the -mm tree.  Its filename is
     checkpatch-whine-about-access_once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-whine-about-acc=
ess_once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-whine-about-acc=
ess_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Joe Perches <joe@perches.com>
Subject: checkpatch: whine about ACCESS_ONCE

Add a test for use of ACCESS_ONCE that could be written using
READ_ONCE or WRITE_ONCE.

--fix it too if desired.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-whine-about-access_once scri=
pts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-whine-about-access_once
+++ a/scripts/checkpatch.pl
@@ -5837,6 +5837,28 @@ sub process {
 			}
 		}
=20
+# whine about ACCESS_ONCE
+		if ($^V && $^V ge 5.10.0 &&
+		=A0=A0=A0=A0$line =3D~ /\bACCESS_ONCE\s*$balanced_parens\s*(=3D(?!=3D=
))?\s*($FuncArg)?/) {
+			my $par =3D $1;
+			my $eq =3D $2;
+			my $fun =3D $3;
+			$par =3D~ s/^\(\s*(.*)\s*\)$/$1/;
+			if (defined($eq)) {
+				if (WARN("PREFER_WRITE_ONCE",
+					=A0"Prefer WRITE_ONCE(<FOO>, <BAR>) over ACCESS_ONCE(<FOO>) =3D <=
BAR>\n" . $herecurr) &&
+				=A0=A0=A0=A0$fix) {
+					$fixed[$fixlinenr] =3D~ s/\bACCESS_ONCE\s*\(\s*\Q$par\E\s*\)\s*$e=
q\s*\Q$fun\E/WRITE_ONCE($par, $fun)/;
+				}
+			} else {
+				if (WARN("PREFER_READ_ONCE",
+					=A0"Prefer READ_ONCE(<FOO>) over ACCESS_ONCE(<FOO>)\n" . $herecur=
r) &&
+				=A0=A0=A0=A0$fix) {
+					$fixed[$fixlinenr] =3D~ s/\bACCESS_ONCE\s*\(\s*\Q$par\E\s*\)/READ=
_ONCE($par)/;
+				}
+			}
+		}
+
 # check for lockdep_set_novalidate_class
 		if ($line =3D~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
 		    $line =3D~ /__lockdep_no_validate__\s*\)/ ) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-prefer_is_enabled-test.patch
checkpatch-improve-constant_comparison-test-for-structure-members.patch
checkpatch-whine-about-access_once.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
