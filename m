From: akpm@linux-foundation.org
Subject: [merged] misdn-indentation-and-braces-disagree-add-braces.patch removed from -mm tree
Date: Tue, 13 Jan 2009 12:13:28 -0800
Message-ID: <200901132013.n0DKDSVc012541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754773AbZAMUNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 15:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     misdn: indentation and braces disagree - add braces
has been removed from the -mm tree.  Its filename was
     misdn-indentation-and-braces-disagree-add-braces.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
@@ -110,7 +110,7 @@ int mISDN_dsp_element_register(struct mI
 	}
 	list_add_tail(&entry->list, &dsp_elements);
=20
-	for (i =3D 0; i < ARRAY_SIZE(element_attributes); ++i)
+	for (i =3D 0; i < ARRAY_SIZE(element_attributes); ++i) {
 		ret =3D device_create_file(&entry->dev,
 				&element_attributes[i]);
 		if (ret) {
@@ -118,6 +118,7 @@ int mISDN_dsp_element_register(struct mI
 				__func__);
 			goto err2;
 		}
+	}
=20
 #ifdef PIPELINE_DEBUG
 	printk(KERN_DEBUG "%s: %s registered\n", __func__, elem->name);
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
