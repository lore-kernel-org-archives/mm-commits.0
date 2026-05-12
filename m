Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906733A543F
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625288; cv=none; b=eILub4NynJ3cxirOJQumMOk8+3tAqGpZt+9zsRNbvelX/aoVnGQ2gvmjvno6viGnS6iVTCOOAv1DgsKaE7oVpCvbTufVryrxtPw5E/36wbwX/cd6K94pxwHMec0rghHyUBoy3jTXJlKwzL0eC+JP5qPS91obftPGMPebDec896A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625288; c=relaxed/simple;
	bh=Za5LNmzhQyW3rKo6hYvlWy983G9FTQLmo9CsjQQcvu0=;
	h=Date:To:From:Subject:Message-Id; b=FpPJGRlLXXdg2MErVYQSBrEvO2PO7PR9QGnGgOncdWQsSmScTuPSqXJzJhaDZ6+C5QRbDvDLDLvnph6ZcIhCXlKaxrkD5njIiyntVAd5tEOlUbr6jUqxRAoV/IJ0hrZ4kdUvb6mLR81wi8F0gU2mrnzL3gNG0KhN+TiTAxLQ65s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AcLEE62O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AcLEE62O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100E7C2BCF5;
	Tue, 12 May 2026 22:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778625288;
	bh=Za5LNmzhQyW3rKo6hYvlWy983G9FTQLmo9CsjQQcvu0=;
	h=Date:To:From:Subject:From;
	b=AcLEE62OdVragms3WXJiLNjV+ltsa6fBL+GuDv5tFKD4iZMUoIYtuKoE3pByo3lSX
	 +0c5zUyuQjYP5iT4XYzhGqIl2a3SRF4abm4Qiod3aYA/IPe3Q0X0NmgNJvtbpDcHXa
	 LjVJnu11KaJwFQ1w3DDdaBlpTDRl3SVKbVkZ7F4U=
Date: Tue, 12 May 2026 15:34:47 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,david@fromorbit.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch added to mm-new branch
Message-Id: <20260512223448.100E7C2BCF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shrinker: avoid out-of-bounds read in set_shrinker_bit()
has been added to the -mm mm-new branch.  Its filename is
     mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: David Carlier <devnexen@gmail.com>
Subject: mm/shrinker: avoid out-of-bounds read in set_shrinker_bit()
Date: Sun, 10 May 2026 19:37:00 +0100

set_shrinker_bit() reads info->unit[shrinker_id_to_index(shrinker_id)]
before checking shrinker_id against info->map_nr_max, so an id past the
currently visible map_nr_max reads past the unit[] array before the
WARN_ON_ONCE() catches it.

Determined from code inspection.

Move the load into the bounded branch.

Link: https://lore.kernel.org/20260510183700.102475-1-devnexen@gmail.com
Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/shrinker.c~mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit
+++ a/mm/shrinker.c
@@ -197,12 +197,13 @@ void set_shrinker_bit(struct mem_cgroup
 {
 	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
 		struct shrinker_info *info;
-		struct shrinker_info_unit *unit;
 
 		rcu_read_lock();
 		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-		unit = info->unit[shrinker_id_to_index(shrinker_id)];
 		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
+			struct shrinker_info_unit *unit;
+
+			unit = info->unit[shrinker_id_to_index(shrinker_id)];
 			/* Pairs with smp mb in shrink_slab() */
 			smp_mb__before_atomic();
 			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-rename-swap_iocb-fields-for-clarity.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch
mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch

