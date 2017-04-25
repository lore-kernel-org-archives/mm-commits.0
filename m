From: akpm@linux-foundation.org
Subject: + mm-uncharge-poisoned-pages.patch added to -mm tree
Date: Tue, 25 Apr 2017 13:47:30 -0700
Message-ID: <58ffb5e2.vyF9XmXik9woSRl7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176518AbdDYUrc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 16:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, avagin@openvz.org, glommer@openvz.org, n-horiguchi@ah.jp.nec.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uncharge poisoned pages
has been added to the -mm tree.  Its filename is
     mm-uncharge-poisoned-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-uncharge-poisoned-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-uncharge-poisoned-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: mm: uncharge poisoned pages

When page are poisoned, they should be uncharged from the root memory
cgroup.

This is required to avoid a BUG raised when the page is onlined back:
BUG: Bad page state in process mem-on-off-test  pfn:7ae3b
page:f000000001eb8ec0 count:0 mapcount:0 mapping:          (null)
index:0x1
flags: 0x3ffff800200000(hwpoison)
raw: 003ffff800200000 0000000000000000 0000000000000001
00000000ffffffff
raw: 5deadbeef0000100 5deadbeef0000200 0000000000000000
c0000007fe055800
page dumped because: page still charged to cgroup
page->mem_cgroup:c0000007fe055800
Modules linked in: pseries_rng rng_core vmx_crypto virtio_balloon
ip_tables x_tables autofs4 virtio_blk virtio_net virtio_pci
virtio_ring virtio
CPU: 34 PID: 5946 Comm: mem-on-off-test Tainted: G    B 4.11.0-rc7-hwp
Call Trace:
[c0000007e4a737f0] [c000000000958e8c] dump_stack+0xb0/0xf0
(unreliable)
[c0000007e4a73830] [c00000000021588c] bad_page+0x11c/0x190
[c0000007e4a738c0] [c00000000021757c] free_pcppages_bulk+0x46c/0x600
[c0000007e4a73990] [c00000000021924c] free_hot_cold_page+0x2ec/0x320
[c0000007e4a739e0] [c0000000002a6440] generic_online_page+0x50/0x70
[c0000007e4a73a10] [c0000000002a6184] online_pages_range+0x94/0xe0
[c0000007e4a73a70] [c00000000005a2b0] walk_system_ram_range+0xe0/0x120
[c0000007e4a73ac0] [c0000000002cce44] online_pages+0x2b4/0x6b0
[c0000007e4a73b60] [c000000000600558] memory_subsys_online+0x218/0x270
[c0000007e4a73bf0] [c0000000005dec84] device_online+0xb4/0x110
[c0000007e4a73c30] [c000000000600f00] store_mem_state+0xc0/0x190
[c0000007e4a73c70] [c0000000005da1d4] dev_attr_store+0x34/0x60
[c0000007e4a73c90] [c000000000377c70] sysfs_kf_write+0x60/0xa0
[c0000007e4a73cb0] [c0000000003769fc] kernfs_fop_write+0x16c/0x240
[c0000007e4a73d00] [c0000000002d1b0c] __vfs_write+0x3c/0x1b0
[c0000007e4a73d90] [c0000000002d34dc] vfs_write+0xcc/0x230
[c0000007e4a73de0] [c0000000002d50e0] SyS_write+0x60/0x110
[c0000007e4a73e30] [c00000000000b760] system_call+0x38/0xfc

Link: http://lkml.kernel.org/r/1493130472-22843-2-git-send-email-ldufour@linux.vnet.ibm.com
Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memory-failure.c~mm-uncharge-poisoned-pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-uncharge-poisoned-pages
+++ a/mm/memory-failure.c
@@ -529,6 +529,9 @@ static const char * const action_page_ty
  */
 static int delete_from_lru_cache(struct page *p)
 {
+	if (memcg_kmem_enabled())
+		memcg_kmem_uncharge(p, 0);
+
 	if (!isolate_lru_page(p)) {
 		/*
 		 * Clear sensible page flags, so that the buddy system won't
_

Patches currently in -mm which might be from ldufour@linux.vnet.ibm.com are

mm-uncharge-poisoned-pages.patch
mm-skip-hwpoisoned-pages-when-onlining-pages.patch

