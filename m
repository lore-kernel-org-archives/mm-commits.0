Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EDB2C08DF
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489979; cv=none; b=rglYDnL0nUqMPPToNtaL1Gov/m2hAIEUiFVTEVuyvrd779zVQRsHbPhX8mLDLbKTSCEdDlt1Zyms+xlbUep3TSo9vMrNiBzFph14XNAHlOxpDyRzXuDlbo5muWxkfsN3dxOls7HZozItsuRs50Mr0rqDNZo6iz4ZxHRYtej2YfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489979; c=relaxed/simple;
	bh=R8qjOABkViLIsTLwJivr/XFEKjCMIc2CtpQjr3/SWx4=;
	h=Date:To:From:Subject:Message-Id; b=EyrCb/GK5Wzvyuu0/G1z52Do5fb/VwpYSH5AB/6m74muqR5D/FsSjs+TUNrHZGlYSCxJMGu/sAUkUNdtiOC8U9jHsm8/xuLxbvRAM3+Orei8iqeVCBpP2IOi3K4fB7KK2YS2kM4TYn5B/UlYH8Xh3+bobFadK+8bBglAetGlPd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhyQtXYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhyQtXYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074FDC4CEE7;
	Sun, 21 Sep 2025 21:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489979;
	bh=R8qjOABkViLIsTLwJivr/XFEKjCMIc2CtpQjr3/SWx4=;
	h=Date:To:From:Subject:From;
	b=XhyQtXYr/cbiE8kpSgc1IVhiXXpm6CQp3asjIB34ZQ7D9TF4FBdWURd+XQH5gqz00
	 ripl0cTZVuC4nE8Sqj8Vfz2Cny6XD2eZzW9cbp+S5SyeR/kqWYFLnzAH501+Ymi1rq
	 OqCWfkmnJLClMeuSNCzkONJ/eixJt7f+JD4TmhIg=
Date: Sun, 21 Sep 2025 14:26:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usamaarif642@gmail.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch removed from -mm tree
Message-Id: <20250921212619.074FDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: skip mlocked THPs that are underused early in deferred_split_scan()
has been removed from the -mm tree.  Its filename was
     mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm: skip mlocked THPs that are underused early in deferred_split_scan()
Date: Mon, 8 Sep 2025 17:07:41 +0800

When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
it does not make sense to try to detect whether it is underused, because
try_to_map_unused_to_zeropage(), called while splitting the folio, will
not actually replace any zeroed pages by the shared zeropage.

Splitting the folio in that case does not make any sense, so let's not
even scan to check if the folio is underused.

Link: https://lkml.kernel.org/r/20250908090741.61519-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/huge_memory.c~mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan
+++ a/mm/huge_memory.c
@@ -4175,6 +4175,13 @@ static unsigned long deferred_split_scan
 		bool underused = false;
 
 		if (!folio_test_partially_mapped(folio)) {
+			/*
+			 * See try_to_map_unused_to_zeropage(): we cannot
+			 * optimize zero-filled pages after splitting an
+			 * mlocked folio.
+			 */
+			if (folio_test_mlocked(folio))
+				goto next;
 			underused = thp_underused(folio);
 			if (!underused)
 				goto next;
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled.patch

