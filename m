From: akpm@linux-foundation.org
Subject: + aoe-create-and-destroy-debugfs-directory-for-aoe.patch added to -mm tree
Date: Fri, 26 Jul 2013 13:36:04 -0700
Message-ID: <51f2ddb4.GunZv00wiNDv+SCJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3GZUgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-create-and-destroy-debugfs-directory-for-aoe.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:36:04 -0700


The patch titled
     Subject: aoe: create and destroy debugfs directory for aoe
has been added to the -mm tree.  Its filename is
     aoe-create-and-destroy-debugfs-directory-for-aoe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-create-and-destroy-debugfs-directory-for-aoe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-create-and-destroy-debugfs-directory-for-aoe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: create and destroy debugfs directory for aoe

This series adds the debugging information that the coraid.com-distributed
aoe driver exports via sysfs, but instead of sysfs, it uses debugfs.

With these patches applied, even without AoE targets on the network, KEDR
reports new possible memory leaks, but these are from callers outside the
aoe driver that have used aoe_devnode to get the name of the character
devices through the aoe_class->devnode callback, and I believe they're
responsible for freeing that memory.


This patch:

Create and destroy the debugfs directory.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoeblk.c~aoe-create-and-destroy-debugfs-directory-for-aoe drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-create-and-destroy-debugfs-directory-for-aoe
+++ a/drivers/block/aoe/aoeblk.c
@@ -17,11 +17,13 @@
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/moduleparam.h>
+#include <linux/debugfs.h>
 #include <scsi/sg.h>
 #include "aoe.h"
 
 static DEFINE_MUTEX(aoeblk_mutex);
 static struct kmem_cache *buf_pool_cache;
+static struct dentry *aoe_debugfs_dir;
 
 /* GPFS needs a larger value than the default. */
 static int aoe_maxsectors;
@@ -351,6 +353,8 @@ err:
 void
 aoeblk_exit(void)
 {
+	debugfs_remove_recursive(aoe_debugfs_dir);
+	aoe_debugfs_dir = NULL;
 	kmem_cache_destroy(buf_pool_cache);
 }
 
@@ -362,7 +366,11 @@ aoeblk_init(void)
 					   0, 0, NULL);
 	if (buf_pool_cache == NULL)
 		return -ENOMEM;
