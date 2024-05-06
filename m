Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA055CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957022; cv=none; b=q/sJg1bnkqayCF6lOXGi4HU2hSge46ognmpCcMEkSdz/Vj9nOvPTpNJuIkXuolUJGOyyrl33vyXKBqpJQayBQ6izwtLK6jztgdiByTmA9PMSX51L24u2K+DvKpATHRZJeIaFVgfTZ/coCziFPEDHg8FDaoFwKj4W1MOjccCBsOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957022; c=relaxed/simple;
	bh=5i+zYjVYMVCoSHcYO+0Zhni/fVfFG4kuBy36n9mWGOQ=;
	h=Date:To:From:Subject:Message-Id; b=bHqNjAUyOqjkBclr17IlXfSN+yTfLRyOt+4QxsmHXz+NNWwBM4hfQ6qeupk5fjFhUxXaajt4Asf2TEEU/33GpQ3TdlEncBJ59uQ0RPilOL5ut1mv8SwsDVmEv/bmKUmHbsQKfK6ZmXwwKpSKjImdUWbfbXAlPiHGw1SLM7NrdMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=izsAZmoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="izsAZmoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19FEC116B1;
	Mon,  6 May 2024 00:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957022;
	bh=5i+zYjVYMVCoSHcYO+0Zhni/fVfFG4kuBy36n9mWGOQ=;
	h=Date:To:From:Subject:From;
	b=izsAZmozcV75I+60R3z1R5fu2xvvX3KKnixDSztBkeEhunf/0I1C+DXSjLBjRy0p1
	 CA2/ZuC/3QnLFOwdqt7HAtbb8lKlpOMMpmzcUsl+7OSkROUj+KfKclag/GWwHECmoA
	 VoAPsCwp/5vf/voD5McSD2XlPhIwIdpwXA4za+wk=
Date: Sun, 05 May 2024 17:57:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch removed from -mm tree
Message-Id: <20240506005702.B19FEC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: use folio in remove_rmap_item_from_tree
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: use folio in remove_rmap_item_from_tree
Date: Thu, 11 Apr 2024 14:17:03 +0800

To save 2 compound_head calls.

Link: https://lkml.kernel.org/r/20240411061713.1847574-3-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-folio-in-remove_rmap_item_from_tree
+++ a/mm/ksm.c
@@ -1006,16 +1006,16 @@ static void remove_rmap_item_from_tree(s
 {
 	if (rmap_item->address & STABLE_FLAG) {
 		struct ksm_stable_node *stable_node;
-		struct page *page;
+		struct folio *folio;
 
 		stable_node = rmap_item->head;
-		page = get_ksm_page(stable_node, GET_KSM_PAGE_LOCK);
-		if (!page)
+		folio = ksm_get_folio(stable_node, GET_KSM_PAGE_LOCK);
+		if (!folio)
 			goto out;
 
 		hlist_del(&rmap_item->hlist);
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 
 		if (!hlist_empty(&stable_node->hlist))
 			ksm_pages_sharing--;
_

Patches currently in -mm which might be from alexs@kernel.org are


