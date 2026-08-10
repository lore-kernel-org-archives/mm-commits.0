Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B4B3033F7
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 22:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786399961; cv=none; b=juQozFUBBhkQBDCGCpyrjuGFW1tKF7ja5nnD5w8ClaKp71vlzQ2AY9xP9wF2Aj4OUTafvKrgvwu1dr3RpN6Y6PNYaNfvo0CG017jrTynCmXyLnpEFDRdlRby+pCFCiv73OrCsZioddgDPTKOhj+tNfMx/MASXawnMEB/CFfKjNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786399961; c=relaxed/simple;
	bh=PNfYmEDwgn+0fwWFiCqgVc7doLlTIYRV28aTLjwvxRU=;
	h=Date:To:From:Subject:Message-Id; b=CtyxA/Sj7RDf1DrHjB7KngYS3jrbMJtFLdXWLqhkzRMbTwpgV5SuWlNtPb1NXxS32D09KM1s/KSfMleHJOD4P2A2ci8M1daec/q9gFS66dFBa5Q72APr3WK1qGjnxcorRxfGL3IuTUDbbWllNH5+jjubW8Pb0a+5CMh4f7nu7M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g/H+WX16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g/H+WX16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05F21F000E9;
	Mon, 10 Aug 2026 22:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786399960;
	bh=RFfvWJjKIA+dq4Lbet1FaqofF7ykO3YIpBB8ZLc2RJc=;
	h=Date:To:From:Subject;
	b=g/H+WX16PALtVFi8Oxx994aWiEdVLkFtXeSbIoL8YqiJHytMV0HtwwIQ4x2nTD3vz
	 bfm3bHHoulmd8dRqUxXAfHHpMbqwVrbWD4ZCnt66bmfY/59t2VwOP4anXNgO0hM6M+
	 t7Bmlj83SCoYebh4fXKt8MIWhdiJtd5bgf3wgvy8=
Date: Mon, 10 Aug 2026 15:12:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,hch@infradead.org,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly.patch added to mm-new branch
Message-Id: <20260810221239.F05F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-writeback: document folio_mark_dirty() locking more explicitly
has been added to the -mm mm-new branch.  Its filename is
     mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/page-writeback: document folio_mark_dirty() locking more explicitly
Date: Mon, 10 Aug 2026 20:10:01 +0200

We have had bugs where set_page_dirty() was used on a page from GUP
without appropriate locking, leading to UAF, in:

 - KVM, see
   https://lore.kernel.org/r/20260810-x86-kvm-setpagedirty-v1-1-85f180892d4f@google.com
 - i915, see commit 0d4bbe3d407f ("drm/i915/userptr: Try to acquire the
   page lock around set_page_dirty()").
 - VMCI, see commit 5a16c535409f ("VMCI: Use set_page_dirty_lock() when
   unregistering guest memory")
 - kpc2000 staging driver, see commit b6d13bd9f2c1 ("staging: kpc2000:
   kpc_dma: Convert set_page_dirty() --> set_page_dirty_lock()")

I think set_page_dirty() and folio_mark_dirty() need more explicit
documentation on how they should be used with pages from GUP; so add a
comment on top of set_page_dirty() and make the comment above
folio_mark_dirty() more explicit.

Link: https://lore.kernel.org/20260810-set-page-dirty-warnings-v2-1-1bd40fadfacd@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/folio-compat.c   |    1 +
 mm/page-writeback.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/mm/folio-compat.c~mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly
+++ a/mm/folio-compat.c
@@ -41,6 +41,7 @@ void set_page_writeback(struct page *pag
 }
 EXPORT_SYMBOL(set_page_writeback);
 
+/* Read the comment above folio_mark_dirty() regarding required locks! */
 bool set_page_dirty(struct page *page)
 {
 	return folio_mark_dirty(page_folio(page));
--- a/mm/page-writeback.c~mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly
+++ a/mm/page-writeback.c
@@ -2763,6 +2763,11 @@ EXPORT_SYMBOL(folio_redirty_for_writepag
  * in this folio.  Truncation will block on the page table lock as it
  * unmaps pages before removing the folio from its mapping.
  *
+ * .. DANGER::
+ *    Do not use this on a folio obtained from a function like
+ *    get_user_pages_fast() without holding appropriate locks; you might want to
+ *    use set_page_dirty_lock() or folio_mark_dirty_lock() instead.
+ *
  * Return: True if the folio was newly dirtied, false if it was already dirty.
  */
 bool folio_mark_dirty(struct folio *folio)
_

Patches currently in -mm which might be from jannh@google.com are

mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly.patch

