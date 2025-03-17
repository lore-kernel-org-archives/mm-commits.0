Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC06215043
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188171; cv=none; b=GdEJsjSB+/FsgNvLVFtthLbn+dkrouWSldCPJLvhFzwkGn5lk+XmwyoKd/Rgr/8oteGgLD+yifco4uWLgaXuIxcZF5KX1bMhyrceLfW7Q7fA5d407D/nu8EfNGouPaJuqjsPsZoyZHI70ZnN8xNOAC4O6yC50X44nGzXWdAFYvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188171; c=relaxed/simple;
	bh=77oNmSEfzsHfaqqfSX/niJ8eOjFa0fI1RUzcWI8CrSY=;
	h=Date:To:From:Subject:Message-Id; b=O6h0HDf9Cjmtq8Jxk2y9oRxF4erLvG0n/34x+Xbl2Su38jqnZ0hfK9Fqod8BNvD4LGx1vEdXbOzv6LMqGIgu8o3x/eZ2I9d/WfQiKtYQvgZWTrh4qgvQPnBP7xd1R4wBzjHeyQ8rcgCNpgAQMwMdgo2Q0c0o6+Rn4PucSN+esYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hvOoTFRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hvOoTFRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D9DC4CEEC;
	Mon, 17 Mar 2025 05:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188171;
	bh=77oNmSEfzsHfaqqfSX/niJ8eOjFa0fI1RUzcWI8CrSY=;
	h=Date:To:From:Subject:From;
	b=hvOoTFReTcO0ppBtRVumpoevbgMq09NIs46xJDGGPkPOS77pyCVdP1cTVR079WvLP
	 wIJIPFLikAqb6CCQnK/Q88uzwfXsAnTZsLnAr3YPI+QuidYGTePFUYpJSD+5IXZxIy
	 aBEMntdepb0aZiFveu385BYWx1sDv8t7gZ2kQiJI=
Date: Sun, 16 Mar 2025 22:09:31 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,wangweiyang2@huawei.com,vbabka@suse.cz,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-factor-out-the-replace_stock_objcg-function.patch removed from -mm tree
Message-Id: <20250317050931.90D9DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: factor out the replace_stock_objcg function
has been removed from the -mm tree.  Its filename was
     memcg-factor-out-the-replace_stock_objcg-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: factor out the replace_stock_objcg function
Date: Fri, 24 Jan 2025 07:35:13 +0000

Factor out the 'replace_stock_objcg' function to make the code more
cohesive.

Link: https://lkml.kernel.org/r/20250124073514.2375622-4-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Finkel <davidf@vimeo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-factor-out-the-replace_stock_objcg-function
+++ a/mm/memcontrol.c
@@ -2700,6 +2700,20 @@ void __memcg_kmem_uncharge_page(struct p
 	obj_cgroup_put(objcg);
 }
 
+/* Replace the stock objcg with objcg, return the old objcg */
+static struct obj_cgroup *replace_stock_objcg(struct memcg_stock_pcp *stock,
+					     struct obj_cgroup *objcg)
+{
+	struct obj_cgroup *old = NULL;
+
+	old = drain_obj_stock(stock);
+	obj_cgroup_get(objcg);
+	stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
+	WRITE_ONCE(stock->cached_objcg, objcg);
+	return old;
+}
+
 static void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 		     enum node_stat_item idx, int nr)
 {
@@ -2717,11 +2731,7 @@ static void mod_objcg_state(struct obj_c
 	 * changes.
 	 */
 	if (READ_ONCE(stock->cached_objcg) != objcg) {
-		old = drain_obj_stock(stock);
-		obj_cgroup_get(objcg);
-		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
-				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
-		WRITE_ONCE(stock->cached_objcg, objcg);
+		old = replace_stock_objcg(stock, objcg);
 		stock->cached_pgdat = pgdat;
 	} else if (stock->cached_pgdat != pgdat) {
 		/* Flush the existing cached vmstat data */
@@ -2875,11 +2885,7 @@ static void refill_obj_stock(struct obj_
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
-		old = drain_obj_stock(stock);
-		obj_cgroup_get(objcg);
-		WRITE_ONCE(stock->cached_objcg, objcg);
-		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
-				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
+		old = replace_stock_objcg(stock, objcg);
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
 	}
 	stock->nr_bytes += nr_bytes;
_

Patches currently in -mm which might be from chenridong@huawei.com are


