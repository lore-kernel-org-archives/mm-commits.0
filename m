From: akpm@osdl.org
Subject: - drivers-char-agp-sgi-agpc-check-kmalloc-return-value.patch removed from -mm tree
Date: Wed, 03 Jan 2007 14:20:37 -0800
Message-ID: <200701032220.l03MKbcX000734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55608 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbXACWUs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:20:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit2030@gmail.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/char/agp/sgi-agp.c: check kmalloc() return value
has been removed from the -mm tree.  Its filename was
     drivers-char-agp-sgi-agpc-check-kmalloc-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/agp/sgi-agp.c: check kmalloc() return value
From: Amit Choudhary <amit2030@gmail.com>

Signed-off-by: Amit Choudhary <amit2030@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/agp/sgi-agp.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/agp/sgi-agp.c~drivers-char-agp-sgi-agpc-check-kmalloc-return-value drivers/char/agp/sgi-agp.c
--- a/drivers/char/agp/sgi-agp.c~drivers-char-agp-sgi-agpc-check-kmalloc-return-value
+++ a/drivers/char/agp/sgi-agp.c
@@ -281,10 +281,11 @@ static int __devinit agp_sgi_init(void)
 	else
 		return 0;
 
-	sgi_tioca_agp_bridges =
-	    (struct agp_bridge_data **)kmalloc(tioca_gart_found *
-					       sizeof(struct agp_bridge_data *),
-					       GFP_KERNEL);
+	sgi_tioca_agp_bridges = kmalloc(tioca_gart_found *
+					sizeof(struct agp_bridge_data *),
+					GFP_KERNEL);
+	if (!sgi_tioca_agp_bridges)
+		return -ENOMEM;
 
 	j = 0;
 	list_for_each_entry(info, &tioca_list, ca_list) {
_

Patches currently in -mm which might be from amit2030@gmail.com are

git-agpgart.patch
git-dvb.patch
git-mtd.patch
