Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5289F3FC5B7
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525413; cv=none; b=j24fiDAeI5MNRFn8F2aYlKXZet6pvT26kjEtL8C+0xjXq0zNrxzyrAKj++aZKNJ4yv6fQgDbyHSnIFzsxaLQ4g4gW01ItSo5/+iArvjEwjsVbOl5R89FBoKCbPKybxPvo7cUbl7CqqPLRTQVmy6g0d+mLIuL7PUnpUafvYAnJx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525413; c=relaxed/simple;
	bh=hA/uF+0Zy9su9UZaNKOze3h395Ux2VFkbqXWc4l6J+0=;
	h=Date:To:From:Subject:Message-Id; b=NOBMiynh032fHDM7HBFRM42s6Kr6QV/vom6A+fIDHTCtwe1BXF+clJK2ytwOK4dD8Lh3yl+p+adg4jIvTcDzK8BrtXgbIF//X4JSlhXThRtIcdd4lJPXvDYpdCpdQkYLo5lT/vmC1TLobFrXSYYY3mSNpV7uR7zJxF19ewVJzdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JRpRgBrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JRpRgBrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A411F00893;
	Fri,  9 Oct 2026 05:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525412;
	bh=qXnPBf+TkqD64zlogyYaRtbOE7IdLjbBDBjS+zYAF6g=;
	h=Date:To:From:Subject;
	b=JRpRgBrljuyzATOQrAuyHqGtSrTnnncq9VahmaR3G6Dr/HWSxrD5URuunjJSP9tzz
	 y9ian0YUST0HNpScQiXUWHmXbi3b/2g4gPwSbZ0PaoB15NqlXuV3SUIHbLeujbolup
	 d0Xs3vYSbXU5kwsAVj9aVfQZVoij7qQCPErs79BE=
Date: Thu, 08 Oct 2026 22:56:51 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-split-mem_cgroup_private_id-into-two-fields.patch removed from -mm tree
Message-Id: <20261009055651.E6A411F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: split mem_cgroup_private_id into two fields
has been removed from the -mm tree.  Its filename was
     memcg-split-mem_cgroup_private_id-into-two-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: split mem_cgroup_private_id into two fields
Date: Fri, 4 Sep 2026 20:05:18 -0700

The two members of struct mem_cgroup_private_id have different access
patterns.  The id is read on every eviction and refault through
mem_cgroup_private_id(), and is only written when the memcg is created and
destroyed.  The ref is written on every swap charge and uncharge.

Split them into private_id and private_id_ref so a later patch can put
them into different cache line groups.  A struct member cannot be split
across two groups.

No functional change.

Link: https://lore.kernel.org/20260905030522.1887837-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/memcontrol.h |   10 +++-------
 mm/memcontrol.c            |   18 +++++++++---------
 2 files changed, 12 insertions(+), 16 deletions(-)

--- a/include/linux/memcontrol.h~memcg-split-mem_cgroup_private_id-into-two-fields
+++ a/include/linux/memcontrol.h
@@ -66,11 +66,6 @@ struct mem_cgroup_reclaim_cookie {
 
 #define MEM_CGROUP_ID_SHIFT	16
 
-struct mem_cgroup_private_id {
-	int id;
-	refcount_t ref;
-};
-
 struct memcg_vmstats_percpu;
 struct memcg1_events_percpu;
 struct memcg_vmstats;
@@ -189,7 +184,8 @@ struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	struct mem_cgroup_private_id id;
+	int private_id;
+	refcount_t private_id_ref;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -810,7 +806,7 @@ static inline unsigned short mem_cgroup_
 	if (mem_cgroup_disabled())
 		return 0;
 
-	return memcg->id.id;
+	return memcg->private_id;
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
--- a/mm/memcontrol.c~memcg-split-mem_cgroup_private_id-into-two-fields
+++ a/mm/memcontrol.c
@@ -3773,7 +3773,7 @@ static void memcg_online_kmem(struct mem
 
 	static_branch_enable(&memcg_kmem_online_key);
 
-	memcg->kmemcg_id = memcg->id.id;
+	memcg->kmemcg_id = memcg->private_id;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
@@ -4032,15 +4032,15 @@ static DEFINE_XARRAY_ALLOC1(mem_cgroup_p
 
 static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
-	if (memcg->id.id > 0) {
-		xa_erase(&mem_cgroup_private_ids, memcg->id.id);
-		memcg->id.id = 0;
+	if (memcg->private_id > 0) {
+		xa_erase(&mem_cgroup_private_ids, memcg->private_id);
+		memcg->private_id = 0;
 	}
 }
 
 static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
-	if (refcount_sub_and_test(n, &memcg->id.ref)) {
+	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
 		mem_cgroup_private_id_remove(memcg);
 
 		/* Memcg ID pins CSS */
@@ -4050,7 +4050,7 @@ static inline void mem_cgroup_private_id
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
-	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
+	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -4174,7 +4174,7 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id.id, NULL,
+	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
 		goto fail;
@@ -4320,7 +4320,7 @@ static int mem_cgroup_css_online(struct
 	lru_gen_online_memcg(memcg);
 
 	/* Online state pins memcg ID, memcg ID pins CSS */
-	refcount_set(&memcg->id.ref, 1);
+	refcount_set(&memcg->private_id_ref, 1);
 	css_get(css);
 
 	/*
@@ -4333,7 +4333,7 @@ static int mem_cgroup_css_online(struct
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, GFP_KERNEL);
 
 	return 0;
 free_objcg:
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


