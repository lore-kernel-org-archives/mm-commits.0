From: akpm@osdl.org
Subject: - ipw2200-replace-kmallocmemset-with-kcalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:19:01 -0800
Message-ID: <200612072319.kB7NJ14a031077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54102 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163957AbWLGXTV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     ipw2200: replace kmalloc+memset with kcalloc
has been removed from the -mm tree.  Its filename was
     ipw2200-replace-kmallocmemset-with-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipw2200: replace kmalloc+memset with kcalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kcalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wireless/ipw2200.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/wireless/ipw2200.c~ipw2200-replace-kmallocmemset-with-kcalloc drivers/net/wireless/ipw2200.c
--- a/drivers/net/wireless/ipw2200.c~ipw2200-replace-kmallocmemset-with-kcalloc
+++ a/drivers/net/wireless/ipw2200.c
@@ -11129,14 +11129,13 @@ static int ipw_up(struct ipw_priv *priv)
 		return -EIO;
 
 	if (cmdlog && !priv->cmdlog) {
-		priv->cmdlog = kmalloc(sizeof(*priv->cmdlog) * cmdlog,
+		priv->cmdlog = kcalloc(cmdlog, sizeof(*priv->cmdlog),
 				       GFP_KERNEL);
 		if (priv->cmdlog == NULL) {
 			IPW_ERROR("Error allocating %d command log entries.\n",
 				  cmdlog);
 			return -ENOMEM;
 		} else {
-			memset(priv->cmdlog, 0, sizeof(*priv->cmdlog) * cmdlog);
 			priv->cmdlog_len = cmdlog;
 		}
 	}
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
ia64-replace-kmallocmemset-with-kzalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch

