From: akpm@osdl.org
Subject: - fs-jffs2-scanc-fix-error-path-leak.patch removed from -mm tree
Date: Wed, 03 Jan 2007 14:20:46 -0800
Message-ID: <200701032220.l03MKkbB000749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbXACWU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit2030@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fs/jffs2/scan.c: Fix error-path leak
has been removed from the -mm tree.  Its filename was
     fs-jffs2-scanc-fix-error-path-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-agpgart.patch
git-dvb.patch
git-mtd.patch
