From: akpm@linux-foundation.org
Subject: - hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:28 -0700
Message-ID: <200705080004.l4804SJV009015@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967356AbXEHAEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: add NULL check in hugetlb_zero_setup()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-add-null-check-in-hugetlb_zero_setup fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-add-null-check-in-hugetlb_zero_setup
+++ a/fs/hugetlbfs/inode.c
@@ -747,6 +747,9 @@ struct file *hugetlb_zero_setup(size_t s
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
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
use-slab_panic-flag-cleanup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
procfs-use-simple_read_from_buffer.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
