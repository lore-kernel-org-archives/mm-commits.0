From: akpm@linux-foundation.org
Subject: - driver-core-add-missing-symlinks-error-handling.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:09:25 -0800
Message-ID: <200703070409.l2749PHL018613@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46631 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161259AbXCGEJi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:09:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     driver core: add missing symlinks error handling
has been removed from the -mm tree.  Its filename was
     driver-core-add-missing-symlinks-error-handling.patch

This patch was dropped because changes in Greg's tree killed it

------------------------------------------------------
Subject: driver core: add missing symlinks error handling
From: "Akinobu Mita" <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/core.c~driver-core-add-missing-symlinks-error-handling drivers/base/core.c
--- a/drivers/base/core.c~driver-core-add-missing-symlinks-error-handling
+++ a/drivers/base/core.c
@@ -665,6 +665,8 @@ int device_add(struct device *dev)
  GroupError:
 	device_remove_attrs(dev);
  AttrsError:
+	device_remove_links(dev, parent);
+
 	if (dev->devt_attr) {
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

driver-core-add-missing-symlinks-error-handling.patch
driver-core-check-sysfs_create_link-errors.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-ocfs2.patch
git-qla3xxx.patch
simplify-the-stacktrace-code.patch
