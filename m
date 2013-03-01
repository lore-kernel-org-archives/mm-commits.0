From: akpm@linux-foundation.org
Subject: + shmem-fix-build-regression.patch added to -mm tree
Date: Thu, 28 Feb 2013 16:31:36 -0800
Message-ID: <20130301003136.BEB3031C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:52499 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab3CAAbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 19:31:37 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so277331qen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 16:31:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wsa@the-dreams.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: shmem: fix build regression
has been added to the -mm tree.  Its filename is
     shmem-fix-build-regression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
shmem-fix-build-regression.patch
shmem-fix-build-regression-fix.patch

