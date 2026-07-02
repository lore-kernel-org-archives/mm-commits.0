Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A8E431E5B
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951343; cv=none; b=iZFwYJvyDGQzg1HWc3dLQmiXzLp7OV97jdSfLFHRgBHMh6PsMc292l/0/8YsiXKZDuZeNP07UauYB1otpQY3m/1faYpYG/iSokGG1rXM6Js3lfXCqgluKg2SFOElA1zlvLPu86FZdN3/PCumaw0vMQein5J2bLvsMZMxk01yEj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951343; c=relaxed/simple;
	bh=T2ppi+m8+ps6t5mvVqBElCnyAzF8rS4euEH6EgGr1y8=;
	h=Date:To:From:Subject:Message-Id; b=D7vWb54lne1VrdYiqi8K2dRovKNSzEDyzB5lkXSgH2iBHmKMJqKz5wsDUSq2c1WikLWYXri71cQuTmbkvzly6q837mAqBeJq61yFPQcuKuV9dX2t32Yd4t3388zdluO5aHkFrxz0BUgHMbB//jfPkdaUdihwxSTn2RRgJlfMAew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ainSGnN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ainSGnN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6461F000E9;
	Thu,  2 Jul 2026 00:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782951342;
	bh=1vDJ9VObBnvANcyO/CQC1FCAHb0Uv1yJqs6Vo4YnMiQ=;
	h=Date:To:From:Subject;
	b=ainSGnN5uM23sK0mIKlLmj6ElUYgE0oOr0vOs2JFbBPEz4y66ncCUzrbofjqPdtAp
	 qnjI3s9ai3cAb7ZIQaPSOFrtrFj7yx5pByVFZnR/NYJJ1GJN3Tfqp7FnfPMjj81le0
	 xx0VlMioIXsdYCF15nl5gQs3xbuXrQ2KxfX3F1ws=
Date: Wed, 01 Jul 2026 17:15:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,jic23@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-use-migrate_info-field-instead-of-private.patch added to mm-unstable branch
Message-Id: <20260702001542.4F6461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: use migrate_info field instead of private
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-use-migrate_info-field-instead-of-private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-use-migrate_info-field-instead-of-private.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/migrate: use migrate_info field instead of private
Date: Wed, 1 Jul 2026 05:17:22 +0000

Add an unsigned long migrate_info member to the struct folio union and use
it to store migration state (anon_vma pointer and FOLIO_WAS_* markers)
instead of using folio->private.  While at it, switch to bitwise OR.

No functional change.

Link: https://lore.kernel.org/20260701-migrate-cleanups-prep-v2-3-d9e8f17130b1@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
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

 include/linux/mm_types.h |    1 +
 mm/migrate.c             |   14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/mm_types.h~mm-migrate-use-migrate_info-field-instead-of-private
+++ a/include/linux/mm_types.h
@@ -427,6 +427,7 @@ struct folio {
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

mm-migrate-rename-page-to-folio-leftovers.patch
mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment.patch
mm-migrate-use-migrate_info-field-instead-of-private.patch

