Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33218167DAC
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732875148; cv=none; b=hj0ugjrb/6NUhzmyh6QKptLkWWuH3389Ge+x6ZtjbLjTOuRdn5Nfvg0Qr8liS/fmuwxnIGl6RX8cjydZkNULbwiQkA5CuUgnkdfpsRJjEVzv3/8fMjHJd2AcbcZZx5UGTsqIsLWl4MduM/1W32RlX2AeoCVwWjhUrOD5/AvahFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732875148; c=relaxed/simple;
	bh=RECwYGBm4ZjOsH8CFa+Mq8GylbKJMRxZNf38ncnxM8k=;
	h=Date:To:From:Subject:Message-Id; b=H6Og9eQsqd7lf8CLAbsWXUVesMfQ/aL9k7nifPf/LWtMQDjvEbgpGy5kfxAXiXeEAtTgWJdZe63h72i2E11rPrJnd2Ic6o+sdvv0D17jjn4dyBdFVfVumM4z4VSFVx1rdjTzBxs8+0A9NTb9jUkSMMK0ykxlK4C3Bpx2OFN2Sog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VoFeMXQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VoFeMXQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788C4C4CECF;
	Fri, 29 Nov 2024 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732875147;
	bh=RECwYGBm4ZjOsH8CFa+Mq8GylbKJMRxZNf38ncnxM8k=;
	h=Date:To:From:Subject:From;
	b=VoFeMXQzt0unouAWof24mwkAgSVazmNNXZ264XyCOAnUXQSSZ+DZoFcWW7Pd1R80S
	 ZC7XLDPaqZ9WKVnm0b58CvmfX+QfZHDd6+kKqi6ElJo9nb7fmLH0pYVl12btUVLkd5
	 ryxX2r8hcj85U9fwVJMRk+vKSvNUsOWp0GoY+alI=
Date: Fri, 29 Nov 2024 02:12:26 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,surenb@google.com,kent.overstreet@linux.dev,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-swap-tags-when-migrate-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20241129101227.788C4C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: swap tags when migrate pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-codetag-swap-tags-when-migrate-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-swap-tags-when-migrate-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Wang <00107082@163.com>
Subject: mm/codetag: swap tags when migrate pages
Date: Fri, 29 Nov 2024 10:52:13 +0800

Current solution to adjust codetag references during page migration is
done in 3 steps:

1. sets the codetag reference of the old page as empty (not pointing
   to any codetag);

2. subtracts counters of the new page to compensate for its own
   allocation;

3. sets codetag reference of the new page to point to the codetag of
   the old page.

This does not work if CONFIG_MEM_ALLOC_PROFILING_DEBUG=n because
set_codetag_empty() becomes NOOP.  Instead, let's simply swap codetag
references so that the new page is referencing the old codetag and the old
page is referencing the new codetag.  This way accounting stays valid and
the logic makes more sense.

Link: https://lkml.kernel.org/r/20241129025213.34836-1-00107082@163.com
Fixes: e0a955bf7f61 ("mm/codetag: add pgalloc_tag_copy()")
Signed-off-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/lkml/20241124074318.399027-1-00107082@163.com/
Acked-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |    4 +--
 lib/alloc_tag.c             |   36 ++++++++++++++++++++--------------
 mm/migrate.c                |    2 -
 3 files changed, 25 insertions(+), 17 deletions(-)

--- a/include/linux/pgalloc_tag.h~mm-codetag-swap-tags-when-migrate-pages
+++ a/include/linux/pgalloc_tag.h
@@ -231,7 +231,7 @@ static inline void pgalloc_tag_sub_pages
 }
 
 void pgalloc_tag_split(struct folio *folio, int old_order, int new_order);
-void pgalloc_tag_copy(struct folio *new, struct folio *old);
+void pgalloc_tag_swap(struct folio *new, struct folio *old);
 
 void __init alloc_tag_sec_init(void);
 
@@ -245,7 +245,7 @@ static inline struct alloc_tag *pgalloc_
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 static inline void alloc_tag_sec_init(void) {}
 static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order) {}
-static inline void pgalloc_tag_copy(struct folio *new, struct folio *old) {}
+static inline void pgalloc_tag_swap(struct folio *new, struct folio *old) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
--- a/lib/alloc_tag.c~mm-codetag-swap-tags-when-migrate-pages
+++ a/lib/alloc_tag.c
@@ -189,26 +189,34 @@ void pgalloc_tag_split(struct folio *fol
 	}
 }
 
-void pgalloc_tag_copy(struct folio *new, struct folio *old)
+void pgalloc_tag_swap(struct folio *new, struct folio *old)
 {
-	union pgtag_ref_handle handle;
-	union codetag_ref ref;
-	struct alloc_tag *tag;
+	union pgtag_ref_handle handle_old, handle_new;
+	union codetag_ref ref_old, ref_new;
+	struct alloc_tag *tag_old, *tag_new;
 
-	tag = pgalloc_tag_get(&old->page);
-	if (!tag)
+	tag_old = pgalloc_tag_get(&old->page);
+	if (!tag_old)
+		return;
+	tag_new = pgalloc_tag_get(&new->page);
+	if (!tag_new)
 		return;
 
-	if (!get_page_tag_ref(&new->page, &ref, &handle))
+	if (!get_page_tag_ref(&old->page, &ref_old, &handle_old))
+		return;
+	if (!get_page_tag_ref(&new->page, &ref_new, &handle_new)) {
+		put_page_tag_ref(handle_old);
 		return;
+	}
+
+	/* swap tags */
+	__alloc_tag_ref_set(&ref_old, tag_new);
+	update_page_tag_ref(handle_old, &ref_old);
+	__alloc_tag_ref_set(&ref_new, tag_old);
+	update_page_tag_ref(handle_new, &ref_new);
 
-	/* Clear the old ref to the original allocation tag. */
-	clear_page_tag_ref(&old->page);
-	/* Decrement the counters of the tag on get_new_folio. */
-	alloc_tag_sub(&ref, folio_size(new));
-	__alloc_tag_ref_set(&ref, tag);
-	update_page_tag_ref(handle, &ref);
-	put_page_tag_ref(handle);
+	put_page_tag_ref(handle_old);
+	put_page_tag_ref(handle_new);
 }
 
 static void shutdown_mem_profiling(bool remove_file)
--- a/mm/migrate.c~mm-codetag-swap-tags-when-migrate-pages
+++ a/mm/migrate.c
@@ -745,7 +745,7 @@ void folio_migrate_flags(struct folio *n
 		folio_set_readahead(newfolio);
 
 	folio_copy_owner(newfolio, folio);
-	pgalloc_tag_copy(newfolio, folio);
+	pgalloc_tag_swap(newfolio, folio);
 
 	mem_cgroup_migrate(folio, newfolio);
 }
_

Patches currently in -mm which might be from 00107082@163.com are

mm-codetag-swap-tags-when-migrate-pages.patch

