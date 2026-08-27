Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB0137419B;
	Thu, 27 Aug 2026 20:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861320; cv=none; b=fAhiZmuXx2zK56/Ti7k0pY+hCWH4fLR0cygQuUC1Ex64GQjyRaRBdJKI9SjBM+fZheDQEpeAJL7uIASviH9+6qQ76aCDtWmak7iy9JksYw6m6TTyWFAhBzJ9UWGBaBeYy6JDJeGexAZ/cnWl6HJrgTDTZHZdUALVFDhkIMI/0vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861320; c=relaxed/simple;
	bh=3X+F5cVfe+N45Y+7/2JIOIpsN5Xyd+zbUEiAPA5bmss=;
	h=Date:To:From:Subject:Message-Id; b=jIY6DpGDF+HERwCaON8rzjxJlr0NemtmCuEAFek77DP3tf6tW8weRwxTd8abD0rhcXrkuZYdNt8mV5gV/5/dkGw5QQIq5orjn8ju1+YPuOfROAOcgfgpkxW9O1U9ZRH1QRcXph239ybE6nHJbfkzGzhafW9hib/9bDjrysSAYQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=naIlsepY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="naIlsepY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206901F00A3D;
	Thu, 27 Aug 2026 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861319;
	bh=Lra4yMoc3Mrb8NdHSSXxmiXjD4KVpC9BAZA2UmKdN+M=;
	h=Date:To:From:Subject;
	b=naIlsepYzi42d/wQr8CZt9++8LncfgJAXsgcLXx9IbWDAtbeaQeiUMV/HUj7ooIux
	 4CVUQXA3HDHQhBXf345NXls1TBcNM+MiqKDb0n8hurgQh96MF6R2uLb20t11HJhbP0
	 V1IoaD3i9drTRG+n+fZ33gfGYUGvvhsCu2mRQyZs=
Date: Thu, 27 Aug 2026 13:08:38 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,stable@vger.kernel.org,shinichiro.kawasaki@wdc.com,reinette.chatre@intel.com,nilay@linux.ibm.com,kbusch@kernel.org,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch removed from -mm tree
Message-Id: <20260827200839.206901F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "once: don't use a work queue to reset sleepable static key"
has been removed from the -mm tree.  Its filename was
     revert-once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


