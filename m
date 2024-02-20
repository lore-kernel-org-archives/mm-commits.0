Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F925336A;
	Tue, 20 Feb 2024 03:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399540; cv=none; b=useY+VVeQT47U9C9q24I1MqAdTWwUex3ea9opQ2F4E8RyYj0O6AD4RrBG9Btv4yLAVuncUxZNDF0icxq++phtLJ/AfGF1R5t+orYEg27IydB8E9RYZMdM0FRm9KJf/0w9xNRBojg61WHHxZRdyX8oELe6oPmnxDBQ7g5YPLws44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399540; c=relaxed/simple;
	bh=Qdoy+M+xlKi0GsrOb4w3F9SIeYLgcxmc4mCg+YDeB9U=;
	h=Date:To:From:Subject:Message-Id; b=nLXIE5oobNcXECubIdqavb5XkEFa0Q5sq8weHLqBIuymY2ykrYUTpmnxue2vYf5l8ZS6OWQZSswN5dxMRQQ2GdnSDCYj6ma18YAQjFgkvWOVuosCpspF4KJg4TCOADSQSdbqdo4udBkDq0ieQU0P7GXLS1mdcEaXdg7om9vXg4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SQYcJSb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SQYcJSb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C25C433F1;
	Tue, 20 Feb 2024 03:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708399539;
	bh=Qdoy+M+xlKi0GsrOb4w3F9SIeYLgcxmc4mCg+YDeB9U=;
	h=Date:To:From:Subject:From;
	b=SQYcJSb70pONVDOWTsgjo0geLI+2xpSSZ7aGVvvwRfuHmEsZyBUPqg0Fvj3B0DAAu
	 MVuhdrkzzupgYWqd6lTwSteHEcu90mDBuBHdsqmHwLc6Boif8MiKVDXwvv4gQuB4bE
	 +P+iU3FrxeLRi3RIucbZKaMtEaxu1F4BPbRzivZ4=
Date: Mon, 19 Feb 2024 19:25:38 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,stable@vger.kernel.org,osalvador@suse.de,hyeongtak.ji@sk.com,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch added to mm-hotfixes-unstable branch
Message-Id: <20240220032539.63C25C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix a bug calling wakeup_kswapd() with a wrong zone index
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch

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
From: Byungchul Park <byungchul@sk.com>
Subject: mm/vmscan: fix a bug calling wakeup_kswapd() with a wrong zone index
Date: Fri, 16 Feb 2024 20:15:02 +0900

With numa balancing on, when a numa system is running where a numa node
doesn't have its local memory so it has no managed zones, the following
oops has been observed.  It's because wakeup_kswapd() is called with a
wrong zone index, -1.  Fixed it by checking the index before calling
wakeup_kswapd().

> BUG: unable to handle page fault for address: 00000000000033f3
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 2 PID: 895 Comm: masim Not tainted 6.6.0-dirty #255
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>    rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> RIP: 0010:wakeup_kswapd (./linux/mm/vmscan.c:7812)
> Code: (omitted)
> RSP: 0000:ffffc90004257d58 EFLAGS: 00010286
> RAX: ffffffffffffffff RBX: ffff88883fff0480 RCX: 0000000000000003
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88883fff0480
> RBP: ffffffffffffffff R08: ff0003ffffffffff R09: ffffffffffffffff
> R10: ffff888106c95540 R11: 0000000055555554 R12: 0000000000000003
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88883fff0940
> FS:  00007fc4b8124740(0000) GS:ffff888827c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000000033f3 CR3: 000000026cc08004 CR4: 0000000000770ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
> ? __die
> ? page_fault_oops
> ? __pte_offset_map_lock
> ? exc_page_fault
> ? asm_exc_page_fault
> ? wakeup_kswapd
> migrate_misplaced_page
> __handle_mm_fault
> handle_mm_fault
> do_user_addr_fault
> exc_page_fault
> asm_exc_page_fault
> RIP: 0033:0x55b897ba0808
> Code: (omitted)
> RSP: 002b:00007ffeefa821a0 EFLAGS: 00010287
> RAX: 000055b89983acd0 RBX: 00007ffeefa823f8 RCX: 000055b89983acd0
> RDX: 00007fc2f8122010 RSI: 0000000000020000 RDI: 000055b89983acd0
> RBP: 00007ffeefa821a0 R08: 0000000000000037 R09: 0000000000000075
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> R13: 00007ffeefa82410 R14: 000055b897ba5dd8 R15: 00007fc4b8340000
>  </TASK>

Link: https://lkml.kernel.org/r/20240216111502.79759-1-byungchul@sk.com
Signed-off-by: Byungchul Park <byungchul@sk.com>
Reported-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Fixes: c574bbe917036 ("NUMA balancing: optimize page placement for memory tiering system")
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/migrate.c~mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index
+++ a/mm/migrate.c
@@ -2519,6 +2519,14 @@ static int numamigrate_isolate_folio(pg_
 			if (managed_zone(pgdat->node_zones + z))
 				break;
 		}
+
+		/*
+		 * If there are no managed zones, it should not proceed
+		 * further.
+		 */
+		if (z < 0)
+			return 0;
+
 		wakeup_kswapd(pgdat->node_zones + z, 0,
 			      folio_order(folio), ZONE_MOVABLE);
 		return 0;
_

Patches currently in -mm which might be from byungchul@sk.com are

mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch
mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority.patch
sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch

