Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820802517A8
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945881; cv=none; b=G20XMIdO5z/qvl38IS1gdWsQq6RdhMjTV7Z26ZEzuEgjvrIEuk6AdCdGT+uMkcpvnP4q+yGXmUQKbWJHpumpT2xKmD+Z0twEJuc/ZSrnNOUxiLvmfoHcEx0ppjbLlgNxucke0BD8zMvm2047sjJItCrem+ICF6GmLWDtwgYFnGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945881; c=relaxed/simple;
	bh=y2ENtEUy9Vbsnjb9GfiCgZ06g/ey8x7vY3qgDHbUkiE=;
	h=Date:To:From:Subject:Message-Id; b=J8jVmkHLhpSxuPW3Sp4roSOYjbN99nW/H8fbvXiREoLlS5w2io4Abq7YPaSNm2nRh693U5iybx/ZmtcA3gvET5LlwNmQmx+m56SmIYbpnD6ad/f5AYaHYEw7gPWeE53k1QsYtWG6OAVA66LnX6E+vZRfUp7NpfoZrSPlILzzvHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BGUnxY9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BGUnxY9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD775C4CEE4;
	Fri, 18 Apr 2025 03:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945880;
	bh=y2ENtEUy9Vbsnjb9GfiCgZ06g/ey8x7vY3qgDHbUkiE=;
	h=Date:To:From:Subject:From;
	b=BGUnxY9gaICUv6IbixWkUDnPH0VBxCMe+tXRvgWLm2LuZkfGzYv1SCuV20zA61FBw
	 iGEH1gkZ1D1/MJ4B+2fXpVztdfm4MUq48q8yQP65+6hN1DAe2dXKRciFGSz9+d7RyQ
	 dWiYWTxTm4NAlmlLs48TAcVKN2k2nT6Qmx79wQHo=
Date: Thu, 17 Apr 2025 20:11:19 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-move-sanity-checks-in-do_wp_page-after-mapcount-vs-refcount-stabilization.patch removed from -mm tree
Message-Id: <20250418031119.DD775C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: move sanity checks in do_wp_page() after mapcount vs. refcount stabilization
has been removed from the -mm tree.  Its filename was
     mm-memory-move-sanity-checks-in-do_wp_page-after-mapcount-vs-refcount-stabilization.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: move sanity checks in do_wp_page() after mapcount vs. refcount stabilization
Date: Tue, 15 Apr 2025 11:50:07 +0200

In __folio_remove_rmap() for RMAP_LEVEL_PMD/RMAP_LEVEL_PUD and with
CONFIG_PAGE_MAPCOUNT we first decrement the folio mapcount (and recompute
mapped shared vs.  mapped exclusively) to then adjust the entire mapcount.

This means that another process might stumble in do_wp_page() over a
PTE-mapped PMD folio that is indicated as "exclusively mapped", but still
has an entire mapcount (PMD mapping), because it is racing with the
process that is unmapping the folio (PMD mapping).  Note that do_wp_page()
will back off once it detects the remaining folio reference from the
process that is in the process of unmapping the folio.

This will trigger the early VM_WARN_ON_ONCE(folio_entire_mapcount(folio))
check in do_wp_page(), that can easily be reproduced by looping a couple
of times over allocating a PMD THP, forking a child where we immediately
unmap it again, and writing in the parent concurrently to the THP.

[  252.738129][T16470] ------------[ cut here ]------------
[  252.739267][T16470] WARNING: CPU: 3 PID: 16470 at mm/memory.c:3738 do_wp_page+0x2a75/0x2c00
[  252.740968][T16470] Modules linked in:
[  252.741958][T16470] CPU: 3 UID: 0 PID: 16470 Comm: ...
...
[  252.765841][T16470]  <TASK>
[  252.766419][T16470]  ? srso_alias_return_thunk+0x5/0xfbef5
[  252.767558][T16470]  ? rcu_is_watching+0x12/0x60
[  252.768525][T16470]  ? srso_alias_return_thunk+0x5/0xfbef5
[  252.769645][T16470]  ? srso_alias_return_thunk+0x5/0xfbef5
[  252.770778][T16470]  ? lock_acquire+0x33/0x80
[  252.771697][T16470]  ? __handle_mm_fault+0x5e8/0x3e40
[  252.772735][T16470]  ? __handle_mm_fault+0x5e8/0x3e40
[  252.773781][T16470]  __handle_mm_fault+0x1869/0x3e40
[  252.774839][T16470]  handle_mm_fault+0x22a/0x640
[  252.775808][T16470]  do_user_addr_fault+0x618/0x1000
[  252.776847][T16470]  exc_page_fault+0x68/0xd0
[  252.777775][T16470]  asm_exc_page_fault+0x26/0x30

While we could adjust the sequence in __folio_remove_rmap(), let's rater
move the mapcount sanity checks after the mapcount vs.  refcount
stabilization phase.  With this fix, a simple reproducer is happy.

While at it, convert the two VM_WARN_ON_ONCE() we are moving to
VM_WARN_ON_ONCE_FOLIO().

Link: https://lkml.kernel.org/r/20250415095007.569836-1-david@redhat.com
Fixes: 1da190f4d0a6 ("mm: Copy-on-Write (COW) reuse support for PTE-mapped THP")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+5e8feb543ca8e12e0ede@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/67fab4fe.050a0220.2c5fcf.0011.GAE@google.com
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-move-sanity-checks-in-do_wp_page-after-mapcount-vs-refcount-stabilization
+++ a/mm/memory.c
@@ -3734,8 +3734,6 @@ static bool __wp_can_reuse_large_anon_fo
 		return false;
 
 	VM_WARN_ON_ONCE(folio_test_ksm(folio));
-	VM_WARN_ON_ONCE(folio_mapcount(folio) > folio_nr_pages(folio));
-	VM_WARN_ON_ONCE(folio_entire_mapcount(folio));
 
 	if (unlikely(folio_test_swapcache(folio))) {
 		/*
@@ -3760,6 +3758,8 @@ static bool __wp_can_reuse_large_anon_fo
 	if (folio_large_mapcount(folio) != folio_ref_count(folio))
 		goto unlock;
 
+	VM_WARN_ON_ONCE_FOLIO(folio_large_mapcount(folio) > folio_nr_pages(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_entire_mapcount(folio), folio);
 	VM_WARN_ON_ONCE(folio_mm_id(folio, 0) != vma->vm_mm->mm_id &&
 			folio_mm_id(folio, 1) != vma->vm_mm->mm_id);
 
_

Patches currently in -mm which might be from david@redhat.com are

kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch
kernel-events-uprobes-pass-vma-to-set_swbp-set_orig_insn-and-uprobe_write_opcode.patch
kernel-events-uprobes-uprobe_write_opcode-rewrite.patch

