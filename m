Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38074367F59
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622915; cv=none; b=GQY81f47HwVzhIxXDDIxDmE0PJiUfpborqjgl4ovElCLyyjaPeLiK5hQw6n2wnrnBv/STWv9Izoly6hzts1WlNnShFOj2BM8gKKqpoL8WYEaR7JYMfrdrdo3UUu0hew2Epohr6t6wBoJcTUszZf6FwXYOxEBEdLj45sclzVD9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622915; c=relaxed/simple;
	bh=sorLOdTWwxnv+DZ15TgkSxmgcAGyA9CM9pjJ5LSIC60=;
	h=Date:To:From:Subject:Message-Id; b=Wo1UJKZJQrryjqwKdqPrrnKjmmGGao4avn3idfRFrfsjM3YDfCwykHSMlW1pNqASEbAnKXnfzno/6cnxagtPcd/9BiZvyKn3hc+/ZHyIsIidvxROza6Qry6BZu5BAqPooyDIZ3ISaV2D5+PbxV2C1NVCAlAGYqkNRkjziq8paMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=veo1MGEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="veo1MGEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E90F1F000E9;
	Tue, 25 Aug 2026 01:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622914;
	bh=AU5G86w13ox6iof0RR4ZSs+3pQ/0/TkHDuN1EBzMWGI=;
	h=Date:To:From:Subject;
	b=veo1MGEY65eH/9d0HluHzEnitmGwI0s3LddZzqg9t4XbzYissxOamrVs8ILU0aUPC
	 2jeT5BP23wBcNhUK6CmGewayBFUmG4U4dfjiz1mlz9aQpJaKR/FgffaKk9eF7BUDPc
	 EIwa3TnVAjnld1yiY0Q/RE93FRaxeZTXjw+C0ZxU=
Date: Mon, 24 Aug 2026 18:55:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,hch@lst.de,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly.patch removed from -mm tree
Message-Id: <20260825015514.0E90F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-writeback: document folio_mark_dirty() locking more explicitly
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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


