Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87692BE057
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 20:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481926; cv=none; b=dNGOnCfQ75DsqBwDIgdDxsl2uvrDdtEn7MTsMb0vtmAAgbUi97fuCifbXaoz8cSyKXEP6DnY/HeyWzrGkhMnEOKMq46H0F8EIqKpVmlFZKoW1sfAtcoadyweJLLe2rEo9P/vcz1GLhFQiriMn6LiZ6j4OdGB6tixbfZDvh/DPHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481926; c=relaxed/simple;
	bh=ohWK+pRhpzZknFxqin9nV4xX8gy9xCepdgzQNZZza4o=;
	h=Date:To:From:Subject:Message-Id; b=FrCPa5agdnT27FtXydo3tmWGpOkSFq607XTbiJiruM8haky/zmprWNDfPgh0tnaxaA5UgpgmdhONv527a5aq72kgxdT2y3pVe+cBvKaoOxu5mmLXx9jOtp12xp9oGTzOcHekI60wMvf0RDAIFK74plLIlZ7F7TRArcvpJxPq2BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1wtZ6IKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1wtZ6IKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5721C19423;
	Mon,  2 Mar 2026 20:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772481925;
	bh=ohWK+pRhpzZknFxqin9nV4xX8gy9xCepdgzQNZZza4o=;
	h=Date:To:From:Subject:From;
	b=1wtZ6IKI+Rlj/HEtCLm0iabzW0ClhPV9JYqRBDfZfLNWMBET0m5Kmh4PJDn09/jOi
	 Phn0AJGKlLU4NuS7VqT+DkDiyJIL04cj7Q19g+kU9oKQHfWMROToRnGk/6tITOPJrh
	 rfpu0i8WA+fslivowqMOz48NPc5w2SEAqbv9455I=
Date: Mon, 02 Mar 2026 12:05:25 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jweiner@meta.com,hao.li@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-split-out-__obj_cgroup_charge.patch added to mm-new branch
Message-Id: <20260302200525.B5721C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: split out __obj_cgroup_charge()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-split-out-__obj_cgroup_charge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-split-out-__obj_cgroup_charge.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: split out __obj_cgroup_charge()
Date: Mon, 2 Mar 2026 14:50:16 -0500

Move the page charge and remainder calculation into its own function.  It
will make the slab stat refactor easier to follow.

Link: https://lkml.kernel.org/r/20260302195305.620713-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Johannes Weiner <jweiner@meta.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-split-out-__obj_cgroup_charge
+++ a/mm/memcontrol.c
@@ -3414,10 +3414,24 @@ out:
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 }
 
+static int __obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp,
+			       size_t size, size_t *remainder)
+{
+	size_t charge_size;
+	int ret;
+
+	charge_size = PAGE_ALIGN(size);
+	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
+	if (!ret)
+		*remainder = charge_size - size;
+
+	return ret;
+}
+
 static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
 				     struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	size_t charge_size, remainder;
+	size_t remainder;
 	int ret;
 
 	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
@@ -3446,10 +3460,7 @@ static int obj_cgroup_charge_account(str
 	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
 	 * race.
 	 */
-	charge_size = PAGE_ALIGN(size);
-	remainder = charge_size - size;
-
-	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
+	ret = __obj_cgroup_charge(objcg, gfp, size, &remainder);
 	if (!ret && (remainder || pgdat))
 		refill_obj_stock(objcg, remainder, false, size, pgdat, idx);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmalloc-streamline-vmalloc-memory-accounting.patch
mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch
mm-memcontrol-split-out-__obj_cgroup_charge.patch
mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch
mm-memcg-separate-slab-stat-accounting-from-objcg-charge-cache.patch

