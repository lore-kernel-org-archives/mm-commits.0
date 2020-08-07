Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4A1C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E0F22C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781489;
	bh=0pwmDf6RKAj4GsHA6WJNrrGdfM0GOFri15aa4i5FvDo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rUhdyvN2zOhu9a5kOQALNoMaWZCpO+6Yj1SPaikF+6xFLjl6hLYj67rTYxL3f4nlt
	 HDSBqB0yazH6W/xvcAmdDAy36BxfBgw4v8OVn8xTRG+G0XTLDBqkeTT68xj/pRfOc/
	 eU6Xk74Y9H325ciDpTPZ3ZonQ985cd9Tr1B1vaTc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHGGYs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGYs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A4B422CAE;
        Fri,  7 Aug 2020 06:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781488;
        bh=0pwmDf6RKAj4GsHA6WJNrrGdfM0GOFri15aa4i5FvDo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SA/e0f9QtGxKy2uftQuH6LgKWDOyTPgr9ii53Wdd+/75hXLUSKiORySS3KOzyUz4J
         BDXL21lYgUI2cU+nSI0qeQrKn2RvE9eTuFcvq57pyShGWwdCIidHekwCnftbQSIZVa
         EBGqcnWLnKg6icd76F4/qLrHXdkFYZrjhhJevNo0=
Date:   Thu, 06 Aug 2020 23:24:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, corbet@lwn.net, dvyukov@google.com,
        glider@google.com, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Subject:  [patch 133/163] kasan: update documentation for generic
 kasan
Message-ID: <20200807062446.EMPtGEWYE%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
