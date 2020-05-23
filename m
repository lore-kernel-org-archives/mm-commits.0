From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-?=
 =?US-ASCII?Q?control-fix-v2.patch?= added to -mm tree
Date: Fri, 22 May 2020 18:09:18 -0700
Message-ID: <20200523010918.eDZY5_14K%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbgEWBJT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 21:09:19 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org


The patch titled
     Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
has been added to the -mm tree.  Its filename is
     mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page

Fix crash with cgroup_disable=memory:

> > > > + mkfs -t ext4 /dev/disk/by-id/ata-TOSHIBA_MG04ACA100N_Y8NRK0BPF6XF
> > > > mke2fs 1.43.8 (1-Jan-2018)
> > > > Creating filesystem with 244190646 4k blocks and 61054976 inodes
> > > > Filesystem UUID: 3bb1a285-2cb4-44b4-b6e8-62548f3ac620
> > > > Superblock backups stored on blocks:
> > > > 32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
> > > > 4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
> > > > 102400000, 214990848
> > > > Allocating group tables:    0/7453                           done
> > > > Writing inode tables:    0/7453                           done
> > > > Creating journal (262144 blocks): [   35.502102] BUG: kernel NULL
> > > > pointer dereference, address: 000000c8
> > > > [   35.508372] #PF: supervisor read access in kernel mode
> > > > [   35.513506] #PF: error_code(0x0000) - not-present page
> > > > [   35.518638] *pde = 00000000
> > > > [   35.521514] Oops: 0000 [#1] SMP
> > > > [   35.524652] CPU: 0 PID: 145 Comm: kswapd0 Not tainted
> > > > 5.7.0-rc6-next-20200519+ #1
> > > > [   35.532121] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> > > > 2.2 05/23/2018
> > > > [   35.539507] EIP: mem_cgroup_get_nr_swap_pages+0x28/0x60

Swap accounting used to be implied-disabled when the cgroup controller was
disabled.  Restore that for the new cgroup_memory_noswap, so that we bail
out of this function instead of dereferencing a NULL memcg.

Link: http://lkml.kernel.org/r/20200521215855.GB815153@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Debugged-by: Hugh Dickins <hughd@google.com>
Debugged-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix-v2
+++ a/mm/memcontrol.c
@@ -7152,7 +7152,11 @@ static struct cftype memsw_files[] = {
 
 static int __init mem_cgroup_swap_init(void)
 {
-	if (mem_cgroup_disabled() || cgroup_memory_noswap)
+	/* No memory control -> no swap control */
+	if (mem_cgroup_disabled())
+		cgroup_memory_noswap = true;
+
+	if (cgroup_memory_noswap)
 		return 0;
 
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-shmem-remove-rare-optimization-when-swapin-races-with-hole-punching.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix-v2.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch
mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch
mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch
mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch
mm-workingset-let-cache-workingset-challenge-anon.patch
mm-remove-use-once-cache-bias-from-lru-balancing.patch
mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
mm-base-lru-balancing-on-an-explicit-cost-model.patch
mm-deactivations-shouldnt-bias-the-lru-balance.patch
mm-only-count-actual-rotations-as-lru-reclaim-cost.patch
mm-balance-lru-lists-based-on-relative-thrashing.patch
mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
mm-vmscan-reclaim-writepage-is-io-cost.patch
mm-vmscan-limit-the-range-of-lru-type-balancing.patch
