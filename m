Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793387252;
	b=LO09FRitG0uVEB2fbvN03j+ZNFRM8qp9H5ZxlhAxRIjzsAJ41cRb024LEyQUNc0OQ89d
	 wni4MlhgNZBQG28PSt/DUcVwd2DuBPkJl87XrAgacZAtHQ44wrYuTUyg66s/ex78/+BDF
	 7pDBuD6YsZhtR+B6VtjiUKBP3SROVEoTX2g5IQMpoDhCQv6D3m54qLPb9E0sll6N/tOKH
	 Mk2ioo1YQ2SprGNaF/RX5jNR2ZifNGrvIqzmTtuMgR1Xwi81VNOmbMUPqGHkpHCXLGbYT
	 W7om9qO0eg/4Dju6UC2TaJGMcN5XyxwnO/tSqscSfCvvdJHmRrwAQ2KgQl65uwao0zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793387252;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2MEbwpwmVEb5ZNBZ4RlzH+TGeY3SrFEDe0lsquxxhuE=;
	b=ytpo6n5dh6wR1e9Ea7ev5uOeSntSHj8JHc175S+Zqmjc+TIewywUGYMNNQjRQoJZsouZ
	 S4HGSyxZI8h8D1rpnxcGQUr/frX4oySwKIAb7OwfDYJ6t7+iAydJu8USeaa7IB6X2w6Z6
	 YdnKWNr6wjS9s4gnZssPydXBjk1s+J2qIb5oXiydttDE9wbCHV+hAMKpTvOjK1NYDof0k
	 P2NNBaTGfxLX78AL/xWKkItpZ/LBK4e/y82qFpMH7PTPDP6Be5WKZNrJleBWPZaqnTQVH
	 ClX85vWlw/2GieGvA/uu32GDKtQx6BttyMWigu751uPmxq+k/XlPoUaGA0EtVeHjCGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uyuDaxq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F349E606A331;
	Fri, 30 Oct 2026 19:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uyuDaxq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859691F00A15;
	Fri, 30 Oct 2026 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793387251;
	bh=2MEbwpwmVEb5ZNBZ4RlzH+TGeY3SrFEDe0lsquxxhuE=;
	h=Date:To:From:Subject;
	b=uyuDaxq2dKFURP0SqM307yRpC6yD2zfjwdiYWAN53/AX8lv5nD2EOrqP8gqOUh/0G
	 fIN0p6MB6Nxnj2gBeZrFzeXR+lrHUXvkESCHumQLTQKCKzL2mhZ2IP4O00+w8nyRkh
	 5Mne5PMCCZx5JJ6LT8QrioWNyZTuEJ5wR4zFOS0w=
Date: Fri, 30 Oct 2026 12:07:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@kernel.org,
	catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch added to mm-new branch
Message-Id: <20261030190731.859691F00A15@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: kmemleak: scan modified objects as soon as they are grayed
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch

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
Subject: mm: kmemleak: scan modified objects as soon as they are grayed
Date: Fri, 30 Oct 2026 11:31:10 -0700

kmemleak keeps reporting the guard page of a systemd-journald thread stack
on Meta's debug kernels, even with min_unref_scans set:

  unreferenced object 0xffff88829a30ae40 (size 256):
    comm "systemd-journal", pid 961, jiffies 4294814590
    backtrace (crc 49b3881c):
      kmem_cache_alloc_noprof+0x2ee/0x630
      vm_area_dup+0x36/0x750
      __split_vma+0xef/0x7d0
      vma_modify+0x11c3/0x18a0
      vma_modify_flags+0x1ea/0x2a0
      mprotect_fixup+0x249/0x630
      do_mprotect_pkey+0x531/0x820
      __x64_sys_mprotect+0x7c/0x90

The VMA is still mapped.  It was never faulted in, so it has no anon_vma
and no file, and the only pointer to it is a slot in a maple tree leaf. 
The mm tree runs in RCU mode: every write replaces the leaf with a copy
and frees the old one after a grace period.  journald rewrites its tree
every couple of seconds, while a scan on a large debug host takes many
minutes, so the leaf kmemleak queued is freed before its turn, and the
copy that replaced it was linked after its parent had been scanned.

The pass over modified objects is meant to catch such moved references,
and the new leaf, being a new white object, does get grayed there.

But the gray list is only scanned after the whole object_list walk, and by
then that copy has been replaced and freed as well.  The confirmation scan
has no such pass, so the miss repeats round after round no matter how many
consecutive scans are required.

Scan the gray list during the walk instead, within a jiffy of an object
being grayed.  Do it from a variant of kmemleak_cond_resched(), which
already pins the current object while the RCU read lock is dropped.  The
live leaf is then read shortly after the walk reaches it, before it can be
freed.

Scanning the gray list after every grayed object made a full scan 41%
slower (1.72s -> 2.42s, arm64 guest with lockdep) when the pass grays a
million objects that do not point to each other.  Scanning it at most once
a jiffy keeps that at the baseline, leaves idle, file storm and mmap churn
workloads unchanged, and still removes the false positives at HZ=100.

I was able to come up with a reproducer that reproduces these false
positives most of the time:

https://github.com/leitao/linux/commit/1291579c487303c5ffbea2cf532649d26329c8a9

Link: https://lore.kernel.org/20261030-kmemleak-gray-drain-v2-1-3ec29a96668e@debian.org
Fixes: 04609ccc40c4 ("kmemleak: Reduce the false positives by checking for modified objects")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/kmemleak.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed
+++ a/mm/kmemleak.c
@@ -1696,8 +1696,10 @@ static void scan_gray_list(void)
  * Conditionally call resched() in an object iteration loop while making sure
  * that the given object won't go away without RCU read lock by performing a
  * get_object() if necessaary.
+ * If @scan_gray is set, also scan the gray list while the RCU lock is dropped.
  */
-static void kmemleak_cond_resched(struct kmemleak_object *object)
+static void __kmemleak_cond_resched(struct kmemleak_object *object,
+				    bool scan_gray)
 {
 	if (!get_object(object))
 		return;	/* Try next object */
@@ -1709,6 +1711,8 @@ static void kmemleak_cond_resched(struct
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
+	if (scan_gray)
+		scan_gray_list();
 	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
@@ -1721,6 +1725,26 @@ unlock_put:
 	put_object(object);
 }
 
+static void kmemleak_cond_resched(struct kmemleak_object *object)
+{
+	__kmemleak_cond_resched(object, false);
+}
+
+/*
+ * Scan newly grayed objects within a jiffy, not after the object_list walk:
+ * one may hold the only reference to another and be freed by then, like a
+ * maple tree node being replaced.
+ */
+static void kmemleak_resched_drain(struct kmemleak_object *object,
+				   unsigned long *last_drain)
+{
+	if (need_resched() ||
+	    (!list_empty(&gray_list) && time_after(jiffies, *last_drain))) {
+		__kmemleak_cond_resched(object, true);
+		*last_drain = jiffies;
+	}
+}
+
 /*
  * Scan all task kernel stacks, rescheduling between tasks. Each task is looked
  * up and pinned within its own RCU read-side section, so no lock is held across
@@ -1909,6 +1933,7 @@ static int scan_zone_pages(struct zone *
 static int __kmemleak_scan(bool full)
 {
 	struct kmemleak_object *object;
+	unsigned long last_drain;
 	struct zone *zone;
 	int __maybe_unused i;
 	int stop = 0;
@@ -2003,10 +2028,10 @@ scan_gray:
 	 * Check for new or unreferenced objects modified since the previous
 	 * scan and color them gray until the next scan.
 	 */
+	last_drain = jiffies;
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		if (need_resched())
-			kmemleak_cond_resched(object);
+		kmemleak_resched_drain(object, &last_drain);
 
 		/*
 		 * This is racy but we can save the overhead of lock/unlock
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch

