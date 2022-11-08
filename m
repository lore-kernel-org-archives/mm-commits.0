Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2193C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 19:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKHTi4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKHTix (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 14:38:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3999FFF
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 11:38:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A89F7B81C1C
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 19:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A7CC433D6;
        Tue,  8 Nov 2022 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667936328;
        bh=k32xAv/P6G/u+o/n9GmPDhfNtHn38o0KYZfsyCk+RIc=;
        h=Date:To:From:Subject:From;
        b=qPvlEJVINFH7QJQJ+AOg6+ThVL5OmVhIXutePMblYjCSEeJ3yzCF2ymxYsJsJAoed
         qKgyDXmk+IdZta84+zkkQvWB/ewMQ/7F8a4hVNsspLNgw2UgSeQx80buxjQHMhogNQ
         IjGchcfpAQINhlyQXiwrwcjPM2tO0P+q9LuIqzkg=
Date:   Tue, 08 Nov 2022 11:38:47 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com, zokeefe@googel.com,
        syzbot+0044b22d177870ee974f@syzkaller.appspotmail.com,
        mhocko@suse.com, shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch added to mm-hotfixes-unstable branch
Message-Id: <20221108193848.55A7CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace VM_WARN_ON to pr_warn if the node is offline with __GFP_THISNODE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: replace VM_WARN_ON to pr_warn if the node is offline with __GFP_THISNODE
Date: Tue, 8 Nov 2022 10:43:57 -0800

Syzbot reported the below splat:

WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221 __alloc_pages_node
include/linux/gfp.h:221 [inline]
WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221
hpage_collapse_alloc_page mm/khugepaged.c:807 [inline]
WARNING: CPU: 1 PID: 3646 at include/linux/gfp.h:221
alloc_charge_hpage+0x802/0xaa0 mm/khugepaged.c:963
Modules linked in:
CPU: 1 PID: 3646 Comm: syz-executor210 Not tainted
6.1.0-rc1-syzkaller-00454-ga70385240892 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 10/11/2022
RIP: 0010:__alloc_pages_node include/linux/gfp.h:221 [inline]
RIP: 0010:hpage_collapse_alloc_page mm/khugepaged.c:807 [inline]
RIP: 0010:alloc_charge_hpage+0x802/0xaa0 mm/khugepaged.c:963
Code: e5 01 4c 89 ee e8 6e f9 ae ff 4d 85 ed 0f 84 28 fc ff ff e8 70 fc
ae ff 48 8d 6b ff 4c 8d 63 07 e9 16 fc ff ff e8 5e fc ae ff <0f> 0b e9
96 fa ff ff 41 bc 1a 00 00 00 e9 86 fd ff ff e8 47 fc ae
RSP: 0018:ffffc90003fdf7d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888077f457c0 RSI: ffffffff81cd8f42 RDI: 0000000000000001
RBP: ffff888079388c0c R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f6b48ccf700(0000) GS:ffff8880b9b00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6b48a819f0 CR3: 00000000171e7000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 collapse_file+0x1ca/0x5780 mm/khugepaged.c:1715
 hpage_collapse_scan_file+0xd6c/0x17a0 mm/khugepaged.c:2156
 madvise_collapse+0x53a/0xb40 mm/khugepaged.c:2611
 madvise_vma_behavior+0xd0a/0x1cc0 mm/madvise.c:1066
 madvise_walk_vmas+0x1c7/0x2b0 mm/madvise.c:1240
 do_madvise.part.0+0x24a/0x340 mm/madvise.c:1419
 do_madvise mm/madvise.c:1432 [inline]
 __do_sys_madvise mm/madvise.c:1432 [inline]
 __se_sys_madvise mm/madvise.c:1430 [inline]
 __x64_sys_madvise+0x113/0x150 mm/madvise.c:1430
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6b48a4eef9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 15 00 00 90 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6b48ccf318 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f6b48af0048 RCX: 00007f6b48a4eef9
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000000020000000
RBP: 00007f6b48af0040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6b48aa53a4
R13: 00007f6b48bffcbf R14: 00007f6b48ccf400 R15: 0000000000022000
 </TASK>

It is because khugepaged allocates pages with __GFP_THISNODE, but the
preferred node is bogus.  The previous patch fixed the khugepaged
code to avoid allocating page from non-existing node.  But it is still
racy against memory hotremove.  There is no synchronization with the
memory hotplug so it is possible that memory gets offline during a
longer taking scanning.

So this warning still seems not quite helpful because:
  * There is no guarantee the node is online for __GFP_THISNODE context
    for all the callsites.
  * Kernel just fails the allocation regardless the warning, and it looks
    all callsites handle the allocation failure gracefully.

Although while the warning has helped to identify a buggy code, it is not
safe in general and this warning could panic the system with panic-on-warn
configuration which tends to be used surprisingly often.  So replace
VM_WARN_ON to pr_warn().  And the warning will be triggered if
__GFP_NOWARN is set since the allocator would print out warning for such
case if __GFP_NOWARN is not set.

Link: https://lkml.kernel.org/r/20221108184357.55614-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: <syzbot+0044b22d177870ee974f@syzkaller.appspotmail.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zach O'Keefe <zokeefe@googel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h~mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode
+++ a/include/linux/gfp.h
@@ -210,6 +210,16 @@ alloc_pages_bulk_array_node(gfp_t gfp, i
 	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array);
 }
 
+static inline void warn_if_node_offline(int nid, gfp_t gfp_mask)
+{
+	gfp_t gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
+
+	if ((gfp == (__GFP_THISNODE|__GFP_NOWARN)) && !node_online(nid)) {
+		pr_warn("%pGg allocation from offline node %d\n", &gfp, nid);
+		dump_stack();
+	}
+}
+
 /*
  * Allocate pages, preferring the node given as nid. The node must be valid and
  * online. For more general interface, see alloc_pages_node().
@@ -218,7 +228,7 @@ static inline struct page *
 __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
 {
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	VM_WARN_ON((gfp_mask & __GFP_THISNODE) && !node_online(nid));
+	warn_if_node_offline(nid, gfp_mask);
 
 	return __alloc_pages(gfp_mask, order, nid, NULL);
 }
@@ -227,7 +237,7 @@ static inline
 struct folio *__folio_alloc_node(gfp_t gfp, unsigned int order, int nid)
 {
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	VM_WARN_ON((gfp & __GFP_THISNODE) && !node_online(nid));
+	warn_if_node_offline(nid, gfp);
 
 	return __folio_alloc(gfp, order, nid, NULL);
 }
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-allow-page-allocation-fallback-to-eligible-nodes.patch
mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch

