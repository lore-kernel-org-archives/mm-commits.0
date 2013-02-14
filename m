From: akpm@linux-foundation.org
Subject: [alternative-merged] timeconstpl-remove-deprecated-defined-array.patch removed from -mm tree
Date: Thu, 14 Feb 2013 11:54:36 -0800
Message-ID: <20130214195436.A29F05A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55160 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3BNTyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 14:54:37 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so280355vcd.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 11:54:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilmari@ilmari.org, hpa@zytor.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timeconst.pl: remove deprecated defined(@array)
has been removed from the -mm tree.  Its filename was
     timeconstpl-remove-deprecated-defined-array.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
=46rom: Dagfinn Ilmari Manns=E5ker <ilmari@ilmari.org>
Subject: timeconst.pl: remove deprecated defined(@array)

The use of defined() on arrays and hashes has been deprecated since per=
l
5.6, but until 5.17.6 it only warned on lexicals, not package globals.

Signed-off-by: Dagfinn Ilmari Manns=E5ker <ilmari@ilmari.org>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
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

Patches currently in -mm which might be from ilmari@ilmari.org are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
