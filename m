From: akpm@linux-foundation.org
Subject: - uml-fix-errno-usage.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:11 -0800
Message-ID: <200703152156.l2FLuBCD027528@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42250 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbXCOV4N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: fix errno usage
has been removed from the -mm tree.  Its filename was
     uml-fix-errno-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: um: fix errno usage
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Avoid reusing userspace errno twice - it can be cleared by libc code
everywhere (in particular printk() does clear it in my setup).

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/daemon_user.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/um/drivers/daemon_user.c~uml-fix-errno-usage arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-fix-errno-usage
+++ a/arch/um/drivers/daemon_user.c
@@ -56,30 +56,31 @@ static int connect_to_switch(struct daem
 
 	pri->control = socket(AF_UNIX, SOCK_STREAM, 0);
 	if(pri->control < 0){
+		err = -errno;
 		printk("daemon_open : control socket failed, errno = %d\n", 
-		       errno);		
-		return(-errno);
+		       -err);
+		return err;
 	}
 
 	if(connect(pri->control, (struct sockaddr *) ctl_addr, 
 		   sizeof(*ctl_addr)) < 0){
-		printk("daemon_open : control connect failed, errno = %d\n",
-		       errno);
 		err = -errno;
+		printk("daemon_open : control connect failed, errno = %d\n",
+		       -err);
 		goto out;
 	}
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if(fd < 0){
-		printk("daemon_open : data socket failed, errno = %d\n", 
-		       errno);
 		err = -errno;
+		printk("daemon_open : data socket failed, errno = %d\n",
+		       -err);
 		goto out;
 	}
 	if(bind(fd, (struct sockaddr *) local_addr, sizeof(*local_addr)) < 0){
-		printk("daemon_open : data bind failed, errno = %d\n", 
-		       errno);
 		err = -errno;
+		printk("daemon_open : data bind failed, errno = %d\n",
+		       -err);
 		goto out_close;
 	}
 
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
git-gccbug.patch
