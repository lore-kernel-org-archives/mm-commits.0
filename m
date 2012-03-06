From: akpm@linux-foundation.org
Subject: [merged] pps-class_create-returns-an-err_ptr-not-null.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:04 -0800
Message-ID: <20120306193504.63EADA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33122 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965200Ab2CFTfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:06 -0500
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so203276laa.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 11:35:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: class_create() returns an ERR_PTR, not NULL
has been removed from the -mm tree.  Its filename was
     pps-class_create-returns-an-err_ptr-not-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: pps: class_create() returns an ERR_PTR, not NULL

class_create() never returns NULLs only ERR_PTRs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pps/pps.c~pps-class_create-returns-an-err_ptr-not-null drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-class_create-returns-an-err_ptr-not-null
+++ a/drivers/pps/pps.c
@@ -369,9 +369,9 @@ static int __init pps_init(void)
 	int err;
 
 	pps_class = class_create(THIS_MODULE, "pps");
-	if (!pps_class) {
+	if (IS_ERR(pps_class)) {
 		pr_err("failed to allocate class\n");
-		return -ENOMEM;
+		return PTR_ERR(pps_class);
 	}
 	pps_class->dev_attrs = pps_attrs;
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
slab-introduce-kmalloc_array.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

