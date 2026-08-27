Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C05484222
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846619; cv=none; b=Yz/VJn+UzqqvxMy6nVNxa2vl3OmxSGWiVsoKsiRlTKYfztCpUAIeG1qsPyqR5kJDVAOg5aq90Uuza2LzQjlL30Y6TQS8jSqcT+rgPA/NFU1uLLeCaVu4QBPHasMWgQvyJ9zG5QE6jlazJcdQ2DywyNz7+KHbFeug6ingferuT8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846619; c=relaxed/simple;
	bh=9h8Sl4fQoPs5TzLkURFMDJooeJ3Qwek3xRXxFHFcQ8A=;
	h=Date:To:From:Subject:Message-Id; b=D/sCQLWpEaIwhnCKGZsfwfE+TaU9XsBm9iMT1L57BtD5OuRAgUE+lv0M4QZkiOAh6AN6bxeW/tJ/xP6aNulcNHlSxwBjdN19g28z7IqgytrJWFDgo43YUgwNchj6j5lNS9oGovuVJOU4Cj96UvbWYSGBiOdKC/4Kq4GM9LUyghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uLJyBLLs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uLJyBLLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4E61F000E9;
	Thu, 27 Aug 2026 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787846618;
	bh=j3a27P8jLYQY7n3BpcAaZTtNh9351EKZfipi+XTtikM=;
	h=Date:To:From:Subject;
	b=uLJyBLLshp3WWuInU5PTCOImw/VyJoI20Bvgyo5O+MzOtv1lp2bdVdNwq2SJURzGz
	 DgZP8MN/g6fPrQlYfeeKLyxXKK8NyxLx5MMUhPgARAWiYXRB/2fNWN6AKV9VANW/ow
	 vB9VUekMfEE2xg77bgf84uMwjXdo+j/vashEKR7k=
Date: Thu, 27 Aug 2026 09:03:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch added to mm-new branch
Message-Id: <20260827160338.2A4E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: annotate data race for per-cpu pageset fields
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch

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
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch

