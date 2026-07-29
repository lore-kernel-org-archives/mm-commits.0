Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E624390C8A
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298437; cv=none; b=qwYsvY/p52bRe3OFubuAidnn+N/l1jlK6kUKZ1tbtaNgfQK9iZ0Rm8Y0kv06sN7RobArTuq9poZRs0rbfdAiYQtz0oTd0mneSUaUKEjePRaIUB4ZaMYZPyuBITCiQtqYfiJdg5kSNkS7LPMSFamzY2ddZY8C4HDMvU9YKVCqjF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298437; c=relaxed/simple;
	bh=XBwuxvJrTropybKVllZSdL4lLXsZIHrvwUl2mnR8O3c=;
	h=Date:To:From:Subject:Message-Id; b=gP+bGWXecKtB0xcsdHOO7E7MBFVSfEoRbqBWz97zud1W30uimnajxYDintzCYn36CBXcjEWGUg6NnksnJqLh/prdleyMsGU4qDkuGOPhivw8udpo/OyO4iUVOITjCumod0zgOWiCjgyJnE77VEDBMFwmogu+RKT4E2IfV6V7KLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DNRDH5zp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DNRDH5zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1337D1F000E9;
	Wed, 29 Jul 2026 04:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298436;
	bh=TBqZH3Ashy18YpwVf+cti5juHavnl/jKAOo3WmPHs0A=;
	h=Date:To:From:Subject;
	b=DNRDH5zpIsJwW4QSfX2kA7QJ4HCexD12+D/kkS2L4dRg4caM9CuLQeQj+DUZ3dFfB
	 hyvswSBSvSVh6aOC4C/u/fQz8kGmnBlYMJcZWJO/9YxDNQwn0xnqOWLyl6fE8+zmOH
	 VfzE/3VaE8mlHkM0gZk8YQglFVMTvCD8RTqubNa0=
Date: Tue, 28 Jul 2026 21:13:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,jic23@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-use-migrate_info-field-instead-of-private.patch removed from -mm tree
Message-Id: <20260729041356.1337D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: use migrate_info field instead of private
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-migrate_info-field-instead-of-private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/migrate: use migrate_info field instead of private
Date: Wed, 1 Jul 2026 05:17:22 +0000

Add an unsigned long migrate_info member to the struct folio union and use
it to store migration state (anon_vma pointer and FOLIO_WAS_* markers)
instead of using folio->private.  While at it, switch to bitwise OR.

No functional change.

[rdunlap@infradead.org: add missing kernel-doc for @migrate_info]
  Link: https://lore.kernel.org/20260717022146.1290242-1-rdunlap@infradead.org
Link: https://lore.kernel.org/20260701-migrate-cleanups-prep-v2-3-d9e8f17130b1@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 +++
 mm/migrate.c             |   14 +++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/include/linux/mm_types.h~mm-migrate-use-migrate_info-field-instead-of-private
+++ a/include/linux/mm_types.h
@@ -368,6 +368,8 @@ typedef unsigned short mm_id_t;
  *    dax_associate_entry.
  * @private: Filesystem per-folio data (see folio_attach_private()).
  * @swap: Used for swp_entry_t if folio_test_swapcache().
+ * @migrate_info: Stores migration state (anon_vma pointer and
+ *    FOLIO_WAS_* markers).
  * @_mapcount: Do not access this member directly.  Use folio_mapcount() to
  *    find out how many times this folio is mapped by userspace.
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
@@ -427,6 +429,7 @@ struct folio {
 			union {
 				void *private;
 				swp_entry_t swap;
+				unsigned long migrate_info;
 			};
 			atomic_t _mapcount;
 			atomic_t _refcount;
--- a/mm/migrate.c~mm-migrate-use-migrate_info-field-instead-of-private
+++ a/mm/migrate.c
@@ -1130,7 +1130,7 @@ static int move_to_new_folio(struct foli
 }
 
 /*
- * To record some information during migration, we use unused private
+ * To record some information during migration, we use the migrate_info
  * field of struct folio of the newly allocated destination folio.
  * This is safe because nobody is using it except us.
  */
@@ -1143,17 +1143,17 @@ enum {
 static void __migrate_folio_record(struct folio *dst,
 		int old_folio_state, struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_folio_state;
+	dst->migrate_info = (unsigned long)anon_vma | old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 		int *old_folio_state, struct anon_vma **anon_vmap)
 {
-	unsigned long private = (unsigned long)dst->private;
+	unsigned long info = dst->migrate_info;
 
-	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
-	*old_folio_state = private & FOLIO_OLD_STATES;
-	dst->private = NULL;
+	*anon_vmap = (struct anon_vma *)(info & ~FOLIO_OLD_STATES);
+	*old_folio_state = info & FOLIO_OLD_STATES;
+	dst->migrate_info = 0;
 }
 
 /* Restore the source folio to the original state upon failure */
@@ -1214,7 +1214,7 @@ static int migrate_folio_unmap(new_folio
 		return -ENOMEM;
 	*dstp = dst;
 
-	dst->private = NULL;
+	dst->migrate_info = 0;
 
 	if (!folio_trylock(src)) {
 		if (mode == MIGRATE_ASYNC)
_

Patches currently in -mm which might be from shivankg@amd.com are


