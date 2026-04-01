Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CB147D921
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775064129; cv=none; b=nBYcFg9VVFlSMyyb1INWDq0Lp2pQy4IGlbbIkrpgxfbGbRc01ncr+l2nHgXkm8obUFftOIzMQP6JGwwWo7jvtwI3UGE+NoGHK9pAhKqcUuZI82TvHqp8bx9pE/ymNjMQZJ+2bVYP+BfwHVcEZZnapQ4rtRgez795VqtIllnBzoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775064129; c=relaxed/simple;
	bh=dNXzl2/LfC/Ku34tkk4Li0e1ru02NNdVihEYrhRNQQE=;
	h=Date:To:From:Subject:Message-Id; b=UuolAXoPvSX+XYXNN1L60yZO5DhpjgqDNE+b34b7RkXn7GYcV7jJr3ZwWUHbwp+RIKarsJcyLQ82KcxDHsM3dx9EArjVTrv4xoyPjX4hok47BcjaLcZWICgFwTgj2hmS5GX+vZZwVfkcQfEZ6uZbO6EeDwf+UUc3VtriTH9cZ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dX26Zzjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dX26Zzjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E90FC4CEF7;
	Wed,  1 Apr 2026 17:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775064129;
	bh=dNXzl2/LfC/Ku34tkk4Li0e1ru02NNdVihEYrhRNQQE=;
	h=Date:To:From:Subject:From;
	b=dX26ZzjfmFfurgUIyuJ0AZ8+ebNeRkq1D8Lj1MV3MmWwWczGEw5QnWoFI1VZTGnjQ
	 sFj0w4fsHsNgzGg6vrSQE10pu8slFt/+DOTbD/9xPviq4HmkbYQ3vudlg3mZaAk9vm
	 i3SUeRxYYBLu0I5xJyoEtjVS74u8Ci/dxez6IcJA=
Date: Wed, 01 Apr 2026 10:22:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kas@kernel.org,hannes@cmpxchg.org,david@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch added to mm-new branch
Message-Id: <20260401172209.4E90FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: spread vmstat_update requeue across the stat interval
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm/vmstat: spread vmstat_update requeue across the stat interval
Date: Wed, 01 Apr 2026 06:57:50 -0700

vmstat_update uses round_jiffies_relative() when re-queuing itself, which
aligns all CPUs' timers to the same second boundary.  When many CPUs have
pending PCP pages to drain, they all call decay_pcp_high() ->
free_pcppages_bulk() simultaneously, serializing on zone->lock and hitting
contention.

Introduce vmstat_spread_delay() which distributes each CPU's vmstat_update
evenly across the stat interval instead of aligning them.

This does not increase the number of timer interrupts — each CPU still
fires once per interval.  The timers are simply staggered rather than
aligned.  Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
wake idle CPUs regardless of scheduling; the spread only affects CPUs that
are already active

`perf lock contention` shows 7.5x reduction in zone->lock contention (872
-> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64 system
under memory pressure.

Tested on a 72-CPU aarch64 system using stress-ng --vm to generate memory
allocation bursts.  Lock contention was measured with:

  perf lock contention -a -b -S free_pcppages_bulk

Results with KASAN enabled:

 free_pcppages_bulk contention (KASAN):
  +--------------+----------+----------+
  | Metric       | No fix   | With fix |
  +--------------+----------+----------+
  | Contentions  |      872 |      117 |
  | Total wait   | 199.43ms | 80.76ms  |
  | Max wait     |  35.76ms | 4.19ms   |
  +--------------+----------+----------+

Results without KASAN:

  free_pcppages_bulk contention (no KASAN):
  +--------------+----------+----------+
  | Metric       | No fix   | With fix |
  +--------------+----------+----------+
  | Contentions  |      240 |      133 |
  | Total wait   |  34.01ms | 24.61ms  |
  | Max wait     |   1.35ms |   965us  |
  +--------------+----------+----------+

Link: https://lkml.kernel.org/r/20260401-vmstat-v1-1-b68ce4a35055@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval
+++ a/mm/vmstat.c
@@ -2032,6 +2032,29 @@ static int vmstat_refresh(const struct c
 }
 #endif /* CONFIG_PROC_FS */
 
+/*
+ * Return a per-cpu delay that spreads vmstat_update work across the stat
+ * interval.  Without this, round_jiffies_relative() aligns every CPU's
+ * timer to the same second boundary, causing a thundering-herd on
+ * zone->lock when multiple CPUs drain PCP pages simultaneously via
+ * decay_pcp_high() -> free_pcppages_bulk().
+ */
+static unsigned long vmstat_spread_delay(void)
+{
+	unsigned long interval = sysctl_stat_interval;
+	unsigned int nr_cpus = num_online_cpus();
+
+	if (nr_cpus <= 1)
+		return round_jiffies_relative(interval);
+
+	/*
+	 * Spread per-cpu vmstat work evenly across the interval.  Don't
+	 * use round_jiffies_relative() here -- it would snap every CPU
+	 * back to the same second boundary, defeating the spread.
+	 */
+	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
+}
+
 static void vmstat_update(struct work_struct *w)
 {
 	if (refresh_cpu_vm_stats(true)) {
@@ -2042,7 +2065,7 @@ static void vmstat_update(struct work_st
 		 */
 		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
 				this_cpu_ptr(&vmstat_work),
-				round_jiffies_relative(sysctl_stat_interval));
+				vmstat_spread_delay());
 	}
 }
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

