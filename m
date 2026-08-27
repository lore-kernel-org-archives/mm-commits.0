Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F89B377A86;
	Thu, 27 Aug 2026 20:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861303; cv=none; b=jqoT3bXWWNeWLv6jAISemLcY7RHJ6QQ+cN0PXjcVGLkMZwyWAZM7TI29ZhL5S3hsrjqVmiNxKmH/Ht4JwnhrMQAOuJLgidhTIMlGa5B1cJ53DqwsrFThNPIwkY2XouyMPL3f259twImIiMXtN5UHeQ0+yhfbwNBGrJzzlttUq+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861303; c=relaxed/simple;
	bh=SMQMAcH7e7NpdB9reBwsx13YT1spRUCxPlY2s3DF+PE=;
	h=Date:To:From:Subject:Message-Id; b=nv7WDuOGUjIh7wvbuXcKw1qoYymra7pGNnCZtgTK2HzFbhviaE9fPT3dkdXTEYaMBhzmeOcZ2JJnAbImFvHt2csKob5u035zWn2PRGWGGI+Eiti6dVlM1QJIJISOURJrDWPAoQ6cTsPZaFt04elDpENadc7cJIbGWlx/Okb/0K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZUfd6L/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZUfd6L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EA91F00A3D;
	Thu, 27 Aug 2026 20:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861300;
	bh=HMKBpqoRtZeeRCix5goKfBjbAdNN+sS+hzI/x0NtJ8Y=;
	h=Date:To:From:Subject;
	b=HZUfd6L/HBWpUyyiJzbWL9C+C5QiujxwDw7WZ0fk7iaqcAa6GThvAJToZ0GiZZyPD
	 WdpXSobbuGgUWZp6zj5YmbqkOciZXUlCc0HhtAeEpLEAM4nmZclSpj3pGgn6pVHhGy
	 8hgBgrM4cmVDxD45SaJwVILdJ2aJcPlRV592y/FE=
Date: Thu, 27 Aug 2026 13:08:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,njilav@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb_cgroup-call-page_counter_set_max-outside-vm_bug_on.patch removed from -mm tree
Message-Id: <20260827200820.B2EA91F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-call-page_counter_set_max-outside-vm_bug_on.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


