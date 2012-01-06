From: akpm@linux-foundation.org
Subject: + fs-fix-fs-fs-writebackc-build-error.patch added to -mm tree
Date: Fri, 06 Jan 2012 14:11:25 -0800
Message-ID: <20120106221126.006B05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63237 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2AFWL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2012 17:11:28 -0500
Received: by eaak10 with SMTP id k10so57891eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Jan 2012 14:11:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, sfr@canb.auug.org.au


The patch titled
     Subject: fs: fix fs/fs-writeback.c build error
has been added to the -mm tree.  Its filename is
     fs-fix-fs-fs-writebackc-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fs: fix fs/fs-writeback.c build error

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
fs-fix-fs-fs-writebackc-build-error.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
leds-add-driver-for-tca6507-led-controller.patch
procfs-parse-mount-options.patch
procfs-add-hidepid=-and-gid=-mount-options.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

