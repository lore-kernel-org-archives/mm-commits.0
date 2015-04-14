From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch removed
 from -mm tree
Date: Tue, 14 Apr 2015 15:14:29 -0700
Message-ID: <552d9145.hc1wuIeSMe0onHTF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbDNWOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mel@csn.ul.ie, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: incorporate zero pages into transparent huge pages fix
has been removed from the -mm tree.  Its filename was
     mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch

This patch was dropped because it was folded into mm-incorporate-zero-pages-into-transparent-huge-pages.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: incorporate zero pages into transparent huge pages fix

After applying the "incorporate zero pages into transparent huge pages"
feature, I've got an oops on a overnight stress test:

------------[ cut here ]------------
kernel BUG at mm/huge_memory.c:1920!
invalid opcode: 0000 [#1] SMP
Modules linked in: tun usbhid snd_hda_codec_realtek x86_pkg_temp_thermal snd_hda_codec_generic kvm_intel kvm snd_hda_intel crc32c_intel snd_hda_controller ghash_clmulni_intel xhci_pci snd_hda_codec xhci_hcd ehci_pci ehci_hcd snd_pcm usbcore psmouse sr_mod snd_timer snd cdrom pcspkr usb_common [last unloaded: microcode]
CPU: 4 PID: 4250 Comm: Analysis Helper Not tainted 3.19.0+ #5
Hardware name:                  /DH61BE, BIOS BEH6110H.86A.0120.2013.1112.1412 11/12/2013
task: ffff88040c520840 ti: ffff880406070000 task.ti: ffff880406070000
RIP: 0010:[<ffffffff811ad362>]  [<ffffffff811ad362>] split_huge_page_to_list+0x6a2/0x7c0
RSP: 0018:ffff880406073c58  EFLAGS: 00010282
RAX: 8000000163b2f067 RBX: ffff880406ac5f90 RCX: ffff880404f70978
RDX: ffffea0000000000 RSI: ffff880404f70000 RDI: 8000000163b2f047
RBP: ffff880408de25c0 R08: 00000000058ecbc0 R09: 00007f2dfe52f000
R10: 0000000000000000 R11: 00007f2dfe600000 R12: 00007f2dfe400000
R13: 0000000404f70067 R14: ffffc00000000fff R15: ffff8800d04da2e0
FS:  00007f2e12168700(0000) GS:ffff88041f300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f03b9871000 CR3: 0000000407c9d000 CR4: 00000000000427e0
Stack:
ffff880406073d08 00000007f2dfe400 00007f2d00000001 ffff880407f2dcd0
ffffea00058e8000 ffff880400000000 00000000058e8000 ffffffff81b8bf40
0000000000000004 ffffea00101ab170 ffff880408d273e8 ffff880406ac5f90
Call Trace:
[<ffffffff811add6a>] ? __split_huge_page_pmd+0xfa/0x2a0
[<ffffffff811838b2>] ? unmap_single_vma+0x2b2/0x810
[<ffffffff810c658b>] ? try_to_wake_up+0xbb/0x2d0
[<ffffffff81104df8>] ? get_futex_key+0x1c8/0x2c0
[<ffffffff81184969>] ? zap_page_range+0x89/0xe0
[<ffffffff81187150>] ? handle_mm_fault+0xe70/0x1110
[<ffffffff810cdd2e>] ? set_next_entity+0x4e/0x60
[<ffffffff811899bc>] ? find_vma+0x5c/0x70
[<ffffffff81195be3>] ? SyS_madvise+0x4f3/0x760
[<ffffffff8177d192>] ? system_call_fastpath+0x12/0x17
Code: ff ff 0f 1f 80 00 00 00 00 c7 44 24 10 00 00 00 00 e9 ef fa ff ff b8 01 00 00 00 e9 3f fb ff ff 48 83 c8 40 e9 f7 fe ff ff 0f 0b <0f> 0b 48 c7 c6 28 b8 a0 81 4c 89 f7 e8 8d 3c fd ff 0f 0b 48 8b
RIP  [<ffffffff811ad362>] split_huge_page_to_list+0x6a2/0x7c0
RSP <ffff880406073c58>
---[ end trace 6ca92529e1de43ba ]---

The oops happens here:

			BUG_ON(!pte_none(*pte));

In short when we do the split_huge_page_map we withdraw from the pgtable
deposit of the MM and we find that pgtable isn't fully zero.

That is most certainly because we didn't clear it if it was a zero page
before putting it in the deposit.  This adds the pte_clear to fix the bug.

The PT lock could be actually not be taken, as the pte is already private
to us and not visible to any other CPU (we'll be adding it to the deposit
later), but because it's private the lock can't create any contention. 
Considering the paravirt calls (which also should be superfluous) may end
up being invoked and make assumptions, I thought it was safer to keep the
locking protocol the same, even if the pgtable is already private.  In
order to drop it however, we should drop it from the other path too.  If
we want to optimize away the lock from both branches, it's better to do it
in a separate patch.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/huge_memory.c~mm-incorporate-zero-pages-into-transparent-huge-pages-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-incorporate-zero-pages-into-transparent-huge-pages-fix
+++ a/mm/huge_memory.c
@@ -2210,6 +2210,18 @@ static void __collapse_huge_page_copy(pt
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			clear_user_highpage(page, address);
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
+			if (is_zero_pfn(pte_pfn(pteval))) {
+				/*
+				 * ptl mostly unnecessary.
+				 */
+				spin_lock(ptl);
+				/*
+				 * paravirt calls inside pte_clear here are
+				 * superfluous.
+				 */
+				pte_clear(vma->vm_mm, address, _pte);
+				spin_unlock(ptl);
+			}
 		} else {
 			src_page = pte_page(pteval);
 			copy_user_highpage(page, src_page, address, vma);
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch

