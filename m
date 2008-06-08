From: akpm@linux-foundation.org
Subject: - libata-fix-g5-sata-broken-on-rc5.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:38 -0700
Message-ID: <200806081949.m58JncCM017698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597AbYFHTuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, alan@lxorguk.ukuu.org.uk, olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     libata: fix G5 SATA broken on -rc5
has been removed from the -mm tree.  Its filename was
     libata-fix-g5-sata-broken-on-rc5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: fix G5 SATA broken on -rc5
From: Hugh Dickins <hugh@veritas.com>

Fix G5 SATA irq 18: nobody cared, reported on -rc5 by Olaf Hering: fixlet
to a57c1bade5a0ee5cd8b74502db9cbebb7f5780b2 libata-sff: Fix oops reported
in kerneloops.org for pnp devices with no ctl

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Tested-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-sff.c~libata-fix-g5-sata-broken-on-rc5 drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-fix-g5-sata-broken-on-rc5
+++ a/drivers/ata/libata-sff.c
@@ -278,7 +278,7 @@ static u8 ata_sff_irq_status(struct ata_
 		    	return status;
 	}
 	/* Clear INTRQ latch */
-	status = ata_sff_check_status(ap);
+	status = ap->ops->sff_check_status(ap);
 	return status;
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
git-unionfs.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
prio_tree-debugging-patch.patch

