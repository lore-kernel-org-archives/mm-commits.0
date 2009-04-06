From: akpm@linux-foundation.org
Subject: [merged] uml-fix-compile-error-from-net_device_ops-conversion.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:49 -0700
Message-ID: <200904061932.n36JWnao010868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757487AbZDFTgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, davem@davemloft.net, jdike@addtoit.com, shemminger@vyatta.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix compile error from net_device_ops conversion
has been removed from the -mm tree.  Its filename was
     uml-fix-compile-error-from-net_device_ops-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix compile error from net_device_ops conversion
From: Miklos Szeredi <mszeredi@suse.cz>

Fix the following compile error:

arch/um/drivers/net_kern.c: In function 'uml_inetaddr_event':
arch/um/drivers/net_kern.c:760: error: 'struct net_device' has no member named 'open'

This was introduced by commit 8bb95b39, "uml: convert network device
to netdevice ops".

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/net_kern.c~uml-fix-compile-error-from-net_device_ops-conversion arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-fix-compile-error-from-net_device_ops-conversion
+++ a/arch/um/drivers/net_kern.c
@@ -757,7 +757,7 @@ static int uml_inetaddr_event(struct not
 	void (*proc)(unsigned char *, unsigned char *, void *);
 	unsigned char addr_buf[4], netmask_buf[4];
 
-	if (dev->open != uml_net_open)
+	if (dev->netdev_ops->ndo_open != uml_net_open)
 		return NOTIFY_DONE;
 
 	lp = netdev_priv(dev);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch

