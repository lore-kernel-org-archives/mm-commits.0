Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7477041687C
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525587; cv=none; b=Y8dYptpDeOtyMUQ6XuL3hcVrQX2jLpjtsXdXzycb2xFbWQte1BNW/0CzW7cCA2mHiSMHD+JL5YGSnE7zYV0pdrXjOFeXCwTBf9uJD9fugEg5fQ1r3DRrUDjZAbBOZ8JRTqcMy0aSne/uxw1bCjuGiTu7wvF71YvJY7olkW4ZY8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525587; c=relaxed/simple;
	bh=o8wEX+PEpyHNTFudNCEg4tjZ3QiZXH/YXi7fAx9cPbU=;
	h=Date:To:From:Subject:Message-Id; b=tpR10YVgcto8DSDsZk6jhgWQSebqL90BLpLb+d597yUTyPH3mon4Ecv+b5SeFOd4uiCq+5KKcng+7z+3Y9948hUJSd60MafnxEOKGlxxhE6TOwkjjgEfzAflBXQLr/bqAdGu6TxsPnIi52zhL80yBjwQU39ZpuEHeoTgPj+061k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CTfcVbc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CTfcVbc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482731F00899;
	Fri,  9 Oct 2026 05:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525583;
	bh=NoCX30CjQCSTT2ExfNffSQBixnLqaAsOFhMQvkeYIGk=;
	h=Date:To:From:Subject;
	b=CTfcVbc0wC7vLkQQWnA3INLgU2eFrPR4hP+kjOpwGkozg/BuhIENDW3WOSi5KGfmh
	 csKKW3EeaqOKK1clp1jV6jb4OKbxRmFXTOFDaS2qkomWE2MsCltMw2W+xTEa3IMnZu
	 Mc1Zsu30BPmJseuzeWudhOxhnIYwwq5+5wUVjYgc=
Date: Thu, 08 Oct 2026 22:59:42 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,trondmy@kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,jack@suse.cz,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,anna@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] treewide-remove-folio_set-clear_private-usage.patch removed from -mm tree
Message-Id: <20261009055943.482731F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: treewide: remove folio_set/clear_private() usage
has been removed from the -mm tree.  Its filename was
     treewide-remove-folio_set-clear_private-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: treewide: remove folio_set/clear_private() usage
Date: Sun, 20 Sep 2026 22:28:07 -0400

They are no-ops now. Remove them.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-11-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
---

 fs/nfs/write.c          |    2 --
 include/linux/pagemap.h |    4 +---
 mm/migrate.c            |    1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

--- a/fs/nfs/write.c~treewide-remove-folio_set-clear_private-usage
+++ a/fs/nfs/write.c
@@ -717,7 +717,6 @@ static void nfs_inode_add_request(struct
 	nfs_lock_request(req);
 	spin_lock(&mapping->i_private_lock);
 	set_bit(PG_MAPPED, &req->wb_flags);
-	folio_set_private(folio);
 	folio->private = req;
 	spin_unlock(&mapping->i_private_lock);
 	atomic_long_inc(&nfsi->nrequests);
@@ -745,7 +744,6 @@ static void nfs_inode_remove_request(str
 
 			spin_lock(&mapping->i_private_lock);
 			folio->private = NULL;
-			folio_clear_private(folio);
 			clear_bit(PG_MAPPED, &req->wb_head->wb_flags);
 			spin_unlock(&mapping->i_private_lock);
 
--- a/include/linux/pagemap.h~treewide-remove-folio_set-clear_private-usage
+++ a/include/linux/pagemap.h
@@ -594,7 +594,6 @@ static inline void folio_attach_private(
 {
 	folio_get(folio);
 	folio->private = data;
-	folio_set_private(folio);
 }
 
 /**
@@ -629,9 +628,8 @@ static inline void *folio_detach_private
 {
 	void *data = folio_get_private(folio);
 
-	if (!folio_test_private(folio))
+	if (!data)
 		return NULL;
-	folio_clear_private(folio);
 	folio->private = NULL;
 	folio_put(folio);
 
--- a/mm/migrate.c~treewide-remove-folio_set-clear_private-usage
+++ a/mm/migrate.c
@@ -835,7 +835,6 @@ void folio_migrate_flags(struct folio *n
 	 */
 	if (folio_test_swapcache(folio))
 		folio_clear_swapcache(folio);
-	folio_clear_private(folio);
 
 	/* page->private contains hugetlb specific flags */
 	if (!folio_test_hugetlb(folio))
_

Patches currently in -mm which might be from ziy@nvidia.com are


