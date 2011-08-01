From: akpm@linux-foundation.org
Subject: + lis3-add-support-for-hp-elitebook-8540w.patch added to -mm tree
Date: Mon, 01 Aug 2011 13:29:40 -0700
Message-ID: <201108012029.p71KTeEu012305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396Ab1HAUaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 16:30:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmail.com


The patch titled
     lis3: add support for HP EliteBook 8540w
has been added to the -mm tree.  Its filename is
     lis3-add-support-for-hp-elitebook-8540w.patch

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
Subject: lis3: add support for HP EliteBook 8540w
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>

Add axis correction for HP EliteBook 8540w.

Reported-by: Lyall Pearce <lyall.pearce@hp.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Malte Starostik <m-starostik@versanet.de>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp_accel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/hp_accel.c~lis3-add-support-for-hp-elite=
book-8540w drivers/platform/x86/hp_accel.c
--- a/drivers/platform/x86/hp_accel.c~lis3-add-support-for-hp-elitebook=
-8540w
+++ a/drivers/platform/x86/hp_accel.c
@@ -209,6 +209,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
 	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
 	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 853", xy_swap),
+	AXIS_DMI_MATCH("NC854xx", "HP EliteBook 854", y_inverted),
 	AXIS_DMI_MATCH("NC273xx", "HP EliteBook 273", y_inverted),
 	/* Intel-based HP Pavilion dv5 */
 	AXIS_DMI_MATCH2("HPDV5_I",
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
