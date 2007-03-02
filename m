From: akpm@linux-foundation.org
Subject: - uml-add-back-accidentally-removed-error.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:50 -0800
Message-ID: <200703020506.l2256on5000832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422749AbXCBFGz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: add back accidentally removed error
has been removed from the -mm tree.  Its filename was
     uml-add-back-accidentally-removed-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: add back accidentally removed error
From: Jeff Dike <jdike@addtoit.com>

In the 2.6.20 hang patch, I accidentally threw out an error message.
This puts it back.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sigio.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/um/os-Linux/sigio.c~uml-add-back-accidentally-removed-error arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-add-back-accidentally-removed-error
+++ a/arch/um/os-Linux/sigio.c
@@ -334,8 +334,11 @@ void maybe_sigio_broken(int fd, int read
 
 	sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
-	if(err)
+	if(err){
+		printk("maybe_sigio_broken - failed to add pollfd for "
+		       "descriptor %d\n", fd);
 		goto out;
+	}
 
 	all_sigio_fds.poll[all_sigio_fds.used++] =
 		((struct pollfd) { .fd  	= fd,
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
