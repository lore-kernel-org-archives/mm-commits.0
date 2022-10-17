Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1025C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJQATw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJQATN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FA631DD4
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:19:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75665B80E2B
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E026C433D6;
        Mon, 17 Oct 2022 00:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965944;
        bh=P5F5yEwfSejg812kZ6VV4w9Dftf4+LLD8y6wlr/FcAo=;
        h=Date:To:From:Subject:From;
        b=xlUeo3rbgXKcFITr6Q0cK+i+Ja3OGbdp9KdEH/72tLUjuFE7gp4QH/s2kwPHxi/v1
         TlIb597E0Oxs3QxXAZ+wlNTGYBVtaf4BwQfVcUYS6G8dMRl0d+eZuWOtWKpmhfb7Od
         ZkmG1Pagddpy0G2SW5nFvC5e7PabEawup0Euzhfs=
Date:   Sun, 16 Oct 2022 17:19:03 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + devdax-sparse-fixes-for-vm_fault_t-in-tracepoints.patch added to mm-unstable branch
Message-Id: <20221017001904.1E026C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: devdax: sparse fixes for vm_fault_t in tracepoints
has been added to the -mm mm-unstable branch.  Its filename is
     devdax-sparse-fixes-for-vm_fault_t-in-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/devdax-sparse-fixes-for-vm_fault_t-in-tracepoints.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: devdax: sparse fixes for vm_fault_t in tracepoints
Date: Fri, 14 Oct 2022 16:58:49 -0700

Now that the dax-mapping-entry code has moved to a common location take
the opportunity to fixup some long standing sparse warnings.  In this case
the tracepoints have long specified the wrong type for the traced return
code.  Pass the correct type, but handle casting it back to 'unsigned int'
inside the trace helpers as the helpers are not prepared to handle
restricted types.

Link: https://lkml.kernel.org/r/166579192919.2236710.12464252412504907962.stgit@dwillia2-xfh.jf.intel.com
Fixes:
drivers/dax/mapping.c:1031:55: sparse: warning: incorrect type in argument 3 (different base types)
drivers/dax/mapping.c:1031:55: sparse:    expected int result
drivers/dax/mapping.c:1031:55: sparse:    got restricted vm_fault_t
drivers/dax/mapping.c:1046:58: sparse: warning: incorrect type in argument 3 (different base types)
drivers/dax/mapping.c:1046:58: sparse:    expected int result
drivers/dax/mapping.c:1046:58: sparse:    got restricted vm_fault_t [assigned] [usertype] ret

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
  Link: http://lore.kernel.org/r/202210091141.cHaQEuCs-lkp@intel.com
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h      |   26 +++++++++++++-------------
 include/trace/events/fs_dax.h |   16 ++++++++--------
 2 files changed, 21 insertions(+), 21 deletions(-)

--- a/include/linux/mm_types.h~devdax-sparse-fixes-for-vm_fault_t-in-tracepoints
+++ a/include/linux/mm_types.h
@@ -891,19 +891,19 @@ enum vm_fault_reason {
 			VM_FAULT_HWPOISON_LARGE | VM_FAULT_FALLBACK)
 
 #define VM_FAULT_RESULT_TRACE \
-	{ VM_FAULT_OOM,                 "OOM" },	\
-	{ VM_FAULT_SIGBUS,              "SIGBUS" },	\
-	{ VM_FAULT_MAJOR,               "MAJOR" },	\
-	{ VM_FAULT_WRITE,               "WRITE" },	\
-	{ VM_FAULT_HWPOISON,            "HWPOISON" },	\
-	{ VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
-	{ VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
-	{ VM_FAULT_NOPAGE,              "NOPAGE" },	\
-	{ VM_FAULT_LOCKED,              "LOCKED" },	\
-	{ VM_FAULT_RETRY,               "RETRY" },	\
-	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
-	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
-	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" }
+	{ (__force unsigned int) VM_FAULT_OOM,                 "OOM" },	\
+	{ (__force unsigned int) VM_FAULT_SIGBUS,              "SIGBUS" },	\
+	{ (__force unsigned int) VM_FAULT_MAJOR,               "MAJOR" },	\
+	{ (__force unsigned int) VM_FAULT_WRITE,               "WRITE" },	\
+	{ (__force unsigned int) VM_FAULT_HWPOISON,            "HWPOISON" },	\
+	{ (__force unsigned int) VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
+	{ (__force unsigned int) VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
+	{ (__force unsigned int) VM_FAULT_NOPAGE,              "NOPAGE" },	\
+	{ (__force unsigned int) VM_FAULT_LOCKED,              "LOCKED" },	\
+	{ (__force unsigned int) VM_FAULT_RETRY,               "RETRY" },	\
+	{ (__force unsigned int) VM_FAULT_FALLBACK,            "FALLBACK" },	\
+	{ (__force unsigned int) VM_FAULT_DONE_COW,            "DONE_COW" },	\
+	{ (__force unsigned int) VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
--- a/include/trace/events/fs_dax.h~devdax-sparse-fixes-for-vm_fault_t-in-tracepoints
+++ a/include/trace/events/fs_dax.h
@@ -9,7 +9,7 @@
 
 DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
-		pgoff_t max_pgoff, int result),
+		pgoff_t max_pgoff, vm_fault_t result),
 	TP_ARGS(inode, vmf, max_pgoff, result),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
@@ -21,7 +21,7 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__field(pgoff_t, max_pgoff)
 		__field(dev_t, dev)
 		__field(unsigned int, flags)
-		__field(int, result)
+		__field(unsigned int, result)
 	),
 	TP_fast_assign(
 		__entry->dev = inode->i_sb->s_dev;
@@ -33,7 +33,7 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__entry->flags = vmf->flags;
 		__entry->pgoff = vmf->pgoff;
 		__entry->max_pgoff = max_pgoff;
-		__entry->result = result;
+		__entry->result = (__force unsigned int) result;
 	),
 	TP_printk("dev %d:%d ino %#lx %s %s address %#lx vm_start "
 			"%#lx vm_end %#lx pgoff %#lx max_pgoff %#lx %s",
@@ -54,7 +54,7 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 #define DEFINE_PMD_FAULT_EVENT(name) \
 DEFINE_EVENT(dax_pmd_fault_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		pgoff_t max_pgoff, int result), \
+		pgoff_t max_pgoff, vm_fault_t result), \
 	TP_ARGS(inode, vmf, max_pgoff, result))
 
 DEFINE_PMD_FAULT_EVENT(dax_pmd_fault);
@@ -151,7 +151,7 @@ DEFINE_EVENT(dax_pmd_insert_mapping_clas
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
 
 DECLARE_EVENT_CLASS(dax_pte_fault_class,
-	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result),
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, vm_fault_t result),
 	TP_ARGS(inode, vmf, result),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
@@ -160,7 +160,7 @@ DECLARE_EVENT_CLASS(dax_pte_fault_class,
 		__field(pgoff_t, pgoff)
 		__field(dev_t, dev)
 		__field(unsigned int, flags)
-		__field(int, result)
+		__field(unsigned int, result)
 	),
 	TP_fast_assign(
 		__entry->dev = inode->i_sb->s_dev;
@@ -169,7 +169,7 @@ DECLARE_EVENT_CLASS(dax_pte_fault_class,
 		__entry->address = vmf->address;
 		__entry->flags = vmf->flags;
 		__entry->pgoff = vmf->pgoff;
-		__entry->result = result;
+		__entry->result = (__force unsigned int) result;
 	),
 	TP_printk("dev %d:%d ino %#lx %s %s address %#lx pgoff %#lx %s",
 		MAJOR(__entry->dev),
@@ -185,7 +185,7 @@ DECLARE_EVENT_CLASS(dax_pte_fault_class,
 
 #define DEFINE_PTE_FAULT_EVENT(name) \
 DEFINE_EVENT(dax_pte_fault_class, name, \
-	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result), \
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, vm_fault_t result), \
 	TP_ARGS(inode, vmf, result))
 
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

fsdax-wait-on-page-not-page-_refcount.patch
fsdax-use-dax_page_idle-to-document-dax-busy-page-checking.patch
fsdax-include-unmapped-inodes-for-page-idle-detection.patch
fsdax-introduce-dax_zap_mappings.patch
fsdax-wait-for-pinned-pages-during-truncate_inode_pages_final.patch
fsdax-validate-dax-layouts-broken-before-truncate.patch
fsdax-hold-dax-lock-over-mapping-insertion.patch
fsdax-update-dax_insert_entry-calling-convention-to-return-an-error.patch
fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio.patch
fsdax-introduce-pgmap_request_folios.patch
fsdax-rework-dax_insert_entry-calling-convention.patch
fsdax-cleanup-dax_associate_entry.patch
devdax-minor-warning-fixups.patch
devdax-fix-sparse-lock-imbalance-warning.patch
libnvdimm-pmem-support-pmem-block-devices-without-dax.patch
devdax-move-address_space-helpers-to-the-dax-core.patch
devdax-sparse-fixes-for-xarray-locking.patch
devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions.patch
devdax-sparse-fixes-for-vm_fault_t-in-tracepoints.patch
devdax-add-pud-support-to-the-dax-mapping-infrastructure.patch
devdax-use-dax_insert_entry-dax_delete_mapping_entry.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios.patch
mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0.patch
mm-meremap_pages-delete-put_devmap_managed_page_refs.patch
mm-gup-drop-dax-pgmap-accounting.patch

