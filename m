From: akpm@linux-foundation.org
Subject: [merged] mm-migrate-fix-remove_migration_pte-for-ksm-pages.patch
 removed from -mm tree
Date: Mon, 03 Apr 2017 12:07:26 -0700
Message-ID: <58e29d6e.Gg104Gh75nIerqXd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751457AbdDCTH1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 15:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix remove_migration_pte() for ksm pages
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-remove_migration_pte-for-ksm-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: migrate: fix remove_migration_pte() for ksm pages

I found that calling page migration for ksm pages causes the following bug:

    [49467.651804] page:ffffea0004d51180 count:2 mapcount:2 mapping:ffff88013c785141 index:0x913
    [49467.652565] flags: 0x57ffffc0040068(uptodate|lru|active|swapbacked)
    [49467.653115] raw: 0057ffffc0040068 ffff88013c785141 0000000000000913 0000000200000001
    [49467.653762] raw: ffffea0004d5f9e0 ffffea0004d53f60 0000000000000000 ffff88007d81b800
    [49467.654399] page dumped because: VM_BUG_ON_PAGE(!PageLocked(page))
    [49467.654910] page->mem_cgroup:ffff88007d81b800
    [49467.655278] ------------[ cut here ]------------
    [49467.655665] kernel BUG at /src/linux-dev/mm/rmap.c:1086!
    [49467.656102] invalid opcode: 0000 [#1] SMP
    [49467.656451] Modules linked in: ppdev parport_pc virtio_balloon i2c_piix4 pcspkr parport i2c_core acpi_cpufreq ip_tables xfs libcrc32c ata_generic pata_acpi ata_piix 8139too libata virtio_blk 8139cp crc32c_intel mii virtio_pci virtio_ring serio_raw virtio floppy dm_mirror dm_region_hash dm_log dm_mod
    [49467.658653] CPU: 0 PID: 3162 Comm: bash Not tainted 4.11.0-rc2-mm1+ #1
    [49467.659188] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
    [49467.659863] task: ffff88007a20ad00 task.stack: ffffc90002470000
    [49467.660367] RIP: 0010:do_page_add_anon_rmap+0x1ba/0x260
    [49467.660806] RSP: 0018:ffffc90002473b30 EFLAGS: 00010282
    [49467.661331] RAX: 0000000000000021 RBX: ffffea0004d51180 RCX: 0000000000000006
    [49467.661916] RDX: 0000000000000000 RSI: 0000000000000082 RDI: ffff88007dc0dfe0
    [49467.662502] RBP: ffffc90002473b58 R08: 00000000fffffffe R09: 00000000000001c1
    [49467.663085] R10: 0000000000000005 R11: 00000000000001c0 R12: ffff880139ab3d80
    [49467.663696] R13: 0000000000000000 R14: 0000700000000200 R15: 0000160000000000
    [49467.664282] FS:  00007f5195f50740(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
    [49467.664950] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [49467.665426] CR2: 00007fd450287000 CR3: 000000007a08e000 CR4: 00000000001406f0
    [49467.666011] Call Trace:
    [49467.666221]  page_add_anon_rmap+0x18/0x20
    [49467.666573]  remove_migration_pte+0x220/0x2c0
    [49467.666937]  rmap_walk_ksm+0x143/0x220
    [49467.667250]  rmap_walk+0x55/0x60
    [49467.667526]  remove_migration_ptes+0x53/0x80
    [49467.667883]  ? numamigrate_update_ratelimit+0x110/0x110
    [49467.668319]  migrate_pages+0x8ed/0xb60
    [49467.668635]  ? kill_proc.isra.17+0x150/0x150
    [49467.668992]  soft_offline_page+0x309/0x8d0
    [49467.669341]  store_soft_offline_page+0xaf/0xf0
    [49467.669711]  dev_attr_store+0x18/0x30
    [49467.670020]  sysfs_kf_write+0x3a/0x50
    [49467.670330]  kernfs_fop_write+0xff/0x180
    [49467.670657]  __vfs_write+0x37/0x160
    [49467.670951]  ? _cond_resched+0x19/0x30
    [49467.671265]  ? __fd_install+0x31/0xd0
    [49467.671589]  ? _cond_resched+0x19/0x30
    [49467.671904]  vfs_write+0xb2/0x1b0
    [49467.672185]  ? syscall_trace_enter+0x1d0/0x2b0
    [49467.672559]  SyS_write+0x55/0xc0
    [49467.672832]  do_syscall_64+0x67/0x180
    [49467.673139]  entry_SYSCALL64_slow_path+0x25/0x25
    [49467.673525] RIP: 0033:0x7f51956339e0
    [49467.673824] RSP: 002b:00007ffcfa0dffc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
    [49467.674447] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f51956339e0
    [49467.675031] RDX: 000000000000000c RSI: 00007f5195f53000 RDI: 0000000000000001
    [49467.675620] RBP: 00007f5195f53000 R08: 000000000000000a R09: 00007f5195f50740
    [49467.676206] R10: 000000000000000b R11: 0000000000000246 R12: 00007f5195907400
    [49467.676807] R13: 000000000000000c R14: 0000000000000001 R15: 0000000000000000
    [49467.677394] Code: fe ff ff 48 81 c2 00 02 00 00 48 89 55 d8 e8 2e c3 fd ff 48 8b 55 d8 e9 42 ff ff ff 48 c7 c6 e0 52 a1 81 48 89 df e8 46 ad fe ff <0f> 0b 48 83 e8 01 e9 7f fe ff ff 48 83 e8 01 e9 96 fe ff ff 48
    [49467.678944] RIP: do_page_add_anon_rmap+0x1ba/0x260 RSP: ffffc90002473b30
    [49467.680102] ---[ end trace a679d00f4af2df48 ]---
    [49467.680495] Kernel panic - not syncing: Fatal exception
    [49467.680943] Kernel Offset: disabled
    [49467.681237] ---[ end Kernel panic - not syncing: Fatal exception

The problem is in the following lines:

    new = page - pvmw.page->index +
        linear_page_index(vma, pvmw.address);

The 'new' is calculated with 'page' which is given by the caller as a
destination page and some offset adjustment for thp.  But this doesn't
properly work for ksm pages because pvmw.page->index doesn't change for
each address but linear_page_index() changes, which means that 'new'
points to different pages for each addresses backed by the ksm page.  As a
result, we try to set totally unrelated pages as destination pages, and
that causes kernel crash.

This patch fixes the miscalculation and makes ksm page migration work fine.

Fixes: 3fe87967c536 ("mm: convert remove_migration_pte() to use page_vma_mapped_walk()")
Link: http://lkml.kernel.org/r/1489717683-29905-1-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-migrate-fix-remove_migration_pte-for-ksm-pages mm/migrate.c
--- a/mm/migrate.c~mm-migrate-fix-remove_migration_pte-for-ksm-pages
+++ a/mm/migrate.c
@@ -209,8 +209,11 @@ static int remove_migration_pte(struct p
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	while (page_vma_mapped_walk(&pvmw)) {
-		new = page - pvmw.page->index +
-			linear_page_index(vma, pvmw.address);
+		if (PageKsm(page))
+			new = page;
+		else
+			new = page - pvmw.page->index +
+				linear_page_index(vma, pvmw.address);
 
 		get_page(new);
 		pte = pte_mkold(mk_pte(new, READ_ONCE(vma->vm_page_prot)));
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


