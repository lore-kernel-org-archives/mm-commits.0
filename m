From: akpm@linux-foundation.org
Subject: + kernel-module-module_is_live-can-be-boolean.patch added to -mm
 tree
Date: Thu, 14 Dec 2017 12:24:02 -0800
Message-ID: <5a32dde2.Sv84LGilxPT4Kwj+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46244 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbdLNUYE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 15:24:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/module: module_is_live can be boolean
has been added to the -mm tree.  Its filename is
     kernel-module-module_is_live-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-module-module_is_live-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-module-module_is_live-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -490,7 +490,7 @@ extern struct mutex module_mutex;
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

mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch
lib-lockref-__lockref_is_dead-can-be-boolean.patch
kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch
kernel-resource-iomem_is_exclusive-can-be-boolean.patch
kernel-module-module_is_live-can-be-boolean.patch
kernel-mutex-mutex_is_locked-can-be-boolean.patch
crash_dump-is_kdump_kernel-can-be-boolean.patch

