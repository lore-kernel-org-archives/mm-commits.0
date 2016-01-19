From: akpm@linux-foundation.org
Subject: [merged]
 mm-soft-offline-check-return-value-in-second-__get_any_page-call.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:02:50 -0800
Message-ID: <569e966a.Q3ibXdxec4sdakpF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbcASUCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, stable@vger.kernel.org, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: check return value in second __get_any_page() call
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-check-return-value-in-second-__get_any_page-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: soft-offline: check return value in second __get_any_page() call

I saw the following BUG_ON triggered in a testcase where a process calls
madvise(MADV_SOFT_OFFLINE) on thps, along with a background process that
calls migratepages command repeatedly (doing ping-pong among different
NUMA nodes) for the first process:

  [   52.556731] Soft offlining page 0x60000 at 0x700000600000
  [   52.592620] __get_any_page: 0x60000 free buddy page
  [   52.593451] page:ffffea0001800000 count:0 mapcount:-127 mapping:          (null) index:0x1
  [   52.594767] flags: 0x1fffc0000000000()
  [   52.595402] page dumped because: VM_BUG_ON_PAGE(atomic_read(&page->_count) == 0)
  [   52.596602] ------------[ cut here ]------------
  [   52.597339] kernel BUG at /src/linux-dev/include/linux/mm.h:342!
  [   52.598284] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
  [   52.599193] Modules linked in: cfg80211 rfkill crc32c_intel serio_raw virtio_balloon i2c_piix4 virtio_blk virtio_net ata_generic pata_acpi
  [   52.600579] CPU: 3 PID: 3035 Comm: test_alloc_gene Tainted: G           O    4.4.0-rc8-v4.4-rc8-160107-1501-00000-rc8+ #74
  [   52.600579] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  [   52.600579] task: ffff88007c63d5c0 ti: ffff88007c210000 task.ti: ffff88007c210000
  [   52.600579] RIP: 0010:[<ffffffff8118998c>]  [<ffffffff8118998c>] put_page+0x5c/0x60
  [   52.600579] RSP: 0018:ffff88007c213e00  EFLAGS: 00010246
  [   52.600579] RAX: 0000000000000044 RBX: ffffea0001800000 RCX: 0000000000000000
  [   52.600579] RDX: ffff88011f50f570 RSI: 0000000000000000 RDI: ffff88011f50cc18
  [   52.600579] RBP: ffff88007c213e08 R08: 000000000000000a R09: 000000000000149c
  [   52.600579] R10: ffff8800dac927f8 R11: 000000000000149c R12: ffffea0001800000
  [   52.600579] R13: 0000000000060000 R14: ffffea0001800000 R15: 0000000000000065
  [   52.600579] FS:  00007feb79d7d740(0000) GS:ffff88011f500000(0000) knlGS:0000000000000000
  [   52.600579] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  [   52.600579] CR2: 00007f3032cd2000 CR3: 00000000da6c4000 CR4: 00000000000006e0
  [   52.600579] Stack:
  [   52.600579]  ffffea0001800000 ffff88007c213e28 ffffffff811eb2ee ffffea0001800000
  [   52.600579]  00000000fffffffb ffff88007c213e70 ffffffff811eccd1 0000000000000018
  [   52.600579]  ffff88007c213e50 0000700000600000 0000700000601000 0000160000000000
  [   52.600579] Call Trace:
  [   52.600579]  [<ffffffff811eb2ee>] put_hwpoison_page+0x4e/0x80
  [   52.600579]  [<ffffffff811eccd1>] soft_offline_page+0x501/0x520
  [   52.600579]  [<ffffffff811bd18c>] SyS_madvise+0x6bc/0x6f0
  [   52.600579]  [<ffffffff8104d0ac>] ? fpu__restore_sig+0xcc/0x320
  [   52.600579]  [<ffffffff810a0003>] ? do_sigaction+0x73/0x1b0
  [   52.600579]  [<ffffffff8109ceb2>] ? __set_task_blocked+0x32/0x70
  [   52.600579]  [<ffffffff81652757>] entry_SYSCALL_64_fastpath+0x12/0x6a
  [   52.600579] Code: 8b fc ff ff 5b 5d c3 48 89 df e8 b0 fa ff ff 48 89 df 31 f6 e8 c6 7d ff ff 5b 5d c3 48 c7 c6 08 54 a2 81 48 89 df e8 a4 c5 01 00 <0f> 0b 66 90 66 66 66 66 90 55 48 89 e5 41 55 41 54 53 48 8b 47
  [   52.600579] RIP  [<ffffffff8118998c>] put_page+0x5c/0x60
  [   52.600579]  RSP <ffff88007c213e00>

The root cause resides in get_any_page() which retries to get a refcount
of the page to be soft-offlined.  This function calls put_hwpoison_page(),
expecting that the target page is putback to LRU list.  But it can be also
freed to buddy.  So the second check need to care about such case.

Fixes: af8fae7c0886 ("mm/memory-failure.c: clean up soft_offline_page()")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-soft-offline-check-return-value-in-second-__get_any_page-call mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft-offline-check-return-value-in-second-__get_any_page-call
+++ a/mm/memory-failure.c
@@ -1575,7 +1575,7 @@ static int get_any_page(struct page *pag
 		 * Did it turn free?
 		 */
 		ret = __get_any_page(page, pfn, 0);
-		if (!PageLRU(page)) {
+		if (ret == 1 && !PageLRU(page)) {
 			/* Drop page reference which is from __get_any_page() */
 			put_hwpoison_page(page);
 			pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-soft-offline-clean-up-soft_offline_page.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

