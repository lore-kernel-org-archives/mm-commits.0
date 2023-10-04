Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E974E8FDC7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 04:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbjJDESw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 00:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjJDESv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 00:18:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F685AC;
        Tue,  3 Oct 2023 21:18:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC14C433C8;
        Wed,  4 Oct 2023 04:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696393127;
        bh=qZnzZ4PXfpPs0GJWARceB4MrgMqmP339To6CaTBHxa8=;
        h=Date:To:From:Subject:From;
        b=m2NxfSzw33uEHyPVcGy/Ww4/TTbQF6+To0aKZ4sJYoUrRDR28MVfkWhKbIzi6N+At
         LarYfvzahbhFNTX+KvpKk2PlljEGkcmOw5GHfg9tJEVspzN6T14uuHKfov/jljEK3i
         5gqFzvU1YVSJFVzhluv6JE2Lhdg7noQiI9/q4hH4=
Date:   Tue, 03 Oct 2023 21:18:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, muchun.song@linux.dev,
        mike.kravetz@oracle.com, riel@surriel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-extend-hugetlb_vma_lock-to-private-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20231004041847.2DC14C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: extend hugetlb_vma_lock to private VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlbfs-extend-hugetlb_vma_lock-to-private-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-extend-hugetlb_vma_lock-to-private-vmas.patch

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
From: Rik van Riel <riel@surriel.com>
Subject: hugetlbfs: extend hugetlb_vma_lock to private VMAs
Date: Tue, 3 Oct 2023 23:25:03 -0400

Extend the locking scheme used to protect shared hugetlb mappings from
truncate vs page fault races, in order to protect private hugetlb mappings
(with resv_map) against MADV_DONTNEED.

Add a read-write semaphore to the resv_map data structure, and use that
from the hugetlb_vma_(un)lock_* functions, in preparation for closing the
race between MADV_DONTNEED and page faults.

Link: https://lkml.kernel.org/r/20231004032814.3108383-2-riel@surriel.com
Fixes: 04ada095dcfc ("hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++++
 mm/hugetlb.c            |   41 ++++++++++++++++++++++++++++++++++----
 2 files changed, 43 insertions(+), 4 deletions(-)

--- a/include/linux/hugetlb.h~hugetlbfs-extend-hugetlb_vma_lock-to-private-vmas
+++ a/include/linux/hugetlb.h
@@ -60,6 +60,7 @@ struct resv_map {
 	long adds_in_progress;
 	struct list_head region_cache;
 	long region_cache_count;
+	struct rw_semaphore rw_sema;
 #ifdef CONFIG_CGROUP_HUGETLB
 	/*
 	 * On private mappings, the counter to uncharge reservations is stored
@@ -1246,6 +1247,11 @@ static inline bool __vma_shareable_lock(
 	return (vma->vm_flags & VM_MAYSHARE) && vma->vm_private_data;
 }
 
+static inline bool __vma_private_lock(struct vm_area_struct *vma)
+{
+	return (!(vma->vm_flags & VM_MAYSHARE)) && vma->vm_private_data;
+}
+
 /*
  * Safe version of huge_pte_offset() to check the locks.  See comments
  * above huge_pte_offset().
--- a/mm/hugetlb.c~hugetlbfs-extend-hugetlb_vma_lock-to-private-vmas
+++ a/mm/hugetlb.c
@@ -97,6 +97,7 @@ static void hugetlb_vma_lock_alloc(struc
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end);
+static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -267,6 +268,10 @@ void hugetlb_vma_lock_read(struct vm_are
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		down_read(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		down_read(&resv_map->rw_sema);
 	}
 }
 
@@ -276,6 +281,10 @@ void hugetlb_vma_unlock_read(struct vm_a
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		up_read(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		up_read(&resv_map->rw_sema);
 	}
 }
 
@@ -285,6 +294,10 @@ void hugetlb_vma_lock_write(struct vm_ar
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		down_write(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		down_write(&resv_map->rw_sema);
 	}
 }
 
@@ -294,17 +307,27 @@ void hugetlb_vma_unlock_write(struct vm_
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		up_write(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		up_write(&resv_map->rw_sema);
 	}
 }
 
 int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
 {
-	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
-	if (!__vma_shareable_lock(vma))
-		return 1;
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
-	return down_write_trylock(&vma_lock->rw_sema);
+		return down_write_trylock(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		return down_write_trylock(&resv_map->rw_sema);
+	}
+
+	return 1;
 }
 
 void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
@@ -313,6 +336,10 @@ void hugetlb_vma_assert_locked(struct vm
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		lockdep_assert_held(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		lockdep_assert_held(&resv_map->rw_sema);
 	}
 }
 
@@ -345,6 +372,11 @@ static void __hugetlb_vma_unlock_write_f
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		__hugetlb_vma_unlock_write_put(vma_lock);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		/* no free for anon vmas, but still need to unlock */
+		up_write(&resv_map->rw_sema);
 	}
 }
 
@@ -1061,6 +1093,7 @@ struct resv_map *resv_map_alloc(void)
 	kref_init(&resv_map->refs);
 	spin_lock_init(&resv_map->lock);
 	INIT_LIST_HEAD(&resv_map->regions);
+	init_rwsem(&resv_map->rw_sema);
 
 	resv_map->adds_in_progress = 0;
 	/*
_

Patches currently in -mm which might be from riel@surriel.com are

hugetlbfs-extend-hugetlb_vma_lock-to-private-vmas.patch
hugetlbfs-close-race-between-madv_dontneed-and-page-fault.patch

