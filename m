Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944211B6CE3
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 23:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738019344; cv=none; b=st+lYJUUiQdNc5uG+uHKHLHTTaxteHAWnjYj+ywKIDlYIMPnTrdn4EE/QzDmiJq3OcAN7nNe3LIYWt5qnaT8GU32IT1/2FTgJvjH7HKNZ3tIB0Npv3jbqgVO5hVQl807EeMwOIJlfbahVTS5oTSu3dp0U6zIOl4uVEFDsZo4Lq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738019344; c=relaxed/simple;
	bh=GNp7NoaIMsfzKZrfGJcyWLZN4fpD+y9GJnuCafoq5vo=;
	h=Date:To:From:Subject:Message-Id; b=Ov0YpsrR8ukheo8BEwv/1dnbuB0Xe2ETbJT0RAer8qynV2yyG7SppKkPB1u8J/qm4HKEr7jABox7L/fmiXx5yr9rfH1KVE+pK8LdQT3gxvJEK/LCGxS6h31dVGoFU8ngnPa3ILEG+cTAYIK2xwqnkHxIbI0f/4t7FBbllXf2QI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f2Al8hGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f2Al8hGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CE6C4CED2;
	Mon, 27 Jan 2025 23:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738019344;
	bh=GNp7NoaIMsfzKZrfGJcyWLZN4fpD+y9GJnuCafoq5vo=;
	h=Date:To:From:Subject:From;
	b=f2Al8hGm7Ta74gtSumHAsXMu0Y4c/dw8ZYDx5jXOpLlacHHm9xHLEsfSGkU8qmQX5
	 bxwSCemhluZKNUKBSoNCF0sZNFO21kJ2xxObhcsaKZpPv/HvaKJFLPpLgtMyEbL+VC
	 ciKSzkLpyDM7ZwhN5cXiXrdtiuMolKUKtsa+ntnE=
Date: Mon, 27 Jan 2025 15:09:03 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,wangweiyang2@huawei.com,vbabka@suse.cz,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-factor-out-the-replace_stock_objcg-function.patch added to mm-unstable branch
Message-Id: <20250127230903.F0CE6C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: factor out the replace_stock_objcg function
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-factor-out-the-replace_stock_objcg-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-factor-out-the-replace_stock_objcg-function.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -2691,6 +2691,20 @@ void __memcg_kmem_uncharge_page(struct p
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
@@ -2708,11 +2722,7 @@ static void mod_objcg_state(struct obj_c
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
@@ -2866,11 +2876,7 @@ static void refill_obj_stock(struct obj_
 
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

memcg-use-ofp_peak_unset-instead-of-1.patch
memcg-call-the-free-function-when-allocation-of-pn-fails.patch
memcg-factor-out-the-replace_stock_objcg-function.patch
memcg-add-config_memcg_v1-for-local-functions.patch

