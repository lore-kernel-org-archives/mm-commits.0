From: akpm@linux-foundation.org
Subject: + init-reduce-rootwait-polling-interval-time-to-5ms.patch added
 to -mm tree
Date: Wed, 07 Dec 2016 12:47:55 -0800
Message-ID: <5848757b.eBRAwaaOnm4k1MtH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932808AbcLGUrX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2016 15:47:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js07.lee@samsung.com, drzeus-list@drzeus.cx, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: init: reduce rootwait polling interval time to 5ms
has been added to the -mm tree.  Its filename is
     init-reduce-rootwait-polling-interval-time-to-5ms.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-reduce-rootwait-polling-interval-time-to-5ms.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-reduce-rootwait-polling-interval-time-to-5ms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jungseung Lee <js07.lee@samsung.com>
Subject: init: reduce rootwait polling interval time to 5ms

For several devices, the rootwait time is sensitive because it directly
affects booting time.  The polling interval of rootwait is currently
100ms.  To save unnessesary waiting time, reduce the polling interval to 5
ms.

Link: http://lkml.kernel.org/r/20161207060743.1728-1-js07.lee@samsung.com
Signed-off-by: Jungseung Lee <js07.lee@samsung.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN init/do_mounts.c~init-reduce-rootwait-polling-interval-time-to-5ms init/do_mounts.c
--- a/init/do_mounts.c~init-reduce-rootwait-polling-interval-time-to-5ms
+++ a/init/do_mounts.c
@@ -543,6 +543,8 @@ void __init mount_root(void)
 #endif
 }
 
+#define ROOTWAIT_MSEC 5
+
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
  */
@@ -588,7 +590,7 @@ void __init prepare_namespace(void)
 			saved_root_name);
 		while (driver_probe_done() != 0 ||
 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
-			msleep(100);
+			msleep(ROOTWAIT_MSEC);
 		async_synchronize_full();
 	}
 
_

Patches currently in -mm which might be from js07.lee@samsung.com are

init-reduce-rootwait-polling-interval-time-to-5ms.patch

