From: akpm@linux-foundation.org
Subject: [patch 094/114] kernel/module: module_is_live can be
 boolean
Date: Tue, 06 Feb 2018 15:41:31 -0800
Message-ID: <20180206234131.dhnCCXLl3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeBFXld (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
