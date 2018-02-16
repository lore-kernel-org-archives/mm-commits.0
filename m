From: akpm@linux-foundation.org
Subject: +
 mm-dont-defer-struct-page-initialization-for-xen-pv-guests.patch added to
 -mm tree
Date: Fri, 16 Feb 2018 12:44:17 -0800
Message-ID: <5a8742a1.LVodVjmppNrilXGd%akpm__14418.0662268356$1518813748$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbeBPUoT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 15:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jgross@suse.com, bob.picco@oracle.com, daniel.m.jordan@oracle.com, pasha.tatashin@oracle.com, stable@vger.kernel.org, steven.sistare@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't defer struct page initialization for Xen pv guests
has been added to the -mm tree.  Its filename is
     mm-dont-defer-struct-page-initialization-for-xen-pv-guests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-defer-struct-page-initialization-for-xen-pv-guests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-defer-struct-page-initialization-for-xen-pv-guests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Juergen Gross <jgross@suse.com>
Subject: mm: don't defer struct page initialization for Xen pv guests

f7f99100d8d95d ("mm: stop zeroing memory during allocation in vmemmap")
broke Xen pv domains in some configurations, as the "Pinned" information
in struct page of early page tables could get lost.  This will lead to the
kernel trying to write directly into the page tables instead of asking the
hypervisor to do so.  The result is a crash like the following:

[    0.004000] BUG: unable to handle kernel paging request at ffff8801ead19008
[    0.004000] IP: xen_set_pud+0x4e/0xd0
[    0.004000] PGD 1c0a067 P4D 1c0a067 PUD 23a0067 PMD 1e9de0067 PTE 80100001ead19065
[    0.004000] Oops: 0003 [#1] PREEMPT SMP
[    0.004000] Modules linked in:
[    0.004000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0-default+ #271
[    0.004000] Hardware name: Dell Inc. Latitude E6440/0159N7, BIOS A07 06/26/2014
[    0.004000] task: ffffffff81c10480 task.stack: ffffffff81c00000
[    0.004000] RIP: e030:xen_set_pud+0x4e/0xd0
[    0.004000] RSP: e02b:ffffffff81c03cd8 EFLAGS: 00010246
[    0.004000] RAX: 002ffff800000800 RBX: ffff88020fd31000 RCX: 0000000000000000
[    0.004000] RDX: ffffea0000000000 RSI: 00000001b8308067 RDI: ffff8801ead19008
[    0.004000] RBP: ffff8801ead19008 R08: aaaaaaaaaaaaaaaa R09: 00000000063f4c80
[    0.004000] R10: aaaaaaaaaaaaaaaa R11: 0720072007200720 R12: 00000001b8308067
[    0.004000] R13: ffffffff81c8a9cc R14: ffff88018fd31000 R15: 000077ff80000000
[    0.004000] FS:  0000000000000000(0000) GS:ffff88020f600000(0000) knlGS:0000000000000000
[    0.004000] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.004000] CR2: ffff8801ead19008 CR3: 0000000001c09000 CR4: 0000000000042660
[    0.004000] Call Trace:
[    0.004000]  __pmd_alloc+0x128/0x140
[    0.004000]  ? acpi_os_map_iomem+0x175/0x1b0
[    0.004000]  ioremap_page_range+0x3f4/0x410
[    0.004000]  ? acpi_os_map_iomem+0x175/0x1b0
[    0.004000]  __ioremap_caller+0x1c3/0x2e0
[    0.004000]  acpi_os_map_iomem+0x175/0x1b0
[    0.004000]  acpi_tb_acquire_table+0x39/0x66
[    0.004000]  acpi_tb_validate_table+0x44/0x7c
[    0.004000]  acpi_tb_verify_temp_table+0x45/0x304
[    0.004000]  ? acpi_ut_acquire_mutex+0x12a/0x1c2
[    0.004000]  acpi_reallocate_root_table+0x12d/0x141
[    0.004000]  acpi_early_init+0x4d/0x10a
[    0.004000]  start_kernel+0x3eb/0x4a1
[    0.004000]  ? set_init_arg+0x55/0x55
[    0.004000]  xen_start_kernel+0x528/0x532
[    0.004000] Code: 48 01 e8 48 0f 42 15 a2 fd be 00 48 01 d0 48 ba 00 00 00 00 00 ea ff ff 48 c1 e8 0c 48 c1 e0 06 48 01 d0 48 8b 00 f6 c4 02 75 5d <4c> 89 65 00 5b 5d 41 5c c3 65 8b 05 52 9f fe 7e 89 c0 48 0f a3
[    0.004000] RIP: xen_set_pud+0x4e/0xd0 RSP: ffffffff81c03cd8
[    0.004000] CR2: ffff8801ead19008
[    0.004000] ---[ end trace 38eca2e56f1b642e ]---

Avoid this problem by not deferring struct page initialization when
running as Xen pv guest.

Link: http://lkml.kernel.org/r/20180216154101.22865-1-jgross@suse.com
Fixes: f7f99100d8d95d ("mm: stop zeroing memory during allocation in vmemmap")
Signed-off-by: Juergen Gross <jgross@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: <stable@vger.kernel.org>	[4.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-dont-defer-struct-page-initialization-for-xen-pv-guests mm/page_alloc.c
--- a/mm/page_alloc.c~mm-dont-defer-struct-page-initialization-for-xen-pv-guests
+++ a/mm/page_alloc.c
@@ -347,6 +347,9 @@ static inline bool update_defer_init(pg_
 	/* Always populate low zones for address-constrained allocations */
 	if (zone_end < pgdat_end_pfn(pgdat))
 		return true;
+	/* Xen PV domains need page structures early */
+	if (xen_pv_domain())
+		return true;
 	(*nr_initialised)++;
 	if ((*nr_initialised > pgdat->static_init_pgcnt) &&
 	    (pfn & (PAGES_PER_SECTION - 1)) == 0) {
_

Patches currently in -mm which might be from jgross@suse.com are

mm-dont-defer-struct-page-initialization-for-xen-pv-guests.patch

