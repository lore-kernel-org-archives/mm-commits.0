Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1995613AA59
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 21:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712265205; cv=none; b=J1GTI1mlrov+H4ixLEfe2AAgJ6+xIzOZmAGFL2pSNo/bVneDF3dx5GbTmob9Vc0SXiPcvND4EVHo/fN4XuTqIjpF88+SD3oNT4N2geNPevT3JM10D612B7NqZppj5DZe68vpTK4mOF1o8G1lRD0RtZHV//hWvEbwlpMfeJuZq/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712265205; c=relaxed/simple;
	bh=684UI4MxI+4PJikHE59pJdEY6qOeUEcESd4ICeGclvY=;
	h=Date:To:From:Subject:Message-Id; b=T/QtlGVu0LlOnBVeWzGU3Cvg2Ru7BF/6e+yJeGu20v323Aa0X2deSs05fkjs1VMXgV05CJZ47TkIhCpdtUnR0iRaW012NzvN1zs+DRdVrc+o4mP1eu+MslNRn/DoJnqrhH9MCOiDNcp704Sv8MfjDEVIAEwjiYN00gJ3A+bq/10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bbIHmgKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bbIHmgKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AE5C43390;
	Thu,  4 Apr 2024 21:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712265204;
	bh=684UI4MxI+4PJikHE59pJdEY6qOeUEcESd4ICeGclvY=;
	h=Date:To:From:Subject:From;
	b=bbIHmgKibj9pWnG7n+yPCSV6Gbqsf21snHu5owdlywl82THcrk8uZiCbrkA8q79Kj
	 U8PPbFUsX1Qe1Z1ABBIEJC602/11cJf96/Y+D3olIhnKH4DzqWb65AnyAekYbDgBHx
	 9iPVzjAKVxfLOkvyWjCjpflC/zn6/00UyTBo6f5o=
Date: Thu, 04 Apr 2024 14:13:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,alexghiti@rivosinc.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-fix-accounting-of-pages-when-migrating.patch added to mm-hotfixes-unstable branch
Message-Id: <20240404211324.87AE5C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: fix accounting of pages when migrating
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmpage_owner-fix-accounting-of-pages-when-migrating.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-fix-accounting-of-pages-when-migrating.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: fix accounting of pages when migrating
Date: Thu, 4 Apr 2024 09:07:01 +0200

Upon migration, new allocated pages are being given the handle of the old
pages.  This is problematic because it means that for the stack which
allocated the old page, we will be substracting the old page + the new one
when that page is freed, creating an accounting imbalance.

There is an interest in keeping it that way, as otherwise the output will
biased towards migration stacks should those operations occur often, but
that is not really helpful.

The link from the new page to the old stack is being performed by calling
__update_page_owner_handle() in __folio_copy_owner().  The only thing that
is left is to link the migrate stack to the old page, so the old page will
be subtracted from the migrate stack, avoiding by doing so any possible
imbalance.

Link: https://lkml.kernel.org/r/20240404070702.2744-4-osalvador@suse.de
Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/page_owner.c~mmpage_owner-fix-accounting-of-pages-when-migrating
+++ a/mm/page_owner.c
@@ -366,9 +366,12 @@ void __split_page_owner(struct page *pag
 
 void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
+	int i;
 	struct page_ext *old_ext;
 	struct page_ext *new_ext;
 	struct page_owner *old_page_owner;
+	struct page_owner *new_page_owner;
+	depot_stack_handle_t migrate_handle;
 
 	old_ext = page_ext_get(&old->page);
 	if (unlikely(!old_ext))
@@ -381,6 +384,8 @@ void __folio_copy_owner(struct folio *ne
 	}
 
 	old_page_owner = get_page_owner(old_ext);
+	new_page_owner = get_page_owner(new_ext);
+	migrate_handle = new_page_owner->handle;
 	__update_page_owner_handle(new_ext, old_page_owner->handle,
 				   old_page_owner->order, old_page_owner->gfp_mask,
 				   old_page_owner->last_migrate_reason,
@@ -395,6 +400,16 @@ void __folio_copy_owner(struct folio *ne
 					old_page_owner->free_pid,
 					old_page_owner->free_tgid,
 					old_page_owner->free_ts_nsec);
+	/*
+	 * We linked the original stack to the new folio, we need to do the same
+	 * for the new one and the old folio otherwise there will be an imbalance
+	 * when subtracting those pages from the stack.
+	 */
+	for (i = 0; i < (1 << new_page_owner->order); i++) {
+		old_page_owner->handle = migrate_handle;
+		old_ext = page_ext_next(old_ext);
+		old_page_owner = get_page_owner(old_ext);
+	}
 
 	page_ext_put(new_ext);
 	page_ext_put(old_ext);
_

Patches currently in -mm which might be from osalvador@suse.de are

mmpage_owner-update-metadata-for-tail-pages.patch
mmpage_owner-fix-refcount-imbalance.patch
mmpage_owner-fix-accounting-of-pages-when-migrating.patch
mmpage_owner-fix-printing-of-stack-records.patch

