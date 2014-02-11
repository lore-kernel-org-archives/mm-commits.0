From: akpm@linux-foundation.org
Subject: [merged]
 fs-filec-fdtable-avoid-triggering-ooms-from-alloc_fdmem.patch removed from
 -mm tree
Date: Tue, 11 Feb 2014 11:23:34 -0800
Message-ID: <52fa78b6.qqe/QVbWtUYXlsp7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaBKTXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, eric.dumazet@gmail.com, cwang@twopensource.com, ebiederm@xmission.com

Subject: [merged] fs-filec-fdtable-avoid-triggering-ooms-from-alloc_fdmem.patch removed from -mm tree
To: ebiederm@xmission.com,cwang@twopensource.com,eric.dumazet@gmail.com,rientjes@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:34 -0800


The patch titled
     Subject: fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem
has been removed from the -mm tree.  Its filename was
     fs-filec-fdtable-avoid-triggering-ooms-from-alloc_fdmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: ebiederm@xmission.com (Eric W. Biederman)
Subject: fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

Recently due to a spike in connections per second memcached on 3 separate
boxes triggered the OOM killer from accept.  At the time the OOM killer
was triggered there was 4GB out of 36GB free in zone 1.  The problem was
that alloc_fdtable was allocating an order 3 page (32KiB) to hold a
bitmap, and there was sufficient fragmentation that the largest page
available was 8KiB.

I find the logic that PAGE_ALLOC_COSTLY_ORDER can't fail pretty dubious
but I do agree that order 3 allocations are very likely to succeed.

There are always pathologies where order > 0 allocations can fail when
there are copious amounts of free memory available.  Using the pigeon hole
principle it is easy to show that it requires 1 page more than 50% of the
pages being free to guarantee an order 1 (8KiB) allocation will succeed, 1
page more than 75% of the pages being free to guarantee an order 2 (16KiB)
allocation will succeed and 1 page more than 87.5% of the pages being free
to guarantee an order 3 allocate will succeed.

A server churning memory with a lot of small requests and replies like
memcached is a common case that if anything can will skew the odds against
large pages being available.

Therefore let's not give external applications a practical way to kill
linux server applications, and specify __GFP_NORETRY to the kmalloc in
alloc_fdmem.  Unless I am misreading the code and by the time the code
reaches should_alloc_retry in __alloc_pages_slowpath (where __GFP_NORETRY
becomes signification).  We have already tried everything reasonable to
allocate a page and the only thing left to do is wait.  So not waiting and
falling back to vmalloc immediately seems like the reasonable thing to do
even if there wasn't a chance of triggering the OOM killer.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Cong Wang <cwang@twopensource.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/file.c~fs-filec-fdtable-avoid-triggering-ooms-from-alloc_fdmem fs/file.c
--- a/fs/file.c~fs-filec-fdtable-avoid-triggering-ooms-from-alloc_fdmem
+++ a/fs/file.c
@@ -34,7 +34,7 @@ static void *alloc_fdmem(size_t size)
 	 * vmalloc() if the allocation size will be considered "large" by the VM.
 	 */
 	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY);
 		if (data != NULL)
 			return data;
 	}
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch
linux-next.patch

