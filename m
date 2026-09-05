Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69F64FB9B8;
	Sat,  5 Sep 2026 18:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634108; cv=none; b=Bi7yuu4RHiS3/8yYLI9Zf0QbzN3HcR4VfJlg1XkxPQP8SH5qQxPasv2gEMnT4tk2eRIEKd/27+voH/08Cxa5fHt5McXGmWR5+bFK/XoH9DaIitt9ZUKDoOEvembgI6spkYZc3u33xJBmdj4Bs5MBlqUnOvwzYB1kZFsA1m7TY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634108; c=relaxed/simple;
	bh=SgGW7XAUqxe263il9rfD0UQJSlcj1UOrXjUZ9vXd2uc=;
	h=Date:To:From:Subject:Message-Id; b=nVjEWo3AjWHj/Lw4T5gNgTOezxhP8rXl/Nrvfc/VnZvrEkNQQ71S/gmmDwoOWbNW73G0sADIzGpJ7aM1FMl8Y2HwwNPbfgHai4rdcdaDrydkMshfS6ZJJn3qN2NJq6Z3nDuWdAkWfvhi3I2E2R5ayhzZsD5ch4eHexuAd1+4avQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ivoX7d5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ivoX7d5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE651F00A3D;
	Sat,  5 Sep 2026 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788634106;
	bh=SjNdGSIP2enBqAL6ENQE2zlAznisnM+P10BX5f2BlrE=;
	h=Date:To:From:Subject;
	b=ivoX7d5TTnfWNB2AB/l0u/MEk6+ZGbjYud3pTL5S/5XlXLI7KdLGrzwJl3cRFKySS
	 eTAH7I/XfiaKjdSr2oto7DjGOPoAd2L/Dre08TXMijr8pQ6lZtX59tHeEAa0qNMnu/
	 pyKKzCLH0PBi6NKSByy06ortHHGEkR4A/4Rdk+lA=
Date: Sat, 05 Sep 2026 11:48:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,hughd@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio.patch removed from -mm tree
Message-Id: <20260905184826.8AE651F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()
has been removed from the -mm tree.  Its filename was
     mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()
Date: Tue, 1 Sep 2026 11:01:09 -0700

NR_MLOCK is updated from interrupt context.  __free_pages_prepare() clears
a stray PG_mlocked and adjusts NR_MLOCK, and a folio can reach it with the
flag still set from a bio completion handler:

  __free_pages_ok+0x6af/0x7a0
  <IRQ>
  __bio_release_pages+0xde/0x260
  __iomap_dio_bio_end_io+0x16e/0x1a0
  blk_update_request+0x14b/0x3d0
  blk_mq_end_request+0x18/0x30
  blk_done_softirq+0x49/0x60

The folio gets there like this.  A MAP_SHARED file mapping is mlocked, so
its page cache folios carry PG_mlocked, and an O_DIRECT write sourced from
that mapping GUP-pins those same folios.  munlock() then runs
mlock_vma_pages_range(), which clears VM_LOCKED before walking the page
tables to munlock each folio.  A concurrent hole punch reaches the folio
through the rmap (i_mmap_rwsem, not mmap_lock) and can land inside that
window: __folio_remove_rmap() -> munlock_vma_folio() sees VM_LOCKED
already clear, so it neither queues the folio on the mlock batch nor takes
a reference, and the pte it clears makes the pending mlock_pte_range()
walk skip the folio at its !pte_present() check.  filemap_remove_folio()
then drops the page cache reference, leaving the bio's pin as the last
one, released from the completion handler above.

So __zone_stat_mod_folio() here needs interrupts disabled, not merely
preemption, and __munlock_folio() has a path where they are not: when the
folio has already been taken off the LRU by somebody else the function
jumps straight to the counter update without taking the lruvec lock.  The
read-modify-write of the per-CPU NR_MLOCK diff can then be interrupted by
the softirq above, and one of the two decrements is lost, leaving Mlocked
in /proc/meminfo permanently overstated.

Use zone_stat_mod_folio().  mod_zone_state()'s this_cpu_try_cmpxchg() is
atomic against a same-CPU interrupt and retries, and on the path where the
lruvec lock is held its cost is negligible next to the lock itself.

The UNEVICTABLE_PG* events are deliberately left on the __ accessors: they
occupy different vm_event_states slots from the UNEVICTABLE_PGCLEARED that
__free_pages_prepare() bumps, and nothing updates those two from interrupt
context.

Link: https://lore.kernel.org/20260901180109.3797944-1-shakeel.butt@linux.dev
Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6a931c5a.08e933ee.dbf97.0093.GAE@google.com/
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio
+++ a/mm/mlock.c
@@ -141,7 +141,7 @@ static struct lruvec *__munlock_folio(st
 
 munlock:
 	if (folio_test_clear_mlocked(folio)) {
-		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
 		if (isolated || !folio_test_unevictable(folio))
 			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
 		else
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch

