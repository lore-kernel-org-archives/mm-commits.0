From: akpm@osdl.org
Subject: + ehca-fix-do_mmap-error-check.patch added to -mm tree
Date: Wed, 20 Dec 2006 19:43:06 -0800
Message-ID: <200612210343.kBL3h6C7014769@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422673AbWLUDni (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 22:43:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hnguyen@de.ibm.com, raisch@de.ibm.com, rolandd@cisco.com


The patch titled
     ehca: fix do_mmap() error check
has been added to the -mm tree.  Its filename is
     ehca-fix-do_mmap-error-check.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
audit-fix-kstrdup-error-check.patch
gss_spkm3-fix-error-handling-in-module-init.patch
git-acpi.patch
git-alsa.patch
powerpc-use-is_init.patch
git-drm.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

