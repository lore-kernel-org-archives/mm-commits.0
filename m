Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429721EB3D
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473443; cv=none; b=AytLKD/P6QsFJ14Sa/ZxJSG9ApW15U17F8ByzfIQUGWOB5tQZ50zkozcJR1tSK6htwifGc3mGrPvsC7Od1wuwqDL0koKhRowBRt4y9uiMyGSsUTH04uYNiVpIphMnHglSPpkzpv+orwwKI9xSr+UA/DoyPeFfP+X5myo0lN9kgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473443; c=relaxed/simple;
	bh=86zD52HMH/TxG620xXkzUGOtQf/vWZBrbqPJ2+durk8=;
	h=Date:To:From:Subject:Message-Id; b=u7EDGfirpuOgjll7xMBZFrKG4/zTj8panJ/eeO3MS2mxuvH15twn6ihd6NyOk1JsyxdCZ2/rPN6BIVB4Zx6KVWq4q06m8hNIFdRw0JuMCgNdUwcNtFKmJs0YaFU+e+4cYgpyl1t/vYSWa0Ziqfd6ZbzBP4uv4Iu6J5v3R9wJTxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fUKiCcEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fUKiCcEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C8BC116B1;
	Sat, 15 Jun 2024 17:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473442;
	bh=86zD52HMH/TxG620xXkzUGOtQf/vWZBrbqPJ2+durk8=;
	h=Date:To:From:Subject:From;
	b=fUKiCcELfeAv9IzsZny50Jc8EcZrSgN8wcwCjSC3LvX2TCl3Kru5K8uWyr55wbave
	 TBMIKLgJmkW5YUV9tDOMIQO6BdVZuhlcoqByqDuvpqQGgfv1pAR/NblWXPc2tBi3l1
	 Z1rR9Mjy7H59O0InbR8yW4R9OY4dk5MPvKtNgYRk=
Date: Sat, 15 Jun 2024 10:44:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-kernel-bug-at-mm-compactionc-2761.patch removed from -mm tree
Message-Id: <20240615174402.C4C8BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: fix kernel BUG at mm/compaction.c:2761!
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-kernel-bug-at-mm-compactionc-2761.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/migrate: fix kernel BUG at mm/compaction.c:2761!
Date: Tue, 11 Jun 2024 22:06:20 -0700 (PDT)

I hit the VM_BUG_ON(!list_empty(&cc->migratepages)) in compact_zone(); and
if DEBUG_VM were off, then pages would be lost on a local list.

Our convention is that if migrate_pages() reports complete success (0),
then the migratepages list will be empty; but if it reports an error or
some pages remaining, then its caller must putback_movable_pages().

There's a new case in which migrate_pages() has been reporting complete
success, but returning with pages left on the migratepages list: when
migrate_pages_batch() successfully split a folio on the deferred list, but
then the "Failure isn't counted" call does not dispose of them all.

Since that block is expecting the large folio to have been counted as 1
failure already, and since the return code is later adjusted to success
whenever the returned list is found empty, the simple way to fix this
safely is to count splitting the deferred folio as "a failure".

Link: https://lkml.kernel.org/r/46c948b4-4dd8-6e03-4c7b-ce4e81cfa536@google.com
Fixes: 7262f208ca68 ("mm/migrate: split source folio if it is on deferred split list")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-kernel-bug-at-mm-compactionc-2761
+++ a/mm/migrate.c
@@ -1654,7 +1654,12 @@ static int migrate_pages_batch(struct li
 
 			/*
 			 * The rare folio on the deferred split list should
-			 * be split now. It should not count as a failure.
+			 * be split now. It should not count as a failure:
+			 * but increment nr_failed because, without doing so,
+			 * migrate_pages() may report success with (split but
+			 * unmigrated) pages still on its fromlist; whereas it
+			 * always reports success when its fromlist is empty.
+			 *
 			 * Only check it without removing it from the list.
 			 * Since the folio can be on deferred_split_scan()
 			 * local list and removing it can cause the local list
@@ -1669,6 +1674,7 @@ static int migrate_pages_batch(struct li
 			if (nr_pages > 2 &&
 			   !list_empty(&folio->_deferred_list)) {
 				if (try_split_folio(folio, split_folios) == 0) {
+					nr_failed++;
 					stats->nr_thp_split += is_thp;
 					stats->nr_split++;
 					continue;
_

Patches currently in -mm which might be from hughd@google.com are

mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix.patch

