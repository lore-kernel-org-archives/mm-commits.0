From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-lkdtmc-fix-missing-allocation-failure-check.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:55:12 -0700
Message-ID: <20120731185512.AC6831E006E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab2GaSzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:55:13 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:55:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, rucsoftsec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/lkdtm.c: fix missing allocation failure check
has been removed from the -mm tree.  Its filename was
     drivers-misc-lkdtmc-fix-missing-allocation-failure-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/misc/lkdtm.c: fix missing allocation failure check

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44691

Reported-by: <rucsoftsec@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/lkdtm.c~drivers-misc-lkdtmc-fix-missing-allocation-failure-check drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~drivers-misc-lkdtmc-fix-missing-allocation-failure-check
+++ a/drivers/misc/lkdtm.c
@@ -477,6 +477,8 @@ static ssize_t lkdtm_debugfs_read(struct
 	int i, n, out;
 
 	buf = (char *)__get_free_page(GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
 
 	n = snprintf(buf, PAGE_SIZE, "Available crash types:\n");
 	for (i = 0; i < ARRAY_SIZE(cp_type); i++)
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch

