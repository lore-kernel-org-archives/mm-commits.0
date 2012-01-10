From: akpm@linux-foundation.org
Subject: [obsolete] fs-fix-fs-fs-writebackc-build-error.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:44:31 -0800
Message-ID: <20120110234432.B01B8200183@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47781 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2AJXof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:44:35 -0500
Received: by eaak10 with SMTP id k10so5007eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 15:44:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fix fs/fs-writeback.c build error
has been removed from the -mm tree.  Its filename was
     fs-fix-fs-fs-writebackc-build-error.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: fs: fix fs/fs-writeback.c build error

In linux-next, fs/fs-writeback.c no longer #includes <linux/buffer_head.h>,
which #included <linux/pagemap.h>, so add that latter header file to
<linux/writeback.h> to fix the build error:

fs/fs-writeback.c:510:11: error: 'PAGE_CACHE_SHIFT' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/writeback.h~fs-fix-fs-fs-writebackc-build-error include/linux/writeback.h
--- a/include/linux/writeback.h~fs-fix-fs-fs-writebackc-build-error
+++ a/include/linux/writeback.h
@@ -6,6 +6,7 @@
 
 #include <linux/sched.h>
 #include <linux/fs.h>
+#include <linux/pagemap.h>
 
 DECLARE_PER_CPU(int, dirty_throttle_leaks);
 
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
leds-add-driver-for-tca6507-led-controller.patch
procfs-parse-mount-options.patch
procfs-add-hidepid=-and-gid=-mount-options.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

