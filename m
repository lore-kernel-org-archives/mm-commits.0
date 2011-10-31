From: akpm@linux-foundation.org
Subject: [folded] lis3-remove-the-references-to-the-global-variable-in-core-driver-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:48:11 -0700
Message-ID: <201110312348.p9VNmBQn005688@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:53244 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1JaXsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilkka.koskinen@nokia.com, eric.piel@tremplin-utc.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lis3-remove-the-references-to-the-global-variable-in-core=
-driver-fix
has been removed from the -mm tree.  Its filename was
     lis3-remove-the-references-to-the-global-variable-in-core-driver-f=
ix.patch

This patch was dropped because it was folded into lis3-remove-the-refer=
ences-to-the-global-variable-in-core-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Subject: lis3-remove-the-references-to-the-global-variable-in-core-driv=
er-fix

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
lis3-free-regulators-if-probe-fails.patch
lis3-change-naming-to-consistent.patch
lis3-change-exported-function-to-use-given.patch
lis3-remove-the-references-to-the-global-variable-in-core-driver.patch
lis3lv02d-make-regulator-api-usage-unconditional.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
