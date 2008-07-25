From: akpm@linux-foundation.org
Subject: - edac-mv64x60-fix-get_property.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:04:12 -0700
Message-ID: <200807252304.m6PN4C5W004028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbYGYXHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, mm-commits@vger.kernel.org


The patch titled
     edac: mv64x60 fix get_property
has been removed from the -mm tree.  Its filename was
     edac-mv64x60-fix-get_property.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mv64x60 fix get_property
From: Dave Jiang <djiang@mvista.com>

Update get_property() call to use of_get_property() in order to fix compile

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mv64x60_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/mv64x60_edac.c~edac-mv64x60-fix-get_property drivers/edac/mv64x60_edac.c
--- a/drivers/edac/mv64x60_edac.c~edac-mv64x60-fix-get_property
+++ a/drivers/edac/mv64x60_edac.c
@@ -612,7 +612,7 @@ static void get_total_mem(struct mv64x60
 	if (!np)
 		return;
 
-	reg = get_property(np, "reg", NULL);
+	reg = of_get_property(np, "reg", NULL);
 
 	pdata->total_mem = reg[1];
 }
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch
edac-mv64x60-add-pci-fixup.patch

