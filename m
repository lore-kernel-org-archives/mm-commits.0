Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F70C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5183760FBF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343624AbhKPEwh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:52:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245621AbhKPEwM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD8D260FBF;
        Tue, 16 Nov 2021 04:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637038131;
        bh=l9h9QVP6bbTrsjeueifYxPQxbDGA1k5YsArEjYXwtCk=;
        h=Date:From:To:Subject:From;
        b=fVFn5g0Y6zubV3KWsbhYv6lmiBsVHsGIca7utrhCijbRSDncDTMcvIGcLpopsNTxc
         s4O6/vHUrqFfDckumecUrK2qRhgshkiIUxiszCRJUHqOiPiVLhM58t7FX4ZpSkpcnt
         y77XQX7thiAugwMmsm6UyWcY1VDfDEmZBH5BPyWM=
Date:   Mon, 15 Nov 2021 20:48:50 -0800
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, Felix.Kuehling@amd.com, jgg@nvidia.com,
        jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, ziy@nvidia.com
Subject:  +
 mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault.patch added to -mm
 tree
Message-ID: <20211116044850.CUIaQ3e1a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm.c: Allow VM_MIXEDMAP to work with hmm_range_fault
has been added to the -mm tree.  Its filename is
     mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/hmm.c: Allow VM_MIXEDMAP to work with hmm_range_fault

hmm_range_fault() can be used instead of get_user_pages() for devices
which allow faulting however unlike get_user_pages() it will return an
error when used on a VM_MIXEDMAP range.

To make hmm_range_fault() more closely match get_user_pages() remove
this restriction. This requires dealing with the !ARCH_HAS_PTE_SPECIAL
case in hmm_vma_handle_pte(). Rather than replicating the logic of
vm_normal_page() call it directly and do a check for the zero pfn
similar to what get_user_pages() currently does.

Also add a test to hmm selftest to verify functionality.

Link: https://lkml.kernel.org/r/20211104012001.2555676-1-apopple@nvidia.com
Fixes: da4c3c735ea4 ("mm/hmm/mirror: helper to snapshot CPU page table")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c                         |   24 +++++++++++++
 mm/hmm.c                               |    5 +-
 tools/testing/selftests/vm/hmm-tests.c |   42 +++++++++++++++++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault
+++ a/lib/test_hmm.c
@@ -1086,9 +1086,33 @@ static long dmirror_fops_unlocked_ioctl(
 	return 0;
 }
 
+static int dmirror_fops_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long addr;
+
+	for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
+		struct page *page;
+		int ret;
+
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return -ENOMEM;
+
+		ret = vm_insert_page(vma, addr, page);
+		if (ret) {
+			__free_page(page);
+			return ret;
+		}
+		put_page(page);
+	}
+
+	return 0;
+}
+
 static const struct file_operations dmirror_fops = {
 	.open		= dmirror_fops_open,
 	.release	= dmirror_fops_release,
+	.mmap		= dmirror_fops_mmap,
 	.unlocked_ioctl = dmirror_fops_unlocked_ioctl,
 	.llseek		= default_llseek,
 	.owner		= THIS_MODULE,
--- a/mm/hmm.c~mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault
+++ a/mm/hmm.c
@@ -300,7 +300,8 @@ static int hmm_vma_handle_pte(struct mm_
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
 	 */
-	if (pte_special(pte) && !pte_devmap(pte) &&
+	if (!vm_normal_page(walk->vma, addr, pte) &&
+	    !pte_devmap(pte) &&
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
@@ -518,7 +519,7 @@ static int hmm_vma_walk_test(unsigned lo
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP | VM_MIXEDMAP)) &&
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
 	    vma->vm_flags & VM_READ)
 		return 0;
 
--- a/tools/testing/selftests/vm/hmm-tests.c~mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -1251,6 +1251,48 @@ TEST_F(hmm, anon_teardown)
 /*
  * Test memory snapshot without faulting in pages accessed by the device.
  */
+TEST_F(hmm, mixedmap)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned char *m;
+	int ret;
+
+	npages = 1;
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(npages);
+	ASSERT_NE(buffer->mirror, NULL);
+
+
+	/* Reserve a range of addresses. */
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE,
+			   self->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Simulate a device snapshotting CPU pagetables. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device saw. */
+	m = buffer->mirror;
+	ASSERT_EQ(m[0], HMM_DMIRROR_PROT_READ);
+
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Test memory snapshot without faulting in pages accessed by the device.
+ */
 TEST_F(hmm2, snapshot)
 {
 	struct hmm_buffer *buffer;
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault.patch

