Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B8B225A38
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 01:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744767049; cv=none; b=YbgVNtegx4kksUBYzGp837rCJ9vdEW9rQkuS87mUtEfmPglpOJdPg/SuYPyo/oKzjXxLB1anBQKJBySrFbCwRqyaB+1Obz1TkW5GyqTnjPqNZGrfqzDUnJbEzylak0ggBc6gsMXhQxUbU21/btVEAuO7Tl39TXbpYf89Qnbbapg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744767049; c=relaxed/simple;
	bh=h4Dg8LHprQp3bTXiwatLUP/24ieMNea7se2p8fmiOvk=;
	h=Date:To:From:Subject:Message-Id; b=lQn3TqV864b1JSxBPmDRsHCiTpsMJ5LCocwUo+lWtkz40e7DS1erweewIsNnP6QGLJC+h0ekM1FqIzEw4o/G49IYvrnxcqoxQttuV2+UMDWdAMHk6QxZpFZCatFr4OHucHpeulrdZQ0QtvhLiSG+YFGyplstBKXsmCzPIsAfPWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hNK7xPYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hNK7xPYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0E7C4CEE7;
	Wed, 16 Apr 2025 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744767049;
	bh=h4Dg8LHprQp3bTXiwatLUP/24ieMNea7se2p8fmiOvk=;
	h=Date:To:From:Subject:From;
	b=hNK7xPYtZ59Geul4sS0RAq07MSSyTq+GtGK8sYBmPa25EuFNIGszfVRWQtMBe+1H/
	 hWfiPi7ixqGHqvhh0wvyz0RooLeRcxuJghck25Zxb0rYqP+DrzQ128FOizNACBzryY
	 oLPT5P4jrlhYtAZ5nBsco41kMRdMD0ZLLdqdK4cI=
Date: Tue, 15 Apr 2025 18:30:48 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-move-sanity-checks-in-do_wp_page-after-mapcount-vs-refcount-stabilization.patch added to mm-hotfixes-unstable branch
Message-Id: <20250416013049.1A0E7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: move sanity checks in do_wp_page() after mapcount vs. refcount stabilization
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-move-sanity-checks-in-do_wp_page-after-mapcount-vs-refcount-stabilization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-move-sanity-checks-in-do_wp_page-after-mapcount-vs-refcount-stabilization.patch

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

fs-dax-fix-folio-splitting-issue-by-resetting-old-folio-order-_nr_pages.patch
mm-memory-move-sanity-checks-in-do_wp_page-after-mapcount-vs-refcount-stabilization.patch
kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch
kernel-events-uprobes-pass-vma-to-set_swbp-set_orig_insn-and-uprobe_write_opcode.patch
kernel-events-uprobes-uprobe_write_opcode-rewrite.patch

