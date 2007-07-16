From: akpm@linux-foundation.org
Subject: - drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:18 -0700
Message-ID: <200707162100.l6GL0I9Z002587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022AbXGPVGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:06:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssatyam@cse.iitk.ac.in, mm-commits@vger.kernel.org


The patch titled
     drivers/message/i2o/device.c: remove redundant GFP_ATOMIC from kmalloc
has been removed from the -mm tree.  Its filename was
     drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/message/i2o/device.c: remove redundant GFP_ATOMIC from kmalloc
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

drivers/message/i2o/device.c:i2o_parm_field_get() unnecessarily passes
GFP_ATOMIC (along with GFP_KERNEL) to kmalloc() from a context that is not
atomic. Remove the pointless GFP_ATOMIC.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/device.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/i2o/device.c~drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc drivers/message/i2o/device.c
--- a/drivers/message/i2o/device.c~drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc
+++ a/drivers/message/i2o/device.c
@@ -485,7 +485,7 @@ int i2o_parm_field_get(struct i2o_device
 	u8 *resblk;		/* 8 bytes for header */
 	int rc;
 
-	resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
+	resblk = kmalloc(buflen + 8, GFP_KERNEL);
 	if (!resblk)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

origin.patch
git-ocfs2.patch
