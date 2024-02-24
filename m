Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E78433D5;
	Sat, 24 Feb 2024 01:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738072; cv=none; b=Vzd2SO0A7+PI0hixb9Xr1N+eCD5P0IR/fuacCJ0AymN7ELLqRZo7ByvHTZd9h0Nl/91Pszpjo1Ff23RACRGvv/Wkp9mWPUpa9u0NS1hOEYxg/9wQ81NmUdwxkEQTo6mRzGo55zMgV/uXrSsVXOOz5tdsWX1Mp8ZmhCNf5p0s0z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738072; c=relaxed/simple;
	bh=8ZAAk5VgMUnKuccmnCOoGGYPN3supMsTtoCZnsWaOos=;
	h=Date:To:From:Subject:Message-Id; b=ZQMQZsD12YMpFknO4nMzUBPxa/QgflKQ424u2nnd9r4HWoBv/dp7sXVOpGxoFBF6LZA3M+nNYAaSpT6U8e8i8GPj1TFUo3yLeN6SqIJpRm4WOYlAylF6cBKRd7kR5O3iA1qiWgJl4hNEaVLE5026fidThm46FgL3xmOsQVLtKdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mgcKDGH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mgcKDGH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89E2C433F1;
	Sat, 24 Feb 2024 01:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738071;
	bh=8ZAAk5VgMUnKuccmnCOoGGYPN3supMsTtoCZnsWaOos=;
	h=Date:To:From:Subject:From;
	b=mgcKDGH++Q1pE3lhzH5PlM9NWuYLUH5WfqO/ofYEl2DewVmy6YCQgCvpBtraDx2xz
	 OKiM6CIkilV7xdmG8/79AmFEUM1OCy7gpdyW6EpfpcKFRif/ZcuKTGx3izyQthv3KP
	 Hdi+n7QC3/rUNs3cP8z6rY+z/wEX42Cz39hbAEAQ=
Date: Fri, 23 Feb 2024 17:27:51 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,stable@vger.kernel.org,osalvador@suse.de,hyeongtak.ji@sk.com,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch removed from -mm tree
Message-Id: <20240224012751.A89E2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: fix a bug calling wakeup_kswapd() with a wrong zone index
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch

