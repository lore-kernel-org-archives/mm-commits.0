From: akpm@linux-foundation.org
Subject: + uml-add-back-accidentally-removed-error.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:34:05 -0800
Message-ID: <200702272034.l1RKY9vn027544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50671 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbXB0UeS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:34:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: add back accidentally removed error
has been added to the -mm tree.  Its filename is
     uml-add-back-accidentally-removed-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-fix-host-ldt-lookup-initialization-locking-try-2.patch
uml-add-back-accidentally-removed-error.patch
uml-enable-raw.patch
uml-host-vdso-fix.patch
uml-pte_mkread-fix.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
