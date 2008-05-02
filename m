From: akpm@linux-foundation.org
Subject: - cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:26 -0700
Message-ID: <200805021943.m42JhQ1M011289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932475AbYEBToD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com, gregkh@suse.de, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/block/cciss.c~cciss-assign-pde-data-before-gluing-pde-into-proc-tree drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/drivers/block/cciss.c
@@ -428,13 +428,9 @@ static void __devinit cciss_procinit(int
 		proc_cciss = proc_mkdir("driver/cciss", NULL);
 	if (!proc_cciss)
 		return;
-	pde = proc_create(hba[i]->devname, S_IWUSR | S_IRUSR | S_IRGRP |
+	pde = proc_create_data(hba[i]->devname, S_IWUSR | S_IRUSR | S_IRGRP |
 					S_IROTH, proc_cciss,
-					&cciss_proc_fops);
-	if (!pde)
-		return;
