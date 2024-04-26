Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A71BA34
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 18:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714156469; cv=none; b=l7TTlMiqpXu1sQugD7fzMtbh+nSgFiExvFZYVv3mNaMQ9b3doWcTpEfMu5AVVjbYit1Th9WsCSSZzCloPVyXtUgovrUYLZ0DZaVOGd0OWFIpZhwaLRfJKKRW4yw7cfwh+nEky2tefq42BgnnGpWtBn5wGqPGi3cPyuNHKsyGNRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714156469; c=relaxed/simple;
	bh=J/OPRu2krroVSnCc/Y5OOlY8Hpkr2vo6NQP5Pof+Mms=;
	h=Date:To:From:Subject:Message-Id; b=ZpvEVI1XaTPrns19u0IefMtNUknf9HZO6/veTGU+ZJffxlApoodrZXSg/ToBHYgFBSq0pi0dmU5B+4+krOYJLb1IkdyevlHYUaiPGz2YrRRVU23WIe+lKZUY/ogQGg//lMlmvhyf+TrmjIqGPTLYhiXyYB/x7yoZyAhCwJ52cwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nr7JoDxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nr7JoDxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0656AC113CD;
	Fri, 26 Apr 2024 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714156469;
	bh=J/OPRu2krroVSnCc/Y5OOlY8Hpkr2vo6NQP5Pof+Mms=;
	h=Date:To:From:Subject:From;
	b=Nr7JoDxLlywBzFtZYIQpDCoPns4WXMrxpyivruIhFs+QwxzFq2z+9VabHX0eTXc0P
	 Ka2mvmiyA861rjj0axiWNkNaG0jffHA/6JkOXobolAJZuIvoscn0rB4VFlxFfmoHeC
	 AeuJ5BYHUJ2DztYJ8c6eq8ZK49gtz6ELtoAEEbtU=
Date: Fri, 26 Apr 2024 11:34:28 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,jannh@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch added to mm-unstable branch
Message-Id: <20240426183429.0656AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: assert the mmap_lock is held in __anon_vma_prepare()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: assert the mmap_lock is held in __anon_vma_prepare()
Date: Fri, 26 Apr 2024 15:45:00 +0100

Patch series "Improve anon_vma scalability for anon VMAs".

We have a 3x throughput improvement reported by Intel's kernel test robot:
https://lore.kernel.org/all/202404261055.c5e24608-oliver.sang@intel.com/

This is from delaying taking the mmap_lock for page faults until we
actually need the mmap_lock in order to assign an anon_vma to the vma.  It
cleans up the page fault path a little by making the anon fault handler
more similar to the file fault handler.


This patch (of 4):

Convert the comment into an assertion.

Link: https://lkml.kernel.org/r/20240426144506.1290619-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240426144506.1290619-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/rmap.c~mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare
+++ a/mm/rmap.c
@@ -182,8 +182,6 @@ static void anon_vma_chain_link(struct v
  * for the new allocation. At the same time, we do not want
  * to do any locking for the common case of already having
  * an anon_vma.
- *
- * This must be called with the mmap_lock held for reading.
  */
 int __anon_vma_prepare(struct vm_area_struct *vma)
 {
@@ -191,6 +189,7 @@ int __anon_vma_prepare(struct vm_area_st
 	struct anon_vma *anon_vma, *allocated;
 	struct anon_vma_chain *avc;
 
+	mmap_assert_locked(mm);
 	might_sleep();
 
 	avc = anon_vma_chain_alloc(GFP_KERNEL);
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
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
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
mm-remove-page_mapping.patch
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

