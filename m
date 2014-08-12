From: akpm@linux-foundation.org
Subject: [merged] fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:22 -0700
Message-ID: <53ea6da6.SNiPvHKM3+MdzHHl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:53941 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbaHLTkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:23 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so1312246qgd.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: copy mm's vm usage counters under mmap_sem
has been removed from the -mm tree.  Its filename was
     fork-copy-mms-vm-usage-counters-under-mmap_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: fork: copy mm's vm usage counters under mmap_sem

If a forking process has a thread calling (un)mmap (silly but still),
the child process may have some of its mm's vm usage counters (total_vm
and friends) screwed up, because currently they are copied from oldmm
w/o holding any locks (memcpy in dup_mm).

This patch moves the counters initialization to dup_mmap() to be called
under oldmm->mmap_sem, which eliminates any possibility of race.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/fork.c~fork-copy-mms-vm-usage-counters-under-mmap_sem kernel/fork.c
--- a/kernel/fork.c~fork-copy-mms-vm-usage-counters-under-mmap_sem
+++ a/kernel/fork.c
@@ -374,6 +374,11 @@ static int dup_mmap(struct mm_struct *mm
 	 */
 	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
 
+	mm->total_vm = oldmm->total_vm;
+	mm->shared_vm = oldmm->shared_vm;
+	mm->exec_vm = oldmm->exec_vm;
+	mm->stack_vm = oldmm->stack_vm;
+
 	rb_link = &mm->mm_rb.rb_node;
 	rb_parent = NULL;
 	pprev = &mm->mmap;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch

