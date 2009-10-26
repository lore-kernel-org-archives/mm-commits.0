From: akpm@linux-foundation.org
Subject: [merged] pcmcia-fix-controller-printk-format-warnings.patch removed from -mm tree
Date: Mon, 26 Oct 2009 15:23:28 -0700
Message-ID: <200910262223.n9QMNS41010930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946AbZJZWYO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Oct 2009 18:24:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     pcmcia: fix controller printk format warnings
has been removed from the -mm tree.  Its filename was
     pcmcia-fix-controller-printk-format-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: fix controller printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new pcmcia printk format warnings:
[This has now moved from linux-next to mainline.
Originally sent 2009-SEP-17.]

drivers/pcmcia/i82365.c:1055: warning: format '%#x' expects type 'unsigned int', but argument 6 has type 'phys_addr_t'
drivers/pcmcia/i82365.c:1055: warning: format '%#x' expects type 'unsigned int', but argument 7 has type 'phys_addr_t'
drivers/pcmcia/tcic.c:734: warning: format '%#x' expects type 'unsigned int', but argument 6 has type 'phys_addr_t'
drivers/pcmcia/tcic.c:734: warning: format '%#x' expects type 'unsigned int', but argument 7 has type 'phys_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pcmcia/i82365.c~pcmcia-fix-controller-printk-format-warnings drivers/pcmcia/i82365.c
--- a/drivers/pcmcia/i82365.c~pcmcia-fix-controller-printk-format-warnings
+++ a/drivers/pcmcia/i82365.c
@@ -1053,8 +1053,8 @@ static int i365_set_io_map(u_short sock,
     u_char map, ioctl;
     
     debug(1, "SetIOMap(%d, %d, %#2.2x, %d ns, "
-	  "%#x-%#x)\n", sock, io->map, io->flags,
-	  io->speed, io->start, io->stop);
+	  "%#llx-%#llx)\n", sock, io->map, io->flags, io->speed,
+	  (unsigned long long)io->start, (unsigned long long)io->stop);
     map = io->map;
     if ((map > 1) || (io->start > 0xffff) || (io->stop > 0xffff) ||
 	(io->stop < io->start)) return -EINVAL;
diff -puN drivers/pcmcia/tcic.c~pcmcia-fix-controller-printk-format-warnings drivers/pcmcia/tcic.c
--- a/drivers/pcmcia/tcic.c~pcmcia-fix-controller-printk-format-warnings
+++ a/drivers/pcmcia/tcic.c
@@ -732,8 +732,8 @@ static int tcic_set_io_map(struct pcmcia
     u_short base, len, ioctl;
     
     debug(1, "SetIOMap(%d, %d, %#2.2x, %d ns, "
-	  "%#x-%#x)\n", psock, io->map, io->flags,
-	  io->speed, io->start, io->stop);
+	  "%#llx-%#llx)\n", psock, io->map, io->flags, io->speed,
+	  (unsigned long long)io->start, (unsigned long long)io->stop);
     if ((io->map > 1) || (io->start > 0xffff) || (io->stop > 0xffff) ||
 	(io->stop < io->start)) return -EINVAL;
     tcic_setw(TCIC_ADDR+2, TCIC_ADR2_INDREG | (psock << TCIC_SS_SHFT));
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

