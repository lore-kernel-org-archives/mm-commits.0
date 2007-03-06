From: akpm@linux-foundation.org
Subject: - reiser4-use-null-for-pointers.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:04:34 -0800
Message-ID: <200703060204.l2624YgD008817@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965716AbXCFCEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use NULL for pointers
has been removed from the -mm tree.  Its filename was
     reiser4-use-null-for-pointers.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: use NULL for pointers
From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointers.
fs/reiser4/plugin/item/ctail.c:1188:38: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/item/ctail.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-use-null-for-pointers fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-use-null-for-pointers
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -1154,7 +1154,7 @@ static int alloc_convert_data(flush_pos_
 	if (!pos->sq)
 		return RETERR(-ENOMEM);
 	memset(pos->sq, 0, sizeof(*pos->sq));
-	cluster_init_write(&pos->sq->clust, 0);
+	cluster_init_write(&pos->sq->clust, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
atyfb-fix-kconfig-error-part-2.patch
git-drm.patch
phy-layer-add-kernel-doc-docbook.patch
fusion-kernel-doc-warning-fixes.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiser4.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
