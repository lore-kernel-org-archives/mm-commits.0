From: akpm@linux-foundation.org
Subject: [folded-merged]
 rmap-add-argument-to-charge-compound-page-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:33:12 -0800
Message-ID: <56982228.U4uNvHn9ztyaffr1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbcANWdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix mapcount mismatch in hugepage migration
has been removed from the -mm tree.  Its filename was
     rmap-add-argument-to-charge-compound-page-fix.patch

This patch was dropped because it was folded into rmap-add-argument-to-charge-compound-page.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: fix mapcount mismatch in hugepage migration

try_to_unmap_one() should be able to handle hugetlb, but page_remove_rmap()
in that function takes false as a compound flag, which breaks hugepage migration
with the following message.

  Soft offlining page 0x1d4a00 at 0x7ff634a00000
  soft offline: 0x1d4a00: migration failed 1, type 60000000000401c
  BUG: Bad page state in process sysctl  pfn:1d4a00
  page:ffffea0007528000 count:0 mapcount:0 mapping:          (null) index:0x0 compound_mapcount: 10
  flags: 0x600000000004008(uptodate|head)
  page dumped because: nonzero mapcount
  Modules linked in: cfg80211 rfkill crc32c_intel virtio_balloon serio_raw i2c_piix4 virtio_blk virtio_net ata_generic pata_acpi
  CPU: 3 PID: 11882 Comm: sysctl Tainted: G        W       4.3.0-mmotm-2015-11-10-15-53-151112-1812-00015-53+ #240
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
   ffffffff81a1a124 ffff8800da047bd0 ffffffff81340adf ffffea0007528000
   ffff8800da047bf8 ffffffff8116e206 0000000000000009 ffffffff81f72538
   ffffea0007528000 ffff8800da047c48 ffffffff8116e6d6 0000020000000000
  Call Trace:
   [<ffffffff81340adf>] dump_stack+0x44/0x55
   [<ffffffff8116e206>] bad_page+0xc6/0x110
   [<ffffffff8116e6d6>] free_pages_prepare+0x486/0x500
   [<ffffffff81170f9a>] __free_pages_ok+0x1a/0xb0
   [<ffffffff81171af1>] __free_pages+0x21/0x40
   [<ffffffff811b5d79>] update_and_free_page+0xa9/0x230
   [<ffffffff811b6641>] free_pool_huge_page+0xc1/0xe0
   [<ffffffff811b6d02>] set_max_huge_pages+0x382/0x4d0
   [<ffffffff811b7002>] hugetlb_sysctl_handler_common+0xa2/0xd0
   [<ffffffff811b823e>] hugetlb_sysctl_handler+0x1e/0x20
   [<ffffffff812535fe>] proc_sys_call_handler+0xae/0xc0
   [<ffffffff81253624>] proc_sys_write+0x14/0x20
   [<ffffffff811e8758>] __vfs_write+0x28/0xe0
   [<ffffffff810d1864>] ? percpu_down_read+0x14/0x60
   [<ffffffff811e8d29>] vfs_write+0xa9/0x190
   [<ffffffff811e9646>] SyS_write+0x46/0xb0
   [<ffffffff8163d797>] entry_SYSCALL_64_fastpath+0x12/0x6a

This patch simply fixes this by giving the compound flag via PageHuge.


Fixes: "rmap: add argument to charge compound page".

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~rmap-add-argument-to-charge-compound-page-fix mm/rmap.c
--- a/mm/rmap.c~rmap-add-argument-to-charge-compound-page-fix
+++ a/mm/rmap.c
@@ -1430,7 +1430,7 @@ static int try_to_unmap_one(struct page
 	} else
 		dec_mm_counter(mm, mm_counter_file(page));
 
-	page_remove_rmap(page, false);
+	page_remove_rmap(page, PageHuge(page));
 	page_cache_release(page);
 
 out_unmap:
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-page_isolation-use-micro-to-judge-the-alignment.patch
rmap-add-argument-to-charge-compound-page.patch
mm-soft-offline-check-return-value-in-second-__get_any_page-call.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

