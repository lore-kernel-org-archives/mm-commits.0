From: akpm@linux-foundation.org
Subject: +
 drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch added
 to -mm tree
Date: Mon, 23 Mar 2020 12:00:33 -0700
Message-ID: <20200323190033.ZwRwhVPmy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727677AbgCWTAe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 15:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, jslaby@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/tty/serial/sh-sci.c: suppress uninitialized var warning
has been added to the -mm tree.  Its filename is
     drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch

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
Subject: drivers/tty/serial/sh-sci.c: suppress uninitialized var warning

drivers/tty/serial/sh-sci.c: In function sci_dma_rx_submit:
./include/linux/spinlock.h:288:3: warning: flags may be used uninitialized in this function [-Wmaybe-uninitialized]
   _raw_spin_unlock_irqrestore(lock, flags); \
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/tty/serial/sh-sci.c:1348:16: note: flags was declared here
  unsigned long flags;

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/sh-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sh-sci.c~drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning
+++ a/drivers/tty/serial/sh-sci.c
@@ -1345,7 +1345,7 @@ static int sci_dma_rx_submit(struct sci_
 {
 	struct dma_chan *chan = s->chan_rx;
 	struct uart_port *port = &s->port;
-	unsigned long flags;
+	unsigned long uninitialized_var(flags);
 	int i;
 
 	for (i = 0; i < 2; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning.patch
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
