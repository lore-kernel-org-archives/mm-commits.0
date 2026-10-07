Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2981717A2F6;
	Wed,  7 Oct 2026 02:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338634; cv=none; b=FUYvwI4xzoujpENT7xUlbPDC038CePMdj2RbK6wrizLEILzNK9Ks6QV8u7lP1f+9lqh7TiJfLu0t7RwVt7VXrqTw6APRCh1EADstGQv6fMIb3CaiV01PwZTkmRV9Eg0p7rTQXXlHE/ENUsBLXRKWE3D1ofCCBQlB+kJPCleXudU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338634; c=relaxed/simple;
	bh=RGid0mU3pHGEdZcx9P+mpMu3dPDYo3kE9VNVDC3zf0w=;
	h=Date:To:From:Subject:Message-Id; b=D496cqaxnstwu4OQg6tUf6+zNujwRESgzTVAvPh4Tbo2IflQJkg5S/+DICBvc9CUyUtPo5joAISVCEuwjUb+MVYEX4V2IGcLlN9xC5nzPOvv5wHVqLrO6Tr0RbPyUsqjzu6das04+Dak+GY1nYc8bo95j0u8egV5KPEtK2OK3j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bsB6lNuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bsB6lNuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1831F0089C;
	Wed,  7 Oct 2026 02:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338632;
	bh=fn066DqE7sB9QHcf5d49HPdGflr7Jz04qjWuI/JqXzs=;
	h=Date:To:From:Subject;
	b=bsB6lNuM7lLJvQj+hKqkLhVmv869qa0sQbV6KdLGkN3/lKmO2xMOER9zY/7cTaGuW
	 +x41yfDLlTnrgeYWguP8GuX7YmHdY9BMmcEDqVSRXKpT4nVQE3WFHb+xPgi1AF1F4S
	 qk7IvS4OeQvlr5jRCStPfuoxxQgm+QtikKQu3YdI=
Date: Tue, 06 Oct 2026 19:03:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,broonie@kernel.org,brads@mainlining.org,bhelgaas@google.com,akpm@linux-foundation.org,drj19981414013@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-fix-lost-wakeup-when-waiting-for-a-muxed-region.patch removed from -mm tree
Message-Id: <20261007020352.BE1831F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: fix lost wakeup when waiting for a muxed region
has been removed from the -mm tree.  Its filename was
     resource-fix-lost-wakeup-when-waiting-for-a-muxed-region.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Cc: Mark Brown <broonie@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>
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


