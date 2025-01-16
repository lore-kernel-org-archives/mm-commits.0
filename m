Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07A018A6D7
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006313; cv=none; b=EGuucE6a9QHQOebse+X0RFzdhquDgem9uc4O7DQjyW1Ho57TgY1dg66cMWhtwJVMhQyye818fodZArqSuhrM5oH4PiQkNWYIEVGL81ljDLoTcjZ4p3jh/7dscHbbMeSf2QMGyxVnLW9sCJJ2iPMH/l6Dxt5wcjO02OjQJmvEEDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006313; c=relaxed/simple;
	bh=EN5LVytdV8iW2m/8k0zxlpKLzUKxpAkqnd18TRD60gE=;
	h=Date:To:From:Subject:Message-Id; b=MzdderLHuYEzoWI2jwRv3PNMz1KQ+SgAJlbYhsifeHI5x8sV1gSgMEKZGH1fko9Fo4+XWNgmSV+jSwtRfCVxUmi9hDJ7BUarL/Vq/dedQoqfMwNrw3oeLAZaXRQowD76fWq3lEJkr6Eu6qhQG8KEtK5QLs18/B77mYnQxlDInVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ONTQLNH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ONTQLNH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBC4C4CED6;
	Thu, 16 Jan 2025 05:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006312;
	bh=EN5LVytdV8iW2m/8k0zxlpKLzUKxpAkqnd18TRD60gE=;
	h=Date:To:From:Subject:From;
	b=ONTQLNH+Yo4DTaKDpP7er+vrqqGO3XyRdc9lTObAE66vO/Xpqt8x7FKaRmBX4Agtc
	 79sq+44hqzaKT51TXmsxYjQVBtECHySGbx+UB/hoadgQGsovXqDPDvrVG3E7oYXiL5
	 DgvAqgdX2OGEUkhCCjgv7kFGrQk4EguurZrgbOZ8=
Date: Wed, 15 Jan 2025 21:45:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch removed from -mm tree
Message-Id: <20250116054512.7CBC4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio
has been removed from the -mm tree.  Its filename was
     mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio
Date: Mon, 13 Jan 2025 14:16:08 +0100

We replaced a simple put_page() by a putback_active_hugepage() call in
commit 3aaa76e125c1 ("mm: migrate: hugetlb: putback destination hugepage
to active list"), to set the "active" flag on the dst hugetlb folio.

Nowadays, we decoupled the "active" list from the flag, by calling the
flag "migratable".

Calling "putback" on something that wasn't allocated is weird and not
future proof, especially if we might reach that path when migration failed
and we just want to free the freshly allocated hugetlb folio.

Let's simply handle the migratable flag and the active list flag in
move_hugetlb_state(), where we know that allocation succeeded and already
handle the temporary flag; use a simple folio_put() to return our
reference.

Link: https://lkml.kernel.org/r/20250113131611.2554758-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++++++++
 mm/migrate.c |    8 ++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio
+++ a/mm/hugetlb.c
@@ -7533,6 +7533,16 @@ void move_hugetlb_state(struct folio *ol
 		}
 		spin_unlock_irq(&hugetlb_lock);
 	}
+
+	/*
+	 * Our old folio is isolated and has "migratable" cleared until it
+	 * is putback. As migration succeeded, set the new folio "migratable"
+	 * and add it to the active list.
+	 */
+	spin_lock_irq(&hugetlb_lock);
+	folio_set_hugetlb_migratable(new_folio);
+	list_move_tail(&new_folio->lru, &(folio_hstate(new_folio))->hugepage_activelist);
+	spin_unlock_irq(&hugetlb_lock);
 }
 
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
--- a/mm/migrate.c~mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio
+++ a/mm/migrate.c
@@ -1539,14 +1539,14 @@ out:
 		list_move_tail(&src->lru, ret);
 
 	/*
-	 * If migration was not successful and there's a freeing callback, use
-	 * it.  Otherwise, put_page() will drop the reference grabbed during
-	 * isolation.
+	 * If migration was not successful and there's a freeing callback,
+	 * return the folio to that special allocator. Otherwise, simply drop
+	 * our additional reference.
 	 */
 	if (put_new_folio)
 		put_new_folio(dst, private);
 	else
-		folio_putback_active_hugetlb(dst);
+		folio_put(dst);
 
 	return rc;
 }
_

Patches currently in -mm which might be from david@redhat.com are


