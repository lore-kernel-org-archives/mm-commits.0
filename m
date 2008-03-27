From: akpm@linux-foundation.org
Subject: - drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch removed from -mm tree
Date: Thu, 27 Mar 2008 15:45:35 -0700
Message-ID: <200803272245.m2RMjacp025706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbYC0WqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 18:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, auke-jan.h.kok@intel.com, bruce.w.allan@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/ixgb/ixgb_main.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/ixgb/ixgb_main.c: remove unused variable
From: Julia Lawall <julia@diku.dk>

The variable num_group_tail_writes is initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ixgb/ixgb_main.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/ixgb/ixgb_main.c~drivers-net-ixgb-ixgb_mainc-remove-unused-variable drivers/net/ixgb/ixgb_main.c
--- a/drivers/net/ixgb/ixgb_main.c~drivers-net-ixgb-ixgb_mainc-remove-unused-variable
+++ a/drivers/net/ixgb/ixgb_main.c
@@ -2088,14 +2088,12 @@ ixgb_alloc_rx_buffers(struct ixgb_adapte
 	struct ixgb_buffer *buffer_info;
 	struct sk_buff *skb;
 	unsigned int i;
-	int num_group_tail_writes;
 	long cleancount;
 
 	i = rx_ring->next_to_use;
 	buffer_info = &rx_ring->buffer_info[i];
 	cleancount = IXGB_DESC_UNUSED(rx_ring);
 
-	num_group_tail_writes = IXGB_RX_BUFFER_WRITE;
 
 	/* leave three descriptors unused */
 	while(--cleancount > 2) {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
fs-gfs2-test-for-is_err-rather-than-0.patch
git-udf.patch
git-net.patch
git-ocfs2.patch
fs-ocfs2-aopsc-test-for-is_err-rather-than-0.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

