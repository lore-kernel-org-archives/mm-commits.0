From: akpm@linux-foundation.org
Subject: +
 net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue.patch
 added to -mm tree
Date: Fri, 10 Nov 2017 15:09:28 -0800
Message-ID: <5a0631a8.dtdFCjhNOt8VZRqb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdKJXJ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2017 18:09:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, jiri@mellanox.com, nogahf@mellanox.com, simon.horman@netronome.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/sched/sch_red.c: work around gcc-4.4.4 anon union initializer issue
has been added to the -mm tree.  Its filename is
     net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net/sched/sch_red.c: work around gcc-4.4.4 anon union initializer issue

gcc-4.4.4 (at lest) has issues with initializers and anonymous unions:

net/sched/sch_red.c: In function 'red_dump_offload':
net/sched/sch_red.c:282: error: unknown field 'stats' specified in initializer
net/sched/sch_red.c:282: warning: initialization makes integer from pointer without a cast
net/sched/sch_red.c:283: error: unknown field 'stats' specified in initializer
net/sched/sch_red.c:283: warning: initialization makes integer from pointer without a cast
net/sched/sch_red.c: In function 'red_dump_stats':
net/sched/sch_red.c:352: error: unknown field 'xstats' specified in initializer
net/sched/sch_red.c:352: warning: initialization makes integer from pointer without a cast

Work around this.

Fixes: 602f3baf2218 ("net_sch: red: Add offload ability to RED qdisc")
Cc: Nogah Frankel <nogahf@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Simon Horman <simon.horman@netronome.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/sch_red.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN net/sched/sch_red.c~net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue net/sched/sch_red.c
--- a/net/sched/sch_red.c~net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue
+++ a/net/sched/sch_red.c
@@ -276,11 +276,13 @@ static int red_dump_offload(struct Qdisc
 {
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_red_qopt_offload hw_stats = {
+		.command = TC_RED_STATS,
 		.handle = sch->handle,
 		.parent = sch->parent,
-		.command = TC_RED_STATS,
-		.stats.bstats = &sch->bstats,
-		.stats.qstats = &sch->qstats,
+		{
+			.stats.bstats = &sch->bstats,
+			.stats.qstats = &sch->qstats,
+		},
 	};
 	int err;
 
@@ -346,10 +348,12 @@ static int red_dump_stats(struct Qdisc *
 	if (tc_can_offload(dev) &&  dev->netdev_ops->ndo_setup_tc) {
 		struct red_stats hw_stats = {0};
 		struct tc_red_qopt_offload hw_stats_request = {
+			.command = TC_RED_XSTATS,
 			.handle = sch->handle,
 			.parent = sch->parent,
-			.command = TC_RED_XSTATS,
-			.xstats = &hw_stats,
+			{
+				.xstats = &hw_stats,
+			},
 		};
 		if (!dev->netdev_ops->ndo_setup_tc(dev,
 						   TC_SETUP_QDISC_RED,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

