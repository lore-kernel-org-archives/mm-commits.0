From: akpm@linux-foundation.org
Subject: + drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:29:07 -0700
Message-ID: <200803172329.m2HNT82P003781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788AbYCQX3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 19:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, auke-jan.h.kok@intel.com, bruce.w.allan@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com


The patch titled
     drivers/net/ixgb/ixgb_main.c: remove unused variable
has been added to the -mm tree.  Its filename is
     drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-acpi.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-dvb.patch
git-hid.patch
git-udf.patch
git-net.patch
git-ocfs2.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
net-9p-trans_fdc-remove-unused-variable.patch
net-ipv6-ndiscc-remove-unused-variable.patch
sound-pci-remove-unused-variable.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch

