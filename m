Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F006C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 108EB2065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027160;
	bh=tbue3AT+st1Gfgoc5ixNOuGnsHdR+xTtCD0oyWuFL0Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dimnRakDQvL0I1uLFLWcw0/E5GEgg97uE3kj005uyI8Gh10DBoKJmqL464bsINHYU
	 0R6cRCtfThR62y6IExGcYOH7wFvlhNti0PwVnGmm0aFBhtD9UwtjHRjWb6zdGih/4Q
	 ieOXQ/S3mkdQ/UCXK5cW6AObUIAwqCM1u3SKbSoI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgHJCjT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCjT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42E2206CD;
        Mon, 10 Aug 2020 02:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027159;
        bh=tbue3AT+st1Gfgoc5ixNOuGnsHdR+xTtCD0oyWuFL0Q=;
        h=Date:From:To:Subject:From;
        b=Wd7VTocZbEOBLu8t/rhvJ4xFWXXTtU+ANCrkaNjZqSg0bBwPeCe9lYa6dUVZq2Tlb
         8hXtisnSPjCShAAvD5N/mGFhH3SU99HHnCMlP9FpEZUM7uvz67YpBRwRmraxGC2l2F
         rh9bj0RCwf8GSud+zh8dpedL1gjqz3prw3MylNqo=
Date:   Sun, 09 Aug 2020 19:39:18 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net,
        dvyukov@google.com, glider@google.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, josh@joshtriplett.org,
        mathieu.desnoyers@efficios.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-update-documentation-for-generic-kasan.patch removed from -mm tree
Message-ID: <20200810023918.cZpgUBDKE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update documentation for generic kasan
has been removed from the -mm tree.  Its filename was
     kasan-update-documentation-for-generic-kasan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: update documentation for generic kasan

Generic KASAN will support to record the last two call_rcu() call stacks
and print them in KASAN report.  So that need to update documentation.

Link: http://lkml.kernel.org/r/20200601051111.1359-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/dev-tools/kasan.rst~kasan-update-documentation-for-generic-kasan
+++ a/Documentation/dev-tools/kasan.rst
@@ -190,6 +190,9 @@ function calls GCC directly inserts the
 This option significantly enlarges kernel but it gives x1.1-x2 performance
 boost over outline instrumented kernel.
 
+Generic KASAN prints up to 2 call_rcu() call stacks in reports, the last one
+and the second to last.
+
 Software tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are


