Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1652A39A7E0;
	Thu, 10 Sep 2026 03:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012660; cv=none; b=QtMc7llEAV2p3xWvXGDswqcqCPMRTesZyozKuGB8887kazlP+kp39/GEJq3L1NPTG47zTRRQK919YAGpGP7nCFEPW1RAP6T7mfqMZkfO78vERAyfCPKbb4sktyxa7WMrBRFo9zjVm4TVuO9OuuBtXm5NBUrC2pU3cC10TvZ8gUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012660; c=relaxed/simple;
	bh=VIrWUHku6ui3gtsmefTmPVc8guP1UO2eiK90Q7panxc=;
	h=Date:To:From:Subject:Message-Id; b=mPtBRkZ3sUyu10fHJR92IrK8yJrwEXBML+9myZeIaxYJHFv/Sz//VrIjnTaDElQfTCvlHqBeQgush1uml9DqJtwzvMonteRrRql59GWI+8Uga6atvMj/qOJcfGWVq3V42VUlPHdItIH2hBUt+jm2H0GsRTR2Wwgdklfc5f7tHpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1+4J50vt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1+4J50vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7C71F00898;
	Thu, 10 Sep 2026 03:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789012656;
	bh=pV9cA6KK0HbPx3nh+oORMhPzbXXZ/gJsrZQ+Ymj2kSc=;
	h=Date:To:From:Subject;
	b=1+4J50vtTghXs2WBzEHFfL7intfJXoPJk4XvivlXGHVT0Fw/nCdrZO7XFddcH2+/W
	 n4w3sH7+oBGAm+ASpDdvh0evJV+pmy7b6oHHv+UpykRR5Dua9je5q4q6GdGgqqOLxa
	 BMGkX1MKHgN2axtvN+nxhlWf5IiWiDsigAli1qdw=
Date: Wed, 09 Sep 2026 20:57:35 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch added to mm-new branch
Message-Id: <20260910035736.2E7C71F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: publish the initial pool with list_add_rcu()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch

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
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/zswap: publish the initial pool with list_add_rcu()
Date: Tue, 8 Sep 2026 09:28:01 +0800

zswap_setup() publishes the pool on the zswap_pools list with a plain
list_add(), but the list is walked by concurrent RCU readers holding
nothing but rcu_read_lock() through zswap_total_pages(), e.g. 
/proc/meminfo and the shrinker count path.

    CPU 0 (writer)                          CPU 1 (reader)
    --------------                          --------------
    zswap_pool_create():
      pool->zs_pool = zs_create_pool(); (1)
    list_add() -> __list_add():
      WRITE_ONCE(zswap_pools.next,
          &pool->list);                (2)   zswap_total_pages():
                                                pool = READ_ONCE(     (a)
                                                    zswap_pools.next);
                                                zs_get_total_pages(   (b)
                                                    pool->zs_pool);

If (2) becomes visible to CPU 1 before (1), CPU 1 finds the pool at (a)
but dereferences a wild pointer at (b).  Publish the node with
list_add_rcu().

Link: https://lore.kernel.org/20260908012801.1864430-1-xialonglong2025@163.com
Fixes: 91cdcd8d624bf ("mm: zswap: optimize zswap pool size tracking")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Assisted-by: Zcode:GLM-5.3
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260906133601.3563324-1-xialonglong2025%40163.com
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-publish-the-initial-pool-with-list_add_rcu
+++ a/mm/zswap.c
@@ -1818,7 +1818,7 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add(&pool->list, &zswap_pools);
+		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
 	} else {
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch
mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch
mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch
mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch
mm-zswap-enable-static-key-after-runtime-pool-recovery.patch
mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch

