Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ECA38FA6
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 03:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742268997; cv=none; b=l+guNdZndTiYFLPzA1yM7Bz9oLyetYzRkCI5NnRJQCsyzpk9+ov6KAyA3zkqyKXOzCy1XhZZ40aJAQZeF6ZVum0Ca4hg3/ziW36U21KD28W80uW506s2DZ/I93Kcu7r26VfKaBgd7ZJ6/7q7Tu72CPE5YoiFYolsnTm3Xw1TAoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742268997; c=relaxed/simple;
	bh=HeKGppihLny4vseX35zn3jOI7P0Sa7hLaS1D8+UOC+A=;
	h=Date:To:From:Subject:Message-Id; b=Ify0T7louGmDlSq2DkhYSaOBGBTUbZT7MXwQWo5U3K8MyRnxRAkNrgdkzSETF9T4zI16SG0R6SPSwY9cT71CDB05nHvxpjWTyQksSvWl/ylFTaoyP/bhb1ghWPox9Ta9WEglDFwqhVRDMeRYJ9yX759vx8Y5a1JqYBsnicrFwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G5i1wtB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5i1wtB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DEAC4CEE3;
	Tue, 18 Mar 2025 03:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742268996;
	bh=HeKGppihLny4vseX35zn3jOI7P0Sa7hLaS1D8+UOC+A=;
	h=Date:To:From:Subject:From;
	b=G5i1wtB61Sv75lFrf3Sf2GqEi66lBaq7/3uWdeQiQrP/pF34TLKWIXFPDp0qcyfrT
	 J60gQKV77+ZjnTy05IHFA4tk1ZdujZ+CgBqhtn6m2tjbDJndzuBAaYT/8MGYo3dJWj
	 Mmmen96qA6RvXFuh3c4hsI4AkJjq4W+rssshEbRg=
Date: Mon, 17 Mar 2025 20:36:36 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,balbirs@nvidia.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-add-hierarchical-effective-limits-for-v2.patch removed from -mm tree
Message-Id: <20250318033636.C1DEAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: add hierarchical effective limits for v2
has been removed from the -mm tree.  Its filename was
     memcg-add-hierarchical-effective-limits-for-v2.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: add hierarchical effective limits for v2
Date: Wed, 5 Feb 2025 14:20:29 -0800

Memcg-v1 exposes hierarchical_[memory|memsw]_limit counters in its
memory.stat file which applications can use to get their effective limit
which is the minimum of limits of itself and all of its ancestors.  This
is pretty useful in environments where cgroup namespace is used and the
application does not have access to the full view of the cgroup hierarchy.
Let's expose effective limits for memcg v2 as well.

Link: https://lkml.kernel.org/r/20250205222029.2979048-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: "T.J. Mercier" <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   24 +++++++++++
 mm/memcontrol.c                         |   48 ++++++++++++++++++++++
 2 files changed, 72 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-add-hierarchical-effective-limits-for-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1311,6 +1311,14 @@ PAGE_SIZE multiple when read back.
 	Caller could retry them differently, return into userspace
 	as -ENOMEM or silently ignore in cases like disk readahead.
 
+  memory.max.effective
+	A read-only single value file which exists on non-root cgroups.
+
+        The effective limit of the cgroup i.e. the minimum memory.max
+        of all ancestors including itself. This is useful for environments
+        where cgroup namespace is being used and the application does not
+        have full view of the hierarchy.
+
   memory.reclaim
 	A write-only nested-keyed file which exists for all cgroups.
 
@@ -1726,6 +1734,14 @@ The following nested keys are defined.
 	Swap usage hard limit.  If a cgroup's swap usage reaches this
 	limit, anonymous memory of the cgroup will not be swapped out.
 
+  memory.swap.max.effective
+	A read-only single value file which exists on non-root cgroups.
+
+        The effective limit of the cgroup i.e. the minimum memory.swap.max
+        of all ancestors including itself. This is useful for environments
+        where cgroup namespace is being used and the application does not
+        have full view of the hierarchy.
+
   memory.swap.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
@@ -1766,6 +1782,14 @@ The following nested keys are defined.
 	limit, it will refuse to take any more stores before existing
 	entries fault back in or are written out to disk.
 
+  memory.zswap.max.effective
+	A read-only single value file which exists on non-root cgroups.
+
+        The effective limit of the cgroup i.e. the minimum memory.zswap.max
+        of all ancestors including itself. This is useful for environments
+        where cgroup namespace is being used and the application does not
+        have full view of the hierarchy.
+
   memory.zswap.writeback
 	A read-write single value file. The default value is "1".
 	Note that this setting is hierarchical, i.e. the writeback would be
--- a/mm/memcontrol.c~memcg-add-hierarchical-effective-limits-for-v2
+++ a/mm/memcontrol.c
@@ -4179,6 +4179,17 @@ static int memory_max_show(struct seq_fi
 		READ_ONCE(mem_cgroup_from_seq(m)->memory.max));
 }
 
+static int memory_max_effective_show(struct seq_file *m, void *v)
+{
+	unsigned long max = PAGE_COUNTER_MAX;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg))
+		max = min(max, READ_ONCE(memcg->memory.max));
+
+	return seq_puts_memcg_tunable(m, max);
+}
+
 static ssize_t memory_max_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off)
 {
@@ -4458,6 +4469,11 @@ static struct cftype memory_files[] = {
 		.write = memory_max_write,
 	},
 	{
+		.name = "max.effective",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_max_effective_show,
+	},
+	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.file_offset = offsetof(struct mem_cgroup, events_file),
@@ -5136,6 +5152,17 @@ static int swap_max_show(struct seq_file
 		READ_ONCE(mem_cgroup_from_seq(m)->swap.max));
 }
 
+static int swap_max_effective_show(struct seq_file *m, void *v)
+{
+	unsigned long max = PAGE_COUNTER_MAX;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg))
+		max = min(max, READ_ONCE(memcg->swap.max));
+
+	return seq_puts_memcg_tunable(m, max);
+}
+
 static ssize_t swap_max_write(struct kernfs_open_file *of,
 			      char *buf, size_t nbytes, loff_t off)
 {
@@ -5186,6 +5213,11 @@ static struct cftype swap_files[] = {
 		.write = swap_max_write,
 	},
 	{
+		.name = "swap.max.effective",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_max_effective_show,
+	},
+	{
 		.name = "swap.peak",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.open = peak_open,
@@ -5327,6 +5359,17 @@ static int zswap_max_show(struct seq_fil
 		READ_ONCE(mem_cgroup_from_seq(m)->zswap_max));
 }
 
+static int zswap_max_effective_show(struct seq_file *m, void *v)
+{
+	unsigned long max = PAGE_COUNTER_MAX;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg))
+		max = min(max, READ_ONCE(memcg->zswap_max));
+
+	return seq_puts_memcg_tunable(m, max);
+}
+
 static ssize_t zswap_max_write(struct kernfs_open_file *of,
 			       char *buf, size_t nbytes, loff_t off)
 {
@@ -5382,6 +5425,11 @@ static struct cftype zswap_files[] = {
 		.write = zswap_max_write,
 	},
 	{
+		.name = "zswap.max.effective",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = zswap_max_effective_show,
+	},
+	{
 		.name = "zswap.writeback",
 		.seq_show = zswap_writeback_show,
 		.write = zswap_writeback_write,
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-avoid-refill_stock-for-root-memcg.patch
memcg-move-do_memsw_account-to-config_memcg_v1.patch

