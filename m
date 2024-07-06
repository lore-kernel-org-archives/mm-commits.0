Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BE213C3F7;
	Sat,  6 Jul 2024 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291232; cv=none; b=sY5jD+CQWjj9XNWsISrkebpYZdQy/0p28Znw+z5mSEHkun22WIVEfKR10nBwYT9ya2lhWTIZ9yui5ubFOziAL8hkxamsW7Z2bi3Gkt2Yclft12tR4NnKkO9LN+6dubdaxJ0GXBA8+EEVlnE0ybhshyW9rwpDhet0lMKNSt8XTa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291232; c=relaxed/simple;
	bh=sKt3vhMUd9BYUOdVkgyHSBTI5hZxLYsxopnn93nMvss=;
	h=Date:To:From:Subject:Message-Id; b=sxJVXMuaf5A326Vok43HwbQK84Sly7dbeOkJCmd3SmGO7LGDUVyuTM3Gi9rOlRHMHy6fmLW897GhYj75mo3FKwjw8RsakSsV7wZFeX9YXNrp2zhslO43juiz3VMGEhxS4wppSwAM4Us0fhoFhtWVja/xHo66x4yQeDc0p20jpfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+rK6vIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+rK6vIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0692C4AF0D;
	Sat,  6 Jul 2024 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291231;
	bh=sKt3vhMUd9BYUOdVkgyHSBTI5hZxLYsxopnn93nMvss=;
	h=Date:To:From:Subject:From;
	b=C+rK6vIun4ZTUwYuv0KN7WMg/7UoIvsxMgzvD1ue5LaJC+8vJWm6F+Er/OJuPdVaM
	 xjqeyORyXqvrGMY1phT64ftaz3GMCquNDknn4vlxTfL4RTYOhrlw48qL15JjfubSeT
	 H2NXIbT3iseH6723UK8xhjWAIGZ+2EnW7pnqgBkE=
Date: Sat, 06 Jul 2024 11:40:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,shy828301@gmail.com,nphamcs@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-crashes-from-deferred-split-racing-folio-migration.patch removed from -mm tree
Message-Id: <20240706184031.B0692C4AF0D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix crashes from deferred split racing folio migration
has been removed from the -mm tree.  Its filename was
     mm-fix-crashes-from-deferred-split-racing-folio-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix crashes from deferred split racing folio migration
Date: Tue, 2 Jul 2024 00:40:55 -0700 (PDT)

Even on 6.10-rc6, I've been seeing elusive "Bad page state"s (often on
flags when freeing, yet the flags shown are not bad: PG_locked had been
set and cleared??), and VM_BUG_ON_PAGE(page_ref_count(page) == 0)s from
deferred_split_scan()'s folio_put(), and a variety of other BUG and WARN
symptoms implying double free by deferred split and large folio migration.

6.7 commit 9bcef5973e31 ("mm: memcg: fix split queue list crash when large
folio migration") was right to fix the memcg-dependent locking broken in
85ce2c517ade ("memcontrol: only transfer the memcg data for migration"),
but missed a subtlety of deferred_split_scan(): it moves folios to its own
local list to work on them without split_queue_lock, during which time
folio->_deferred_list is not empty, but even the "right" lock does nothing
to secure the folio and the list it is on.

Fortunately, deferred_split_scan() is careful to use folio_try_get(): so
folio_migrate_mapping() can avoid the race by folio_undo_large_rmappable()
while the old folio's reference count is temporarily frozen to 0 - adding
such a freeze in the !mapping case too (originally, folio lock and
unmapping and no swap cache left an anon folio unreachable, so no freezing
was needed there: but the deferred split queue offers a way to reach it).

Link: https://lkml.kernel.org/r/29c83d1a-11ca-b6c9-f92e-6ccb322af510@google.com
Fixes: 9bcef5973e31 ("mm: memcg: fix split queue list crash when large folio migration")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 -----------
 mm/migrate.c    |   13 +++++++++++++
 2 files changed, 13 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-fix-crashes-from-deferred-split-racing-folio-migration
+++ a/mm/memcontrol.c
@@ -7823,17 +7823,6 @@ void mem_cgroup_migrate(struct folio *ol
 
 	/* Transfer the charge and the css ref */
 	commit_charge(new, memcg);
-	/*
-	 * If the old folio is a large folio and is in the split queue, it needs
-	 * to be removed from the split queue now, in case getting an incorrect
-	 * split queue in destroy_large_folio() after the memcg of the old folio
-	 * is cleared.
-	 *
-	 * In addition, the old folio is about to be freed after migration, so
-	 * removing from the split queue a bit earlier seems reasonable.
-	 */
-	if (folio_test_large(old) && folio_test_large_rmappable(old))
-		folio_undo_large_rmappable(old);
 	old->memcg_data = 0;
 }
 
--- a/mm/migrate.c~mm-fix-crashes-from-deferred-split-racing-folio-migration
+++ a/mm/migrate.c
@@ -415,6 +415,15 @@ int folio_migrate_mapping(struct address
 		if (folio_ref_count(folio) != expected_count)
 			return -EAGAIN;
 
+		/* Take off deferred split queue while frozen and memcg set */
+		if (folio_test_large(folio) &&
+		    folio_test_large_rmappable(folio)) {
+			if (!folio_ref_freeze(folio, expected_count))
+				return -EAGAIN;
+			folio_undo_large_rmappable(folio);
+			folio_ref_unfreeze(folio, expected_count);
+		}
+
 		/* No turning back from here */
 		newfolio->index = folio->index;
 		newfolio->mapping = folio->mapping;
@@ -433,6 +442,10 @@ int folio_migrate_mapping(struct address
 		return -EAGAIN;
 	}
 
+	/* Take off deferred split queue while frozen and memcg set */
+	if (folio_test_large(folio) && folio_test_large_rmappable(folio))
+		folio_undo_large_rmappable(folio);
+
 	/*
 	 * Now we know that no one else is looking at the folio:
 	 * no turning back from here.
_

Patches currently in -mm which might be from hughd@google.com are


