From: akpm@linux-foundation.org
Subject: [merged] kernel-module-module_is_live-can-be-boolean.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:59:53 -0800
Message-ID: <20180207195953.jAraPcgez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGT7y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/module: module_is_live can be boolean
has been removed from the -mm tree.  Its filename was
     kernel-module-module_is_live-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: kernel/module: module_is_live can be boolean

Make module_is_live return bool due to this particular function only using
either one or zero as its return value.

No functional change.

Link: http://lkml.kernel.org/r/1513266622-15860-6-git-send-email-baiyaowei@cmss.chinamobile.com
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/module.h~kernel-module-module_is_live-can-be-boolean include/linux/module.h
--- a/include/linux/module.h~kernel-module-module_is_live-can-be-boolean
+++ a/include/linux/module.h
@@ -491,7 +491,7 @@ extern struct mutex module_mutex;
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
    (IDE & SCSI) require entry into the module during init.*/
-static inline int module_is_live(struct module *mod)
+static inline bool module_is_live(struct module *mod)
 {
 	return mod->state != MODULE_STATE_GOING;
 }
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are


