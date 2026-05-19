Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722F43BB13D
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 20:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779222507; cv=none; b=brpQLsYSFSoQjpUUHpN1fzaVvrPFYJ1V0R1cIgmHuPUM2gEqQy6lcVN+FdDQNMRvBGzstrxBFDjW9qpJ5P5y9txvnfPO6dIRJWcCc5mZNFodHimFa6NC0LyzeRpPd7bnw8YMWRjWHbBcqCr7cKGrh5emkXAqrYUVod5x7/b14M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779222507; c=relaxed/simple;
	bh=3rYqydYlAP+oZn/FSc5y5lb3+Uuch9xJVYxgYTeQtLE=;
	h=Date:To:From:Subject:Message-Id; b=TEyLEZCMqblgsnMzXm6wdQqH6Ko1riergYfC3oc0AV5IEWR5lDxhmqcsn6Ew5eakuyiIskx/1Ye2CZLgSH37jzeeRolon99B/B2+8k89WI2zVEioN6brhab3znPY8rgluPNLXdT5Egf/JzREuuF688m0NGgxCoN+EsBNf/gnJ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t3MgE2N6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t3MgE2N6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA181F000E9;
	Tue, 19 May 2026 20:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779222506;
	bh=qUJzTW2qk8Wb7JV/CHjWtDPN6OEcz4UsGkpCRq5THuw=;
	h=Date:To:From:Subject;
	b=t3MgE2N6R5KCtINkC7PnQSOaS77gIHKKmZVeRt2/PYycGGSZtrZzMiX73gs/twPEC
	 LUjVDt1tR9UbD3xkvxTJFzEvYeKmLtdDJGoGKiDxDvpkf3mwDrsAqXzfs1xOstFONb
	 +jeFkWUbKPYBZ2SnkChrvOz91T86bi51DBTf1ZWk=
Date: Tue, 19 May 2026 13:28:25 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch added to mm-new branch
Message-Id: <20260519202826.0CA181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: use zone_pcp_disable() for poison handling
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/memory-failure: use zone_pcp_disable() for poison handling
Date: Thu, 14 May 2026 16:57:54 +0800

__page_handle_poison() used drain_all_pages() instead of
zone_pcp_disable() because dissolve_free_hugetlb_folio() could restore HVO
vmemmap pages and decrement hugetlb_optimize_vmemmap_key.  That static key
update took cpu_hotplug_lock through static_key_slow_dec(), while
zone_pcp_disable() holds pcp_batch_high_lock.  CPU hotplug takes the locks
in the opposite order through page_alloc_cpu_online/dead(), so the
combination could deadlock.

That dependency no longer exists.  Commit da3e2d1ca43d ("mm/hugetlb:
remove hugetlb_optimize_vmemmap_key static key") removed the HVO static
key and the static_branch_dec() from hugetlb_vmemmap_restore_folio().  The
dissolve_free_hugetlb_folio() path no longer reaches
static_key_slow_dec().

Use zone_pcp_disable() again while dissolving the hugetlb folio and taking
the target page off the buddy allocator.  This prevents the drained PCP
lists from being refilled before take_page_off_buddy() runs, making the
page isolation deterministic.

Link: https://lore.kernel.org/20260514085754.84097-1-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-zone_pcp_disable-for-poison-handling
+++ a/mm/memory-failure.c
@@ -172,23 +172,11 @@ static int __page_handle_poison(struct p
 {
 	int ret;
 
-	/*
-	 * zone_pcp_disable() can't be used here. It will
-	 * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() might hold
-	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
-	 * optimization is enabled. This will break current lock dependency
-	 * chain and leads to deadlock.
-	 * Disabling pcp before dissolving the page was a deterministic
-	 * approach because we made sure that those pages cannot end up in any
-	 * PCP list. Draining PCP lists expels those pages to the buddy system,
-	 * but nothing guarantees that those pages do not get back to a PCP
-	 * queue if we need to refill those.
-	 */
+	zone_pcp_disable(page_zone(page));
 	ret = dissolve_free_hugetlb_folio(page_folio(page));
-	if (!ret) {
-		drain_all_pages(page_zone(page));
+	if (!ret)
 		ret = take_page_off_buddy(page);
-	}
+	zone_pcp_enable(page_zone(page));
 
 	return ret;
 }
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-convert-vmemmap_pd_populate-to-static-functions.patch
mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch

