From: akpm@linux-foundation.org
Subject: [merged] infiniband-use-rlimit-helpers.patch removed from -mm tree
Date: Tue, 16 Feb 2010 10:35:01 -0800
Message-ID: <201002161835.o1GIZ1Uc030403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab0BPSfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 13:35:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, hal.rosenstock@gmail.com, infinipath@qlogic.com, rolandd@cisco.com, sean.hefty@intel.com, mm-commits@vger.kernel.org


The patch titled
     infiniband: use rlimit helpers
has been removed from the -mm tree.  Its filename was
     infiniband-use-rlimit-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: infiniband: use rlimit helpers
From: Jiri Slaby <jslaby@suse.cz>

Make sure compiler won't do weird things with limits.  E.g.  fetching them
twice may return 2 different values after writable limits are implemented.

I.e.  either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd ("resource: add helpers for
fetching rlimits") or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Roland Dreier <rolandd@cisco.com>
Cc: Ralph Campbell <infinipath@qlogic.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/infiniband/core/umem.c~infiniband-use-rlimit-helpers drivers/infiniband/core/umem.c
--- a/drivers/infiniband/core/umem.c~infiniband-use-rlimit-helpers
+++ a/drivers/infiniband/core/umem.c
@@ -136,7 +136,7 @@ struct ib_umem *ib_umem_get(struct ib_uc
 	down_write(&current->mm->mmap_sem);
 
 	locked     = npages + current->mm->locked_vm;
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
 	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		ret = -ENOMEM;
diff -puN drivers/infiniband/hw/ipath/ipath_user_pages.c~infiniband-use-rlimit-helpers drivers/infiniband/hw/ipath/ipath_user_pages.c
--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c~infiniband-use-rlimit-helpers
+++ a/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -59,8 +59,7 @@ static int __get_user_pages(unsigned lon
 	size_t got;
 	int ret;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >>
-		PAGE_SHIFT;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
 	if (num_pages > lock_limit) {
 		ret = -ENOMEM;
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
mm-use-rlimit-helpers.patch
bootmem-avoid-dma32-zone-by-default.patch
fs-use-rlimit-helpers.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
kernel-core-use-helpers-for-rlimits-fix.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

