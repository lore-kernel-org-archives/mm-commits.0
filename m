Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCCAC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A094420897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816501;
	bh=QoUnqKZJPGgPSD2L+NFlQaQN482vyk4CXuqa4iADZfM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jcGi/MAbxPEhmbAUMNRU9raDz8jnmtHEcQ+LvQOJx+gRe+JA+lfiexvbjRUzPSnoW
	 p1oBi3FHzsuvOlZdPRot1UqyPq21EG7v7Mua3eOAeWtX9p9NQu4SL+yhjbrxO5LEMP
	 CllmeoxeFXCDkls/XeJyzxj3InzDdxKVtIy/w2GI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404363AbgJPCsV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbgJPCsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF8A208E4;
        Fri, 16 Oct 2020 02:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816500;
        bh=QoUnqKZJPGgPSD2L+NFlQaQN482vyk4CXuqa4iADZfM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HZYZPkqv6/flWKYEkMMHysbxfAa1q7Dz5wjDNRzZE+4vNUYa7yJv1lRz2zjf7bKIP
         khh3yxEjW1YLK0dgwvC4/cx3A41RlZBUxEfldfEibXK/IMSlppx+NFRZ3nndk/Y+TB
         HRW81CQiJJfI0h9aaNMmns3sMX58DdcgHimKgikQ=
Date:   Thu, 15 Oct 2020 19:48:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 115/156] lib/percpu_counter.c: use helper macro
 abs()
Message-ID: <20201016024819.q9mQrHzJJ%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
