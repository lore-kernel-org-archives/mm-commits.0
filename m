Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A301A9F8C
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334138; cv=none; b=cGnUAA9qF0f65SrJ51iLybnBMSi4F7IAtphH33fHOWrjaSQigKDAab8A8VcHeZX26mN/us+11ATD+GlcLNQ6f6yn4f+gS25OGBjAHmhjFWXms6OPBJ1+JKlVhEg8oj1JuW3zeC3LGNFTysA8wkjZBWa5T4tfMI6R5wQpKfpZrwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334138; c=relaxed/simple;
	bh=2Bs5bJnS5AdlZosqAvvd2fo2HW/RU4iAwLEwE1am25c=;
	h=Date:To:From:Subject:Message-Id; b=OdKVjBBYKAEhRqQlbVodg/8dVAx4nv5FcLAM2EM5pEhkpVLOdQI1Ow8xV9PhxyYZitpxNdyED0JqQ2La/7fbJeQ1JBEwjRClIOmewvsqudaqb/jJ8YCTRCWbH83w22a/CTQLuU7HL4tPOQD9xYOeLYy4GGltX7p12S4HeUubOII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rPXmOR/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rPXmOR/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9A31F0089B;
	Wed,  7 Oct 2026 00:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334136;
	bh=eLT2Mn5lGZgNhSS+b485OtdcXi2szIPchIKu5BjUsU4=;
	h=Date:To:From:Subject;
	b=rPXmOR/1AoURP96R6Zj1u1npdAHg8LzNiWPa3e2GoceqVXqQNwySN6usGwpxxwDAM
	 OHSs8v59wqlNJUi6lkKgElP0o8WGhKzbuIhlMt/emeOrvdX2na5xxrznnchTJQxiJI
	 1LKoZHyCJEV97YwCAYQQ0wtT+vXhN+4SeMBjz1lM=
Date: Tue, 06 Oct 2026 17:48:56 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch removed from -mm tree
Message-Id: <20261007004856.9D9A31F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: annotate data race for per-cpu pageset fields
has been removed from the -mm tree.  Its filename was
     mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/vmstat: annotate data race for per-cpu pageset fields
Date: Thu, 27 Aug 2026 15:05:46 +0800

zoneinfo_show_print() reads pcp->count, pcp->high, pcp->batch,
pcp->high_min, pcp->high_max and the per-cpu stat_threshold while holding
only zone->lock, which does not synchronize these fields.  The writers are
the page allocation and free fast paths under pcp->lock, decay_pcp_high()
which updates pcp->high without any lock, pageset_update() which writes
batch/high_min/high_max with WRITE_ONCE(), and
refresh_zone_stat_thresholds() which writes stat_threshold locklessly.

The race is benign: the values are only printed to /proc/zoneinfo, they
are naturally aligned integers, and pageset_update() already documents
that users of batch/high_min/high_max must cope with the fields changing
asynchronously.  Annotate the reads with data_race(), following commit
af1c31acc853 ("mm/vmstat: annotate data race for
zone->free_area[order].nr_free").

Found by KCSAN testing on an older kernel; the same race still exists on
mainline.  No functional change intended.

BUG: KCSAN: data-race in zoneinfo_show_print+0x355/0x520 root/klinux/mm/vmstat.c:1774
race at unknown origin, with read to 0xffff8e1835410808 of 4 bytes by task 22653 on cpu 12:
zoneinfo_show_print+0x355/0x520 root/klinux/mm/vmstat.c:1774
walk_zones_in_node root/klinux/mm/vmstat.c:1496 [inline]
zoneinfo_show+0x41/0x70 root/klinux/mm/vmstat.c:1806
seq_read_iter+0x30c/0x970 root/klinux/fs/seq_file.c:230
proc_reg_read_iter+0x10c/0x170 root/klinux/fs/proc/inode.c:305
copy_splice_read+0x2a1/0x4e0 root/klinux/fs/splice.c:365
do_splice_read root/klinux/fs/splice.c:985 [inline]
do_splice_read+0x139/0x1a0 root/klinux/fs/splice.c:959
splice_direct_to_actor+0x16b/0x540 root/klinux/fs/splice.c:1089
do_splice_direct_actor root/klinux/fs/splice.c:1207 [inline]
do_splice_direct+0x10a/0x180 root/klinux/fs/splice.c:1233
do_sendfile+0x6ea/0x7e0 root/klinux/fs/read_write.c:1363
__do_sys_sendfile64 root/klinux/fs/read_write.c:1424 [inline]
__se_sys_sendfile64 root/klinux/fs/read_write.c:1410 [inline]
__x64_sys_sendfile64+0x117/0x130 root/klinux/fs/read_write.c:1410
x64_sys_call+0x1cc7/0x1ee0 root/klinux/./arch/x86/include/generated/asm/syscalls_64.h:41
do_syscall_x64 root/klinux/arch/x86/entry/common.c:46 [inline]
do_syscall_64+0x75/0x2c0 root/klinux/arch/x86/entry/common.c:76
entry_SYSCALL_64_after_hwframe+0x76/0xe0
value changed: 0x000001b2 -> 0x000001b1
Reported by Kernel Concurrency Sanitizer on:
CPU: 12 PID: 22653 Comm: syz-executor.12 Not tainted 6.6.140+ #672
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014

Link: https://lore.kernel.org/20260827070546.1336383-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 mm/vmstat.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields
+++ a/mm/vmstat.c
@@ -1837,6 +1837,11 @@ static void zoneinfo_show_print(struct s
 		struct per_cpu_zonestat __maybe_unused *pzstats;
 
 		pcp = per_cpu_ptr(zone->per_cpu_pageset, i);
+		/*
+		 * Access to the per-cpu pageset fields is lockless as they
+		 * are used only for printing purposes. Use data_race to
+		 * avoid KCSAN warning.
+		 */
 		seq_printf(m,
 			   "\n    cpu: %i"
 			   "\n              count:    %i"
@@ -1845,15 +1850,15 @@ static void zoneinfo_show_print(struct s
 			   "\n              high_min: %i"
 			   "\n              high_max: %i",
 			   i,
-			   pcp->count,
-			   pcp->high,
-			   pcp->batch,
-			   pcp->high_min,
-			   pcp->high_max);
+			   data_race(pcp->count),
+			   data_race(pcp->high),
+			   data_race(pcp->batch),
+			   data_race(pcp->high_min),
+			   data_race(pcp->high_max));
 #ifdef CONFIG_SMP
 		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, i);
 		seq_printf(m, "\n  vm stats threshold: %d",
-				pzstats->stat_threshold);
+				data_race(pzstats->stat_threshold));
 #endif
 	}
 	seq_printf(m,
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch
mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch
mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch
mm-memcg-reparent-non-hierarchical-lruvec-stats-on-cgroup-v2.patch

