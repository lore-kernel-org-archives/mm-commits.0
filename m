Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99BAC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96AF260F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347948AbhIBV7d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347963AbhIBV7b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE9B0603E9;
        Thu,  2 Sep 2021 21:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619912;
        bh=MCo3XbarGALCYGvJu1n2AiGkhZ+20naJuP+3zdwgVqQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X1zgv4d2HmjHrltLIkxg0X81HwgBO5KvF4aBFdwy72ItpRJ5YDv2viufy44g1gvMR
         SGL4LE9+qYiK4eP4DNfoYOpmazeOvGaGTi1vloMw2FL8fj+W6ENfA/gywbN1avJDZ+
         XvhfMSSADYcAYssZrd9ZbFtH7+zbLTgEIIor1JGs=
Date:   Thu, 02 Sep 2021 14:58:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, shy828301@gmail.com,
        tdmackey@twitter.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 162/212] mm: hwpoison: don't drop slab caches for
 offlining non-LRU page
Message-ID: <20210902215831.ed8EFo5iv%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Yang Shi <shy828301@gmail.com>
Subject: mm: hwpoison: don't drop slab caches for offlining non-LRU page

In the current implementation of soft offline, if non-LRU page is met, all
the slab caches will be dropped to free the page then offline.  But if the
page is not slab page all the effort is wasted in vain.  Even though it is
a slab page, it is not guaranteed the page could be freed at all.

However the side effect and cost is quite high.  It does not only drop the
slab caches, but also may drop a significant amount of page caches which
are associated with inode caches.  It could make the most workingset gone
in order to just offline a page.  And the offline is not guaranteed to
succeed at all, actually I really doubt the success rate for real life
workload.

Furthermore the worse consequence is the system may be locked up and
unusable since the page cache release may incur huge amount of works
queued for memcg release.

Actually we ran into such unpleasant case in our production environment.=20
Firstly, the workqueue of memory_failure_work_func is locked up as below:

BUG: workqueue lockup - pool cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 stuck f=
or 53s!
Showing busy workqueues and worker pools:
workqueue events: flags=3D0x0
=C2=A0 pwq 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D14/256 refcnt=
=3D15
=C2=A0 =C2=A0 in-flight: 409271:memory_failure_work_func
=C2=A0 =C2=A0 pending: kfree_rcu_work, kfree_rcu_monitor, kfree_rcu_work, r=
ht_deferred_worker, rht_deferred_worker, rht_deferred_worker, rht_deferred_=
worker, kfree_rcu_work, kfree_rcu_work, kfree_rcu_work, kfree_rcu_work, dra=
in_local_stock, kfree_rcu_work
workqueue mm_percpu_wq: flags=3D0x8
=C2=A0 pwq 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D1/256 refcnt=
=3D2
=C2=A0 =C2=A0 pending: vmstat_update
workqueue cgroup_destroy: flags=3D0x0
  pwq 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D1/1 refcnt=3D12072
    pending: css_release_work_fn

There were over 12K css_release_work_fn queued, and this caused a few
lockups due to the contention of worker pool lock with IRQ disabled, for
example:

NMI watchdog: Watchdog detected hard LOCKUP on cpu 1
Modules linked in: amd64_edac_mod edac_mce_amd crct10dif_pclmul crc32_pclmu=
l ghash_clmulni_intel xt_DSCP iptable_mangle kvm_amd bpfilter vfat fat acpi=
_ipmi i2c_piix4 usb_storage ipmi_si k10temp i2c_core ipmi_devintf ipmi_msgh=
andler acpi_cpufreq sch_fq_codel xfs libcrc32c crc32c_intel mlx5_core mlxfw=
 nvme xhci_pci ptp nvme_core pps_core xhci_hcd
CPU: 1 PID: 205500 Comm: kworker/1:0 Tainted: G             L    5.10.32-t1=
.el7.twitter.x86_64 #1
Hardware name: TYAN F5AMT /z        /S8026GM2NRE-CGN, BIOS V8.030 03/30/2021
Workqueue: events memory_failure_work_func
RIP: 0010:queued_spin_lock_slowpath+0x41/0x1a0
Code: 41 f0 0f ba 2f 08 0f 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 07 30 e4 09 d0 =
a9 00 01 ff ff 75 1b 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 <8b> 07 84 c0 75 f=
8 b8 01 00 00 00 66 89 07 c3 f6 c4 01 75 04 c6 47
RSP: 0018:ffff9b2ac278f900 EFLAGS: 00000002
RAX: 0000000000480101 RBX: ffff8ce98ce71800 RCX: 0000000000000084
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8ce98ce6a140
RBP: 00000000000284c8 R08: ffffd7248dcb6808 R09: 0000000000000000
R10: 0000000000000003 R11: ffff9b2ac278f9b0 R12: 0000000000000001
R13: ffff8cb44dab9c00 R14: ffffffffbd1ce6a0 R15: ffff8cacaa37f068
FS:  0000000000000000(0000) GS:ffff8ce98ce40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcf6e8cb000 CR3: 0000000a0c60a000 CR4: 0000000000350ee0
Call Trace:
 __queue_work+0xd6/0x3c0
 queue_work_on+0x1c/0x30
 uncharge_batch+0x10e/0x110
 mem_cgroup_uncharge_list+0x6d/0x80
 release_pages+0x37f/0x3f0
 __pagevec_release+0x1c/0x50
 __invalidate_mapping_pages+0x348/0x380
 ? xfs_alloc_buftarg+0xa4/0x120 [xfs]
 inode_lru_isolate+0x10a/0x160
 ? iput+0x1d0/0x1d0
 __list_lru_walk_one+0x7b/0x170
 ? iput+0x1d0/0x1d0
 list_lru_walk_one+0x4a/0x60
 prune_icache_sb+0x37/0x50
 super_cache_scan+0x123/0x1a0
 do_shrink_slab+0x10c/0x2c0
 shrink_slab+0x1f1/0x290
 drop_slab_node+0x4d/0x70
 soft_offline_page+0x1ac/0x5b0
 ? dev_mce_log+0xee/0x110
 ? notifier_call_chain+0x39/0x90
 memory_failure_work_func+0x6a/0x90
 process_one_work+0x19e/0x340
 ? process_one_work+0x340/0x340
 worker_thread+0x30/0x360
 ? process_one_work+0x340/0x340
 kthread+0x116/0x130

The lockup made the machine is quite unusable.  And it also made the most
workingset gone, the reclaimabled slab caches were reduced from 12G to
300MB, the page caches were decreased from 17G to 4G.

But the most disappointing thing is all the effort doesn't make the page
offline, it just returns:

soft_offline: 0x1469f2: unknown non LRU page type 5ffff0000000000 ()

It seems the aggressive behavior for non-LRU page didn't pay back, so it
doesn't make too much sense to keep it considering the terrible side
effect.

Link: https://lkml.kernel.org/r/20210819054116.266126-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: David Mackey <tdmackey@twitter.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    2 +-
 mm/hwpoison-inject.c |    2 +-
 mm/memory-failure.c  |   18 ++++++++----------
 3 files changed, 10 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-dont-drop-slab-caches-for-offlining-no=
n-lru-page
+++ a/include/linux/mm.h
@@ -3110,7 +3110,7 @@ extern void memory_failure_queue_kick(in
 extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
-extern void shake_page(struct page *p, int access);
+extern void shake_page(struct page *p);
 extern atomic_long_t num_poisoned_pages __read_mostly;
 extern int soft_offline_page(unsigned long pfn, int flags);
=20
--- a/mm/hwpoison-inject.c~mm-hwpoison-dont-drop-slab-caches-for-offlining-=
non-lru-page
+++ a/mm/hwpoison-inject.c
@@ -30,7 +30,7 @@ static int hwpoison_inject(void *data, u
 	if (!hwpoison_filter_enable)
 		goto inject;
=20
-	shake_page(hpage, 0);
+	shake_page(hpage);
 	/*
 	 * This implies unable to support non-LRU pages.
 	 */
--- a/mm/memory-failure.c~mm-hwpoison-dont-drop-slab-caches-for-offlining-n=
on-lru-page
+++ a/mm/memory-failure.c
@@ -282,9 +282,9 @@ static int kill_proc(struct to_kill *tk,
=20
 /*
  * Unknown page type encountered. Try to check whether it can turn PageLRU=
 by
- * lru_add_drain_all, or a free page by reclaiming slabs when possible.
+ * lru_add_drain_all.
  */
-void shake_page(struct page *p, int access)
+void shake_page(struct page *p)
 {
 	if (PageHuge(p))
 		return;
@@ -296,11 +296,9 @@ void shake_page(struct page *p, int acce
 	}
=20
 	/*
-	 * Only call drop_slab_node here (which would also shrink
-	 * other caches) if access is not potentially fatal.
+	 * TODO: Could shrink slab caches here if a lightweight range-based
+	 * shrinker will be available.
 	 */
-	if (access)
-		drop_slab_node(page_to_nid(p));
 }
 EXPORT_SYMBOL_GPL(shake_page);
=20
@@ -1205,7 +1203,7 @@ try_again:
 			 * page, retry.
 			 */
 			if (pass++ < 3) {
-				shake_page(p, 1);
+				shake_page(p);
 				goto try_again;
 			}
 			ret =3D -EIO;
@@ -1222,7 +1220,7 @@ try_again:
 		 */
 		if (pass++ < 3) {
 			put_page(p);
-			shake_page(p, 1);
+			shake_page(p);
 			count_increased =3D false;
 			goto try_again;
 		}
@@ -1369,7 +1367,7 @@ static bool hwpoison_user_mappings(struc
 	 * shake_page() again to ensure that it's flushed.
 	 */
 	if (mlocked)
-		shake_page(hpage, 0);
+		shake_page(hpage);
=20
 	/*
 	 * Now that the dirty bit has been propagated to the
@@ -1723,7 +1721,7 @@ try_again:
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	shake_page(p, 0);
+	shake_page(p);
=20
 	lock_page(p);
=20
_
