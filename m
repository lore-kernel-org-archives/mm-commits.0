Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C79F4BC01A
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 23:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790812051; cv=none; b=j3vcKwJwSgQ4ih+EKkuEzIbgPgpx//1HUU18l1pAlZ7GxYPrmFrgyuxlHe0HbcSmXQhJrFSLJZMeobIO1GOdu5KU0YnDJqDSCedDTBKVZuzipcXmDu2cxyBwcDrZdgg/l3zjmH4ix085CHC7ztq+rP2Ji3W/FAkzTDwQr8DsuRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790812051; c=relaxed/simple;
	bh=OP2EsIywm8SD3tGDwQAH8ViokRV8fjWds3M2XtJjjTU=;
	h=Date:To:From:Subject:Message-Id; b=Xm733nzW9VLjMnq+dRVYRIOc4QM5YbPvTbnjymrQYm0dfjGfW74sHhzLZ0AnkmxZnPHSmfS0sh8mbiQK8ZF+30kbMNuVxSM6vo4HwTJGIR2njkrn4tuuYzbZvDWIJWraYtf/Zq78gnzoQQCD7HLHgiikPcgtE6IOP8HKJAbaJ/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q/0vvzLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q/0vvzLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D27B1F000FF;
	Wed, 30 Sep 2026 23:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790812049;
	bh=6+xK9yg0AbcGV6zC8rLB2TDex0GecA9Aw53Ox6+iqf0=;
	h=Date:To:From:Subject;
	b=q/0vvzLj/oFjeeCdm3pvntDO8OLN/1ZKP3lB4xKAkoujiO7TJqs2NylRSY/3PV4xs
	 WFKjEkhb1KpE2Yjt5cDb0sGUjHSqVVdKeYVx65wRrXWA/pieVWjqSgzbW7VoTlriiq
	 PriYxy0g/p/hFqkDVA2ANRjqEK1dnj7SJSNWiH1I=
Date: Wed, 30 Sep 2026 16:47:29 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,vineeth@bitbyteword.org,shikemeng@huaweicloud.com,rafael.j.wysocki@intel.com,nphamcs@gmail.com,kelleynnn@gmail.com,kasong@tencent.com,hughd@google.com,huang.ying.caritas@gmail.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch added to mm-new branch
Message-Id: <20260930234729.9D27B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make swapoff interruptible when unusing mms/shmem
has been added to the -mm mm-new branch.  Its filename is
     mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch

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
From: Chris Down <chris@chrisdown.name>
Subject: mm: make swapoff interruptible when unusing mms/shmem
Date: Thu, 1 Oct 2026 01:17:40 +0200

try_to_unuse() only checks for a pending signal between mms, and
shmem_unuse() doesn't check at all.  That means that once swapoff gets to
a process or a shmem file with a lot swapped out, nothing can interrupt it
until every last page of it has been read back in.

Just as one example of where this can concretely show up, freezing tasks
for suspend or hibernation has to wait for swapoff to notice the freezer's
fake signal, and gives up after freeze_timeout_msecs (20 seconds by
default).

Here's a facetious example where one swaps out 2GiB of one process to a
swap file on ext4, starts swapoff, and half a second later tries to freeze
with pm_test=freezer.  Writing to /sys/power/state then fails with EBUSY
and this in dmesg:

    Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
    task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
    Call trace:
     [...]
     io_schedule+0x44/0x70
     folio_wait_bit_common+0x1ec/0x3d0
     __folio_lock+0x24/0x40
     unuse_pte_range+0x2d0/0x348
     unuse_vma+0x158/0x248
     unuse_mm+0xfc/0x150
     try_to_unuse+0x104/0x3f8
     __do_sys_swapoff+0x220/0x5d8
     [...]

The same goes for anything else that wants swapoff to stop, like an admin
hitting ^C in a panic, of course.

Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
try_to_unuse() was driven by find_next_to_unuse() which checks for a
signal before every entry, so let's restore that behaviour.

Just as an example of the improvements, here's how long freezing takes
in the same test while swapoff is happening on my computer:

                      before                  after
    400MiB anon       8.925s                  0.028s
    400MiB shmem      1.639s                  0.003s
    2GiB anon         failed after 20.003s    0.011s

Link: https://lore.kernel.org/ar2YlFYjYUZ49ZA5@chrisdown.name
Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Cc: Vineeth Pillai <vineeth@bitbyteword.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
---

 mm/shmem.c    |    4 ++++
 mm/swapfile.c |    2 ++
 2 files changed, 6 insertions(+)

--- a/mm/shmem.c~mm-make-swapoff-interruptible-when-unusing-mms-shmem
+++ a/mm/shmem.c
@@ -1742,6 +1742,10 @@ static int shmem_unuse_inode(struct inod
 		if (ret < 0)
 			break;
 
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
 		start = indices[folio_batch_count(&fbatch) - 1];
 	} while (true);
 
--- a/mm/swapfile.c~mm-make-swapoff-interruptible-when-unusing-mms-shmem
+++ a/mm/swapfile.c
@@ -2628,6 +2628,8 @@ static inline int unuse_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		cond_resched();
+		if (signal_pending(current))
+			return -EINTR;
 		next = pmd_addr_end(addr, end);
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch

