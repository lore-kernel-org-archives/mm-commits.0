Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD50C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E14061402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhEHWut (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWus (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EB2D6100C;
        Sat,  8 May 2021 22:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514186;
        bh=oShT6VBx+IQ7IzQ115uW+F/KW/gh2ubAfkGcH+utFmM=;
        h=Date:From:To:Subject:From;
        b=DnEiUyBCek3uiDzTWemZmhlOkTN6gtnUSF1czAOs8Eb18jOvAqeenkdjI0AkjAux/
         mMMHbeI+kXNjab24frzmNiWBwHOnBkIo5r/oN1/eCRA/hsBa3vhWn0Oj+x3MotveVH
         sb7/dN508UpPvJLO40ssedgdQ84KXUS7gQhsvc6A=
Date:   Sat, 08 May 2021 15:49:46 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
 removed from -mm tree
Message-ID: <20210508224946.Uk1QTWq4m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: /proc/sys/vm/stat_refresh skip checking known negative stats
has been removed from the -mm tree.  Its filename was
     mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: /proc/sys/vm/stat_refresh skip checking known negative stats

vmstat_refresh() can occasionally catch nr_zone_write_pending and
nr_writeback when they are transiently negative.  The reason is partly
that the interrupt which decrements them in test_clear_page_writeback()
can come in before __test_set_page_writeback() got to increment them; but
transient negatives are still seen even when that is prevented, and I am
not yet certain why (but see Roman's note below).  Those stats are not
buggy, they have never been seen to drift away from 0 permanently: so just
avoid the annoyance of showing a warning on them.

Similarly avoid showing a warning on nr_free_cma: CMA users have seen that
one reported negative from /proc/sys/vm/stat_refresh too, but it does
drift away permanently: I believe that's because its incrementation and
decrementation are decided by page migratetype, but the migratetype of a
pageblock is not guaranteed to be constant.

Roman Gushchin points out:
For performance reasons, vmstat counters are incremented and decremented
using per-cpu batches.  vmstat_refresh() flushes the per-cpu batches on
all CPUs, to get values as accurate as possible; but this method is not
atomic, so the resulting value is not always precise.  As a consequence,
for those counters whose actual value is close to 0, a small negative
value may occasionally be reported.  If the value is small and the state
is transient, it is not an indication of an error.

Link: https://lore.kernel.org/linux-mm/20200714173747.3315771-1-guro@fb.com/
Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2103012158540.7549@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/vmstat.c~mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats
+++ a/mm/vmstat.c
@@ -1858,6 +1858,14 @@ int vmstat_refresh(struct ctl_table *tab
 	if (err)
 		return err;
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
+		/*
+		 * Skip checking stats known to go negative occasionally.
+		 */
+		switch (i) {
+		case NR_ZONE_WRITE_PENDING:
+		case NR_FREE_CMA_PAGES:
+			continue;
+		}
 		val = atomic_long_read(&vm_zone_stat[i]);
 		if (val < 0) {
 			pr_warn("%s: %s %ld\n",
@@ -1874,6 +1882,13 @@ int vmstat_refresh(struct ctl_table *tab
 	}
 #endif
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+		/*
+		 * Skip checking stats known to go negative occasionally.
+		 */
+		switch (i) {
+		case NR_WRITEBACK:
+			continue;
+		}
 		val = atomic_long_read(&vm_node_stat[i]);
 		if (val < 0) {
 			pr_warn("%s: %s %ld\n",
_

Patches currently in -mm which might be from hughd@google.com are


