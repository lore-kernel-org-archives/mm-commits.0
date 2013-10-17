From: akpm@linux-foundation.org
Subject: [merged]
 mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state.patch removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:05 -0700
Message-ID: <526028b1.7QyX6VdbzZ3J71eC%akpm__8659.97112491659$1382033605$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877Ab3JQSNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, xemul@parallels.com, stable@vger.kernel.org, sfr@canb.auug.org.au, peterz@infradead.org, n-horiguchi@ah.jp.nec.com, mtosatti@redhat.com, mpm@selenic.com, mel@csn.ul.ie, luto@amacapital.net, kosaki.motohiro@gmail.com, gorcunov@openvz.org, aneesh.kumar@linux.vnet.ibm.com, gorcunov@gmail.com

Subject: [merged] mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state.patch removed from -mm tree
To: gorcunov@gmail.com,aneesh.kumar@linux.vnet.ibm.com,gorcunov@openvz.org,kosaki.motohiro@gmail.com,luto@amacapital.net,mel@csn.ul.ie,mpm@selenic.com,mtosatti@redhat.com,n-horiguchi@ah.jp.nec.com,peterz@infradead.org,sfr@canb.auug.org.au,stable@vger.kernel.org,xemul@parallels.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:05 -0700


The patch titled
     Subject: mm: migration: do not lose soft dirty bit if page is in migration state
has been removed from the -mm tree.  Its filename was
     mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: migration: do not lose soft dirty bit if page is in migration state

If page migration is turned on in config and the page is migrating, we may
lose the soft dirty bit.  If fork and mprotect are called on migrating
pages (once migration is complete) pages do not obtain the soft dirty bit
in the correspond pte entries.  Fix it adding an appropriate test on swap
entries.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    2 ++
 mm/migrate.c  |    2 ++
 mm/mprotect.c |    7 +++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state mm/memory.c
--- a/mm/memory.c~mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state
+++ a/mm/memory.c
@@ -837,6 +837,8 @@ copy_one_pte(struct mm_struct *dst_mm, s
 					 */
 					make_migration_entry_read(&entry);
 					pte = swp_entry_to_pte(entry);
+					if (pte_swp_soft_dirty(*src_pte))
+						pte = pte_swp_mksoft_dirty(pte);
 					set_pte_at(src_mm, addr, src_pte, pte);
 				}
 			}
diff -puN mm/migrate.c~mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state mm/migrate.c
--- a/mm/migrate.c~mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state
+++ a/mm/migrate.c
@@ -161,6 +161,8 @@ static int remove_migration_pte(struct p
 
 	get_page(new);
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
+	if (pte_swp_soft_dirty(*ptep))
+		pte = pte_mksoft_dirty(pte);
 	if (is_write_migration_entry(entry))
 		pte = pte_mkwrite(pte);
 #ifdef CONFIG_HUGETLB_PAGE
diff -puN mm/mprotect.c~mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state mm/mprotect.c
--- a/mm/mprotect.c~mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state
+++ a/mm/mprotect.c
@@ -94,13 +94,16 @@ static unsigned long change_pte_range(st
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
 			if (is_write_migration_entry(entry)) {
+				pte_t newpte;
 				/*
 				 * A protection check is difficult so
 				 * just be safe and disable write
 				 */
 				make_migration_entry_read(&entry);
-				set_pte_at(mm, addr, pte,
-					swp_entry_to_pte(entry));
+				newpte = swp_entry_to_pte(entry);
+				if (pte_swp_soft_dirty(oldpte))
+					newpte = pte_swp_mksoft_dirty(newpte);
+				set_pte_at(mm, addr, pte, newpte);
 			}
 			pages++;
 		}
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch

