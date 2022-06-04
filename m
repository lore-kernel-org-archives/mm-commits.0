Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8DFC43334
	for <mm-commits@archiver.kernel.org>; Sat,  4 Jun 2022 18:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbiFDSg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Jun 2022 14:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238142AbiFDSg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Jun 2022 14:36:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C7610BF
        for <mm-commits@vger.kernel.org>; Sat,  4 Jun 2022 11:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17B2CB802C6
        for <mm-commits@vger.kernel.org>; Sat,  4 Jun 2022 18:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC94AC385B8;
        Sat,  4 Jun 2022 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654367812;
        bh=vSbMwEs2EgNnNr+lDJiNbpUdOYthvMtFJYAX9AmzaTw=;
        h=Date:To:From:Subject:From;
        b=1KKzNY4kAd+aXoVCuZkhyaJul30Vu987G0bFZldt2rkqkN5mHUcfniWYtKDyFgBwq
         vPBI5Zg2jiQQMRMIPRoRk7DLNsjSpkLhlKJCLoRikPMdwlyb/Xwk0d2EPh1uSX+dSe
         16hF4yn/rUEi/7kIi04+A+rSB6wBKA6yfVtRm0P8=
Date:   Sat, 04 Jun 2022 11:36:52 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch added to mm-nonmm-unstable branch
Message-Id: <20220604183652.BC94AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/flex_proportions.c: remove local_irq_ops in fprop_new_period()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Jan Kara <jack@suse.cz>
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

lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch

