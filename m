Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244F815E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628291; cv=none; b=M9VI2ZO28Cjte9ZDd4tNj2sEac6GXCwO3+lKiG7ju8Da2ymM0S2gaEWOIpOkivDiwl2le3UMH8Igb02n+7SJ5uEiCsxmBT87BB8RENMx7mUuj6St3y96ph9BzWhtUS7w0+XSMwfkQuwluyNZNvGUmSwxjZoJYFA/f3JIwFuwZOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628291; c=relaxed/simple;
	bh=lq0wt8ctwVunkI/Ee/DuUgieLiWGeGp4Y0A4jfkWUXQ=;
	h=Date:To:From:Subject:Message-Id; b=jS58zY9Fav1C+pqlx2aYiz19qLUWj8jaDjepNh9zWzfXSEOFhGSMcF+I0tAisjMQ6O/TpIrgaj1+fpzao4ZgtftwP1OhEGh6YZFACDqF1eqt/u3sPSAl2Xpmdtow385sjy06OcJxrJOiSBZwgfzshi1r53UbtyOJEYHpC9BV12E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i+BUAdsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i+BUAdsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF119C32789;
	Sat, 29 Jun 2024 02:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628291;
	bh=lq0wt8ctwVunkI/Ee/DuUgieLiWGeGp4Y0A4jfkWUXQ=;
	h=Date:To:From:Subject:From;
	b=i+BUAdsXjWfM67KHGCW878zOmZOo5QL4RrkRhnXZ42OBrfpTdEDXtV/N66pI2sqr5
	 CQsTzo8Iw0IvCOMumXv1lO5OMb3+aATNfx7Grj6SdFgavXNxkc04rDHOgrO5U9pRgm
	 HYZnocOv08KZhBP92OS3QGQQRuRsrWbLAGZ+bAGM=
Date: Fri, 28 Jun 2024 19:31:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,donettom@linux.ibm.com,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch removed from -mm tree
Message-Id: <20240629023130.EF119C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: make migrate_misplaced_folio() return 0 on success
has been removed from the -mm tree.  Its filename was
     mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: make migrate_misplaced_folio() return 0 on success
Date: Thu, 20 Jun 2024 23:29:34 +0200

Patch series "mm/migrate: move NUMA hinting fault folio isolation + checks
under PTL".


Let's just return 0 on success, which is less confusing.

...  especially because we got it wrong in the migrate.h stub where we
have "return -EAGAIN; /* can't migrate now */" instead of "return 0;". 
Likely this wrong return value doesn't currently matter, but it certainly
adds confusion.

We'll add migrate_misplaced_folio_prepare() next, where we want to use the
same "return 0 on success" approach, so let's just clean this up.

Link: https://lkml.kernel.org/r/20240620212935.656243-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240620212935.656243-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++---
 mm/memory.c      |    2 +-
 mm/migrate.c     |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-migrate-make-migrate_misplaced_folio-return-0-on-success
+++ a/mm/huge_memory.c
@@ -1653,7 +1653,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	int nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid = (-1 & LAST_CPUPID_MASK);
-	bool migrated = false, writable = false;
+	bool writable = false;
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -1697,8 +1697,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	spin_unlock(vmf->ptl);
 	writable = false;
 
-	migrated = migrate_misplaced_folio(folio, vma, target_nid);
-	if (migrated) {
+	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATED;
 		nid = target_nid;
 	} else {
--- a/mm/memory.c~mm-migrate-make-migrate_misplaced_folio-return-0-on-success
+++ a/mm/memory.c
@@ -5357,7 +5357,7 @@ static vm_fault_t do_numa_page(struct vm
 	ignore_writable = true;
 
 	/* Migrate to the requested node */
-	if (migrate_misplaced_folio(folio, vma, target_nid)) {
+	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		nid = target_nid;
 		flags |= TNF_MIGRATED;
 	} else {
--- a/mm/migrate.c~mm-migrate-make-migrate_misplaced_folio-return-0-on-success
+++ a/mm/migrate.c
@@ -2618,11 +2618,11 @@ int migrate_misplaced_folio(struct folio
 					    nr_succeeded);
 	}
 	BUG_ON(!list_empty(&migratepages));
-	return isolated;
+	return isolated ? 0 : -EAGAIN;
 
 out:
 	folio_put(folio);
-	return 0;
+	return -EAGAIN;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
_

Patches currently in -mm which might be from david@redhat.com are


