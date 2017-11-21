From: akpm@linux-foundation.org
Subject: + proc-simpler-proc-vmcore-cleanup.patch added to -mm tree
Date: Tue, 21 Nov 2017 12:36:43 -0800
Message-ID: <5a148e5b.r5rvpiLy2I0cvRcs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdKUUgo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 15:36:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mahesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/vmcore.c: simpler /proc/vmcore cleanup
has been added to the -mm tree.  Its filename is
     proc-simpler-proc-vmcore-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-simpler-proc-vmcore-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-simpler-proc-vmcore-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 	if (proc_vmcore) {
 		proc_remove(proc_vmcore);
 		proc_vmcore = NULL;
 	}
 
 	/* clear the vmcore list. */
-	list_for_each_safe(pos, next, &vmcore_list) {
+	while (!list_empty(&vmcore_list)) {
 		struct vmcore *m;
 
-		m = list_entry(pos, struct vmcore, list);
+		m = list_first_entry(&vmcore_list, struct vmcore, list);
 		list_del(&m->list);
 		kfree(m);
 	}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
proc-simpler-proc-vmcore-cleanup.patch
seq_file-delete-small-value-optimization.patch

