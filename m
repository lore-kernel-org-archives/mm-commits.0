From: akpm@linux-foundation.org
Subject: [folded-merged]
 swap-choose-swap-device-according-to-numa-node-v2-fix.patch removed from
 -mm tree
Date: Wed, 06 Sep 2017 16:09:02 -0700
Message-ID: <59b0800e.VCg5eMfmluGq5zGb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdIFXJD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aaron.lu@intel.com, andi@firstfloor.org, hughd@google.com, mhocko@suse.com, minchan@kernel.org, tim.c.chen@intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-choose-swap-device-according-to-numa-node-v2-fix
has been removed from the -mm tree.  Its filename was
     swap-choose-swap-device-according-to-numa-node-v2-fix.patch

This patch was dropped because it was folded into swap-choose-swap-device-according-to-numa-node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-choose-swap-device-according-to-numa-node-v2-fix

use kmalloc_array()

Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~swap-choose-swap-device-according-to-numa-node-v2-fix mm/swapfile.c
--- a/mm/swapfile.c~swap-choose-swap-device-according-to-numa-node-v2-fix
+++ a/mm/swapfile.c
@@ -3700,7 +3700,8 @@ static int __init swapfile_init(void)
 {
 	int nid;
 
-	swap_avail_heads = kmalloc(nr_node_ids * sizeof(struct plist_head), GFP_KERNEL);
+	swap_avail_heads = kmalloc_array(nr_node_ids, sizeof(struct plist_head),
+					 GFP_KERNEL);
 	if (!swap_avail_heads) {
 		pr_emerg("Not enough memory for swap heads, swap is disabled\n");
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

swap-choose-swap-device-according-to-numa-node.patch
mmfork-introduce-madv_wipeonfork-fix.patch

