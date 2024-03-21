Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72C8134420
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055000; cv=none; b=Ku4joClYmFQWdtRfj2wesWdl0pPgYpQT6oOWgsWCJSVOOrqhWpYGQs9logrKlm5XH2vWPZtJnw1yNuLQX4HNajl23/pCJhO0Y9hEzdJHMtVJOWSzkkZ2GDRsheNJY3fmYc+5t1jB/m8WzFMF8L6ITM3ampzGarib05SuwPbPHhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055000; c=relaxed/simple;
	bh=CESO0VnUY/pzxz7+hwaeGKqmAQv+TRhwj7z44C0AC0w=;
	h=Date:To:From:Subject:Message-Id; b=p1G5IBzg1SiMgvAtliLXXlLGf2zIuZ8qdizpiK5r/Ry9NpPrU0cbNkn8kjFiamKmCFtqJhbRPYr2Bfpdw1RBi1KG1Y4JI3M9/njLUd2kOvEfIa4eULlBp/dUiTG0smetXJrr9i5GNA8nh3Zj+IkAw8xEBLGq2T9wbzlnlHWVQQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJr0Jc44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJr0Jc44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E23C433C7;
	Thu, 21 Mar 2024 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055000;
	bh=CESO0VnUY/pzxz7+hwaeGKqmAQv+TRhwj7z44C0AC0w=;
	h=Date:To:From:Subject:From;
	b=DJr0Jc44pgWZd6hpa+s5UDi609VDRAmXYBqbzOltYb/je44kcIKWAnF56/CR1lcOT
	 hOEeE6zvnW1U+gdt4OGI+CZyGl4S+7jPEoY0JQcop3AbngtX+wLKKBHeXklWRGuIwj
	 mdBtqGapbPOP+a7vHOQUe4W7y8XUVrdnFFn6QljY=
Date: Thu, 21 Mar 2024 14:03:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-always-initialise-folio-_deferred_list.patch added to mm-unstable branch
Message-Id: <20240321210320.31E23C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: always initialise folio->_deferred_list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-always-initialise-folio-_deferred_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-always-initialise-folio-_deferred_list.patch

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
Subject: mm: always initialise folio->_deferred_list
Date: Thu, 21 Mar 2024 14:24:39 +0000

Patch series "Various significant MM patches".

These patches all interact in annoying ways which make it tricky to send
them out in any way other than a big batch, even though there's not really
an overarching theme to connect them.

The big effects of this patch series are:

 - folio_test_hugetlb() becomes reliable, even when called without a
   page reference
 - We free up PG_slab, and we could always use more page flags
 - We no longer need to check PageSlab before calling page_mapcount()


This patch (of 9):

For compound pages which are at least order-2 (and hence have a
deferred_list), initialise it and then we can check at free that the page
is not part of a deferred list.  We recently found this useful to rule out
a source of corruption.

Link: https://lkml.kernel.org/r/20240321142448.1645400-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240321142448.1645400-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 mm/hugetlb.c     |    3 ++-
 mm/internal.h    |    2 ++
 mm/memcontrol.c  |    2 ++
 mm/page_alloc.c  |    9 +++++----
 5 files changed, 11 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-always-initialise-folio-_deferred_list
+++ a/mm/huge_memory.c
@@ -771,8 +771,6 @@ void folio_prep_large_rmappable(struct f
 {
 	if (!folio || !folio_test_large(folio))
 		return;
-	if (folio_order(folio) > 1)
-		INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_large_rmappable(folio);
 }
 
--- a/mm/hugetlb.c~mm-always-initialise-folio-_deferred_list
+++ a/mm/hugetlb.c
@@ -1796,7 +1796,8 @@ static void __update_and_free_hugetlb_fo
 		destroy_compound_gigantic_folio(folio, huge_page_order(h));
 		free_gigantic_folio(folio, huge_page_order(h));
 	} else {
-		__free_pages(&folio->page, huge_page_order(h));
+		INIT_LIST_HEAD(&folio->_deferred_list);
+		folio_put(folio);
 	}
 }
 
--- a/mm/internal.h~mm-always-initialise-folio-_deferred_list
+++ a/mm/internal.h
@@ -525,6 +525,8 @@ static inline void prep_compound_head(st
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
+	if (order > 1)
+		INIT_LIST_HEAD(&folio->_deferred_list);
 }
 
 static inline void prep_compound_tail(struct page *head, int tail_idx)
--- a/mm/memcontrol.c~mm-always-initialise-folio-_deferred_list
+++ a/mm/memcontrol.c
@@ -7400,6 +7400,8 @@ static void uncharge_folio(struct folio
 	struct obj_cgroup *objcg;
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+	VM_BUG_ON_FOLIO(folio_order(folio) > 1 &&
+			!list_empty(&folio->_deferred_list), folio);
 
 	/*
 	 * Nobody should be changing or seriously looking at
--- a/mm/page_alloc.c~mm-always-initialise-folio-_deferred_list
+++ a/mm/page_alloc.c
@@ -1007,10 +1007,11 @@ static int free_tail_page_prepare(struct
 		}
 		break;
 	case 2:
-		/*
-		 * the second tail page: ->mapping is
-		 * deferred_list.next -- ignore value.
-		 */
+		/* the second tail page: deferred_list overlaps ->mapping */
+		if (unlikely(!list_empty(&folio->_deferred_list))) {
+			bad_page(page, "on deferred list");
+			goto out;
+		}
 		break;
 	default:
 		if (page->mapping != TAIL_MAPPING) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

