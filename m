From: akpm@linux-foundation.org
Subject: +
 xen-properly-account-for-_page_numa-during-xen-pte-translations.patch added to -mm tree
Date: Tue, 04 Feb 2014 12:46:07 -0800
Message-ID: <52f1518f.ONIJHvGp6iDNptnB%akpm__49653.8899177269$1391546783$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaBDUqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 15:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ufimtseva@gmail.com, steven@uplinklabs.net, stable@vger.kernel.org, konrad.wilk@oracle.com, david.vrabel@citrix.com, mgorman@suse.de

Subject: + xen-properly-account-for-_page_numa-during-xen-pte-translations.patch added to -mm tree
To: mgorman@suse.de,david.vrabel@citrix.com,konrad.wilk@oracle.com,stable@vger.kernel.org,steven@uplinklabs.net,ufimtseva@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 12:46:07 -0800


The patch titled
     Subject: xen: properly account for _PAGE_NUMA during xen pte translations
has been added to the -mm tree.  Its filename is
     xen-properly-account-for-_page_numa-during-xen-pte-translations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xen-properly-account-for-_page_numa-during-xen-pte-translations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xen-properly-account-for-_page_numa-during-xen-pte-translations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: xen: properly account for _PAGE_NUMA during xen pte translations

Steven Noonan forwarded a users report where they had a problem starting
vsftpd on a Xen paravirtualized guest, with this in dmesg:

[   60.654862] BUG: Bad page map in process vsftpd  pte:8000000493b88165 pmd:e9cc01067
[   60.654876] page:ffffea00124ee200 count:0 mapcount:-1 mapping:     (null) index:0x0
[   60.654879] page flags: 0x2ffc0000000014(referenced|dirty)
[   60.654885] addr:00007f97eea74000 vm_flags:00100071 anon_vma:ffff880e98f80380 mapping:          (null) index:7f97eea74
[   60.654890] CPU: 4 PID: 587 Comm: vsftpd Not tainted 3.12.7-1-ec2 #1
[   60.654893]  ffff880e9cc6ec38 ffff880e9cc61ca0 ffffffff814c763b 00007f97eea74000
[   60.654900]  ffff880e9cc61ce8 ffffffff8116784e 0000000000000000 0000000000000000
[   60.654906]  ffff880e9cc013a0 ffffea00124ee200 00007f97eea75000 ffff880e9cc61e10
[   60.654912] Call Trace:
[   60.654921]  [<ffffffff814c763b>] dump_stack+0x45/0x56
[   60.654928]  [<ffffffff8116784e>] print_bad_pte+0x22e/0x250
[   60.654933]  [<ffffffff81169073>] unmap_single_vma+0x583/0x890
[   60.654938]  [<ffffffff8116a405>] unmap_vmas+0x65/0x90
[   60.654942]  [<ffffffff81173795>] exit_mmap+0xc5/0x170
[   60.654948]  [<ffffffff8105d295>] mmput+0x65/0x100
[   60.654952]  [<ffffffff81062983>] do_exit+0x393/0x9e0
[   60.654955]  [<ffffffff810630dc>] do_group_exit+0xcc/0x140
[   60.654959]  [<ffffffff81063164>] SyS_exit_group+0x14/0x20
[   60.654965]  [<ffffffff814d602d>] system_call_fastpath+0x1a/0x1f
[   60.654968] Disabling lock debugging due to kernel taint
[   60.655191] BUG: Bad rss-counter state mm:ffff880e9ca60580 idx:0 val:-1
[   60.655196] BUG: Bad rss-counter state mm:ffff880e9ca60580 idx:1 val:1

The issue could not be reproduced under an HVM instance with the same
kernel, so it appears to be exclusive to paravirtual Xen guests.  He
bisected the problem to commit 1667918b (mm: numa: clear numa hinting
information on mprotect) that was also included in 3.12-stable.

The problem was related to how xen translates ptes because it was not
accounting for the _PAGE_NUMA bit.  This patch splits pte_present to add a
pteval_present helper for use by xen so both bare metal and xen use the
same code when checking if a PTE is present.

[mgorman@suse.de: wrote changelog, proposed minor modifications]
Reported-by: Steven Noonan <steven@uplinklabs.net>
Tested-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Elena Ufimtseva <ufimtseva@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   14 ++++++++++++--
 arch/x86/xen/mmu.c             |    4 ++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~xen-properly-account-for-_page_numa-during-xen-pte-translations arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~xen-properly-account-for-_page_numa-during-xen-pte-translations
+++ a/arch/x86/include/asm/pgtable.h
@@ -445,10 +445,20 @@ static inline int pte_same(pte_t a, pte_
 	return a.pte == b.pte;
 }
 
+static inline int pteval_present(pteval_t pteval)
+{
+	/*
+	 * Yes Linus, _PAGE_PROTNONE == _PAGE_NUMA. Expressing it this
+	 * way clearly states that the intent is that a protnone and numa
+	 * hinting ptes are considered present for the purposes of
+	 * pagetable operations like zapping, protection changes, gup etc.
+	 */
+	return pteval & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_NUMA);
+}
+
 static inline int pte_present(pte_t a)
 {
-	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE |
-			       _PAGE_NUMA);
+	return pteval_present(pte_flags(a));
 }
 
 #define pte_accessible pte_accessible
diff -puN arch/x86/xen/mmu.c~xen-properly-account-for-_page_numa-during-xen-pte-translations arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~xen-properly-account-for-_page_numa-during-xen-pte-translations
+++ a/arch/x86/xen/mmu.c
@@ -365,7 +365,7 @@ void xen_ptep_modify_prot_commit(struct
 /* Assume pteval_t is equivalent to all the other *val_t types. */
 static pteval_t pte_mfn_to_pfn(pteval_t val)
 {
-	if (val & _PAGE_PRESENT) {
+	if (pteval_present(val)) {
 		unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
 		unsigned long pfn = mfn_to_pfn(mfn);
 
@@ -381,7 +381,7 @@ static pteval_t pte_mfn_to_pfn(pteval_t
 
 static pteval_t pte_pfn_to_mfn(pteval_t val)
 {
-	if (val & _PAGE_PRESENT) {
+	if (pteval_present(val)) {
 		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
 		pteval_t flags = val & PTE_FLAGS_MASK;
 		unsigned long mfn;
_

Patches currently in -mm which might be from mgorman@suse.de are

xen-properly-account-for-_page_numa-during-xen-pte-translations.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-optimize-put_mems_allowed-usage.patch
linux-next.patch

