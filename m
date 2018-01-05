From: akpm@linux-foundation.org
Subject: [patch 1/9] mm: check pfn_valid first in zero_resv_unavail
Date: Thu, 04 Jan 2018 16:17:45 -0800
Message-ID: <5a4ec429.12kiKYbQrUivoG32%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEARr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jan 2018 19:17:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dyoung@redhat.com, mhocko@kernel.org, pasha.tatashin@oracle.com

From: Dave Young <dyoung@redhat.com>
Subject: mm: check pfn_valid first in zero_resv_unavail

With latest kernel I get below bug while testing kdump:

[    0.000000] BUG: unable to handle kernel paging request at ffffea00034b1040
[    0.000000] IP: zero_resv_unavail+0xbd/0x126
[    0.000000] PGD 37b98067 P4D 37b98067 PUD 37b97067 PMD 0
[    0.000000] Oops: 0002 [#1] SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.15.0-rc1+ #316
[    0.000000] Hardware name: LENOVO 20ARS1BJ02/20ARS1BJ02, BIOS GJET92WW (2.42 ) 03/03/2017
[    0.000000] task: ffffffff81a0e4c0 task.stack: ffffffff81a00000
[    0.000000] RIP: 0010:zero_resv_unavail+0xbd/0x126
[    0.000000] RSP: 0000:ffffffff81a03d88 EFLAGS: 00010006
[    0.000000] RAX: 0000000000000000 RBX: ffffea00034b1040 RCX: 0000000000000010
[    0.000000] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffffea00034b1040
[    0.000000] RBP: 00000000000d2c41 R08: 00000000000000c0 R09: 0000000000000a0d
[    0.000000] R10: 0000000000000002 R11: 0000000000007f01 R12: ffffffff81a03d90
[    0.000000] R13: ffffea0000000000 R14: 0000000000000063 R15: 0000000000000062
[    0.000000] FS:  0000000000000000(0000) GS:ffffffff81c73000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: ffffea00034b1040 CR3: 0000000037609000 CR4: 00000000000606b0
[    0.000000] Call Trace:
[    0.000000]  ? free_area_init_nodes+0x640/0x664
[    0.000000]  ? zone_sizes_init+0x58/0x72
[    0.000000]  ? setup_arch+0xb50/0xc6c
[    0.000000]  ? start_kernel+0x64/0x43d
[    0.000000]  ? secondary_startup_64+0xa5/0xb0
[    0.000000] Code: c1 e8 0c 48 39 d8 76 27 48 89 de 48 c1 e3 06 48 c7 c7 7a 87 79 81 e8 b0 c0 3e ff 4c 01 eb b9 10 00 00 00 31 c0 48 89 df 49 ff c6 <f3> ab eb bc 6a 00 49
c7 c0 f0 93 d1 81 31 d2 83 ce ff 41 54 49
[    0.000000] RIP: zero_resv_unavail+0xbd/0x126 RSP: ffffffff81a03d88
[    0.000000] CR2: ffffea00034b1040
[    0.000000] ---[ end trace f5ba9e8f73c7ee26 ]---

This is introduced by a4a3ede2132a ("mm: zero reserved and unavailable
struct pages").

The reason is some efi reserved boot ranges is not reported in E820 ram.
In my case it is a bgrt buffer:
efi: mem00: [Boot Data          |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d2c41000-0x00000000d2c85fff] (0MB)

Use "add_efi_memmap" can workaround the problem with another fix:
http://lkml.kernel.org/r/20171130052327.GA3500@dhcp-128-65.nay.redhat.com

In zero_resv_unavail it would be better to check pfn_valid first before zero
the page struct. This fixes the problem and potential other similar problems.
Also as Pavel Tatashin suggested checks pfn_valid at the beginning of the
section.

The range is backed by real memory.  The memory range is efi "Boot
Service Data", that means after ExitBootServices() these ranges can be
used as system ram.  But some of them need to be reserved, for example
the bgrt image address in an acpi table, if the image memory is freed
then kexec reboot will fail because kexec inherit same acpi table to
initialize the driver.

Link: http://lkml.kernel.org/r/20171201095048.GA3084@dhcp-128-65.nay.redhat.com
Fixes: a4a3ede2132a ("mm: zero reserved and unavailable struct pages")
Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-check-pfn_valid-first-in-zero_resv_unavail mm/page_alloc.c
--- a/mm/page_alloc.c~mm-check-pfn_valid-first-in-zero_resv_unavail
+++ a/mm/page_alloc.c
@@ -6260,6 +6260,8 @@ void __paginginit zero_resv_unavail(void
 	pgcnt = 0;
 	for_each_resv_unavail_range(i, &start, &end) {
 		for (pfn = PFN_DOWN(start); pfn < PFN_UP(end); pfn++) {
+			if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages)))
+				continue;
 			mm_zero_struct_page(pfn_to_page(pfn));
 			pgcnt++;
 		}
_
