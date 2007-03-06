From: akpm@linux-foundation.org
Subject: - reiser4-re-add-page_count-check-to-reiser4_releasepage.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:18 -0800
Message-ID: <200703060200.l2620I8d008720@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46618 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965685AbXCFCAX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: re-add page_count check to reiser4_releasepage
has been removed from the -mm tree.  Its filename was
     reiser4-re-add-page_count-check-to-reiser4_releasepage.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: re-add page_count check to reiser4_releasepage
From: Alexaner Zarochentsev <zam@namesys.com>

re-add to reiser4_releasepage mistakenly removed page_count check.  reiser4
uses extra page reference to protect page from detaching from the jnode.

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/as_ops.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN fs/reiser4/as_ops.c~reiser4-re-add-page_count-check-to-reiser4_releasepage fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-re-add-page_count-check-to-reiser4_releasepage
+++ a/fs/reiser4/as_ops.c
@@ -292,6 +292,11 @@ int reiser4_releasepage(struct page *pag
 	if (PageDirty(page))
 		return 0;
 
+	/* extra page reference is used by reiser4 to protect
+	 * jnode<->page link from this ->releasepage(). */
+	if (page_count(page) > 3)
+		return 0;
+
 	/* releasable() needs jnode lock, because it looks at the jnode fields
 	 * and we need jload_lock here to avoid races with jload(). */
 	spin_lock_jnode(node);
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
