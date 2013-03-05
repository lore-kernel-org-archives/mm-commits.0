From: akpm@linux-foundation.org
Subject: [alternative-merged] shmem-fix-build-regression.patch removed from -mm tree
Date: Mon, 04 Mar 2013 16:34:27 -0800
Message-ID: <20130305003427.F18D65A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:53812 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3CEAe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Mar 2013 19:34:28 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so676986yhz.1
        for <mm-commits@vger.kernel.org>; Mon, 04 Mar 2013 16:34:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wsa@the-dreams.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix build regression
has been removed from the -mm tree.  Its filename was
     shmem-fix-build-regression.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Wolfram Sang <wsa@the-dreams.de>
Subject: shmem: fix build regression

commit 6b4d0b27 (clean shmem_file_setup() a bit) broke allnoconfig since
this needs the NOMMU path where 'error' is still needed:

mm/shmem.c:2935:2: error: 'error' undeclared (first use in this function)

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 1 file changed, 1 insertion(+)

index ed2befb..56ff7d7 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/shmem.c~shmem-fix-build-regression mm/shmem.c
--- a/mm/shmem.c~shmem-fix-build-regression
+++ a/mm/shmem.c
@@ -2897,6 +2897,7 @@ static struct dentry_operations anon_ops
  */
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
 {
+	int error;
 	struct file *res;
 	struct inode *inode;
 	struct path path;
_

Patches currently in -mm which might be from wsa@the-dreams.de are

linux-next.patch
shmem-fix-build-regression-fix.patch

