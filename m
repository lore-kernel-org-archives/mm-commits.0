From: akpm@linux-foundation.org
Subject: [merged] misdn-one-handmade-array_size-converted.patch removed from -mm tree
Date: Tue, 13 Jan 2009 12:13:26 -0800
Message-ID: <200901132013.n0DKDQjU012534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbZAMUNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 15:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     misdn: one handmade ARRAY_SIZE converted
has been removed from the -mm tree.  Its filename was
     misdn-one-handmade-array_size-converted.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: misdn: one handmade ARRAY_SIZE converted
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Defined as:

static struct device_attribute element_attributes[] =3D {

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/dsp_pipeline.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/isdn/mISDN/dsp_pipeline.c~misdn-one-handmade-array_si=
ze-converted drivers/isdn/mISDN/dsp_pipeline.c
--- a/drivers/isdn/mISDN/dsp_pipeline.c~misdn-one-handmade-array_size-c=
onverted
+++ a/drivers/isdn/mISDN/dsp_pipeline.c
@@ -110,8 +110,7 @@ int mISDN_dsp_element_register(struct mI
 	}
 	list_add_tail(&entry->list, &dsp_elements);
=20
-	for (i =3D 0; i < (sizeof(element_attributes)
-		/ sizeof(struct device_attribute)); ++i)
+	for (i =3D 0; i < ARRAY_SIZE(element_attributes); ++i)
 		ret =3D device_create_file(&entry->dev,
 				&element_attributes[i]);
 		if (ret) {
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
