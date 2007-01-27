From: akpm@osdl.org
Subject: - ehca-fix-do_mmap-error-check.patch removed from -mm tree
Date: Sat, 27 Jan 2007 14:04:16 -0800
Message-ID: <200701272204.l0RM4GvM017497@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbXA0WEZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 17:04:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hnguyen@de.ibm.com, raisch@de.ibm.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     ehca: fix do_mmap() error check
has been removed from the -mm tree.  Its filename was
     ehca-fix-do_mmap-error-check.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ehca: fix do_mmap() error check
From: Akinobu Mita <akinobu.mita@gmail.com>

The return value of do_mmap() should be checked by IS_ERR().

Acked-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/ehca/ehca_uverbs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_uverbs.c~ehca-fix-do_mmap-error-check drivers/infiniband/hw/ehca/ehca_uverbs.c
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c~ehca-fix-do_mmap-error-check
+++ a/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -321,14 +321,14 @@ int ehca_mmap_nopage(u64 foffset, u64 le
 		     struct vm_area_struct **vma)
 {
 	down_write(&current->mm->mmap_sem);
-	*mapped = (void*)do_mmap(NULL,0, length, PROT_WRITE,
+	*mapped = (void*)do_mmap(NULL, 0, length, PROT_WRITE,
 				 MAP_SHARED | MAP_ANONYMOUS,
 				 foffset);
 	up_write(&current->mm->mmap_sem);
-	if (!(*mapped)) {
+	if (IS_ERR(*mapped)) {
 		ehca_gen_err("couldn't mmap foffset=%lx length=%lx",
 			     foffset, length);
-		return -EINVAL;
+		return PTR_ERR(*mmaped);
 	}
 
 	*vma = find_vma(current->mm, (u64)*mapped);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-powerpc.patch
ehca-fix-do_mmap-error-check.patch
ehca-fix-do_mmap-error-check-fix.patch
ehca-avoid-crash-on-kthread_create-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-input.patch
git-netdev-all.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-s390.patch
git-watchdog.patch
simplify-the-stacktrace-code.patch
