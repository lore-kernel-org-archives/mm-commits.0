From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch removed from -mm tree
Date: Fri, 08 Aug 2014 13:58:17 -0700
Message-ID: <53e539e9.mojauphHhewlu3Vc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:53889 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbaHHU6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:58:18 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so806655qgd.0
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:58:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix
has been removed from the -mm tree.  Its filename was
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch

This patch was dropped because it was folded into mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

------------------------------------------------------
From: kbuild test robot <fengguang.wu@intel.com>
Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix

remap_oldmem_pfn_checked() can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix
+++ a/fs/proc/vmcore.c
@@ -340,7 +340,7 @@ static inline char *alloc_elfnotes_buf(s
  *
  * Returns zero on success, -EAGAIN on failure.
  */
-int remap_oldmem_pfn_checked(struct vm_area_struct *vma, unsigned long from,
+static int remap_oldmem_pfn_checked(struct vm_area_struct *vma, unsigned long from,
 			     unsigned long pfn, unsigned long size,
 			     pgprot_t prot)
 {
@@ -391,7 +391,7 @@ fail:
 	return -EAGAIN;
 }
 
-int vmcore_remap_oldmem_pfn(struct vm_area_struct *vma,
+static int vmcore_remap_oldmem_pfn(struct vm_area_struct *vma,
 			    unsigned long from, unsigned long pfn,
 			    unsigned long size, pgprot_t prot)
 {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
nilfs2-integrate-sysfs-support-into-driver.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch

