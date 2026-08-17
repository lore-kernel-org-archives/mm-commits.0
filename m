Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1ED3EDE56;
	Mon, 17 Aug 2026 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786988396; cv=none; b=jQrkCX4WgYGV4gnxgwrvy13OzDktjSf4GGsAiJ6AZ2hH0bv8pebwMVBs+Qt23Uk8AL5vgnf3B30Q0ccsBPBGPy3ZNYpINWt+W4jURJHPgFwhf2JkSRaCbaNH0utD3wh6+/IClriW5UxsWZev7pMa/B4VymzPMKFxUAJV9BuZ43g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786988396; c=relaxed/simple;
	bh=2T5hZS+acnYJei3onSPKaMoghg+2/HwCbfoFBnCL6pg=;
	h=Date:To:From:Subject:Message-Id; b=spEYpOhB6yOsegHPFxwuSkHQkmzufsIWmfPb4yoVCclR9CdhAJaiYu+76J8l2/r/iaO6CljrijsQYf/Vw8NA9ozituA0wXuVioM1AIe/CocEuoLrT1RRf36Ew+CJNGQXfOpmL2nR74qQCKnpknoLiDHC+o542a7HQ3CJfVFzN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GPDcx6Ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GPDcx6Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DD01F000E9;
	Mon, 17 Aug 2026 17:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786988395;
	bh=GDs9i7t6c6qitcypguUc+yWYAOD4eHwPMEwxiWBMlGM=;
	h=Date:To:From:Subject;
	b=GPDcx6IpnGEavCtGFbcvsHEm1WzMA561R3hsvXrHmePoGC/RGRkQOdAltDko9mCwG
	 jXWAzsO2dFC+GNKKlFx545a3fhXHgTB0+CiyT2hm7KHV7n6p8TobP5+UzdJmcxyk9G
	 7BFSwkVKP46++dORMGnMuvH1I47ndir0HyhbCw1U=
Date: Mon, 17 Aug 2026 10:39:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,njilav@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-call-page_counter_set_max-outside-vm_bug_on.patch added to mm-hotfixes-unstable branch
Message-Id: <20260817173955.12DD01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_cgroup-call-page_counter_set_max-outside-vm_bug_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-call-page_counter_set_max-outside-vm_bug_on.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Narek Jilavyan <njilav@gmail.com>
Subject: mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()
Date: Mon, 17 Aug 2026 10:34:33 +0000

hugetlb_cgroup_css_alloc() rounds the counter limit down to a multiple of
the huge page size and then applies it inside an assertion:

	VM_BUG_ON(page_counter_set_max(fault, limit));
	VM_BUG_ON(page_counter_set_max(rsvd, limit));

With CONFIG_DEBUG_VM=n, VM_BUG_ON(cond) is BUILD_BUG_ON_INVALID(cond),
i.e.  ((void)(sizeof((__force long)(cond)))), whose operand is never
evaluated.  page_counter_set_max() is not a predicate - it performs
xchg(&counter->max, nr_pages) - so on every non-debug kernel the limit is
never applied and the counters keep page_counter_init()'s
PAGE_COUNTER_MAX.

That is user-visible, because hugetlb_cgroup_read_u64_max() recomputes the
same rounded value and uses equality as its "unlimited" sentinel. 
PAGE_COUNTER_MAX is LONG_MAX / PAGE_SIZE = 2251799813685247, which is odd,
so round_down() really does change it and the two sides disagree.  With
CONFIG_DEBUG_VM=n:

	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
	9223372036854771712

and with this patch:

	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
	max

A debug option should not change cgroup output.

Call the function, then assert the result, as v6.12 did.  Use
VM_WARN_ON_ONCE() rather than restoring VM_BUG_ON(): the two are identical
under CONFIG_DEBUG_VM=n, and checkpatch asks that new code not use BUG()
variants.

Link: https://lore.kernel.org/20260817103433.191266-1-njilav@gmail.com
Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Narek Jilavyan <njilav@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-call-page_counter_set_max-outside-vm_bug_on
+++ a/mm/hugetlb_cgroup.c
@@ -97,6 +97,7 @@ static void hugetlb_cgroup_init(struct h
 		struct page_counter *fault, *fault_parent = NULL;
 		struct page_counter *rsvd, *rsvd_parent = NULL;
 		unsigned long limit;
+		int ret;
 
 		if (parent_h_cgroup) {
 			fault_parent = hugetlb_cgroup_counter_from_cgroup(
@@ -118,8 +119,10 @@ static void hugetlb_cgroup_init(struct h
 		limit = round_down(PAGE_COUNTER_MAX,
 				   pages_per_huge_page(&hstates[idx]));
 
-		VM_BUG_ON(page_counter_set_max(fault, limit));
-		VM_BUG_ON(page_counter_set_max(rsvd, limit));
+		ret = page_counter_set_max(fault, limit);
+		VM_WARN_ON_ONCE(ret);
+		ret = page_counter_set_max(rsvd, limit);
+		VM_WARN_ON_ONCE(ret);
 	}
 }
 
_

Patches currently in -mm which might be from njilav@gmail.com are

mm-hugetlb_cgroup-call-page_counter_set_max-outside-vm_bug_on.patch

