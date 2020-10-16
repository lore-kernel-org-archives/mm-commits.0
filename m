Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07871C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABDE02145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881607;
	bh=xZi3hvPvt78CxtNlcSMeZmS4AFBMYku+ggDLYb9qxc4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jA/hroygYDUbLYma5GJ28ovvtPIEMMiAZFThO9LHNNKdEqyp0ke8kw4Sku0F13wGX
	 9gFo4ZJvAproYqT58CLFcLWcDA6c0fQuHG1whGQTw+v1bItv+7dKspPjE5H4H3nsRB
	 1CM1tIKHzZNVMuLeXCWzoT4eHPC6UlMPdINk6jXE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409130AbgJPUx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409125AbgJPUx1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E006205CB;
        Fri, 16 Oct 2020 20:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881606;
        bh=xZi3hvPvt78CxtNlcSMeZmS4AFBMYku+ggDLYb9qxc4=;
        h=Date:From:To:Subject:From;
        b=LCSiz1CpWD96yMw8oIQTBg7wDC6uvrO3DJl73Zsypr9+A1LyI1FfK8prbjcnGtSIB
         ly0BHPj+o2YkqVbIHvEjPlypR1/3DaVdQaVqdcXhxeJHo6I0toWaGQYMbTZ/byX0D6
         Pz3cmR5PUN7GpHkha21P8tF31/mxzTe/0XMhmfMo=
Date:   Fri, 16 Oct 2020 13:53:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged] percpu_counter-use-helper-macro-abs.patch
 removed from -mm tree
Message-ID: <20201016205326.larwZzpXF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/percpu_counter.c: use helper macro abs()
has been removed from the -mm tree.  Its filename was
     percpu_counter-use-helper-macro-abs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: lib/percpu_counter.c: use helper macro abs()

Use helper macro abs() to simplify the "x >= t || x <= -t" cmp.

Link: https://lkml.kernel.org/r/20200927122746.5964-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/percpu_counter.c~percpu_counter-use-helper-macro-abs
+++ a/lib/percpu_counter.c
@@ -85,7 +85,7 @@ void percpu_counter_add_batch(struct per
 
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
-	if (count >= batch || count <= -batch) {
+	if (abs(count) >= batch) {
 		unsigned long flags;
 		raw_spin_lock_irqsave(&fbc->lock, flags);
 		fbc->count += count;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

