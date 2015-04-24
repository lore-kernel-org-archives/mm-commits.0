From: akpm@linux-foundation.org
Subject: + configfs-init-configfs-module-earlier-at-boot-time.patch added
 to -mm tree
Date: Fri, 24 Apr 2015 12:53:53 -0700
Message-ID: <553a9f51.aTX6j/ndQbhDpKUB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbbDXTxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Apr 2015 15:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.baluta@intel.com, hch@lst.de, jlbec@evilplan.org, lars@metafoo.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: configfs: init configfs module earlier at boot time
has been added to the -mm tree.  Its filename is
     configfs-init-configfs-module-earlier-at-boot-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/configfs-init-configfs-module-earlier-at-boot-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/configfs-init-configfs-module-earlier-at-boot-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Baluta <daniel.baluta@intel.com>
Subject: configfs: init configfs module earlier at boot time

We need this earlier in the boot process to allow various subsystems to
use configfs (e.g Industrial IIO).

Also, debugfs is at core_initcall level and configfs should be on the same
level from infrastructure point of view.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Suggested-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/mount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/configfs/mount.c~configfs-init-configfs-module-earlier-at-boot-time fs/configfs/mount.c
--- a/fs/configfs/mount.c~configfs-init-configfs-module-earlier-at-boot-time
+++ a/fs/configfs/mount.c
@@ -173,5 +173,5 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.2");
 MODULE_DESCRIPTION("Simple RAM filesystem for user driven kernel subsystem configuration.");
 
-module_init(configfs_init);
+core_initcall(configfs_init);
 module_exit(configfs_exit);
_

Patches currently in -mm which might be from daniel.baluta@intel.com are

origin.patch
configfs-init-configfs-module-earlier-at-boot-time.patch

