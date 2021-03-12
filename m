Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8D6C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 08:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5873364F83
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 08:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhCLIIK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 03:08:10 -0500
Received: from vmi485042.contaboserver.net ([161.97.139.209]:55372 "EHLO
        gentwo.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232131AbhCLIHq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 03:07:46 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Mar 2021 03:07:45 EST
Received: by gentwo.de (Postfix, from userid 1001)
        id 7EF95B0096A; Fri, 12 Mar 2021 09:01:07 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.de (Postfix) with ESMTP id 77027B006A0;
        Fri, 12 Mar 2021 09:01:07 +0100 (CET)
Date:   Fri, 12 Mar 2021 09:01:07 +0100 (CET)
From:   Christoph Lameter <cl@gentwo.de>
To:     akpm@linux-foundation.org
cc:     guro@fb.com, iamjoonsoo.kim@lge.com, jnwang@linux.alibaba.com,
        khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, sming56@gmail.com,
        vbabka@suse.cz, wenyang@linux.alibaba.com, willy@infradead.org,
        xlpang@linux.alibaba.com
Subject: Re: + mm-slub-introduce-two-counters-for-partial-objects.patch added
 to -mm tree
In-Reply-To: <20210311221459.k6DMM1FqH%akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.22.394.2103120856290.207966@gentwo.de>
References: <20210311221459.k6DMM1FqH%akpm@linux-foundation.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 11 Mar 2021, akpm@linux-foundation.org wrote:

> This patch introduces two counters to maintain the actual number of
> partial objects dynamically instead of iterating the partial page lists
> with list_lock held.

Well these counters have to be maintained in the fast paths of the
allocator. This approach increases the cache footprint, increases the
complexity of fastpaths even more. It reduces performance (which may not
be that visible in benchmarks that can keep the entire processing logic in
l1 or so) and causes a future maintenance headache.

The only reason to use this counter that was given is to retrieve the
current number of partial objects via sysfs. This is not a critical
operation and the use of that sysfs file could be avoided.

Or we can simply remove the ability to retrieve the number of partial
objects from sysfs?



