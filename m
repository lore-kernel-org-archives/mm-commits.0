Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDBFC433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B85C364EBD
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345770AbhCDA7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447313AbhCDATu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:19:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00D1564F31;
        Wed,  3 Mar 2021 23:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614814713;
        bh=PXchON29Wka/ptPbzkYYbYISRJUPT+w+gRjZdljrRws=;
        h=Date:From:To:Subject:From;
        b=JfURK7roNwQXiJ5T98l9Z9KC6HMU4RYKbvS7Ge7aougmM5/Apq3rhU6UUUwsdR6GS
         Zp3sHCSjYOn2p8pmYe4zdcNe8nZe9GSnqyKeZram2cGP9y7mS0VaA8OrLJzPVqzQl2
         wtLJKW8GVjpBIVkYvEppCkJgIu0z5ZJszKcV1h4Q=
Date:   Wed, 03 Mar 2021 15:38:32 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch added
 to -mm tree
Message-ID: <20210303233832.QnmE_4Ac3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: /proc/sys/vm/stat_refresh skip checking known negative stats
has been added to the -mm tree.  Its filename is
     mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

