From: akpm@linux-foundation.org
Subject: + netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:06:21 -0700
Message-ID: <20120815230622.381D65C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60500 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2HOXGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:06:25 -0400
Received: by lbbge1 with SMTP id ge1so102288lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:06:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, Ian.Campbell@eu.citrix.com, davem@davemloft.net, konrad.wilk@oracle.com


The patch titled
     Subject: netvm: check for page == NULL when propagating the skb->pfmemalloc flag
has been added to the -mm tree.  Its filename is
     netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: netvm: check for page == NULL when propagating the skb->pfmemalloc flag

Commit c48a11c7 ("netvm: propagate page->pfmemalloc to skb") is
responsible for the following bug triggered by a xen network driver

[    1.908592] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[    1.908643] IP: [<ffffffffa0037750>] xennet_poll+0x980/0xec0 [xen_netfront]
[    1.908703] PGD ea1df067 PUD e8ada067 PMD 0
[    1.908774] Oops: 0000 [#1] SMP
[    1.908797] Modules linked in: fbcon tileblit font radeon bitblit softcursor ttm drm_kms_helper crc32c_intel xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea +xen_kbdfront xenfs xen_privcmd
[    1.908938] CPU 0
[    1.908950] Pid: 2165, comm: ip Not tainted 3.5.0upstream-08854-g444fa66 #1
[    1.908983] RIP: e030:[<ffffffffa0037750>]  [<ffffffffa0037750>] xennet_poll+0x980/0xec0 [xen_netfront]
[    1.909029] RSP: e02b:ffff8800ffc03db8  EFLAGS: 00010282
[    1.909055] RAX: ffff8800ea010140 RBX: ffff8800f00e86c0 RCX: 000000000000009a
[    1.909055] RDX: 0000000000000040 RSI: 000000000000005a RDI: ffff8800fa7dee80
[    1.909055] RBP: ffff8800ffc03ee8 R08: ffff8800f00e86d8 R09: ffff8800ea010000
[    1.909055] R10: dead000000200200 R11: dead000000100100 R12: ffff8800fa7dee80
[    1.909055] R13: 000000000000005a R14: ffff8800fa7dee80 R15: 0000000000000200
[    1.909055] FS:  00007fbafc188700(0000) GS:ffff8800ffc00000(0000) knlGS:0000000000000000
[    1.909055] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.909055] CR2: 0000000000000010 CR3: 00000000ea108000 CR4: 0000000000002660
[    1.909055] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.909055] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.909055] Process ip (pid: 2165, threadinfo ffff8800ea0f2000, task ffff8800fa783040)
[    1.909055] Stack:
[    1.909055]  ffff8800e27e5040 ffff8800ffc03e88 ffff8800ffc03e68 ffff8800ffc03e48
[    1.909055]  7fffffffffffffff ffff8800ffc03e00 ffff8800e27e5040 ffff8800f00e86d8
[    1.909055]  ffff8800ffc03eb0 00000040ffffffff ffff8800f00e8000 00000000ffc03e30
[    1.909055] Call Trace:
[    1.909055]  <IRQ>
[    1.909055]  [<ffffffff81066028>] ?  pvclock_clocksource_read+0x58/0xd0
[    1.909055]  [<ffffffff81486352>] net_rx_action+0x112/0x240
[    1.909055]  [<ffffffff8107f319>] __do_softirq+0xb9/0x190
[    1.909055]  [<ffffffff815d8d7c>] call_softirq+0x1c/0x30

The problem is that the xenfront driver is passing a NULL page to
__skb_fill_page_desc() which was unexpected.  This patch checks that there
is a page before dereferencing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/skbuff.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/skbuff.h~netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag include/linux/skbuff.h
--- a/include/linux/skbuff.h~netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag
+++ a/include/linux/skbuff.h
@@ -1259,7 +1259,7 @@ static inline void __skb_fill_page_desc(
 	 * do not lose pfmemalloc information as the pages would not be
 	 * allocated using __GFP_MEMALLOC.
 	 */
-	if (page->pfmemalloc && !page->mapping)
+	if (page && page->pfmemalloc && !page->mapping)
 		skb->pfmemalloc	= true;
 	frag->page.p		  = page;
 	frag->page_offset	  = off;
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch
netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch

