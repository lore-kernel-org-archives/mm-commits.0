From: akpm@linux-foundation.org
Subject: +
 drivers-net-ethernet-mellanox-mlx4-crdumpc-fix-build-with-gcc-720.patch
 added to -mm tree
Date: Mon, 30 Mar 2020 18:07:22 -0700
Message-ID: <20200331010722.XCDU0oIRv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbgCaBHZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Mar 2020 21:07:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, jacob.e.keller@intel.com, jiri@mellanox.com, kuba@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/ethernet/mellanox/mlx4/crdump.c: fix build with gcc-7.2.0
has been added to the -mm tree.  Its filename is
     drivers-net-ethernet-mellanox-mlx4-crdumpc-fix-build-with-gcc-720.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-net-ethernet-mellanox-mlx4-crdumpc-fix-build-with-gcc-720.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-net-ethernet-mellanox-mlx4-crdumpc-fix-build-with-gcc-720.patch

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
Subject: drivers/net/ethernet/mellanox/mlx4/crdump.c: fix build with gcc-7.2.0

drivers/net/ethernet/mellanox/mlx4/crdump.c:45:10: error: initializer element is not constant
  .name = region_cr_space_str,
          ^~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx4/crdump.c:45:10: note: (near initialization for region_cr_space_ops.name)
drivers/net/ethernet/mellanox/mlx4/crdump.c:50:10: error: initializer element is not constant
  .name = region_fw_health_str,
          ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx4/crdump.c:50:10: note: (near initialization for region_fw_health_ops.name)

Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx4/crdump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c~drivers-net-ethernet-mellanox-mlx4-crdumpc-fix-build-with-gcc-720
+++ a/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -38,8 +38,8 @@
 #define CR_ENABLE_BIT_OFFSET		0xF3F04
 #define MAX_NUM_OF_DUMPS_TO_STORE	(8)
 
-static const char * const region_cr_space_str = "cr-space";
-static const char * const region_fw_health_str = "fw-health";
+static const char region_cr_space_str[] = "cr-space";
+static const char region_fw_health_str[] = "fw-health";
 
 static const struct devlink_region_ops region_cr_space_ops = {
 	.name = region_cr_space_str,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch
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
drivers-net-ethernet-mellanox-mlx4-crdumpc-fix-build-with-gcc-720.patch
