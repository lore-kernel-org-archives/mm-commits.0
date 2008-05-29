From: akpm@linux-foundation.org
Subject: + hugetlb-fix-lockdep-error.patch added to -mm tree
Date: Wed, 28 May 2008 20:36:22 -0700
Message-ID: <200805290336.m4T3aM91014497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbYE2Dgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 23:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, agl@us.ibm.com, kosaki.motohiro@jp.fujitsu.com, nacc@us.ibm.com


The patch titled
     hugetlb: fix lockdep error
has been added to the -mm tree.  Its filename is
     hugetlb-fix-lockdep-error.patch

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
Subject: hugetlb: fix lockdep error
From: Nick Piggin <npiggin@suse.de>

=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc4 #30
---------------------------------------------
heap-overflow/2250 is trying to acquire lock:
 (&mm->page_table_lock){--..}, at: [<c0000000000cf2e8>] .copy_hugetlb_page_range+0x108/0x280

but task is already holding lock:
 (&mm->page_table_lock){--..}, at: [<c0000000000cf2dc>] .copy_hugetlb_page_range+0xfc/0x280

other info that might help us debug this:
3 locks held by heap-overflow/2250:
 #0:  (&mm->mmap_sem){----}, at: [<c000000000050e44>] .dup_mm+0x134/0x410
 #1:  (&mm->mmap_sem/1){--..}, at: [<c000000000050e54>] .dup_mm+0x144/0x410
 #2:  (&mm->page_table_lock){--..}, at: [<c0000000000cf2dc>] .copy_hugetlb_page_range+0xfc/0x280

stack backtrace:
Call Trace:
[c00000003b2774e0] [c000000000010ce4] .show_stack+0x74/0x1f0 (unreliable)
[c00000003b2775a0] [c0000000003f10e0] .dump_stack+0x20/0x34
[c00000003b277620] [c0000000000889bc] .__lock_acquire+0xaac/0x1080
[c00000003b277740] [c000000000089000] .lock_acquire+0x70/0xb0
[c00000003b2777d0] [c0000000003ee15c] ._spin_lock+0x4c/0x80
[c00000003b277870] [c0000000000cf2e8] .copy_hugetlb_page_range+0x108/0x280
[c00000003b277950] [c0000000000bcaa8] .copy_page_range+0x558/0x790
[c00000003b277ac0] [c000000000050fe0] .dup_mm+0x2d0/0x410
[c00000003b277ba0] [c000000000051d24] .copy_process+0xb94/0x1020
[c00000003b277ca0] [c000000000052244] .do_fork+0x94/0x310
[c00000003b277db0] [c000000000011240] .sys_clone+0x60/0x80
[c00000003b277e30] [c0000000000078c4] .ppc_clone+0x8/0xc

Fix is the same way that mm/memory.c copy_page_range does the
lockdep annotation.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-fix-lockdep-error mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-lockdep-error
+++ a/mm/hugetlb.c
@@ -785,7 +785,7 @@ int copy_hugetlb_page_range(struct mm_st
 			continue;
 
 		spin_lock(&dst->page_table_lock);
-		spin_lock(&src->page_table_lock);
+		spin_lock_nested(&src->page_table_lock, SINGLE_DEPTH_NESTING);
 		if (!huge_pte_none(huge_ptep_get(src_pte))) {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

