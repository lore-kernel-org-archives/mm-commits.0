Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E2417E4
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738889969; cv=none; b=o2ejsb2c3aYfAwlT5eOrZmjsR1PEXJD6TsxN3stn0+jmqIF2e/nmkPMt+viiq+QuUgoPgCrFHKCV1Af+X53MpxYoWMNo1to3Gv/2Ifn76sf8YTuBFMf3Pkwp5si+PKrzvrD0OO+iuuKpY0V2zvJoUbn6W/H/kW2OrAA2AisNd80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738889969; c=relaxed/simple;
	bh=+LIQFfqdPWEWx6DWvth4fZUGDn5ihAq7ckbHNTiJ+b8=;
	h=Date:To:From:Subject:Message-Id; b=c37tuc8BPAcgFK2kCgCSNaBSR2wpO9n4jsnPcF5VqYliLCvZf+Mn6cS/dBURtHPGefj2+BzffP7GgZsL3NAyd6KUoIfqElqq2p4Izo+KfMPKsAF2VAGC1wi6dV2mIFQWotD/JFjEkt5XRW4d0OTc4sIjuOxBh/xwBV9hFERLonU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gtT2jEtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gtT2jEtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E22FC4CEDD;
	Fri,  7 Feb 2025 00:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738889969;
	bh=+LIQFfqdPWEWx6DWvth4fZUGDn5ihAq7ckbHNTiJ+b8=;
	h=Date:To:From:Subject:From;
	b=gtT2jEtOCSyfGWQr+ejaisoP2zENhHsjaYw0ITX3Y3xvEuqehwwBZ0aPrNrdUvFgI
	 lNA1iLJ40qhfdrwG1Eviysb9sNJU7zfbS7MPmKNOAR5VadW4Vb2+WpYlZM4o60+ym0
	 ivkeJSGDXpXRLpS/hwZ73np5gYUKtljsrJmq62cs=
Date: Thu, 06 Feb 2025 16:59:28 -0800
To: mm-commits@vger.kernel.org,tjmercier@google.com,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,balbirs@nvidia.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-add-hierarchical-effective-limits-for-v2.patch added to mm-unstable branch
Message-Id: <20250207005929.3E22FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: add hierarchical effective limits for v2
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-add-hierarchical-effective-limits-for-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-add-hierarchical-effective-limits-for-v2.patch

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
@@ -4161,6 +4161,17 @@ static int memory_max_show(struct seq_fi
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
@@ -4439,6 +4450,11 @@ static struct cftype memory_files[] = {
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
@@ -5117,6 +5133,17 @@ static int swap_max_show(struct seq_file
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
@@ -5167,6 +5194,11 @@ static struct cftype swap_files[] = {
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
@@ -5308,6 +5340,17 @@ static int zswap_max_show(struct seq_fil
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
@@ -5363,6 +5406,11 @@ static struct cftype zswap_files[] = {
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

memcg-add-hierarchical-effective-limits-for-v2.patch

