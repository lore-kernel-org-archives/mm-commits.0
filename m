From: akpm@linux-foundation.org
Subject: + dynamic_debug-only-add-header-when-used-fix.patch added to -mm
 tree
Date: Wed, 13 Jul 2016 15:21:37 -0700
Message-ID: <5786bef1.e2eed5Y4/V4IgBHr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbcGMWVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 18:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drbd: include dynamic_debug.h in drb_int.h
has been added to the -mm tree.  Its filename is
     dynamic_debug-only-add-header-when-used-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-only-add-header-when-used-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-only-add-header-when-used-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: drbd: include dynamic_debug.h in drb_int.h

dynamic_debug.h isn't included via kernel.h anymore.  Since drbd_int.h
needs it to access dynamic_dev_dbg for dynamic_drbd_dbg, include the
header directly.  Remove inclusion of dynamic_debug.h from drbd_actlog.c
since it is already included via drbd_int.h.

Link: http://lkml.kernel.org/r/1468447828-18558-2-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_actlog.c |    1 -
 drivers/block/drbd/drbd_int.h    |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/drbd/drbd_actlog.c~dynamic_debug-only-add-header-when-used-fix drivers/block/drbd/drbd_actlog.c
--- a/drivers/block/drbd/drbd_actlog.c~dynamic_debug-only-add-header-when-used-fix
+++ a/drivers/block/drbd/drbd_actlog.c
@@ -27,7 +27,6 @@
 #include <linux/crc32c.h>
 #include <linux/drbd.h>
 #include <linux/drbd_limits.h>
-#include <linux/dynamic_debug.h>
 #include "drbd_int.h"
 
 
diff -puN drivers/block/drbd/drbd_int.h~dynamic_debug-only-add-header-when-used-fix drivers/block/drbd/drbd_int.h
--- a/drivers/block/drbd/drbd_int.h~dynamic_debug-only-add-header-when-used-fix
+++ a/drivers/block/drbd/drbd_int.h
@@ -41,6 +41,7 @@
 #include <linux/backing-dev.h>
 #include <linux/genhd.h>
 #include <linux/idr.h>
+#include <linux/dynamic_debug.h>
 #include <net/tcp.h>
 #include <linux/lru_cache.h>
 #include <linux/prefetch.h>
_

Patches currently in -mm which might be from luisbg@osg.samsung.com are

dynamic_debug-only-add-header-when-used.patch
dynamic_debug-only-add-header-when-used-fix.patch
befs-check-return-of-sb_min_blocksize.patch
befs-fix-function-name-in-documentation.patch
befs-remove-unused-functions.patch

