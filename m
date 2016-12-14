From: akpm@linux-foundation.org
Subject: [merged] init-reduce-rootwait-polling-interval-time-to-5ms.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:28:02 -0800
Message-ID: <58519d42.hecbte6FDNeQzo63%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45836 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756555AbcLNT3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js07.lee@samsung.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: init: reduce rootwait polling interval time to 5ms
has been removed from the -mm tree.  Its filename was
     init-reduce-rootwait-polling-interval-time-to-5ms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jungseung Lee <js07.lee@samsung.com>
Subject: init: reduce rootwait polling interval time to 5ms

For several devices, the rootwait time is sensitive because it directly
affects booting time.  The polling interval of rootwait is currently
100ms.  To save unnessesary waiting time, reduce the polling interval to 5
ms.

[akpm@linux-foundation.org: remove used-once #define]
Link: http://lkml.kernel.org/r/20161207060743.1728-1-js07.lee@samsung.com
Signed-off-by: Jungseung Lee <js07.lee@samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts.c~init-reduce-rootwait-polling-interval-time-to-5ms init/do_mounts.c
--- a/init/do_mounts.c~init-reduce-rootwait-polling-interval-time-to-5ms
+++ a/init/do_mounts.c
@@ -588,7 +588,7 @@ void __init prepare_namespace(void)
 			saved_root_name);
 		while (driver_probe_done() != 0 ||
 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
-			msleep(100);
+			msleep(5);
 		async_synchronize_full();
 	}
 
_

Patches currently in -mm which might be from js07.lee@samsung.com are


