From: akpm@linux-foundation.org
Subject: + lis3-remove-the-references-to-the-global-variable-in-core-driver-fix.patch added to -mm tree
Date: Fri, 26 Aug 2011 13:52:05 -0700
Message-ID: <201108262052.p7QKq5ej011206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693Ab1HZUwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 16:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilkka.koskinen@nokia.com, eric.piel@tremplin-utc.net


The patch titled
     lis3-remove-the-references-to-the-global-variable-in-core-driver-f=
ix
has been added to the -mm tree.  Its filename is
     lis3-remove-the-references-to-the-global-variable-in-core-driver-f=
ix.patch

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
Subject: lis3-remove-the-references-to-the-global-variable-in-core-driv=
er-fix
=46rom: Ilkka Koskinen <ilkka.koskinen@nokia.com>

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~lis3-remove-the-references=
-to-the-global-variable-in-core-driver-fix drivers/misc/lis3lv02d/lis3l=
v02d.c
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~lis3-remove-the-references-to-=
the-global-variable-in-core-driver-fix
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -200,7 +200,7 @@ static int lis3lv02d_get_odr(struct lis3
 	u8 ctrl;
 	int shift;
=20
-	lis3->read(&lis3, CTRL_REG1, &ctrl);
+	lis3->read(lis3, CTRL_REG1, &ctrl);
 	ctrl &=3D lis3->odr_mask;
 	shift =3D ffs(lis3->odr_mask) - 1;
 	return lis3->odrs[(ctrl >> shift)];
_

Patches currently in -mm which might be from ilkka.koskinen@nokia.com a=
re

lis3lv02d-avoid-divide-by-zero-due-to-unchecked.patch
lis3-update-maintainer-information.patch
lis3-add-support-for-hp-elitebook-2730p.patch
lis3-add-support-for-hp-elitebook-8540w.patch
hp_accel-add-hp-probook-655x.patch
config_hp_accel-fix-help-text.patch
lis3-free-regulators-if-probe-fails.patch
lis3-change-naming-to-consistent.patch
lis3-change-exported-function-to-use-given.patch
lis3-remove-the-references-to-the-global-variable-in-core-driver.patch
lis3-remove-the-references-to-the-global-variable-in-core-driver-fix.pa=
tch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
