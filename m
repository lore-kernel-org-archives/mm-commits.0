From: akpm@osdl.org
Subject: + fs-jffs2-scanc-fix-error-path-leak.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:07:12 -0800
Message-ID: <200701022107.l02L7BNr029671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60574 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983AbXABVHa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:07:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit2030@gmail.com, dwmw2@infradead.org


The patch titled
     fs/jffs2/scan.c: Fix error-path leak
has been added to the -mm tree.  Its filename is
     fs-jffs2-scanc-fix-error-path-leak.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/jffs2/scan.c: Fix error-path leak
From: Amit Choudhary <amit2030@gmail.com>

Signed-off-by: Amit Choudhary <amit2030@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jffs2/scan.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/jffs2/scan.c~fs-jffs2-scanc-fix-error-path-leak fs/jffs2/scan.c
--- a/fs/jffs2/scan.c~fs-jffs2-scanc-fix-error-path-leak
+++ a/fs/jffs2/scan.c
@@ -130,6 +130,7 @@ int jffs2_scan_medium(struct jffs2_sb_in
 	if (jffs2_sum_active()) {
 		s = kzalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
 		if (!s) {
+			kfree(flashbuf);
 			JFFS2_WARNING("Can't allocate memory for summary\n");
 			return -ENOMEM;
 		}
_

Patches currently in -mm which might be from amit2030@gmail.com are

git-dvb.patch
fs-jffs2-scanc-fix-error-path-leak.patch
