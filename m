From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?drivers-infiniband-sw-siw-siw=5Fqp=5Frxc-suppress-uniniti?=
 =?US-ASCII?Q?alized-var-warning.patch?= removed from -mm tree
Date: Sat, 28 Mar 2020 15:48:36 -0700
Message-ID: <20200328224836.Y0A_53Jw8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgC1Wsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 18:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bmt@zurich.ibm.com, dledford@redhat.com, jgg@ziepe.ca, leonro@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/sw/siw/siw_qp_rx.c: suppress uninitialized var warning
has been removed from the -mm tree.  Its filename was
     drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/infiniband/sw/siw/siw_qp_rx.c: suppress uninitialized var warning

drivers/infiniband/sw/siw/siw_qp_rx.c: In function siw_proc_send:
./include/linux/spinlock.h:288:3: warning: flags may be used uninitialized in this function [-Wmaybe-uninitialized]
   _raw_spin_unlock_irqrestore(lock, flags); \
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/infiniband/sw/siw/siw_qp_rx.c:335:16: note: flags was declared here
  unsigned long flags;

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/sw/siw/siw_qp_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/sw/siw/siw_qp_rx.c~drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning
+++ a/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -332,7 +332,7 @@ static struct siw_wqe *siw_rqe_get(struc
 	struct siw_srq *srq;
 	struct siw_wqe *wqe = NULL;
 	bool srq_event = false;
-	unsigned long flags;
+	unsigned long uninitialized_var(flags);
 
 	srq = qp->srq;
 	if (srq) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
