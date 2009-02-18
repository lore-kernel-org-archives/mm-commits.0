From: akpm@linux-foundation.org
Subject: + uml-fix-vde-network-backend-in-user-mode-linux.patch added to -mm tree
Date: Wed, 18 Feb 2009 14:52:24 -0800
Message-ID: <200902182252.n1IMqPK7019334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755AbZBRWxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 17:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shammash@artha.org, jdike@addtoit.com, jkosina@suse.cz, wangcong@zeuux.org


The patch titled
     uml: fix vde network backend in user mode linux
has been added to the -mm tree.  Its filename is
     uml-fix-vde-network-backend-in-user-mode-linux.patch

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

uml-fix-vde-network-backend-in-user-mode-linux.patch

