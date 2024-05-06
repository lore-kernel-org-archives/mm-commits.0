Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14C76116
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956293; cv=none; b=edszemWmbdBDLe+dmJiIupQ84kV5ZxZ+iver1V+s473VYsT/2gMUTOKDDIBEXLKacseHeR4rQsy1qLyo8klC1Uj8vr1cor5RBpbBAf1pnxK2VjIn4V2AMJPFuL1pXFhnSz01m2+ft0mjneuF3OJ7Ev9Pc/pE0d3MUJRFmYMxGCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956293; c=relaxed/simple;
	bh=Nb03CTk3hy3fnyHDq8MzppEMkeT/L8BtG08QltPpMI4=;
	h=Date:To:From:Subject:Message-Id; b=NdgDCQFGNtkLeHz+jR11WUsPTkmTnrQpMP+0o6kJh4DsOMDK0h13zsv2uRGWqOoK00eRDWufDIJvlEKMgpRTM7v6INjcGFbpSx7qoX7iqx69cbEVNL+TulL0VLv9QYWqTlRYicUIWzgfhC+fm+RSTSy9hDoISnhL4aQed3EGz94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vr8Xa8lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vr8Xa8lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A50C113CC;
	Mon,  6 May 2024 00:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956293;
	bh=Nb03CTk3hy3fnyHDq8MzppEMkeT/L8BtG08QltPpMI4=;
	h=Date:To:From:Subject:From;
	b=Vr8Xa8lmFXKfdf3t5JP68OEMJu/TUoki+YFnHBt2QZ48ivE8prntW1DVQOLqLdaQi
	 KkxBO1KWJ87NozsTv42g6i6wW+i+Dq+4xBzyXxtgchEhKN4V1DOfeaszo/elRv0UED
	 IZTISpPufj1oP6V5n7hFscHL7A4z3jFe5B3cM2fs=
Date: Sun, 05 May 2024 17:44:52 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] doc-split-bufferrst-out-of-api-summaryrst-fix.patch removed from -mm tree
Message-Id: <20240506004453.54A50C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc-split-bufferrst-out-of-api-summaryrst-fix
has been removed from the -mm tree.  Its filename was
     doc-split-bufferrst-out-of-api-summaryrst-fix.patch

This patch was dropped because it was folded into doc-split-bufferrst-out-of-api-summaryrst.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: doc-split-bufferrst-out-of-api-summaryrst-fix
Date: Wed, 17 Apr 2024 02:57:46 +0100

fix kerneldoc warning

Documentation/filesystems/index.rst:50: WARNING: toctree contains reference to nonexisting document 'filesystems/buffer' 

Link: https://lkml.kernel.org/r/20240417015933.453505-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/buffer.rst |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- /dev/null
+++ a/Documentation/filesystems/buffer.rst
@@ -0,0 +1,13 @@
+Buffer Heads
+============
+
+Linux uses buffer heads to maintain state about individual filesystem blocks.
+Buffer heads are deprecated and new filesystems should use iomap instead.
+
+Functions
+---------
+
+.. kernel-doc:: include/linux/buffer_head.h
+.. kernel-doc:: fs/buffer.c
+   :export:
+
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch
mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch
mm-delay-the-check-for-a-null-anon_vma.patch
mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch
mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch
thp-remove-hpage_pmd_order-minimum-assertion.patch
squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

