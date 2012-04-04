From: akpm@linux-foundation.org
Subject: + timeconstpl-remove-deprecated-defined-array.patch added to -mm tree
Date: Wed, 04 Apr 2012 16:57:53 -0700
Message-ID: <20120404235754.13988A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:38715 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2DDX54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 19:57:56 -0400
Received: by wejx9 with SMTP id x9so41134wej.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 16:57:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilmari@ilmari.org, hpa@zytor.com, tglx@linutronix.de


The patch titled
     Subject: timeconst.pl: remove deprecated defined(@array)
has been added to the -mm tree.  Its filename is
     timeconstpl-remove-deprecated-defined-array.patch

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
=46rom: Dagfinn Ilmari Manns=E5ker <ilmari@ilmari.org>
Subject: timeconst.pl: remove deprecated defined(@array)

The use of defined() on arrays and hashes has been deprecated since per=
l
5.6, but until 5.17.6 it only warned on lexicals, not package globals.

Signed-off-by: Dagfinn Ilmari Manns=E5ker <ilmari@ilmari.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timeconst.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timeconst.pl~timeconstpl-remove-deprecated-defined-arr=
ay kernel/timeconst.pl
--- a/kernel/timeconst.pl~timeconstpl-remove-deprecated-defined-array
+++ a/kernel/timeconst.pl
@@ -370,7 +370,7 @@ if ($hz eq '--can') {
 	}
=20
 	@val =3D @{$canned_values{$hz}};
-	if (!defined(@val)) {
+	if (!@val) {
 		@val =3D compute_values($hz);
 	}
 	output($hz, @val);
_
Subject: Subject: timeconst.pl: remove deprecated defined(@array)

Patches currently in -mm which might be from ilmari@ilmari.org are

timeconstpl-remove-deprecated-defined-array.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
