Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41588389473;
	Fri, 21 Aug 2026 18:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787337376; cv=none; b=FbnzYYWsKTws/lH85UsXlGoBNNC24YCOxMZwBMMtRV0dx/5P/nWK3rNXS5ObYiQtDNIJQZMK7pSRDpqDhWytKrjzxMjv4mhDoSay68k2AQfp3dG65PgX50bpOo+Oeu2F489CHYshO35iD0kYiDIYkaJCYlKGErjOSLMrvLKnUO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787337376; c=relaxed/simple;
	bh=cCjfNaLYwXJJ5NuRIOTwji6zpxQP6tWEArGHuW1h3AA=;
	h=Date:To:From:Subject:Message-Id; b=YcNHOOq0eTM291aRfESQtXNI818t+Hxrz8xuz0nN4HzqYng3KrssJF9hZ4K0Qt5/X97uqi686MJtwUrl3nVYRTH+fu8pSfXZfatULXcOwSbFNRN382pdzSRa007UOzUjVL5uwC8SHpDNJ/YrRejg5uUeDUF7YO4IylW7CRT6eB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Orumuhkd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Orumuhkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6646C1F000E9;
	Fri, 21 Aug 2026 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787337373;
	bh=XQxaU1vWKgjENkU9EpWsz8KK+8s1eCGf4bLaKnLTrBs=;
	h=Date:To:From:Subject;
	b=Orumuhkdo0B0jQmBfvSEgO6KF5GssEk/vLibQpegzGf5bWVlDC0BSAslU63BeraWC
	 RLqwzNHUGT+OdfWtK/UN1vdB16qbQxTT8GzGAQsYdu7gMr5hhAyQ8nXdOFLF+7Npna
	 /k6hf6nz1i7phzXIDnWPUgYJzmMXs9SMNm2zHX5k=
Date: Fri, 21 Aug 2026 11:36:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,include@grrlz.net,broonie@kernel.org,bhelgaas@google.com,akpm@linux-foundation.org,drj19981414013@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-fix-lost-wakeup-when-waiting-for-a-muxed-region.patch added to mm-nonmm-unstable branch
Message-Id: <20260821183613.6646C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: fix lost wakeup when waiting for a muxed region
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-fix-lost-wakeup-when-waiting-for-a-muxed-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-fix-lost-wakeup-when-waiting-for-a-muxed-region.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: DAI RENJIE <drj19981414013@gmail.com>
Subject: resource: fix lost wakeup when waiting for a muxed region
Date: Fri, 21 Aug 2026 14:08:17 +0000

A task waiting for a muxed region can sleep forever in
TASK_UNINTERRUPTIBLE even though the region it waits for is already free. 
__request_region_locked() queues itself on muxed_resource_wait and drops
resource_lock before setting TASK_UNINTERRUPTIBLE, while
__release_region() wakes the queue after dropping the same lock.  A wakeup
landing in between finds TASK_RUNNING, does not match TASK_NORMAL and is
discarded; callers hold a muxed region only across a bounded transaction,
so no further release is coming.  The task is unkillable and its caller
never returns.

The window is one store wide, but an interrupt is enough to hold the
waiter in it, and the machine this was seen on runs PREEMPT_DYNAMIC in its
voluntary default.  Since v6.11 spd5118 exports the DDR5 sensors of AMD
boards through i2c-piix4, which takes a muxed region per SMBus
transaction; a third of the in-tree users of request_muxed_region() are
hwmon drivers, so reading a world-readable attribute is all an
unprivileged user needs to drive the contention.  The blocked task sleeps
holding the i2c adapter bus lock, and 27 more piled up behind it.

Reproduced by building a kernel with the two orderings selectable at
runtime and a 2ms delay inside the window.  Switching only that knob, a
two-thread barriered reproducer loses the wakeup 200 times out of 200
before the fix and 0 out of 200 after it; without the delay it goes 20000
times through the wait path and loses none.

Fix it by setting the task state before dropping resource_lock, as
prepare_to_wait() does: the releasing side needs resource_lock to unlink
the resource, so it cannot reach the wakeup before the state is published.

Link: https://lore.kernel.org/20260821-b4-resource-muxed-lost-wakeup-v1-1-37eb6473a76c@gmail.com
Fixes: 8b6d043b7ee2 ("resource: shared I/O region support")
Signed-off-by: DAI RENJIE <drj19981414013@gmail.com>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~resource-fix-lost-wakeup-when-waiting-for-a-muxed-region
+++ a/kernel/resource.c
@@ -1350,8 +1350,8 @@ static int __request_region_locked(struc
 		}
 		if (conflict->flags & flags & IORESOURCE_MUXED) {
 			add_wait_queue(&muxed_resource_wait, &wait);
-			write_unlock(&resource_lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
+			write_unlock(&resource_lock);
 			schedule();
 			remove_wait_queue(&muxed_resource_wait, &wait);
 			write_lock(&resource_lock);
_

Patches currently in -mm which might be from drj19981414013@gmail.com are

resource-fix-lost-wakeup-when-waiting-for-a-muxed-region.patch

