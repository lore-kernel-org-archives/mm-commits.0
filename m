Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC545C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379877AbiFQC7F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379878AbiFQC7B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD3865D0B
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6102FB826F3
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08538C3411C;
        Fri, 17 Jun 2022 02:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434738;
        bh=KsCQaSBFubNma8+ojik/Uhikj8/qBCFJQtKOOuEQ+Wg=;
        h=Date:To:From:Subject:From;
        b=kj+QjOh0ttTEVQ9DaHZLwoQEqhoeXwDxbfAYOSc5CZ1ktvxwQZPlLhn6cu7zYnAvi
         zdhL/41hqCIRhZGjymhRrsJ2u0MgHWQMNiYhf0DbShmpH+l5bYXoSH2BGvcfXIvrBC
         1WIkjb78ZCkKe64b1g4hEY9loZ0EsXc7Frrc7Yfw=
Date:   Thu, 16 Jun 2022 19:58:57 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch removed from -mm tree
Message-Id: <20220617025858.08538C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/flex_proportions.c: remove local_irq_ops in fprop_new_period()
has been removed from the -mm tree.  Its filename was
     lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/flex_proportions.c: remove local_irq_ops in fprop_new_period()
Date: Sat, 4 Jun 2022 21:15:02 +0800

commit e78d4833c03e28> "lib: Fix possible deadlock in flexible proportion
code" adds the local_irq_ops because percpu_counter_{sum |add} ops'lock
can cause deadlock by interrupts.  Now percpu_counter _{sum|add} ops use
raw_spin_(un)lock_irq*, so revert the commit and resolve the conflict.

Link: https://lkml.kernel.org/r/20220604131502.5190-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_proportions.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/lib/flex_proportions.c~lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period
+++ a/lib/flex_proportions.c
@@ -63,18 +63,13 @@ void fprop_global_destroy(struct fprop_g
  */
 bool fprop_new_period(struct fprop_global *p, int periods)
 {
-	s64 events;
-	unsigned long flags;
+	s64 events = percpu_counter_sum(&p->events);
 
-	local_irq_save(flags);
-	events = percpu_counter_sum(&p->events);
 	/*
 	 * Don't do anything if there are no events.
 	 */
-	if (events <= 1) {
-		local_irq_restore(flags);
+	if (events <= 1)
 		return false;
-	}
 	write_seqcount_begin(&p->sequence);
 	if (periods < 64)
 		events -= events >> periods;
@@ -82,7 +77,6 @@ bool fprop_new_period(struct fprop_globa
 	percpu_counter_add(&p->events, -events);
 	p->period += periods;
 	write_seqcount_end(&p->sequence);
-	local_irq_restore(flags);
 
 	return true;
 }
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

