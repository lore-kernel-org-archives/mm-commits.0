From: akpm@linux-foundation.org
Subject: [merged] proc-simpler-proc-vmcore-cleanup.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:55:57 -0800
Message-ID: <20180207195557.Zxg4OqJAu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754320AbeBGTz6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mahesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/vmcore.c: simpler /proc/vmcore cleanup
has been removed from the -mm tree.  Its filename was
     proc-simpler-proc-vmcore-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/proc/vmcore.c: simpler /proc/vmcore cleanup

Iterators aren't necessary as you can just grab the first entry and delete
it until no entries left.

Link: http://lkml.kernel.org/r/20171121191121.GA20757@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/proc/vmcore.c~proc-simpler-proc-vmcore-cleanup fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~proc-simpler-proc-vmcore-cleanup
+++ a/fs/proc/vmcore.c
@@ -1178,18 +1178,16 @@ fs_initcall(vmcore_init);
 /* Cleanup function for vmcore module. */
 void vmcore_cleanup(void)
 {
-	struct list_head *pos, *next;
