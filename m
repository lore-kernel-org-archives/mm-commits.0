From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 =?US-ASCII?Q?mm-memcontrol-make-swap-tracking-an-integral-part-of-memo?=
 =?US-ASCII?Q?ry-control-fix.patch?= removed from -mm tree
Date: Fri, 22 May 2020 18:06:53 -0700
Message-ID: <20200523010653.yMGIWxpo2%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387453AbgEWBG4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 21:06:56 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@kernel.org, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, shakeelb@google.com


The patch titled
     Subject: mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix

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

do_memsw_account() used to be automatically false when the cgroup
controller was disabled.  Now that it's replaced by cgroup_memory_noswap,
for which this isn't true, make the mem_cgroup_disabled() checks explicit
in the swap control API.

[hannes@cmpxchg.org: use mem_cgroup_disabled() in all API functions]
Link: http://lkml.kernel.org/r/20200521191746.GB815980@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Debugged-by: Hugh Dickins <hughd@google.com>
Debugged-by: Michal Hocko <mhocko@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   47 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix
+++ a/mm/memcontrol.c
@@ -6882,6 +6882,9 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 
+	if (mem_cgroup_disabled())
+		return;
+
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
@@ -6947,6 +6950,10 @@ int mem_cgroup_try_charge_swap(struct pa
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
+	/* Only cgroup2 has swap.max */
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
@@ -6991,6 +6998,9 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
+	if (mem_cgroup_disabled())
+		return;
+
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
@@ -7011,12 +7021,25 @@ long mem_cgroup_get_nr_swap_pages(struct
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return nr_swap_pages;
+	if (mem_cgroup_disabled())
+		goto out;
+
+	/* Swap control disabled */
+	if (cgroup_memory_noswap)
+		goto out;
+
+	/*
+	 * Only cgroup2 has swap.max, cgroup1 does mem+sw accounting,
+	 * which does not place restrictions specifically on swap.
+	 */
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		goto out;
+
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
 		nr_swap_pages = min_t(long, nr_swap_pages,
 				      READ_ONCE(memcg->swap.max) -
 				      page_counter_read(&memcg->swap));
+out:
 	return nr_swap_pages;
 }
 
@@ -7028,18 +7051,30 @@ bool mem_cgroup_swap_full(struct page *p
 
 	if (vm_swap_full())
 		return true;
-	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return false;
+
+	if (mem_cgroup_disabled())
+		goto out;
+
+	/* Swap control disabled */
+	if (cgroup_memory_noswap)
+		goto out;
+
+	/*
+	 * Only cgroup2 has swap.max, cgroup1 does mem+sw accounting,
+	 * which does not place restrictions specifically on swap.
+	 */
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		goto out;
 
 	memcg = page->mem_cgroup;
 	if (!memcg)
-		return false;
+		goto out;
 
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
 		if (page_counter_read(&memcg->swap) * 2 >=
 		    READ_ONCE(memcg->swap.max))
 			return true;
