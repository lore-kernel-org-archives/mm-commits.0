From: akpm@linux-foundation.org
Subject: + drivers-media-video-adp1653c-needs-moduleh.patch added to -mm tree
Date: Wed, 03 Aug 2011 10:36:15 -0700
Message-ID: <201108031733.p73HXjNU002569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570Ab1HCRe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 13:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, lethal@linux-sh.org, mchehab@infradead.org


The patch titled
     drivers/media/video/adp1653.c needs module.h
has been added to the -mm tree.  Its filename is
     drivers-media-video-adp1653c-needs-moduleh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/adp1653.c needs module.h
From: Randy Dunlap <rdunlap@xenotime.net>

adp1653.c uses interfaces that are provided by <linux/module.h>
and needs to include that header file to fix build errors.

drivers/media/video/adp1653.c:453: warning: data definition has no type or storage class
drivers/media/video/adp1653.c:453: warning: parameter names (without types) in function declaration
drivers/media/video/adp1653.c:474: error: 'THIS_MODULE' undeclared (first use in this function)
and more.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/adp1653.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/adp1653.c~drivers-media-video-adp1653c-needs-moduleh drivers/media/video/adp1653.c
--- a/drivers/media/video/adp1653.c~drivers-media-video-adp1653c-needs-moduleh
+++ a/drivers/media/video/adp1653.c
@@ -32,6 +32,7 @@
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/version.h>
 #include <media/adp1653.h>
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch
fs-dcachec-fix-new-kernel-doc-warning.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
init-add-root=partuuid=uuid-partnroff=%d-support-update.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch
linux-next.patch
drivers-media-video-adp1653c-needs-moduleh.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

