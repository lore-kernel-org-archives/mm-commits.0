From: akpm@linux-foundation.org
Subject: +
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
 added to -mm tree
Date: Tue, 03 Nov 2015 14:45:09 -0800
Message-ID: <563938f5.sI3ImkOIy/Fqby5P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbbKCWpK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2015 17:45:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not crash on PageDoubleMap() for non-head pages
has been added to the -mm tree.  Its filename is
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: do not crash on PageDoubleMap() for non-head pages

We usually don't call PageDoubleMap() on small or tail pages, but during
read from /proc/kpageflags we don't protect the page from being freed
under us and it can lead to VM_BUG_ON_PAGE() in PageDoubleMap():

 page:ffffea00033e0000 count:0 mapcount:0 mapping:          (null) index:0x700000200
 flags: 0x4000000000000000()
 page dumped because: VM_BUG_ON_PAGE(!PageHead(page))
 page->mem_cgroup:ffff88021588cc00
 ------------[ cut here ]------------
 kernel BUG at /src/linux-dev/include/linux/page-flags.h:552!
 invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
 Modules linked in: cfg80211 rfkill crc32c_intel virtio_balloon serio_raw i2c_piix4 virtio_blk virtio_net ata_generic pata_acpi
 CPU: 0 PID: 1183 Comm: page-types Not tainted 4.2.0-mmotm-2015-10-21-14-41-151027-1418-00014-41+ #179
 Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 task: ffff880214a08bc0 ti: ffff880213e2c000 task.ti: ffff880213e2c000
 RIP: 0010:[<ffffffff812434b6>]  [<ffffffff812434b6>] stable_page_flags+0x336/0x340
 RSP: 0018:ffff880213e2fda8  EFLAGS: 00010292
 RAX: 0000000000000021 RBX: ffff8802150a39c0 RCX: 0000000000000000
 RDX: ffff88021ec0ff38 RSI: ffff88021ec0d658 RDI: ffff88021ec0d658
 RBP: ffff880213e2fdc8 R08: 000000000000000a R09: 000000000000132f
 R10: 0000000000000000 R11: 000000000000132f R12: 4000000000000000
 R13: ffffea00033e6340 R14: 00007fff8449e430 R15: ffffea00033e6340
 FS:  00007ff7f9525700(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000000063b800 CR3: 00000000d9e71000 CR4: 00000000000006f0
 Stack:
  ffff8800db82df80 ffff8802150a39c0 0000000000000008 00000000000cf98d
  ffff880213e2fe18 ffffffff81243588 00007fff8449e430 ffff880213e2ff20
  000000000063b800 ffff8802150a39c0 fffffffffffffffb ffff880213e2ff20
 Call Trace:
  [<ffffffff81243588>] kpageflags_read+0xc8/0x130
  [<ffffffff81235848>] proc_reg_read+0x48/0x70
  [<ffffffff811d6b08>] __vfs_read+0x28/0xd0
  [<ffffffff812ee43e>] ? security_file_permission+0xae/0xc0
  [<ffffffff811d6f53>] ? rw_verify_area+0x53/0xf0
  [<ffffffff811d707a>] vfs_read+0x8a/0x130
  [<ffffffff811d7bf7>] SyS_pread64+0x77/0x90
  [<ffffffff81648117>] entry_SYSCALL_64_fastpath+0x12/0x6a
 Code: ca 00 00 40 01 48 39 c1 48 0f 44 da e9 a2 fd ff ff 48 c7 c6 50 a6 a1 8 1 e8 58 ab f4 ff 0f 0b 48 c7 c6 90 a2 a1 81 e8 4a ab f4 ff <0f> 0b 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 57
 RIP  [<ffffffff812434b6>] stable_page_flags+0x336/0x340
  RSP <ffff880213e2fda8>
 ---[ end trace e5d18553088c026a ]---

Let's drop the VM_BUG_ON_PAGE() from PageDoubleMap() and return false for
non-head pages.

The patch can be folded into
	"mm: rework mapcount accounting to enable 4k mapping of THPs"

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/page-flags.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2 include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2
+++ a/include/linux/page-flags.h
@@ -549,8 +549,7 @@ static inline int PageTransTail(struct p
  */
 static inline int PageDoubleMap(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	return test_bit(PG_double_map, &page[1].flags);
+	return PageHead(page) && test_bit(PG_double_map, &page[1].flags);
 }
 
 static inline int TestSetPageDoubleMap(struct page *page)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch

