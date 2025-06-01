Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F401607B4;
	Sun,  1 Jun 2025 05:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756852; cv=none; b=QuYFRWqy4X6zXa7IWeVfsb4ryqauB1twNLEyHJseRpDFCAe2j+uBlzxkey27Oimefny9ATVbns5tx1hKw6DGKRVUdyoqssz12vIFyvzUQ1jOSHjFMXS2KsI3yONEQ/Mlnk2NWkVhJRJNSShyo7ro9/1fzLX0YXJIRUoG1ehiGrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756852; c=relaxed/simple;
	bh=N9vu4Ix9GexY4yJZ+Cw5v16fCb8jpZgVDaoON0PPO5g=;
	h=Date:To:From:Subject:Message-Id; b=KeHvgoN3zhyWUgHdUGm3MpeRMUoP3rI9ZPdMLQwuuXoZJSz6bd8dxxQXIaXGx+5cKePm+s5Kj3eddHqprM//b9P9/cqn2A0x924bOYj54Tbj/5oXv9Ifx2zBKhlM1dTCHlFaXxH0G0tdltiEa5OM4xvOhWdfzzlqlBOmW8vxhhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ha4fx0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ha4fx0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0EAC4CEED;
	Sun,  1 Jun 2025 05:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756852;
	bh=N9vu4Ix9GexY4yJZ+Cw5v16fCb8jpZgVDaoON0PPO5g=;
	h=Date:To:From:Subject:From;
	b=1ha4fx0/VDPxv09f/D4RA6tqnZIuUmZ67orJoVpH05VwVVaD1D4FAvIH4816wo+BV
	 kyFZVPYHyEtbUdNmufZleO3pi81Ta/CaIz0pO1KbMgdJhj+nKzZ+jKgobkOTFZSmx8
	 Mgac6EJ7jM47o4VvnaS9dkyssfhuizaHVsZeH9pE=
Date: Sat, 31 May 2025 22:47:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,fengwei.yin@intel.com,dev.jain@arm.com,david@redhat.com,bharata@amd.com,baolin.wang@linux.alibaba.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference.patch removed from -mm tree
Message-Id: <20250601054732.AA0EAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: fix race with folio split/free using temporary reference
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: fix race with folio split/free using temporary reference
Date: Mon, 26 May 2025 18:28:18 +0000

hpage_collapse_scan_file() calls is_refcount_suitable(), which in turn
calls folio_mapcount().  folio_mapcount() checks folio_test_large() before
proceeding to folio_large_mapcount(), but there is a race window where the
folio may get split/freed between these checks, triggering:

  VM_WARN_ON_FOLIO(!folio_test_large(folio), folio)

Take a temporary reference to the folio in hpage_collapse_scan_file(). 
This stabilizes the folio during refcount check and prevents incorrect
large folio detection due to concurrent split/free.  Use helper
folio_expected_ref_count() + 1 to compare with folio_ref_count() instead
of using is_refcount_suitable().

Link: https://lkml.kernel.org/r/20250526182818.37978-1-shivankg@amd.com
Fixes: 05c5323b2a34 ("mm: track mapcount of large folios in single value")
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: syzbot+2b99589e33edbe9475ca@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6828470d.a70a0220.38f255.000c.GAE@google.com
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Fengwei Yin <fengwei.yin@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference
+++ a/mm/khugepaged.c
@@ -2293,6 +2293,17 @@ static int hpage_collapse_scan_file(stru
 			continue;
 		}
 
+		if (!folio_try_get(folio)) {
+			xas_reset(&xas);
+			continue;
+		}
+
+		if (unlikely(folio != xas_reload(&xas))) {
+			folio_put(folio);
+			xas_reset(&xas);
+			continue;
+		}
+
 		if (folio_order(folio) == HPAGE_PMD_ORDER &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
@@ -2303,23 +2314,27 @@ static int hpage_collapse_scan_file(stru
 			 * it's safe to skip LRU and refcount checks before
 			 * returning.
 			 */
+			folio_put(folio);
 			break;
 		}
 
 		node = folio_nid(folio);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			folio_put(folio);
 			break;
 		}
 		cc->node_load[node]++;
 
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
+			folio_put(folio);
 			break;
 		}
 
-		if (!is_refcount_suitable(folio)) {
+		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
+			folio_put(folio);
 			break;
 		}
 
@@ -2331,6 +2346,7 @@ static int hpage_collapse_scan_file(stru
 		 */
 
 		present += folio_nr_pages(folio);
+		folio_put(folio);
 
 		if (need_resched()) {
 			xas_pause(&xas);
_

Patches currently in -mm which might be from shivankg@amd.com are


