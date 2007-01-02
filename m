From: akpm@osdl.org
Subject: + drivers-char-agp-sgi-agpc-check-kmalloc-return-value.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:44:31 -0800
Message-ID: <200701022244.l02MiW2q032395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40577 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964990AbXABWpI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:45:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit2030@gmail.com, davej@codemonkey.org.uk


The patch titled
     drivers/char/agp/sgi-agp.c: check kmalloc() return value
has been added to the -mm tree.  Its filename is
     drivers-char-agp-sgi-agpc-check-kmalloc-return-value.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-char-agp-sgi-agpc-check-kmalloc-return-value.patch
git-dvb.patch
fs-jffs2-scanc-fix-error-path-leak.patch
