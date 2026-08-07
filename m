Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEED3A7F70
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068020; cv=none; b=E/YbeS/ToepuTKGhY5vipMJ02FzGT8z+a8GSJDFgbrGgiUsOXB6W8gwuSyNUO0ke5UN7bIGoD/CqjKiNKJq8snhpj3XYOUJJcuIiIk0nNcYVjgNOq1nZ8C72LI40XF0f0eK9fWea1U2iQtn84ep6NVTKcqKd0SqX3IQgHCSjNPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068020; c=relaxed/simple;
	bh=qB4ePUnvvJRxth6xD6lQcEfI/jEL3lC/Ed18VNo7kn0=;
	h=Date:To:From:Subject:Message-Id; b=a43/3mjsuP7XUJ3TU3LQeV8XS6m+GzoN8QMmA/JCiEb2cbvH5NiUt8akR1EYlrITZ0thdZ+dHXgFaVB/Ewnw9YJfPJfptarK++Yb139EDbdQ8V230cJBAb9Sh7g9NGgYumNdfqV84ALTItGWtC5zYmUn2l/mSxrhlB8kKcedXrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogY8Wi5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogY8Wi5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30991F00A3F;
	Fri,  7 Aug 2026 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068011;
	bh=HaeSyYKwPJeq+7qjHYsQ4mPicTPzqItADFWOhH32DZU=;
	h=Date:To:From:Subject;
	b=ogY8Wi5NMGHH6bQxsv7xSbF0wtcspOuLtyVTQtUnkAYWyHapb/A/CAAXLABp6KNUg
	 z69/wAw4v0i4iylUEGJrSQp+tG9kiOS4Z+jUh/Vqgf4eymsvYsOX3IlEh3jm74t+56
	 QRG+XFrXbkPmsQVfd1tMWLv+KxJ+mZCyoio3Fe+I=
Date: Thu, 06 Aug 2026 19:00:11 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch removed from -mm tree
Message-Id: <20260807020011.A30991F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: factor out memcg kmem uncharge sequence
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcontrol: factor out memcg kmem uncharge sequence
Date: Mon, 13 Jul 2026 17:03:04 +0800

The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
in obj_cgroup_release() and drain_obj_stock_slot().  Factor it into a
small memcg_uncharge_kmem() helper.  The reference get/put stays at the
call sites, as they differ.

No functional change.

Link: https://lore.kernel.org/20260713090304.3015329-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence
+++ a/mm/memcontrol.c
@@ -137,6 +137,14 @@ bool mem_cgroup_kmem_disabled(void)
 
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
+static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+	memcg1_account_kmem(memcg, -nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		memcg_uncharge(memcg, nr_pages);
+}
+
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
 	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
@@ -172,10 +180,7 @@ static void obj_cgroup_release(struct pe
 		struct mem_cgroup *memcg;
 
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
-		memcg1_account_kmem(memcg, -nr_pages);
-		if (!mem_cgroup_is_root(memcg))
-			memcg_uncharge(memcg, nr_pages);
+		memcg_uncharge_kmem(memcg, nr_pages);
 		mem_cgroup_put(memcg);
 	}
 
@@ -3329,10 +3334,7 @@ static void drain_obj_stock_slot(struct
 
 			memcg = get_mem_cgroup_from_objcg(old);
 
-			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
-			memcg1_account_kmem(memcg, -nr_pages);
-			if (!mem_cgroup_is_root(memcg))
-				memcg_uncharge(memcg, nr_pages);
+			memcg_uncharge_kmem(memcg, nr_pages);
 
 			css_put(&memcg->css);
 		}
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

