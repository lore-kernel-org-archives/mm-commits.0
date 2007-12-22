From: akpm@linux-foundation.org
Subject: + maps4-add-proc-kpageflags-interface-fix-2.patch added to -mm tree
Date: Fri, 21 Dec 2007 20:58:30 -0800
Message-ID: <200712220458.lBM4wUiJ018067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbXLVE7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 23:59:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, davem@davemloft.net, m.kozlowski@tuxland.pl


The patch titled
     problems with cat /proc/kpageflags
has been added to the -mm tree.  Its filename is
     maps4-add-proc-kpageflags-interface-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: problems with cat /proc/kpageflags
From: Matt Mackall <mpm@selenic.com>

On Thu, Dec 20, 2007 at 04:17:26PM -0800, David Miller wrote:
> From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Date: Thu, 20 Dec 2007 20:47:55 +0100
>
> > [  145.128915] TSTATE: 0000004411009603 TPC: 00000000005119ac TNPC: 00000000005119b0 Y: 00000000    Not tainted
> > [  145.128940] TPC: <kpagecount_read+0x94/0xe0>
>
> My suspicion at this point is that with certain RAM layouts, simply
> iterating over PFN's is simply not working out.

That was my original suspicion, which is why I asked Mariusz to
effectively comment out the actual PFN lookup up-thread. I didn't send
him a patch to do that, so I guess my instructions on how to hack it
may have been misunderstood.

> pfn_to_page() seems to be doing no range checking, and with sparsemem
> vmemmap, which sparc64 always uses, this can be problematic.
>
> It just blindly goes "vmemmap + pfn" which is asking for trouble, in
> particular when the physical RAM layout really is sparse.
>
> Maybe it's enough to add a pfn_valid() check here?  If pfn_valid()
> means there is a vmemmap translation setup for that page struct too,
> it would work.

Here's a test patch:

Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_misc.c~maps4-add-proc-kpageflags-interface-fix-2 fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~maps4-add-proc-kpageflags-interface-fix-2
+++ a/fs/proc/proc_misc.c
@@ -699,7 +699,10 @@ static ssize_t kpagecount_read(struct fi
 		return -EIO;
 
 	while (count > 0) {
-		ppage = pfn_to_page(pfn++);
+		ppage = 0;
+		if (pfn_valid(pfn))
+			ppage = pfn_to_page(pfn);
+		pfn++;
 		if (!ppage)
 			pcount = 0;
 		else
@@ -762,7 +765,10 @@ static ssize_t kpageflags_read(struct fi
 		return -EIO;
 
 	while (count > 0) {
-		ppage = pfn_to_page(pfn++);
+		ppage = 0;
+		if (pfn_valid(pfn))
+			ppage = pfn_to_page(pfn);
+		pfn++;
 		if (!ppage)
 			kflags = 0;
 		else
_

Patches currently in -mm which might be from mpm@selenic.com are

maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
remove-unused-code-from-mm-tiny-shmemc.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
printk_ratelimit-functions-should-use-config_printk.patch
