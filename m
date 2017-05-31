From: akpm@linux-foundation.org
Subject: + mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch added
 to -mm tree
Date: Wed, 31 May 2017 11:18:26 -0700
Message-ID: <592f08f2.Xldr/SPzlAhx9UPi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdEaSS1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 14:18:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, riel@redhat.com, rmk@armlinux.org.uk, sfr@canb.auug.org.au, tony@atomide.com, vdavydov.dev@gmail.com, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-per-lruvec-stats-infrastructure-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-per-lruvec-stats-infrastructure-fix

Fix the following crash in the new cgroup stat keeping code:

Freeing unused kernel memory: 856K
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1104K
Freeing unused kernel memory: 588K
page:ffffea000005d8c0 count:2 mapcount:1 mapping:          (null) index:0x0
flags: 0x800000000000801(locked|reserved)
raw: 0800000000000801 0000000000000000 0000000000000000 0000000200000000
raw: ffffea000005d8e0 ffffea000005d8e0 0000000000000000 0000000000000000
page dumped because: not cgrouped, will crash
BUG: unable to handle kernel NULL pointer dereference at 00000000000004d8
IP: page_add_file_rmap+0x56/0xf0
PGD 0
P4D 0
Oops: 0000 [#1] SMP
CPU: 0 PID: 1 Comm: init Not tainted 4.12.0-rc2-00065-g390160f076be-dirty #326
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
task: ffff88007d380000 task.stack: ffffc9000031c000
RIP: 0010:page_add_file_rmap+0x56/0xf0
RSP: 0000:ffffc9000031fd88 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea000005d8c0 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007ffde000
RBP: ffffc9000031fd98 R08: 0000000000000003 R09: 0000000000000000
R10: ffffc9000031fd18 R11: 0000000000000000 R12: ffff88007ffdfab8
R13: ffffea000005d8c0 R14: ffff88007c76d508 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000004d8 CR3: 000000007c76c000 CR4: 00000000000006b0
Call Trace:
 alloc_set_pte+0xb5/0x2f0
 finish_fault+0x2b/0x50
 __handle_mm_fault+0x3e5/0xb90
 handle_mm_fault+0x284/0x340
 __do_page_fault+0x1fb/0x410
 do_page_fault+0xc/0x10
 page_fault+0x22/0x30

This is a special page being faulted, and these will never be charged
to a cgroup. Assume the root cgroup for uncharged pages to fix this.

Link: http://lkml.kernel.org/r/20170531171450.GA10481@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@armlinux.org.uk>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix
+++ a/include/linux/memcontrol.h
@@ -596,18 +596,26 @@ static inline void mod_lruvec_state(stru
 static inline void __mod_lruvec_page_state(struct page *page,
 					   enum node_stat_item idx, int val)
 {
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	lruvec = mem_cgroup_lruvec(page_pgdat(page), page->mem_cgroup);
+	/* Special pages in the VM aren't charged, use root */
+	memcg = page->mem_cgroup ? : root_mem_cgroup;
+
+	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
 	__mod_lruvec_state(lruvec, idx, val);
 }
 
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	lruvec = mem_cgroup_lruvec(page_pgdat(page), page->mem_cgroup);
+	/* Special pages in the VM aren't charged, use root */
+	memcg = page->mem_cgroup ? : root_mem_cgroup;
+
+	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
 	mod_lruvec_state(lruvec, idx, val);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

