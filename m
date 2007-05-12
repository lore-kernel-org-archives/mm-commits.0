From: akpm@linux-foundation.org
Subject: - allow-compat_ioctlc-to-compile-without-config_net.patch removed from -mm tree
Date: Fri, 11 May 2007 22:16:13 -0700
Message-ID: <200705120516.l4C5GDLn001809@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756555AbXELFQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, ak@suse.de, arnd@arndb.de, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Allow compat_ioctl.c to compile without CONFIG_NET
has been removed from the -mm tree.  Its filename was
     allow-compat_ioctlc-to-compile-without-config_net.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow compat_ioctl.c to compile without CONFIG_NET
From: Simon Horman <horms@verge.net.au>

A small regression appears to have been introduced in the recent patch
"cleanup compat ioctl handling", which was included in Linus' tree after
2.6.20.

siocdevprivate_ioctl() is no longer defined if CONFIG_NET is undefined,
whereas previously it was a dummy function in this case.

This causes compilation with CONFIG_COMPAT but without CONFIG_NET to fail.

fs/compat_ioctl.c: In function `compat_sys_ioctl':
fs/compat_ioctl.c:3571: warning: implicit declaration of function `siocdevprivate_ioctl'

Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/compat_ioctl.c~allow-compat_ioctlc-to-compile-without-config_net fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~allow-compat_ioctlc-to-compile-without-config_net
+++ a/fs/compat_ioctl.c
@@ -3566,10 +3566,13 @@ asmlinkage long compat_sys_ioctl(unsigne
 			goto found_handler;
 	}
 
+#ifdef CONFIG_NET
 	if (S_ISSOCK(filp->f_path.dentry->d_inode->i_mode) &&
 	    cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15)) {
 		error = siocdevprivate_ioctl(fd, cmd, arg);
-	} else {
+	} else
+#endif
+	{
 		static int count;
 
 		if (++count <= 50)
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
use-menuconfig-objects-ipvs.patch
