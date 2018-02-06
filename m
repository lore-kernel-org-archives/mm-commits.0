From: akpm@linux-foundation.org
Subject: [patch 018/114] fs/proc/vmcore.c: simpler /proc/vmcore
 cleanup
Date: Tue, 06 Feb 2018 15:37:02 -0800
Message-ID: <20180206233702.6oAiuYNwP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbeBFXhE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mahesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
