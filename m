Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0841EC433DB
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 14:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEC8B64F18
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 14:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbhCOOUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 10:20:09 -0400
Received: from vmi485042.contaboserver.net ([161.97.139.209]:56008 "EHLO
        gentwo.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237757AbhCOOTz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 10:19:55 -0400
Received: by gentwo.de (Postfix, from userid 1001)
        id AB814B00D57; Mon, 15 Mar 2021 15:19:53 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.de (Postfix) with ESMTP id A8695B00D2F;
        Mon, 15 Mar 2021 15:19:53 +0100 (CET)
Date:   Mon, 15 Mar 2021 15:19:53 +0100 (CET)
From:   Christoph Lameter <cl@gentwo.de>
To:     Xunlei Pang <xlpang@linux.alibaba.com>
cc:     akpm@linux-foundation.org, guro@fb.com, iamjoonsoo.kim@lge.com,
        jnwang@linux.alibaba.com, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sming56@gmail.com, vbabka@suse.cz,
        wenyang@linux.alibaba.com, willy@infradead.org
Subject: Re: + mm-slub-introduce-two-counters-for-partial-objects.patch added
 to -mm tree
In-Reply-To: <74683920-d8f8-8900-06ed-8ccb2464f115@linux.alibaba.com>
Message-ID: <alpine.DEB.2.22.394.2103151512400.313667@gentwo.de>
References: <20210311221459.k6DMM1FqH%akpm@linux-foundation.org> <alpine.DEB.2.22.394.2103120856290.207966@gentwo.de> <74683920-d8f8-8900-06ed-8ccb2464f115@linux.alibaba.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 13 Mar 2021, Xunlei Pang wrote:

> > Or we can simply remove the ability to retrieve the number of partial
> > objects from sysfs?
> >
>
> Not only sysfs, /proc/slabinfo is another user to calculate the
> "active_objs", I'm afraid it's hard to change the ABI of this
> commonly-used interface.

Well the field is there but is is used for any real purpose?

Could potentially be replaced by the total objects possible in the slab
cache.


