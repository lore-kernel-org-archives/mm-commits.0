From: akpm@linux-foundation.org
Subject: +
 mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch added
 to -mm tree
Date: Thu, 17 Jul 2014 13:20:12 -0700
Message-ID: <53c82ffc.ZxzwMOfJRAc2H4NM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:35985 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaGQUUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 16:20:13 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so136545qgd.2
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 13:20:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix
has been added to the -mm tree.  Its filename is
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch
mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
add-lib-globc-fix.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch
debugging-keep-track-of-page-owners.patch

