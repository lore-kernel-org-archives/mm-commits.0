Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C1D1F03C9
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760206264; cv=none; b=uw44WpW8tqKcY4eg/CaWoK+KYpo+CPvBWeoJ/s77GRas0fb3r41IsSrSXOquJp90iYcIs+WYxLUW6AdIQmJevsMZxqvcV6Cc1gb0zV+eEXYZy9enQlv1aS5ZJ2KkT3oxrK6YASo2RFni9Da/89+cjdok5z8iblgxPoOtjAJN78Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760206264; c=relaxed/simple;
	bh=gK3Qc2rbDur5t6X/hTqZ/hGg3YvnqrJm6eB9HnSzKRI=;
	h=Date:To:From:Subject:Message-Id; b=geUaBOBEj1/kPGjs9p56ykp7qdqgo1x7rwNnM5iyCHVZG6fIghV3K2TgqmIkiq+5CZnwOuURAma82rtupcBjmLOTv0arE0WXtvUP0ZeJq4zIlUd07epf0OYpjaXSrMMAvs+4Gpsi4u4HDofqCudoIwQrS3SGJlm7yC+WZPWEnwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wflz/nUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wflz/nUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1BAC4CEF4;
	Sat, 11 Oct 2025 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760206263;
	bh=gK3Qc2rbDur5t6X/hTqZ/hGg3YvnqrJm6eB9HnSzKRI=;
	h=Date:To:From:Subject:From;
	b=Wflz/nUuLAChYDcEdUgHh0+Y7lWAskDSLu761bPN7ViB45lGOLf/9lqDuUYKBmgV8
	 OxKWObVH7exzd5umBeweZXUg/YN4zGmmv0oJ+dHoaQM0eTHv8MMUPkz9hkcbMy+4cE
	 9VNSkfZmcdF9YygtreLx9PON+jgKhETkrwJ1Kyks=
Date: Sat, 11 Oct 2025 11:11:02 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baohua@kernel.org,aaron.lu@intel.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-select-swap-device-with-default-priority-round-robin.patch added to mm-new branch
Message-Id: <20251011181103.6D1BAC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: select swap device with default priority round robin
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-select-swap-device-with-default-priority-round-robin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-select-swap-device-with-default-priority-round-robin.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap: select swap device with default priority round robin
Date: Sat, 11 Oct 2025 16:16:24 +0800

Swap devices are assumed to have similar accessing speed if no priority is
specified when swapon.  It's unfair and doesn't make sense just because
one swap device is swapped on firstly, its priority will be higher than
the one swapped on later.

Here, set all swap devicess to have priority '-1' by default.  With this
change, swap device with default priority will be selected round robin
when swapping out.  This can improve the swapping efficiency a lot among
multiple swap devices with default priority.

Below are swapon output during processes high pressure vm-scability test
is being taken:

1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one by
   priority from high to low when one swap device is exhausted:
------------------------------------
[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE   USED PRIO
/dev/zram0 partition  16G    16G   -1
/dev/zram1 partition  16G 966.2M   -2
/dev/zram2 partition  16G     0B   -3
/dev/zram3 partition  16G     0B   -4

2) This is behaviour with commit a2468cc9bfdf, on node, swap device
   sharing the same node id is selected firstly until exhausted; while
   on node no swap device sharing the node id it selects the one with
   highest priority until exhaustd:
------------------------------------
[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE  USED PRIO
/dev/zram0 partition  16G 15.7G   -2
/dev/zram1 partition  16G  3.4G   -3
/dev/zram2 partition  16G  3.4G   -4
/dev/zram3 partition  16G  2.6G   -5

3) After this patch applied, swap devices with default priority are selectd
   round robin:
------------------------------------
[root@hp-dl385g10-03 block]# swapon
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition  16G 6.6G   -1
/dev/zram1 partition  16G 6.6G   -1
/dev/zram2 partition  16G 6.6G   -1
/dev/zram3 partition  16G 6.6G   -1

With the change, we can see about 18% efficiency promotion relative to
node based way as below.  (Surely, the pre-commit a2468cc9bfdf way is the
worst.)

vm-scability test:
==================
Test with:
usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
                            one by one:      node based:      round robin:
System time:                1087.38 s        637.92 s         526.74 s     (lower is better)
Sum Throughput:             2036.55 MB/s     3546.56 MB/s     4207.56 MB/s (higher is better)
Single process Throughput:  65.69 MB/s       114.40 MB/s      135.72 MB/s  (high is better)
free latency:               15769409.48 us   10138455.99 us   6810119.01 us(lower is better)

Link: https://lkml.kernel.org/r/20251011081624.224202-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

--- a/mm/swapfile.c~mm-swap-select-swap-device-with-default-priority-round-robin
+++ a/mm/swapfile.c
@@ -74,7 +74,7 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-static int least_priority;
+#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -2708,10 +2708,7 @@ static void setup_swap_info(struct swap_
 			    struct swap_cluster_info *cluster_info,
 			    unsigned long *zeromap)
 {
-	if (prio >= 0)
-		si->prio = prio;
-	else
-		si->prio = --least_priority;
+	si->prio = prio;
 	/*
 	 * the plist prio is negated because plist ordering is
 	 * low-to-high, while swap ordering is high-to-low
@@ -2729,16 +2726,7 @@ static void _enable_swap_info(struct swa
 	total_swap_pages += si->pages;
 
 	assert_spin_locked(&swap_lock);
-	/*
-	 * both lists are plists, and thus priority ordered.
-	 * swap_active_head needs to be priority ordered for swapoff(),
-	 * which on removal of any swap_info_struct with an auto-assigned
-	 * (i.e. negative) priority increments the auto-assigned priority
-	 * of any lower-priority swap_info_structs.
-	 * swap_avail_head needs to be priority ordered for folio_alloc_swap(),
-	 * which allocates swap pages from the highest available priority
-	 * swap_info_struct.
-	 */
+
 	plist_add(&si->list, &swap_active_head);
 
 	/* Add back to available list */
@@ -2888,17 +2876,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	}
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
-	if (p->prio < 0) {
-		struct swap_info_struct *si = p;
-		int nid;
-
-		plist_for_each_entry_continue(si, &swap_active_head, list) {
-			si->prio++;
-			si->list.prio--;
-			si->avail_list.prio--;
-		}
-		least_priority++;
-	}
 	plist_del(&p->list, &swap_active_head);
 	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
@@ -3609,7 +3586,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	mutex_lock(&swapon_mutex);
-	prio = -1;
+	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap-do-not-choose-swap-device-according-to-numa-node.patch
mm-swap-select-swap-device-with-default-priority-round-robin.patch

