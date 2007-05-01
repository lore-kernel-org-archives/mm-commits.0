From: akpm@linux-foundation.org
Subject: + hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch added to -mm tree
Date: Tue, 01 May 2007 16:00:31 -0700
Message-ID: <200705012300.l41N0VOp008734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030302AbXEAXAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 19:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, wli@holomorphy.com


The patch titled
     hugetlbfs: add NULL check in hugetlb_zero_setup()
has been added to the -mm tree.  Its filename is
     hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlbfs: add NULL check in hugetlb_zero_setup()
From: Akinobu Mita <akinobu.mita@gmail.com>

If hugetlbfs module_init() fails, hugetlbfs_vfsmount is not initialized and
shmget() with SHM_HUGETLB flag will cause NULL pointer dereference.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: William Irwin <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-add-null-check-in-hugetlb_zero_setup fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-add-null-check-in-hugetlb_zero_setup
+++ a/fs/hugetlbfs/inode.c
@@ -746,6 +746,9 @@ struct file *hugetlb_zero_setup(size_t s
 	char buf[16];
 	static atomic_t counter;
 
+	if (!hugetlbfs_vfsmount)
+		return ERR_PTR(-ENOENT);
+
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-alsa.patch
git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch
slob-handle-slab_panic-flag.patch
use-slab_panic-flag-cleanup.patch
fault-injection-fix-failslab-with-config_numa.patch
hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
sunrpc-fix-error-path-in-module_init.patch
