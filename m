From: akpm@linux-foundation.org
Subject: + misdn-indentation-and-braces-disagree-add-braces.patch added to -mm tree
Date: Tue, 04 Nov 2008 12:27:20 -0800
Message-ID: <200811042027.mA4KRKnJ010178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227AbYKDU1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 15:27:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi, kkeil@suse.de


The patch titled
     misdn: indentation and braces disagree - add braces
has been added to the -mm tree.  Its filename is
     misdn-indentation-and-braces-disagree-add-braces.patch

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
Subject: misdn: indentation and braces disagree - add braces
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

This is not buggy due to plain luck as there is only one entry currentl=
y
in the element_attributes.

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/dsp_pipeline.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/mISDN/dsp_pipeline.c~misdn-indentation-and-brace=
s-disagree-add-braces drivers/isdn/mISDN/dsp_pipeline.c
--- a/drivers/isdn/mISDN/dsp_pipeline.c~misdn-indentation-and-braces-di=
sagree-add-braces
+++ a/drivers/isdn/mISDN/dsp_pipeline.c
@@ -99,7 +99,7 @@ int mISDN_dsp_element_register(struct mI
 		goto err1;
 	}
=20
-	for (i =3D 0; i < ARRAY_SIZE(element_attributes); ++i)
+	for (i =3D 0; i < ARRAY_SIZE(element_attributes); ++i) {
 		ret =3D device_create_file(&entry->dev,
 				&element_attributes[i]);
 		if (ret) {
@@ -107,6 +107,7 @@ int mISDN_dsp_element_register(struct mI
 				__func__);
 			goto err2;
 		}
+	}
=20
 	list_add_tail(&entry->list, &dsp_elements);
=20
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

linux-next.patch
consolemap-indentation-braces-disagree-reindent.patch
misdn-indentation-braces-disagree-add-braces.patch
misdn-one-handmade-array_size-converted.patch
misdn-indentation-and-braces-disagree-add-braces.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
