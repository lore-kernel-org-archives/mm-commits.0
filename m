From: akpm@linux-foundation.org
Subject: + swap-choose-swap-device-according-to-numa-node-v2.patch added
 to -mm tree
Date: Thu, 17 Aug 2017 15:38:13 -0700
Message-ID: <59961ad5.UXtpykbg7tWmPUDl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50042 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdHQWiP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaron.lu@intel.com, andi@firstfloor.org, hughd@google.com, mhocko@suse.com, minchan@kernel.org, tim.c.chen@intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-choose-swap-device-according-to-numa-node-v2
has been added to the -mm tree.  Its filename is
     swap-choose-swap-device-according-to-numa-node-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-choose-swap-device-according-to-numa-node-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-choose-swap-device-according-to-numa-node-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aaron Lu <aaron.lu@intel.com>
Subject: swap-choose-swap-device-according-to-numa-node-v2

- Add pr_emrg in swapfile_init() for -ENOMEM case and check for
  swap_avail_heads during swap on time as suggested by Andrew Morton;

- Documentation update as suggested by Andrew Morton;

- style fix by adding a blank line in __del_from_avail_list().

Link: http://lkml.kernel.org/r/20170814053130.GD2369@aaronlu.sh.intel.com
Link: http://lkml.kernel.org/r/20170816024439.GA10925@aaronlu.sh.intel.com
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/swap_numa.txt |   53 ++++++++++++++++++++++++++++++-
 mm/swapfile.c                  |    8 ++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/swap_numa.txt~swap-choose-swap-device-according-to-numa-node-v2 Documentation/vm/swap_numa.txt
--- a/Documentation/vm/swap_numa.txt~swap-choose-swap-device-according-to-numa-node-v2
+++ a/Documentation/vm/swap_numa.txt
@@ -1,7 +1,56 @@
+Automatically bind swap device to numa node
+-------------------------------------------
+
 If the system has more than one swap device and swap device has the node
 information, we can make use of this information to decide which swap
 device to use in get_swap_pages() to get better performance.
 
+
+How to use this feature
+-----------------------
+
+Swap device has priority and that decides the order of it to be used. To make
+use of automatically binding, there is no need to manipulate priority settings
+for swap devices. e.g. on a 2 node machine, assume 2 swap devices swapA and
+swapB, with swapA attached to node 0 and swapB attached to node 1, are going
+to be swapped on. Simply swapping them on by doing:
+# swapon /dev/swapA
+# swapon /dev/swapB
+
+Then node 0 will use the two swap devices in the order of swapA then swapB and
+node 1 will use the two swap devices in the order of swapB then swapA. Note
+that the order of them being swapped on doesn't matter.
+
+A more complex example on a 4 node machine. Assume 6 swap devices are going to
+be swapped on: swapA and swapB are attached to node 0, swapC is attached to
+node 1, swapD and swapE are attached to node 2 and swapF is attached to node3.
+The way to swap them on is the same as above:
+# swapon /dev/swapA
+# swapon /dev/swapB
+# swapon /dev/swapC
+# swapon /dev/swapD
+# swapon /dev/swapE
+# swapon /dev/swapF
+
+Then node 0 will use them in the order of:
+swapA/swapB -> swapC -> swapD -> swapE -> swapF
+swapA and swapB will be used in a round robin mode before any other swap device.
+
+node 1 will use them in the order of:
+swapC -> swapA -> swapB -> swapD -> swapE -> swapF
+
+node 2 will use them in the order of:
+swapD/swapE -> swapA -> swapB -> swapC -> swapF
+Similaly, swapD and swapE will be used in a round robin mode before any
+other swap devices.
+
+node 3 will use them in the order of:
+swapF -> swapA -> swapB -> swapC -> swapD -> swapE
+
+
+Implementation details
+----------------------
+
 The current code uses a priority based list, swap_avail_list, to decide
 which swap device to use and if multiple swap devices share the same
 priority, they are used round robin. This change here replaces the single
@@ -15,4 +64,6 @@ value in the swap_avail_list is the nega
 due to plist being sorted from low to high. The new policy doesn't change
 the semantics for priority >=0 cases, the previous starting from -1 then
 downwards now becomes starting from -2 then downwards and -1 is reserved
-as the promoted value.
+as the promoted value. So if multiple swap devices are attached to the same
+node, they will all be promoted to priority -1 on that node's plist and will
+be used round robin before any other swap devices.
diff -puN mm/swapfile.c~swap-choose-swap-device-according-to-numa-node-v2 mm/swapfile.c
--- a/mm/swapfile.c~swap-choose-swap-device-according-to-numa-node-v2
+++ a/mm/swapfile.c
@@ -595,6 +595,7 @@ new_cluster:
 static void __del_from_avail_list(struct swap_info_struct *p)
 {
 	int nid;
+
 	for_each_node(nid)
 		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
 }
@@ -3106,6 +3107,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (!swap_avail_heads)
+		return -ENOMEM;
+
 	p = alloc_swap_info();
 	if (IS_ERR(p))
 		return PTR_ERR(p);
@@ -3697,8 +3701,10 @@ static int __init swapfile_init(void)
 	int nid;
 
 	swap_avail_heads = kmalloc(nr_node_ids * sizeof(struct plist_head), GFP_KERNEL);
-	if (!swap_avail_heads)
+	if (!swap_avail_heads) {
+		pr_emerg("Not enough memory for swap heads, swap is disabled\n");
 		return -ENOMEM;
+	}
 
 	for_each_node(nid)
 		plist_head_init(&swap_avail_heads[nid]);
_

Patches currently in -mm which might be from aaron.lu@intel.com are

swap-choose-swap-device-according-to-numa-node.patch
swap-choose-swap-device-according-to-numa-node-v2.patch

