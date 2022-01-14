Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872B3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiANWFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiANWFe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35161C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:05:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6BF262003
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E834FC36AE9;
        Fri, 14 Jan 2022 22:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197933;
        bh=2dP30ttTaKtwyHMkE9iApBpNEEQRRLNZqJO6/Y8n2eE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Gcz+tMtM5C77uFuemT4Ze5ZNv7esbd32Ybx//cC3yb41GkF0MVnZeNB1Ss+uxIwy4
         MLrD7HKzEFmukqpRIRBvWE25qS1i/evYAjVHkQD+G+OorUcUitXspH0uHi92pS+yrj
         uNngePFWXte15EI80ZpHSnsV9uCNLSxVzqyUjSS0=
Date:   Fri, 14 Jan 2022 14:05:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dqiao@redhat.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 049/146] mm/page_counter: remove an incorrect call
 to propagate_protected_usage()
Message-ID: <20220114220532.E3LmAAg_1%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Donghai Qiao <dqiao@redhat.com>
Subject: mm/page_counter: remove an incorrect call to propagate_protected_usage()

propagate_protected_usage() is called to propagate the usage change in the
page_counter structure.  But there is a call to this function from
page_counter_try_charge() when there is actually no usage change.  Hence
this call should be removed.

Link: https://lkml.kernel.org/r/20211118181125.3918222-1-dqiao@redhat.com
Signed-off-by: Donghai Qiao <dqiao@redhat.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_counter.c~mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage
+++ a/mm/page_counter.c
@@ -120,7 +120,6 @@ bool page_counter_try_charge(struct page
 		new = atomic_long_add_return(nr_pages, &c->usage);
 		if (new > c->max) {
 			atomic_long_sub(nr_pages, &c->usage);
-			propagate_protected_usage(c, new);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
_
