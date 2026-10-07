Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9566A547041
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334183; cv=none; b=f/O839Di+RIn5NbhAJG6c7qZrac8OpFG0BULwCGA8LHBUQEIkpS+O7+GO+nbvMf0vQsEOR/8MDGFe+GOD1WxbmbQ5GE/dMCQX5KAfuNtzOiPT5vr1FwxzaskxgskpJcYDawt9d7reJbuiH1s5knnhHnei2ecqggz3Fq1ia6+X7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334183; c=relaxed/simple;
	bh=j0UeXvGFD2jvdFkK5nsQXlPM/p2qLELrStqDOU73Mfo=;
	h=Date:To:From:Subject:Message-Id; b=iJAWzl8/uDNAaKTBVEEYyzpVvWXzLaF6rUOM1v+YyM11owmSHnoZVYgKpjtieLkRfpR097r23yPAmr34sYu4VueJN8Hrn+85AFoQIfEUDrh/3bcPHI1zDZpZu6GlSlxP/auhlZISLba4S6HRu/PC8f1UjFYqyTRC9qPuKpuWtDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HBadA0ar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HBadA0ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBF31F0089D;
	Wed,  7 Oct 2026 00:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334181;
	bh=mlg0lqHWcciF26N/IU+gBHq/IKXYVJsE1MMoq36tnss=;
	h=Date:To:From:Subject;
	b=HBadA0arCmfB5M4t7qn8rjbO7JJeX2FoKdLusiQ2RLOdgUQFKRjE/0xV0mhR1EtlI
	 e/U8oLDLngcei00uyzTbbSBrL6SCoAPvacE8MPRsb85+XKl9K+cuOHSri9pm1ff/aN
	 ck6PvXPfuA7ELYOMcHLscPl6yRU92ON3qyZ6J75g=
Date: Tue, 06 Oct 2026 17:49:40 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,linmiaohe@huawei.com,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch removed from -mm tree
Message-Id: <20261007004941.2BBF31F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: warn instead of silently bailing gigantic pages without runtime support
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/hugetlb: warn instead of silently bailing gigantic pages without runtime support
Date: Sun, 23 Aug 2026 12:40:52 +0800

remove_hugetlb_folio() and __update_and_free_hugetlb_folio() silently
return for gigantic hstates that lack runtime freeing support.  All
callers should already filter such hstates upstream, so turn the silent
bail into a VM_WARN_ON_ONCE to catch caller regressions instead of masking
them.

Link: https://lore.kernel.org/20260823044118.1097121-3-xialonglong2025@163.com
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Assisted-by: Codex:gpt-5.6-sol
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
---

 mm/hugetlb.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support
+++ a/mm/hugetlb.c
@@ -1396,8 +1396,11 @@ void remove_hugetlb_folio(struct hstate
 	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
-	if (hstate_is_gigantic_no_runtime(h))
+	if (hstate_is_gigantic_no_runtime(h)) {
+		/* Callers must filter gigantic_no_runtime upstream. */
+		VM_WARN_ON_ONCE(1);
 		return;
+	}
 
 	list_del(&folio->lru);
 
@@ -1458,8 +1461,11 @@ static void __update_and_free_hugetlb_fo
 {
 	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
-	if (hstate_is_gigantic_no_runtime(h))
+	if (hstate_is_gigantic_no_runtime(h)) {
+		/* Callers must filter gigantic_no_runtime upstream. */
+		VM_WARN_ON_ONCE(1);
 		return;
+	}
 
 	/*
 	 * If we don't know which subpages are hwpoisoned, we can't free
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch
mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

