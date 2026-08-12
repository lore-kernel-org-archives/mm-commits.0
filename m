Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69621495051
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 22:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786575016; cv=none; b=FZTDQm/+Ps6guovGSHdfRCaaadUFOIgObx2T4DpByyHWI8U1joJIe2zvEo5oOPAlHYo6ELhkEe05u8ackR32oiHmEMzXzThhCoCQehSlUDJYP0MFdYY1BjVZAUhcwvGn8pxACaU96UQgABhXom7MocEEbF1m5kxsjjrc5ZO4IfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786575016; c=relaxed/simple;
	bh=oDZKV7xpZM4EYx77Gm2SES5lDl++gRyePLZ7j3ozo2g=;
	h=Date:To:From:Subject:Message-Id; b=ANZWrKpOyRc9UeH5bG1ApVDz9W1N0WistOo0Q3gd895zRr0BCt4crZ3ATyBA/8weZiIGSJ45aCfE5UezTrsXx72ypSokpK67ME64iXdnDtmP84ashYzN3mnBElvJcNFW3ArQKrIx4A2FXP3NkNbTIZYNk2A6ADpJl+Z6PumCQLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uiJE+yEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uiJE+yEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB421F000E9;
	Wed, 12 Aug 2026 22:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786575013;
	bh=+SvanphoUwOhIiM2nyPqYt3X/EoB9F04aQGRHoGSBR0=;
	h=Date:To:From:Subject;
	b=uiJE+yEBy8nfFIAyGDlt5B4JsiL8xRd7nr4KQsAyX37W7FCteLf6Eb2DmlXZAznIu
	 mJY8IfXLcuKy/kEJhn0RNmEzK6NURCwGNxqZfrD/+oBbDYG9ziAvXiFe9zK4ZBLSQi
	 MOSP8DD1CE4GvHuYpNYGXDlvsiKDxsPVZPrH6i3s=
Date: Wed, 12 Aug 2026 15:50:13 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-make-the-v1-soft-limit-knob-inert.patch added to mm-hotfixes-unstable branch
Message-Id: <20260812225013.CCB421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: make the v1 soft limit knob inert
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-make-the-v1-soft-limit-knob-inert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-make-the-v1-soft-limit-knob-inert.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: make the v1 soft limit knob inert
Date: Tue, 11 Aug 2026 13:31:55 -0700

The v1 soft limit has been deprecated since v6.12 and nobody has reported
depending on it.  Start the removal by decoupling the interface from the
implementation: keep memory.soft_limit_in_bytes, but ignore writes to it
and always report the maximum value on read similar to what
memory.kmem.limit_in_bytes already does.

Writes are still parsed, so malformed input keeps returning -EINVAL.  The
knob now also behaves the same everywhere: it used to return -EOPNOTSUPP
on PREEMPT_RT, where soft limit reclaim has always been disabled.

This also fixes the syzbot report linked below.  Soft limit reclaim is the
only caller that runs shrink_lruvec() from kswapd against a specific
memcg, so it is the only way to reach lru_gen_shrink_lruvec() and in turn
set_mm_walk(), which warns when called from kswapd.

Link: https://lore.kernel.org/20260811203203.3456029-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |   49 +--------------
 mm/memcontrol-v1.c                             |   43 +++++++------
 2 files changed, 32 insertions(+), 60 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-make-the-v1-soft-limit-knob-inert
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -47,7 +47,6 @@ Features:
  - pages are linked to per-memcg LRU exclusively, and there is no global LRU.
  - optionally, memory+swap usage can be accounted and limited.
  - hierarchical accounting
- - soft limit
  - moving (recharging) account at moving a task is selectable.
  - usage threshold notifier
  - memory pressure notifier
@@ -76,10 +75,9 @@ Brief summary of control files.
  memory.memsw.failcnt		     show the number of memory+Swap hits limits
  memory.max_usage_in_bytes	     show max memory usage recorded
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
- memory.soft_limit_in_bytes	     set/show soft limit of memory usage
-				     This knob is not available on CONFIG_PREEMPT_RT systems.
-                                     This knob is deprecated and shouldn't be
-                                     used.
+ memory.soft_limit_in_bytes	     This knob is deprecated and has no effect.
+                                     Writes are ignored and reads always
+                                     return the maximum value.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't be
@@ -340,9 +338,6 @@ memory.kmem.usage_in_bytes, or in a sepa
 The main "kmem" counter is fed into the main counter, so kmem charges will
 also be visible from the user counter.
 
-Currently no soft limit is implemented for kernel memory. It is future work
-to trigger slab reclaim when those limits are reached.
-
 2.7.1 Current Kernel Memory resources accounted
 -----------------------------------------------
 
@@ -710,42 +705,10 @@ For compatibility reasons writing 1 to m
 
 THIS IS DEPRECATED!
 
-Soft limits allow for greater sharing of memory. The idea behind soft limits
-is to allow control groups to use as much of the memory as needed, provided
-
-a. There is no memory contention
-b. They do not exceed their hard limit
-
-When the system detects memory contention or low memory, control groups
-are pushed back to their soft limits. If the soft limit of each control
-group is very high, they are pushed back as much as possible to make
-sure that one control group does not starve the others of memory.
-
-Please note that soft limits is a best-effort feature; it comes with
-no guarantees, but it does its best to make sure that when memory is
-heavily contended for, memory is allocated based on the soft limit
-hints/setup. Currently soft limit based reclaim is set up such that
-it gets invoked from balance_pgdat (kswapd).
-
-7.1 Interface
--------------
+Writing to memory.soft_limit_in_bytes has no effect and reading it will
+always return the maximum value.
 
-Soft limits can be setup by using the following commands (in this example we
-assume a soft limit of 256 MiB)::
-
-	# echo 256M > memory.soft_limit_in_bytes
-
-If we want to change this to 1G, we can at any time use::
-
-	# echo 1G > memory.soft_limit_in_bytes
-
-.. note::
-       Soft limits take effect over a long period of time, since they involve
-       reclaiming memory for balancing between memory cgroups
-
-.. note::
-       It is recommended to set the soft limit always below the hard limit,
-       otherwise the hard limit will take precedence.
+Use memory.low and memory.min in cgroup v2 instead.
 
 .. _cgroup-v1-memory-move-charges:
 
--- a/mm/memcontrol-v1.c~memcg-make-the-v1-soft-limit-knob-inert
+++ a/mm/memcontrol-v1.c
@@ -95,7 +95,6 @@ enum {
 	RES_LIMIT,
 	RES_MAX_USAGE,
 	RES_FAILCNT,
-	RES_SOFT_LIMIT,
 };
 
 #ifdef CONFIG_LOCKDEP
@@ -1589,6 +1588,30 @@ static int mem_cgroup_hierarchy_write(st
 	return -EINVAL;
 }
 
+static u64 mem_cgroup_soft_limit_read(struct cgroup_subsys_state *css,
+				      struct cftype *cft)
+{
+	return (u64)PAGE_COUNTER_MAX * PAGE_SIZE;
+}
+
+static ssize_t mem_cgroup_soft_limit_write(struct kernfs_open_file *of,
+					   char *buf, size_t nbytes, loff_t off)
+{
+	unsigned long nr_pages;
+	int ret;
+
+	ret = page_counter_memparse(strstrip(buf), "-1", &nr_pages);
+	if (ret)
+		return ret;
+
+	pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
+		     "Writing any value to this file has no effect. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
+	return nbytes;
+}
+
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
@@ -1625,8 +1648,6 @@ static u64 mem_cgroup_read_u64(struct cg
 		return (u64)counter->watermark * PAGE_SIZE;
 	case RES_FAILCNT:
 		return counter->failcnt;
-	case RES_SOFT_LIMIT:
-		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -1721,17 +1742,6 @@ static ssize_t mem_cgroup_write(struct k
 			break;
 		}
 		break;
-	case RES_SOFT_LIMIT:
-		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
-			ret = -EOPNOTSUPP;
-		} else {
-			pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
-				     "Please report your usecase to linux-mm@kvack.org if you "
-				     "depend on this functionality.\n");
-			WRITE_ONCE(memcg->soft_limit, nr_pages);
-			ret = 0;
-		}
-		break;
 	}
 	return ret ?: nbytes;
 }
@@ -2085,9 +2095,8 @@ struct cftype mem_cgroup_legacy_files[]
 	},
 	{
 		.name = "soft_limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-		.write = mem_cgroup_write,
-		.read_u64 = mem_cgroup_read_u64,
+		.write = mem_cgroup_soft_limit_write,
+		.read_u64 = mem_cgroup_soft_limit_read,
 	},
 	{
 		.name = "failcnt",
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-keep-folios-objcg-same-as-its-node.patch
memcg-make-the-v1-soft-limit-knob-inert.patch
memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done.patch

