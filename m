From: akpm@linux-foundation.org
Subject: [patch 12/20] mm, meminit: always return a valid node from
 early_pfn_to_nid
Date: Thu, 14 Jul 2016 12:07:20 -0700
Message-ID: <5787e2e8.S9u0cYgPu1j5bLVv%akpm__2263.40274462036$1468523260$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbcGNTHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, rientjes@google.com, stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, meminit: always return a valid node from early_pfn_to_nid

early_pfn_to_nid can return node 0 if a PFN is invalid on machines that
has no node 0.  A machine with only node 1 was observed to crash with the
following message

 BUG: unable to handle kernel paging request at 000000000002a3c8
 PGD 0
 Modules linked in:
 Hardware name: Supermicro H8DSP-8/H8DSP-8, BIOS 080011  06/30/2006
 task: ffffffff81c0d500 ti: ffffffff81c00000 task.ti: ffffffff81c00000
 RIP: 0010:[<ffffffff816dbd63>]  [<ffffffff816dbd63>] reserve_bootmem_region+0x6a/0xef
 RSP: 0000:ffffffff81c03eb0  EFLAGS: 00010086
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: ffffffff81c03ec0 RSI: ffffffff81d205c0 RDI: ffffffff8213ee60
 R13: ffffea0000000000 R14: ffffea0000000020 R15: ffffea0000000020
 FS:  0000000000000000(0000) GS:ffff8800fba00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000000002a3c8 CR3: 0000000001c06000 CR4: 00000000000006b0
 Stack:
  ffffffff81c03f00 0000000000000400 ffff8800fbfc3200 ffffffff81e2a2c0
  ffffffff81c03fb0 ffffffff81c03f20 ffffffff81dadf7d ffffea0002000040
  ffffea0000000000 0000000000000000 000000000000ffff 0000000000000001
 Call Trace:
  [<ffffffff81dadf7d>] free_all_bootmem+0x4b/0x12a
  [<ffffffff81d97122>] mem_init+0x70/0xa3
  [<ffffffff81d78f21>] start_kernel+0x25b/0x49b

The problem is that early_page_uninitialised uses the early_pfn_to_nid
helper which returns node 0 for invalid PFNs. No caller of early_pfn_to_nid
cares except early_page_uninitialised. This patch has early_pfn_to_nid
always return a valid node.

Link: http://lkml.kernel.org/r/1468008031-3848-3-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid
+++ a/mm/page_alloc.c
@@ -1273,7 +1273,7 @@ int __meminit early_pfn_to_nid(unsigned
 	spin_lock(&early_pfn_lock);
 	nid = __early_pfn_to_nid(pfn, &early_pfnnid_cache);
 	if (nid < 0)
-		nid = 0;
+		nid = first_online_node;
 	spin_unlock(&early_pfn_lock);
 
 	return nid;
_
