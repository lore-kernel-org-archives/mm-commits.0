Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FA52F7EF5;
	Tue, 25 Aug 2026 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787679893; cv=none; b=ZvImlPeC7SybexUZ4W0caGJ//F8OrQ5V9aaiKZJLJS6CtJGlSHnubUPjKmBsQNK0Ka9D16XYEF2sKIucOnZQBFwR2EKxp0xGnv7xtdydOYSXDUG+3JGDzfUsxtBzL7wzEooPoch67ezxed6EzLhMgJ8rw0AlvrrDvdvk3BN8u+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787679893; c=relaxed/simple;
	bh=IvWFykD79hZlQAf9Yz33kNHckU0lf7DJHusgEUFmvI4=;
	h=Date:To:From:Subject:Message-Id; b=Cbxrj1yy0QnPlX2fKj7Tnca1kg5rt93GMQcGzsRJDvq9eCQA4Awpn5mJ53LxP7JvkF2b1AcZbfZuu8WRIv/ZmAGjOpCOQUgbMXKLl5o19HdzHssa6ZSNVsWCgVZERCmY08O8f58H4r3QCYjDTjNC791c6B3b1MKNf6umH53wz78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KtXVxjWJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KtXVxjWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDE61F000E9;
	Tue, 25 Aug 2026 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787679891;
	bh=uFyJO5DeWFx0FRxNd0kZ245YNDEH+Lh6CCL2arLJneE=;
	h=Date:To:From:Subject;
	b=KtXVxjWJXF0027Zk2GiBmK0RV49U+VN7gsp0S9l+bpjf1TRpIL7c1D2PSuVl0IpaL
	 dXoA9Q02Pv0265Dq4Yqr14PraYF9Gd+sSRjxH01Lgtr1AyutztdTUXkQAU0uM7Px21
	 0HuFxdRLFMwzCwUrp0puzyevMP4cxS0CIfWdkdrs=
Date: Tue, 25 Aug 2026 10:44:50 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,stable@vger.kernel.org,shinichiro.kawasaki@wdc.com,reinette.chatre@intel.com,nilay@linux.ibm.com,kbusch@kernel.org,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch added to mm-hotfixes-unstable branch
Message-Id: <20260825174451.5EDE61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "once: don't use a work queue to reset sleepable static key"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch

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
From: Eric Dumazet <edumazet@google.com>
Subject: Revert "once: don't use a work queue to reset sleepable static key"
Date: Tue, 25 Aug 2026 14:25:15 +0000

This reverts commit e8eef69a99f185e75909adb24ab93d706e07bf27.

While DO_ONCE_SLEEPABLE() is used from sleepable/process context, callers
may still be holding arbitrary subsystem locks.

For instance, __inet_hash_connect() uses get_random_sleepable_once() which
invokes DO_ONCE_SLEEPABLE() while holding the socket lock (sk_lock):

  lock_sock(sk)
    __inet_hash_connect()
      get_random_sleepable_once()
        DO_ONCE_SLEEPABLE()
          __do_once_sleepable_done()
            static_branch_disable()
              static_key_disable()
                cpus_read_lock()

Calling static_branch_disable() directly from __do_once_sleepable_done()
causes static_key_disable() to synchronously acquire cpus_read_lock()
(cpu_hotplug_lock) and jump_label_mutex inside the caller's lock context.

This introduces an unwanted lockdep dependency:
  sk_lock -> cpu_hotplug_lock

Because cpu_hotplug_lock depends on fs_reclaim (via workqueue CPU bringup
allocating memory with GFP_KERNEL), and storage/block layers (such as
NVMe-TCP) acquire sk_lock during I/O dispatch, lockdep reports circular
locking dependencies:

  set->srcu -> sk_lock -> cpu_hotplug_lock -> fs_reclaim -> q_usage_counter -> elevator_lock -> set->srcu

This false positive previously prompted commit 19bdb70c77d3 ("nvme-tcp:
lockdep: use dynamic lockdep keys per socket instance") to work around the
warning using per-socket dynamic keys in NVMe-TCP.  That in turn broke
asynchronous socket teardown and caused syzbot warnings in
tcp_tsq_handler().

Restoring once_disable_jump() in __do_once_sleepable_done() ensures that
static_branch_disable() is executed asynchronously from a system workqueue
without holding the caller's locks.

Link: https://lore.kernel.org/20260825142515.1965654-1-edumazet@google.com
Fixes: e8eef69a99f1 ("once: don't use a work queue to reset sleepable static key")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Closes: https://lore.kernel.org/lkml/ao0mwtt8ePAINFni@shinhome/
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/once.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/once.c~revert-once-dont-use-a-work-queue-to-reset-sleepable-static-key
+++ a/lib/once.c
@@ -93,6 +93,6 @@ void __do_once_sleepable_done(bool *done
 {
 	*done = true;
 	mutex_unlock(&once_mutex);
-	static_branch_disable(once_key);
+	once_disable_jump(once_key, mod);
 }
 EXPORT_SYMBOL(__do_once_sleepable_done);
_

Patches currently in -mm which might be from edumazet@google.com are

mm-mempolicy-fix-sleeping-allocation-in-alloc_pages_bulk_weighted_interleave.patch
revert-once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch

