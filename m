Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AF722AE65
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 02:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787797034; cv=none; b=o7we7A+YQyoRo+klQdSesTvdwBKikKBWEWYWZ8e+tKjEZS1zeIluRJmAazZ/1luCNUnzYP/vPaEse2YUbI5L18kDOSBgeamzSxOYzcEXjUXDeozTOfedoU8PZ4Z2hSgt7ocJCNuq8IyEmfKo32aqibsryIQQDRb55rhaQHTo2BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787797034; c=relaxed/simple;
	bh=ezpROrm7QtikJkAd0pnSrCoEkKnqiZF6dEak6TZpBa8=;
	h=Date:To:From:Subject:Message-Id; b=OOHFgzW4FDl81q0s5GvVvYF2iM0mRjsFtj6wiO1fs7Ey6FdT9TRzjuibeVPZrtXsgt9gxE3EZi8eh8hlMD3oVihzc9s9Fv4fDYbygZ8hbiAb1v0pShiw1lMBJknMJyYyvcGvy9g6a3NyHUSUjMHmjAllewlYK+I3vYdBZ8/yI0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QllgW71x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QllgW71x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC621F000E9;
	Thu, 27 Aug 2026 02:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787797032;
	bh=9+pwxa+wrySiPJzzpdV+lmrhmabRvv1SAsnL3dijDTA=;
	h=Date:To:From:Subject;
	b=QllgW71xxP62pYqPkpqtchdx1BiJierPWBtb+xR+oetGPenHmOl+Nl7NBQ9vIc0af
	 9kCTyydBQsND8xA/xOGykaEdUX4qochDIM74Z8ybG8ssk1hx9sb1ABO7A3mLoFt2B8
	 Ag5PaZve2LtDTkPwI/fyQ8B1uuM5TF+wer158meo=
Date: Wed, 26 Aug 2026 19:17:12 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,jianhuizzzzz@gmail.com,jonaszhou-oc@zhaoxin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-avoid-false-sharing-with-drain_vmap_work.patch added to mm-new branch
Message-Id: <20260827021712.CBC621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: avoid false sharing with drain_vmap_work
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-avoid-false-sharing-with-drain_vmap_work.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-avoid-false-sharing-with-drain_vmap_work.patch

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
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
Subject: mm/vmalloc: avoid false sharing with drain_vmap_work
Date: Tue, 25 Aug 2026 18:46:59 +0800

free_vmap_area_noflush() queues drain_vmap_work after the number of lazily
freed pages exceeds lazy_max_pages().  Until the worker purges those
pages, concurrent frees keep calling schedule_work().  Even if the work is
already pending, queue_work_on() performs a locked test_and_set_bit() on
the pending bit in the work item.

On the tested x86-64 build, drain_vmap_work and vmap_nodes occupy the same
64-byte cache line.  The work item starts at offset 0 and the vmap_nodes
pointer at offset 32.  The latter is read by vmap allocation and free
paths, so updates to the work item invalidate a cache line read by all
CPUs.

Put drain_vmap_work in the cacheline-aligned data section.  Tests were run
on Linux 7.2.

On a two-socket Intel Xeon Silver 4208 system using 16 workers, the
runtimes of vmalloc.fix_align, vmalloc.fix_size, and
vmalloc.no_block_alloc decreased by 12.61%, 5.78%, and 6.87%,
respectively.  HITM samples for the affected cache line and total HITM
samples decreased by 96.55% and 13.36%, respectively.

Link: https://lore.kernel.org/20260825104659.100134-1-jonaszhou-oc@zhaoxin.com
Signed-off-by: JonasZhou <jonaszhou-oc@zhaoxin.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <jianhuizzzzz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-avoid-false-sharing-with-drain_vmap_work
+++ a/mm/vmalloc.c
@@ -1089,7 +1089,12 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vm
 static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
-static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+/*
+ * Keep the work item, whose pending bit is updated by freeing CPUs,
+ * away from vmap metadata read by allocation and free paths.
+ */
+static __cacheline_aligned_in_smp
+DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
 
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
_

Patches currently in -mm which might be from jonaszhou-oc@zhaoxin.com are

mm-vmalloc-avoid-false-sharing-with-drain_vmap_work.patch

