From: akpm@linux-foundation.org
Subject: - uml-fix-error-cleanup-ordering.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:49 -0700
Message-ID: <200710162036.l9GKandM015222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934143AbXJPVVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix error cleanup ordering
has been removed from the -mm tree.  Its filename was
     uml-fix-error-cleanup-ordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
