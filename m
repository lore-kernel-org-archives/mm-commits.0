From: akpm@linux-foundation.org
Subject: [merged] fork-reset-mm-pinned_vm.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:20 -0700
Message-ID: <53ea6da4.M4Pj7ZJ3NAIfy3p1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:56452 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaHLTkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:21 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1920122obc.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hal.rosenstock@gmail.com, oleg@redhat.com, rientjes@google.com, roland@kernel.org, sean.hefty@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: reset mm->pinned_vm
has been removed from the -mm tree.  Its filename was
     fork-reset-mm-pinned_vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: fork: reset mm->pinned_vm

mm->pinned_vm counts pages of mm's address space that were permanently
pinned in memory by increasing their reference counter. The counter was
introduced by commit bc3e53f682d9 ("mm: distinguish between mlocked and
pinned pages"), while before it locked_vm had been used for such pages.

Obviously, we should reset the counter on fork if !CLONE_VM, just like
we do with locked_vm, but currently we don't. Let's fix it.

This patch will fix the contents of /proc/pid/status:VmPin.

ib_umem_get[infiniband] and perf_mmap still check pinned_vm against
RLIMIT_MEMLOCK.  It's left from the times when pinned pages were accounted
under locked_vm, but today it looks wrong.  It isn't clear how we should
deal with it.

We still have some drivers accounting pinned pages under mm->locked_vm -
this is what commit bc3e53f682d9 was fighting against.  It's
infiniband/usnic and vfio.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~fork-reset-mm-pinned_vm kernel/fork.c
--- a/kernel/fork.c~fork-reset-mm-pinned_vm
+++ a/kernel/fork.c
@@ -543,6 +543,7 @@ static struct mm_struct *mm_init(struct
 	atomic_long_set(&mm->nr_ptes, 0);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
+	mm->pinned_vm = 0;
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
 	mm_init_cpumask(mm);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch

