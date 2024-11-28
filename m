Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07FA2581;
	Thu, 28 Nov 2024 00:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755053; cv=none; b=nqAgLS/QBQ89VwJkCsF8yyn3msa7ONttKa1H6LyO/+Ok1oJBRDjNTp1HX63QflBxKLLA2wMqATnt6R3WQfydwPf8EJayYG/fETR2cMAg0GpZnqnuOMs+m00dW8R22F82glfzBthcMf13jh/QHjoHACugwBiIqelezj6gKt07EtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755053; c=relaxed/simple;
	bh=D5svZbTVbynBEl6/YhB5PXpLnr2+ZAb58sbP34BExf4=;
	h=Date:To:From:Subject:Message-Id; b=aWCK54j1MY32HIVjdqN3s/s9QmZNErlmwpc7NjqarVn+Q+KSFzCC//R7aHBLEyAlnCvXdt5suJgcF7vmzvnVUwWW5tVgWB2M+F4ygmRqTa2He1o/LsBqnZa+Ejlb5LTkh1t4+v54XMPoLtwRViXCedDNywtERD2cj8NO03yFudw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WYrp5Cow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WYrp5Cow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCB4C4CECC;
	Thu, 28 Nov 2024 00:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755053;
	bh=D5svZbTVbynBEl6/YhB5PXpLnr2+ZAb58sbP34BExf4=;
	h=Date:To:From:Subject:From;
	b=WYrp5CowNbDFW3q3aDZ31tciq+pNQNwDVwhFe6diPJmr/GHt3P9FXTIlzyJMZb3dW
	 lbp4qbCpmc31g7KbMEb6K1sVLFJUpyM7kzhB3xgf5PXEZQYXidn9N6YoNLfpEqnYAo
	 GOYCXWm7fcISy1F0ES7IGiJfORh21919tHYwilRY=
Date: Wed, 27 Nov 2024 16:50:52 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mgorman@techsingularity.net,snishika@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128005053.8CCB4C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: ensure kswapd is woken up if the wait queue is active
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Seiji Nishikawa <snishika@redhat.com>
Subject: mm: vmscan: ensure kswapd is woken up if the wait queue is active
Date: Wed, 27 Nov 2024 00:06:12 +0900

Even after commit 501b26510ae3 ("vmstat: allow_direct_reclaim should use
zone_page_state_snapshot"), a task may remain indefinitely stuck in
throttle_direct_reclaim() while holding mm->rwsem.

__alloc_pages_nodemask
 try_to_free_pages
  throttle_direct_reclaim

This can cause numerous other tasks to wait on the same rwsem, leading
to severe system hangups:

[1088963.358712] INFO: task python3:1670971 blocked for more than 120 seconds.
[1088963.365653]       Tainted: G           OE     -------- -  - 4.18.0-553.el8_10.aarch64 #1
[1088963.373887] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1088963.381862] task:python3         state:D stack:0     pid:1670971 ppid:1667117 flags:0x00800080
[1088963.381869] Call trace:
[1088963.381872]  __switch_to+0xd0/0x120
[1088963.381877]  __schedule+0x340/0xac8
[1088963.381881]  schedule+0x68/0x118
[1088963.381886]  rwsem_down_read_slowpath+0x2d4/0x4b8

The issue arises when allow_direct_reclaim(pgdat) returns false,
preventing progress even when the pgdat->pfmemalloc_wait wait queue is
empty. Despite the wait queue being empty, the condition,
allow_direct_reclaim(pgdat), may still be returning false, causing it to
continue looping.

In some cases, reclaimable pages exist (zone_reclaimable_pages() returns
 > 0), but calculations of pfmemalloc_reserve and free_pages result in
wmark_ok being false.

And then, despite the pgdat->kswapd_wait queue being non-empty, kswapd
is not woken up, further exacerbating the problem:

crash> px ((struct pglist_data *) 0xffff00817fffe540)->kswapd_highest_zoneidx
$775 = __MAX_NR_ZONES

This patch modifies allow_direct_reclaim() to wake kswapd if the
pgdat->kswapd_wait queue is active, regardless of whether wmark_ok is true
or false.  This change ensures kswapd does not miss wake-ups under high
memory pressure, reducing the risk of task stalls in the throttled reclaim
path.

Link: https://lkml.kernel.org/r/20241126150612.114561-1-snishika@redhat.com
Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active
+++ a/mm/vmscan.c
@@ -6389,8 +6389,8 @@ static bool allow_direct_reclaim(pg_data
 
 	wmark_ok = free_pages > pfmemalloc_reserve / 2;
 
-	/* kswapd must be awake if processes are being throttled */
-	if (!wmark_ok && waitqueue_active(&pgdat->kswapd_wait)) {
+	/* Always wake up kswapd if the wait queue is not empty */
+	if (waitqueue_active(&pgdat->kswapd_wait)) {
 		if (READ_ONCE(pgdat->kswapd_highest_zoneidx) > ZONE_NORMAL)
 			WRITE_ONCE(pgdat->kswapd_highest_zoneidx, ZONE_NORMAL);
 
_

Patches currently in -mm which might be from snishika@redhat.com are

mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active.patch

