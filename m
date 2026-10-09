Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8483F58EA;
	Fri,  9 Oct 2026 05:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525487; cv=none; b=CrOLyUJ+M7I+o+yirhV2Br7+c+k42AdhRrop2fUrbwwltlic/WsruTg0UiNVZ1ro/CcsH1tQdcHDgYUEg5JN3WbG0hNhacYFWezFhdXqkvSt89GiyTpUBL3h8HhjGHHMS/X2nE0xKwJ28CxpWo+jfs4t33w6GjiPlioY7lEH8Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525487; c=relaxed/simple;
	bh=3czWyrRDMbOeYkZcwpU8EVXwZcwJekkwmB83ZrkRX1I=;
	h=Date:To:From:Subject:Message-Id; b=RpTER1fzvHfy8XbjQdbZHdfFUJSM3vz/BuG8g2AHBgzPVNrHictNBKXgVgo67B5X0a1wqL7ZBFRJOSkAV3MrFG7XRtsE90P8VtksJPP2krPnvxlOXHlFSjXpaxKeMMaZdq1Dj97UD31mEc/ue2HkCEjsNOssDpqYfGXnDDZ7lns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yBy3F7la; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yBy3F7la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415AC1F000FF;
	Fri,  9 Oct 2026 05:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525486;
	bh=lnieW/RwyWVD4E5ukmiSt5g6B1wfS1DEMiCUWMQaZ8c=;
	h=Date:To:From:Subject;
	b=yBy3F7laa0sWxxCtcBI9ftDIJ7qzO69iDuAgA7Oxu8vXfDGo5Jv9WwbVVjzMysw33
	 Vhse7Y+gh4GNX7krzPSiAh9/sll89WUfyxkMMGxdHSX7Og9Gd7WTqoNDcaPDZJYmFj
	 6eSjufPVzrz98XZJWrR915+I3CrzxkXD2yCBghfY=
Date: Thu, 08 Oct 2026 22:58:05 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch removed from -mm tree
Message-Id: <20261009055806.415AC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: publish the initial pool with list_add_rcu()
has been removed from the -mm tree.  Its filename was
     mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 91cdcd8d624b ("mm: zswap: optimize zswap pool size tracking")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260906133601.3563324-1-xialonglong2025%40163.com
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Assisted-by: Zcode:GLM-5.3
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-publish-the-initial-pool-with-list_add_rcu
+++ a/mm/zswap.c
@@ -1815,7 +1815,7 @@ static int zswap_setup(void)
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


