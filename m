From: akpm@linux-foundation.org
Subject: [merged] devmem-handle-class_create-failure.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:00 -0400
Message-ID: <201004071851.o37IpQGA001295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab0DGSva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     devmem: handle class_create() failure
has been removed from the -mm tree.  Its filename was
     devmem-handle-class_create-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devmem: handle class_create() failure
From: Anton Blanchard <anton@samba.org>

I hit this when we had a bug in IDR for a few days.  Basically sysfs would
fail to create new inodes since it uses an IDR and therefore class_create
would fail.

While we are unlikely to see this fail we may as well handle it instead of
oopsing.

Signed-off-by: Anton Blanchard <anton@samba.org>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/mem.c~devmem-handle-class_create-failure drivers/char/mem.c
--- a/drivers/char/mem.c~devmem-handle-class_create-failure
+++ a/drivers/char/mem.c
@@ -908,6 +908,9 @@ static int __init chr_dev_init(void)
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
 
 	mem_class = class_create(THIS_MODULE, "mem");
+	if (IS_ERR(mem_class))
+		return PTR_ERR(mem_class);
+
 	mem_class->devnode = mem_devnode;
 	for (minor = 1; minor < ARRAY_SIZE(devlist); minor++) {
 		if (!devlist[minor].name)
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
linux-next.patch

