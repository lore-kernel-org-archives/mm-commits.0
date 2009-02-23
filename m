From: akpm@linux-foundation.org
Subject: [merged] uml-fix-vde-network-backend-in-user-mode-linux.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:26 -0800
Message-ID: <200902232006.n1NK6QSN013384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbZBWUHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:07:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shammash@artha.org, jdike@addtoit.com, jkosina@suse.cz, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix vde network backend in user mode linux
has been removed from the -mm tree.  Its filename was
     uml-fix-vde-network-backend-in-user-mode-linux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix vde network backend in user mode linux
From: Luca Bigliardi <shammash@artha.org>

* Replace kmalloc() with uml_kmalloc() (fix build failure)

* Remove unnecessary UM_KERN_INFO in printk() (don't display '<6>' while
  printing info)

Signed-off-by: Luca Bigliardi <shammash@artha.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Reviewed-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/vde_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/vde_user.c~uml-fix-vde-network-backend-in-user-mode-linux arch/um/drivers/vde_user.c
--- a/arch/um/drivers/vde_user.c~uml-fix-vde-network-backend-in-user-mode-linux
+++ a/arch/um/drivers/vde_user.c
@@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *
 {
 	struct vde_open_args *args;
 
-	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
+	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
 		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
@@ -91,8 +91,8 @@ void vde_init_libstuff(struct vde_data *
 	args->group = init->group;
 	args->mode = init->mode ? init->mode : 0700;
 
-	args->port ?  printk(UM_KERN_INFO "port %d", args->port) :
-		printk(UM_KERN_INFO "undefined port");
+	args->port ?  printk("port %d", args->port) :
+		printk("undefined port");
 }
 
 int vde_user_read(void *conn, void *buf, int len)
_

Patches currently in -mm which might be from shammash@artha.org are


