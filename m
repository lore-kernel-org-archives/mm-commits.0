From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?drivers-infiniband-sw-siw-siw=5Fqp=5Frxc-suppress-uniniti?=
 =?US-ASCII?Q?alized-var-warning.patch?= added to -mm tree
Date: Sat, 21 Mar 2020 18:14:45 -0700
Message-ID: <20200322011445.jaJOoESxE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbgCVBOq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 21:14:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bmt@zurich.ibm.com, dledford@redhat.com, jgg@ziepe.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/sw/siw/siw_qp_rx.c: suppress uninitialized var warning
has been added to the -mm tree.  Its filename is
     drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/infiniband/sw/siw/siw_qp_rx.c: suppress uninitialized var warning

drivers/infiniband/sw/siw/siw_qp_rx.c: In function siw_proc_send:
./include/linux/spinlock.h:288:3: warning: flags may be used uninitialized in this function [-Wmaybe-uninitialized]
   _raw_spin_unlock_irqrestore(lock, flags); \
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/infiniband/sw/siw/siw_qp_rx.c:335:16: note: flags was declared here
  unsigned long flags;

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

memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_event-fix.patch
mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
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
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning.patch
