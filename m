From: akpm@linux-foundation.org
Subject: [merged] c2port-class_create-returns-an-err_ptr.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:06 -0800
Message-ID: <20120306193506.49A11A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45293 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233Ab2CFTfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:07 -0500
Received: by yenq2 with SMTP id q2so679869yen.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 11:35:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c2port: class_create() returns an ERR_PTR
has been removed from the -mm tree.  Its filename was
     c2port-class_create-returns-an-err_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: c2port: class_create() returns an ERR_PTR

class_create() doesn't return a NULL, it only returns ERR_PTRs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/c2port/core.c~c2port-class_create-returns-an-err_ptr drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~c2port-class_create-returns-an-err_ptr
+++ a/drivers/misc/c2port/core.c
@@ -984,9 +984,9 @@ static int __init c2port_init(void)
 		" - (C) 2007 Rodolfo Giometti\n");
 
 	c2port_class = class_create(THIS_MODULE, "c2port");
-	if (!c2port_class) {
+	if (IS_ERR(c2port_class)) {
 		printk(KERN_ERR "c2port: failed to allocate class\n");
-		return -ENOMEM;
+		return PTR_ERR(c2port_class);
 	}
 	c2port_class->dev_attrs = c2port_attrs;
 
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

