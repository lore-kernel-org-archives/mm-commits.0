Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E44C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 00:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239985AbiBZAHF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 19:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238742AbiBZAHE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 19:07:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D8A1EF350
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 16:06:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6D161D23
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 00:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4566C340E7;
        Sat, 26 Feb 2022 00:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645833990;
        bh=GgNm5XyDunM3q/0QefrLgA8ZXoHKmN6wi5O+AGlD2ec=;
        h=Date:To:From:Subject:From;
        b=yk+U4FlHsOCv1GyULDLc/3/X0vlOgjBTKfpIKahpA+5Rynmyqt2KLkfYhJ67a1DgR
         mCRWqtyJzFZJwyfVdrHWXV9VptUTFbKZU9wjmq1IWgY73JXC0n2XYXR0mHKKIURawW
         7uo0T+aelcYaV4MdKiZ70dyQ+m+ujomF9BO3A0Ew=
Date:   Fri, 25 Feb 2022 16:06:30 -0800
To:     mm-commits@vger.kernel.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-protect-memcg_stock-with-a-local_lock_t-fix.patch added to -mm tree
Message-Id: <20220226000630.B4566C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: add a comment regarding the release `obj'
has been added to the -mm tree.  Its filename is
     mm-memcg-protect-memcg_stock-with-a-local_lock_t-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-protect-memcg_stock-with-a-local_lock_t-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-protect-memcg_stock-with-a-local_lock_t-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/memcg: add a comment regarding the release `obj'

Please fold into
    mm/memcg: Protect memcg_stock with a local_lock_t

Link: https://lkml.kernel.org/r/Yhjye3LaBB8q55bg@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-protect-memcg_stock-with-a-local_lock_t-fix
+++ a/mm/memcontrol.c
@@ -3244,6 +3244,10 @@ static struct obj_cgroup *drain_obj_stoc
 	}
 
 	stock->cached_objcg = NULL;
+	/*
+	 * The `old' objects needs to be released by the caller via
+	 * obj_cgroup_put() outside of memcg_stock_pcp::stock_lock.
+	 */
 	return old;
 }
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcg-disable-threshold-event-handlers-on-preempt_rt.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix-2.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t-fix.patch
mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch

