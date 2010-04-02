From: akpm@linux-foundation.org
Subject: + devmem-handle-class_create-failure.patch added to -mm tree
Date: Fri, 02 Apr 2010 16:50:42 -0700
Message-ID: <201004022350.o32Nog8b012113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab0DBXuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 19:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, fengguang.wu@intel.com


The patch titled
     devmem: handle class_create() failure
has been added to the -mm tree.  Its filename is
     devmem-handle-class_create-failure.patch

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
@@ -914,6 +914,9 @@ static int __init chr_dev_init(void)
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

devmem-handle-class_create-failure.patch

