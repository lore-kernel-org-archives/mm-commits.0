From: akpm@linux-foundation.org
Subject: [patch 26/51] mm/device-public-memory: fix edge case in
 _vm_normal_page()
Date: Tue, 03 Oct 2017 16:15:35 -0700
Message-ID: <59d41a17.AviUJQczN/dbBpvU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58654 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, jglisse@redhat.com

From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: mm/device-public-memory: fix edge case in _vm_normal_page()

With device public pages at the end of my memory space, I'm getting output
from _vm_normal_page():

BUG: Bad page map in process migrate_pages  pte:c0800001ffff0d06 pmd:f95d3000
addr:00007fff89330000 vm_flags:00100073 anon_vma:c0000000fa899320 mapping:          (null) index:7fff8933
file:          (null) fault:          (null) mmap:          (null) readpage:          (null)
CPU: 0 PID: 13963 Comm: migrate_pages Tainted: P    B      OE 4.14.0-rc1-wip #155
Call Trace:
[c0000000f965f910] [c00000000094d55c] dump_stack+0xb0/0xf4 (unreliable)
[c0000000f965f950] [c0000000002b269c] print_bad_pte+0x28c/0x340
[c0000000f965fa00] [c0000000002b59c0] _vm_normal_page+0xc0/0x140
[c0000000f965fa20] [c0000000002b6e64] zap_pte_range+0x664/0xc10
[c0000000f965fb00] [c0000000002b7858] unmap_page_range+0x318/0x670
[c0000000f965fbd0] [c0000000002b8074] unmap_vmas+0x74/0xe0
[c0000000f965fc20] [c0000000002c4a18] exit_mmap+0xe8/0x1f0
[c0000000f965fce0] [c0000000000ecbdc] mmput+0xac/0x1f0
[c0000000f965fd10] [c0000000000f62e8] do_exit+0x348/0xcd0
[c0000000f965fdd0] [c0000000000f6d2c] do_group_exit+0x5c/0xf0
[c0000000f965fe10] [c0000000000f6ddc] SyS_exit_group+0x1c/0x20
[c0000000f965fe30] [c00000000000b184] system_call+0x58/0x6c

The pfn causing this is the very last one.  Correct the bounds check
accordingly.

Fixes: df6ad69838fc ("mm/device-public-memory: device memory cache coherent with CPU")
Link: http://lkml.kernel.org/r/1506092178-20351-1-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
Reviewed-by: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-device-public-memory-fix-edge-case-in-_vm_normal_page mm/memory.c
--- a/mm/memory.c~mm-device-public-memory-fix-edge-case-in-_vm_normal_page
+++ a/mm/memory.c
@@ -845,7 +845,7 @@ struct page *_vm_normal_page(struct vm_a
 		 * vm_normal_page() so that we do not have to special case all
 		 * call site of vm_normal_page().
 		 */
-		if (likely(pfn < highest_memmap_pfn)) {
+		if (likely(pfn <= highest_memmap_pfn)) {
 			struct page *page = pfn_to_page(pfn);
 
 			if (is_device_public_page(page)) {
_
