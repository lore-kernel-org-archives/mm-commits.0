From: akpm@linux-foundation.org
Subject: + mm-__page_symlink-retry-loop-error-code-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:47:44 -0800
Message-ID: <200702160047.l1G0licd014584@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40973 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422963AbXBPArs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 19:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org


The patch titled
     __page_symlink retry loop error code fix
has been added to the -mm tree.  Its filename is
     mm-__page_symlink-retry-loop-error-code-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: __page_symlink retry loop error code fix
From: Dmitriy Monakhov <dmonakhov@openvz.org>

If prepare_write or commit_write return AOP_TRUNCATED_PAGE we jump to
"retry" label and than if find_or_create_page() failed function return
incorrect error code.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~mm-__page_symlink-retry-loop-error-code-fix fs/namei.c
--- a/fs/namei.c~mm-__page_symlink-retry-loop-error-code-fix
+++ a/fs/namei.c
@@ -2688,10 +2688,11 @@ int __page_symlink(struct inode *inode, 
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-	int err = -ENOMEM;
+	int err;
 	char *kaddr;
 
 retry:
+	err = -ENOMEM;
 	page = find_or_create_page(mapping, 0, gfp_mask);
 	if (!page)
 		goto fail;
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
mm-__page_symlink-retry-loop-error-code-fix.patch
