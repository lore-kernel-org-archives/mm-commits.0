From: akpm@linux-foundation.org
Subject: + uml-fix-error-cleanup-ordering.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:29:52 -0700
Message-ID: <200707310129.l6V1TqJU008490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763448AbXGaBaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: fix error cleanup ordering
has been added to the -mm tree.  Its filename is
     uml-fix-error-cleanup-ordering.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix error cleanup ordering
From: Jeff Dike <jdike@addtoit.com>

I messed up the error cleanup ordering in the console port driver.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/port_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/port_kern.c~uml-fix-error-cleanup-ordering arch/um/drivers/port_kern.c
--- a/arch/um/drivers/port_kern.c~uml-fix-error-cleanup-ordering
+++ a/arch/um/drivers/port_kern.c
@@ -216,10 +216,10 @@ void *port_data(int port_num)
 				    .telnetd_pid  	= -1 });
 	goto out;
 
- out_free:
-	kfree(port);
  out_close:
 	os_close_file(fd);
+ out_free:
+	kfree(port);
  out:
 	up(&ports_sem);
 	return dev;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-console-should-handle-spurious-irqs.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
