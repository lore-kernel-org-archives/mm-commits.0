From: akpm@linux-foundation.org
Subject: - flush-cache-before-installing-new-page-at-migraton.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:21 -0700
Message-ID: <200710162034.l9GKYLJs014932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965381AbXJPVyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, davem@davemloft.net, hugh@veritas.com, nickpiggin@yahoo.com.au, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     flush cache before installing new page at migraton
has been removed from the -mm tree.  Its filename was
     flush-cache-before-installing-new-page-at-migraton.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: flush cache before installing new page at migraton
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In migration, a new page should be cache flushed before set_pte() in some
archs which have virtually-tagged cache.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/migrate.c~flush-cache-before-installing-new-page-at-migraton mm/migrate.c
--- a/mm/migrate.c~flush-cache-before-installing-new-page-at-migraton
+++ a/mm/migrate.c
@@ -171,6 +171,7 @@ static void remove_migration_pte(struct 
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (is_write_migration_entry(entry))
 		pte = pte_mkwrite(pte);
+	flush_cache_page(vma, addr, pte_pfn(pte));
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageAnon(new))
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
git-sh.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch
