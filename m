Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6931A3C2774
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439116; cv=none; b=dXnV1UzfsecnMbTI1B+DrOrXMs5tuOrGq9ABSMm42uutpsneKTzCrFZlbhZrO32ciaMyPtcaZJE9pTG5h68BWlOM4bZoP+yjGEsHhkzFOv/g//DXkdCJD2vzlT3zVWytOMDtTsJLCdXqLLqnUsV/pnzhw4MADSNCrMrm91wDhi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439116; c=relaxed/simple;
	bh=Z4yRuHO1lnYycAhDKjzsvsB/Y+NeKPsWB/DvKf/M208=;
	h=Date:To:From:Subject:Message-Id; b=kli/Kumg/QbU40XveaLkbTHk9RfD5QEL31jkDck/biXBMyUcGS3psw/G6Iy54HJzwCmH6VJy+fzsharf1GDwqbIuypD9o5e6zl1rwbvsUXJHZ7gh8iwttfVooVyhZagSjhJstcZ4vOCrV5qK8IcF21ZY+abMcdZ5zTgDC82wSRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2qpp23pD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2qpp23pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AE81F00893;
	Tue,  2 Jun 2026 22:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439115;
	bh=+WCpUH7tOfJXl3th1BQgmP95iPaKhvp5bW3XSfiM3cw=;
	h=Date:To:From:Subject;
	b=2qpp23pDmcxFlBkkCVcjjWegX7LK6iS/DKDFtR8x3YZyc/Fp0AZMWPTk23MkOx8mS
	 lkLri8kXxXwnCt1xycc7keQDZ30JgFZuiWoxuyIRtqjsJ3fUw1yKS7nDC4zGHLmoWB
	 XhnFhnsaanfkxYjSjgAbJPaB/roPE55/qvvRYGrw=
Date: Tue, 02 Jun 2026 15:25:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch removed from -mm tree
Message-Id: <20260602222514.E4AE81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
Date: Mon, 18 May 2026 16:41:13 -0700

The next commit will need to find the memcg id from the user-passed path
to the memory cgroup, from sysfs.c.  memcg_path_to_id() is doing that, but
defined in sysfs-schemes.c as a static function.  Move the function to
sysfs-common.c and mark it as non-static, so that the next commit can
reuse the function.

Link: https://lore.kernel.org/20260518234119.97569-26-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.c  |   41 +++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs-common.h  |    2 +
 mm/damon/sysfs-schemes.c |   41 -------------------------------------
 3 files changed, 43 insertions(+), 41 deletions(-)

--- a/mm/damon/sysfs-common.c~mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common
+++ a/mm/damon/sysfs-common.c
@@ -104,3 +104,44 @@ const struct kobj_type damon_sysfs_ul_ra
 	.default_groups = damon_sysfs_ul_range_groups,
 };
 
+
+static bool damon_sysfs_memcg_path_eq(struct mem_cgroup *memcg,
+		char *memcg_path_buf, char *path)
+{
+#ifdef CONFIG_MEMCG
+	cgroup_path(memcg->css.cgroup, memcg_path_buf, PATH_MAX);
+	if (sysfs_streq(memcg_path_buf, path))
+		return true;
+#endif /* CONFIG_MEMCG */
+	return false;
+}
+
+int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
+{
+	struct mem_cgroup *memcg;
+	char *path;
+	bool found = false;
+
+	if (!memcg_path)
+		return -EINVAL;
+
+	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
+			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
+		/* skip offlined memcg */
+		if (!mem_cgroup_online(memcg))
+			continue;
+		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
+			*id = mem_cgroup_id(memcg);
+			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
+			break;
+		}
+	}
+
+	kfree(path);
+	return found ? 0 : -EINVAL;
+}
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common
+++ a/mm/damon/sysfs-common.h
@@ -59,3 +59,5 @@ int damos_sysfs_set_quota_scores(struct
 void damos_sysfs_update_effective_quotas(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common
+++ a/mm/damon/sysfs-schemes.c
@@ -2791,47 +2791,6 @@ const struct kobj_type damon_sysfs_schem
 	.default_groups = damon_sysfs_schemes_groups,
 };
 
-static bool damon_sysfs_memcg_path_eq(struct mem_cgroup *memcg,
-		char *memcg_path_buf, char *path)
-{
-#ifdef CONFIG_MEMCG
-	cgroup_path(memcg->css.cgroup, memcg_path_buf, PATH_MAX);
-	if (sysfs_streq(memcg_path_buf, path))
-		return true;
-#endif /* CONFIG_MEMCG */
-	return false;
-}
-
-static int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
-{
-	struct mem_cgroup *memcg;
-	char *path;
-	bool found = false;
-
-	if (!memcg_path)
-		return -EINVAL;
-
-	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
-	if (!path)
-		return -ENOMEM;
-
-	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
-			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
-		/* skip offlined memcg */
-		if (!mem_cgroup_online(memcg))
-			continue;
-		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
-			*id = mem_cgroup_id(memcg);
-			found = true;
-			mem_cgroup_iter_break(NULL, memcg);
-			break;
-		}
-	}
-
-	kfree(path);
-	return found ? 0 : -EINVAL;
-}
-
 static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		struct damon_sysfs_scheme_filters *sysfs_filters)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

